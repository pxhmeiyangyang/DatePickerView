//
//  ViewController.m
//  DatePickerView
//
//  Created by pxh on 2018/7/25.
//  Copyright © 2018年 pxh. All rights reserved.
//

#import "ViewController.h"
#import "DatePickerView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    DatePickerView* picker = [[DatePickerView alloc] init];
    [self.view addSubview:picker];
    picker.frame = CGRectMake(100, 100, 300, 300);
    picker.backgroundColor = UIColor.whiteColor;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(picker.year,picker.month,picker.day);
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
