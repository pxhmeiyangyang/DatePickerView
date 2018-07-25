//
//  DatePickerView.h
//  DatePickerView
//
//  Created by pxh on 2018/7/25.
//  Copyright © 2018年 pxh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerView : UIView

//我们的主角，pickerView
@property (strong, nonatomic) UIPickerView *pickerView;

//这三个参数放在外面，可供外界调用
@property (nonatomic,strong) NSString *year;

@property (nonatomic,strong) NSString *month;

@property (nonatomic,strong) NSString *day;

@property (nonatomic,strong) NSDate* date;

@property (nonatomic,strong) NSDate* MinimumMinidate;

@property (nonatomic,strong) NSDate* MaximumDate;

@property (nonatomic,strong) UIColor* selectColor;

@property (nonatomic,assign) BOOL showChineseHint;

-(instancetype)init;

//创建一个将年月日组合起来的NSString，并返回
-(NSString *)getDateForMyMode;

@end
