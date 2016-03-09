//
//  ACGlobal.h
//  A-cyclist
//
//  Created by tunny on 15/7/13.
//  Copyright (c) 2015年 tunny. All rights reserved.
//


#import <Foundation/Foundation.h>

/*****************************「const定义」********************************/
#pragma mark - 授权信息
/** Bmob授权 */
extern NSString * const ACBmobAppKey;
/** 新浪微博授权 */
extern NSString * const ACSinaAppKey;
extern NSString * const ACSinaSecret;
extern NSString * const ACSinaRedirectURL;
/** QQ授权 */
extern NSString * const ACQQAppId;
extern NSString * const ACQQAppKey;
extern NSString * const ACQQRedirectURL;
/** Wechat授权 */
extern NSString * const ACWechatAppId;
extern NSString * const ACWechatSecret;
extern NSString * const ACWechatRedirectURL;
/** 百度地图授权 */
extern NSString * const ACBaiduAppKey;
/** 友盟授权 */
extern NSString * const ACYouMengAppKey;


#pragma mark - Bmob数据相关常量
/** BmobURL地址AccessKey */
extern NSString * const ACBmobAccessKey;
/** BmobURL地址SecretKey */
extern NSString * const ACBmobSecretKey;
/** BmobURL有效访问时间(单位秒) 一天*/
extern int const ACBmobValidTime;
/** Bmob服务器缩略图规格 50x50 */
extern NSUInteger const ACBmobThumbnailRuleID;
/** Bmob服务器缩略图规格 180x180 */
extern NSUInteger const ACBmobMiddleRuleID;

#pragma mark - 提示信息
/** 登录成功 */
extern NSString * const ACLoginSuccess;
/** 注册成功 */
extern NSString * const ACRegisterSuccess;

/** 重置密码 */
extern NSString * const ACRestPasswordSuccess;
extern NSString * const ACRestPasswordError;

/** 登录失败 */
extern NSString * const ACLoginError;
/** 新浪微博登录失败 */
extern NSString * const ACSinaLoginError;
/** 注册失败 */
extern NSString * const ACRegisterError;
/** 邮件格式错误 */
extern NSString * const ACErrorEmail;
/** 邮箱地址不能为空 */
extern NSString * const ACEmptyEmail;
/** 用户名格式错误 */
extern NSString * const ACErrorUserName;
/** 密码不合法 */
extern NSString * const ACPasswordError;


/*****************************「宏定义」********************************/
#ifdef  DEBUG
#define DLog( s, ... ) NSLog( @"<%@:(%d) %s> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __func__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

#define ACScreenBounds          [UIScreen mainScreen].bounds
#define RGBColor(r,g,b,a)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define iOS8                    ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define isiOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)    //是否高于iOS7
#define isiOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)   //是否高于iOS8
#define isiOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? YES : NO)   //是否高于iOS9



