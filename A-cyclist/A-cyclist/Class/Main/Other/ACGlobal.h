//
//  ACGlobal.h
//  A-cyclist
//
//  Created by tunny on 15/7/13.
//  Copyright (c) 2015年 tunny. All rights reserved.
//


#import <Foundation/Foundation.h>


//const定义

#pragma mark - 授权信息
/** Bmob授权 */
extern NSString * const ACBmobAppKey;


#pragma mark - 提示信息
/** 登录成功 */
extern NSString * const ACLoginSuccess;
/** 注册成功 */
extern NSString * const ACRegisterSuccess;

/** 登录失败 */
extern NSString * const ACLoginFail;
/** 注册失败 */
extern NSString * const ACRegisterError;
/** 邮件格式错误 */
extern NSString * const ACErrorEmail;
/** 用户名格式错误 */
extern NSString * const ACErrorUserName;



// 宏定义

#ifdef  DEBUG
#define DLog( s, ... ) NSLog( @"<%p %@:(%d) %s> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __func__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

#define ACScreenBounds  [UIScreen mainScreen].bounds

