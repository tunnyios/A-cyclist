//
//  ACGlobal.m
//  A-cyclist
//
//  Created by tunny on 15/7/13.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - 授权信息
/** Bmob授权 */
NSString * const ACBmobAppKey = @"ff5b5ae23656f82ba51044b03ad5975a";


#pragma mark - 提示信息
/** 登录成功 */
NSString * const ACLoginSuccess = @"登录成功";
/** 注册成功 */
NSString * const ACRegisterSuccess = @"注册成功";

/** 登录失败 */
NSString * const ACLoginFail = @"登录失败";
/** 注册失败 */
NSString * const ACRegisterError = @"注册失败";
/** 邮件格式错误 */
NSString * const ACErrorEmail = @"邮箱不合法";
/** 用户名格式错误 */
NSString * const ACErrorUserName = @"昵称中不能包含(除_以外的)特殊字符， 最短3个字符最长不超过16个字符";