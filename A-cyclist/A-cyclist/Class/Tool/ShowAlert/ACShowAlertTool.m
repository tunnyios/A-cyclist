//
//  ACShowAlertTool.m
//  A-cyclist
//
//  Created by tunny on 15/7/20.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACShowAlertTool.h"
#import "MBProgressHUD+MJ.h"

@implementation ACShowAlertTool

#pragma mark - 提示消息(0.7s)
+ (void)showSuccess:(NSString *)string
{
    [MBProgressHUD showSuccess:string];
}

+ (void)showError:(NSString *)string
{
    [MBProgressHUD showError:string];
}

#pragma mark - 显示消息(长时间)
+ (void)showMessage:(NSString *)string onView:(UIView *)view
{
    if (view == nil) {
        [MBProgressHUD showMessage:string];
    } else {
        [MBProgressHUD showMessage:string toView:view];
    }
}

+ (void)hideMessage
{
    [MBProgressHUD hideHUD];
}

@end
