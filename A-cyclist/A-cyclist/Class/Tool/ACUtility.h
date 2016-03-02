//
//  ACUtility.h
//  A-cyclist
//
//  Created by tunny on 16/3/2.
//  Copyright © 2016年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ACUtility : NSObject
/*****************************「全局变量」********************************/
extern NSString * deviceId;         //deviceId


/*****************************「公共方法」********************************/
/**
*  接收转字符串处理
*/
+ (NSString *)stringWithId:(id)value;

/**
 *  显示系统弹框
 */
+ (void)showMessage:(NSString *)msg target:(id)target;

/**
 *  检验手机号
 */
+ (BOOL)isValidateMobile:(NSString *)mobile;

/**
 *  计算时间间隔
 */
+ (NSString *)computationTimer:(NSString *)timeStr;

/**
 *  处理日期    
 *  2015-02-02 12:30:59.50 ~> 2015-02-02 12:30:59
 */
+ (NSString *)formDateToString:(NSString *)strDate;

/**
 *  获取deviceId
 */
+ (void)getUUID;

@end
