//
//  DatePickerView.m
//  DatePickerView
//
//  Created by pxh on 2018/7/25.
//  Copyright © 2018年 pxh. All rights reserved.
//

#import "DatePickerView.h"

@interface DatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

//保存年月日数据的array
@property (nonatomic,strong) NSMutableArray *yearArray;

@property (nonatomic,strong) NSMutableArray *monthArray;

@property (nonatomic,strong) NSMutableArray *dayArray;

//选中的当前行
@property (nonatomic,assign) int selectedRowYear;

@property (nonatomic,assign) int selectedRowMonth;

@property (nonatomic,assign) int selectedRowDay;

@property (nonatomic,assign) int MinimumYear;

@property (nonatomic,assign) int MaximumYear;

//每个月的天数
@property (nonatomic,assign) int dayNumber;

//应该跟新天数了,当月份或年份被选择过或是刚进入为true，需要刷新day
@property (nonatomic,assign) Boolean dayShouldChangeEnable;

@end



@implementation DatePickerView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self deploySubview];
        [self initParameter];
        //获取当前的年月日，并且初始化
        [self updateDate:[NSDate date]];
        self.dayShouldChangeEnable= false;
        self.showChineseHint = false;
    }
    return self;
}

-(void)initParameter{
    self.MinimumYear = 1970;
    self.MaximumYear = 2050;
    self.selectColor = [UIColor greenColor];
}

-(void)setDate:(NSDate *)date{
    _date = date;
    [self updateDate:date];
}

-(void)setMaximumDate:(NSDate *)MaximumDate{
    _MaximumDate = MaximumDate;
    NSDateComponents* dateComponent = [self getDateComponents:MaximumDate];
    self.MaximumYear = (int)[dateComponent year];
}

-(void)setMinimumMinidate:(NSDate *)MinimumMinidate{
    _MinimumMinidate = MinimumMinidate;
    NSDateComponents* dateComponent = [self getDateComponents:MinimumMinidate];
    self.MinimumYear = (int)[dateComponent year];
}


//pickerView的懒加载
-(UIPickerView *)pickerView{
    
    if(!_pickerView){
        _pickerView = [[UIPickerView alloc] init];
    }
    return _pickerView;
}

//年份的懒加载
-(NSMutableArray *)yearArray{
    if(!_yearArray){
        _yearArray = [NSMutableArray array];
        //此处设置年份，固定的，当然你也可以提取出来，设为可变的
        for (int index=self.MinimumYear; index<=self.MaximumYear; index++) {
            [_yearArray addObject:[@(index) stringValue]];
        }
    }
    return _yearArray;
}

//根据传递进入的dayNumber计算dayArray
-(void)setDaysForMonth:(int) dayNumber{
    self.dayArray = nil;
    self.dayArray = [NSMutableArray array];
    for (int index=1; index<=_dayNumber; index++) {
        [_dayArray addObject:[@(index) stringValue]];
    }
}

//月份的懒加载
-(NSMutableArray *)monthArray{
    if(!_monthArray){
        _monthArray = [NSMutableArray array];
        for (int index=1; index<=12; index++) {
            [_monthArray addObject:[@(index) stringValue]];
        }
    }
    return _monthArray;
}

-(void)deploySubview{
    [self addSubview:self.pickerView];
    //设置dataSource和delegate
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
}

-(NSDateComponents* )getDateComponents:(NSDate* )date{
    //获取当前的年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    return dateComponent;
}

//获取当期的年月日，并且初始化pickView，及一些其他参数
-(void)updateDate:(NSDate* )date{
    
    NSDateComponents *dateComponent = [self getDateComponents:date];
    
    int year = (int)[dateComponent year];
    int month = (int)[dateComponent month];
    int day  = (int)[dateComponent day];
    
    //我根据月份和年份计算天数
    [self calculateDayWithMonth:month andYear:year];
    
    NSLog(@"%i,%i,%i",year,month,day);
    
    self.selectedRowYear = (year-self.MinimumYear);
    self.selectedRowMonth = (month -1);
    self.selectedRowDay = (day-1);
    
    //根据现在的年份和月份，初始化pickerView
    [self.pickerView selectRow:_selectedRowYear inComponent:0 animated:YES];
    [self.pickerView selectRow:_selectedRowMonth inComponent:1 animated:YES];
    [self.pickerView selectRow:_selectedRowDay inComponent:2 animated:YES];
    
    //将目前的日期赋值给公共参数，以便外面调用
    self.year = [@(year) stringValue];
    self.month = [@(month) stringValue];
    self.day =  [@(day) stringValue];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.pickerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

/*********************数据源方法**********************/
//返回的是pickerView有多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return  3; // 年份、月份、天
}

//表明pickerView每列的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0){ //年份行数
        return self.yearArray.count;
    }
    else if(component == 1){ //月份行数
        return self.monthArray.count;
    }
    else{ //天行数
        return self.dayArray.count;
    }
    
}
/*********************数据源方法**********************/

/*********************代理方法**********************/
//第row行的标题
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component ==0) { //年份第row行标题
        if (_showChineseHint) {
            return [NSString stringWithFormat:@"%@年",[self.yearArray objectAtIndex:row]];
        }else{
            return [NSString stringWithFormat:@"%@",[self.yearArray objectAtIndex:row]];
        }
    }else if(component == 1){ //月份第row行标题
        if (_showChineseHint) {
            return [NSString stringWithFormat:@"%@月",[self.monthArray objectAtIndex:row]];
        }else{
            return [NSString stringWithFormat:@"%@",[self.monthArray objectAtIndex:row]];
        }
    }else{ //天数第row行标题
        if (_showChineseHint) {
            return [NSString stringWithFormat:@"%@日",[self.dayArray objectAtIndex:row]];
        }else{
            return [NSString stringWithFormat:@"%@",[self.dayArray objectAtIndex:row]];
        }
    }
}

