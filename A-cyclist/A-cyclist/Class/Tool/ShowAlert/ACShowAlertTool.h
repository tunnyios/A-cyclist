//
//  ACShowAlertTool.h
//  A-cyclist
//
//  Created by tunny on 15/7/20.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ACShowAlertTool : NSObject

/** 显示提示，0.7s 字号14 */
+ (void)showSuccess:(NSString *)string;

/** 显示提示，0.7s 字号14 */
+ (void)showError:(NSString *)string;

/** 显示正在加载消息样式 */
+ (void)showMessage:(NSString *)string onView:(UIView *)view;

/** 隐藏 */
+ (void)hideMessage;
@end