/*
 监听用户选中第component列的第row行，在这个之中，读取被选中的年月日
 因为年份和月份不同，天数都会时时改变，所以设置_dayShouldChangeEnable参数
 表示当年份和月份改变时，重新计算天数，这里有点缺陷，就是可能存在重复计算天数的情况，影响效率
 */
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if(component == 0){
        //当用户更改年份的时候，为防止闰年和非闰年对2月份天数的影响，_dayShouldChangeEnable = true表明需要重新计算对应月份的天数
        _dayShouldChangeEnable = true;
        self.year = _yearArray[row];//将选中的月份数赋值给公共的年份参数，以便外面调用
        self.selectedRowYear = (int)row; //将row赋值给
        [pickerView reloadComponent:0]; //为了选中的row变颜色，需要刷新整行
    }
    else if(component==1){
        //当用户更改月份的时候，_dayShouldChangeEnable = true表明需要重新计算天数
        _dayShouldChangeEnable = true;
        self.month = _monthArray[row]; //将选中的月份数赋值给公共的月份参数，以便外面调用
        self.selectedRowMonth = (int)row;
        [pickerView reloadComponent:1];
    }
    else{
        self.day = _dayArray[row];//将选中的天数赋值给公共的天数参数，以便外面调用
        NSLog(@"---------->>>>2");
        self.selectedRowDay = (int)row;
        [pickerView reloadComponent:2];
    }
    if(_dayShouldChangeEnable) //若，天数需要更新，那么执行
    {
        //调用计算天数的函数
        [self calculateDayWithMonth:[self.month intValue] andYear:[self.year intValue]];
        //由于更新的时候self.selectRowDay很可能大于 天数的最大值，比如self.selectRowDay为31，而天数最大值切换至了29，所以若超出，则需要将selectRowDay重新赋值
        if(self.selectedRowDay > _dayNumber-1){
            self.selectedRowDay = _dayNumber-1;
            NSLog(@"---------->>>>>%zi<<<<<<",self.selectedRowDay);
        }
        //重新对天数的那一列进行更新
        [pickerView reloadComponent:2];
        //false
        _dayShouldChangeEnable = false;
    }
    
}


//选中的项目变成绿色
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* Label = (UILabel*)view;
    if (!Label){
        Label = [[UILabel alloc] init];
        Label.minimumScaleFactor = 8;
        Label.adjustsFontSizeToFitWidth = YES;
        [Label setTextAlignment:NSTextAlignmentCenter];
        [Label setFont:[UIFont systemFontOfSize:15]];
        //当年份列，被选中的行对应变成绿色
        if (component==0&&_selectedRowYear==row) {
            
            Label.textColor=self.selectColor;
            
        }else if (component==1&&_selectedRowMonth==row){
            
            Label.textColor= self.selectColor;
            
        }else if(component==2&&_selectedRowDay==row){
            
            Label.textColor= self.selectColor;
        }
    }
    Label.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    //在该代理方法里添加以下两行代码删掉上下背景中的黑线
    [[pickerView.subviews objectAtIndex:1] setHidden:TRUE];
    [[pickerView.subviews objectAtIndex:2] setHidden:TRUE];
    return Label;
}
/*********************代理方法**********************/


//根据month和year计算对应的天数
-(void)calculateDayWithMonth:(int) month andYear:(int) year{
    
    
    float yearF = [self.year floatValue]/4; //能被4整除的是闰年
    float yearI = (int)yearF; //若yearI和yearF不一样，也就是说没有被整除，则不是闰年
    //当然以上计算没有包括：能被100整除，但不能被400整除的，不是闰年，因为2000年已过2100年还远....
    
    switch (month) {
        case 1:_dayNumber = 31;
            break;
        case 2:
            if(yearF != yearI){_dayNumber = 28;}else{
                _dayNumber = 29;}
            break;
        case 3:_dayNumber = 31;
            break;
        case 4:_dayNumber = 30;
            break;
        case 5:_dayNumber = 31;
            break;
        case 6:_dayNumber = 30;
            break;
        case 7:_dayNumber = 31;
            break;
        case 8:_dayNumber = 31;
            break;
        case 9:_dayNumber = 30;
            break;
        case 10:_dayNumber = 31;
            break;
        case 11:_dayNumber = 30;
            break;
        case 12:_dayNumber = 31;
            break;
        default:_dayNumber = 31;
            break;
    }
    [self setDaysForMonth:_dayNumber]; //此处调用函数，将dayArray重新赋值；
    
}

//将日期格式转化为2016-01-01这种格式
-(NSString *)getDateForMyMode{
    NSString *myMonth = @"";
    NSString *myDay = @"";
    
    if([self.month intValue] < 10){
        myMonth = [NSString stringWithFormat:@"0%@",self.month];
    }else{
        myMonth = [NSString stringWithFormat:@"%@",self.month];
    }
    if([self.day intValue] <10){
        myDay = [NSString stringWithFormat:@"0%@",self.day];
    }else{
        myDay = [NSString stringWithFormat:@"%@",self.day];
    }
    
    return [NSString stringWithFormat:@"%@-%@-%@",self.year,myMonth,myDay];
}



-(void)dealloc{
    NSLog(@"myDatePickerView dealloc");
}

@end
