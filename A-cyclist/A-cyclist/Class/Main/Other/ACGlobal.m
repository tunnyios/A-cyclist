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
/** 新浪微博授权 */
NSString * const ACSinaAppKey = @"3238796127";
NSString * const ACSinaSecret = @"c165747ce7d48f058ae5a875ff36cc2d";
NSString * const ACSinaRedirectURL = @"https://api.weibo.com/oauth2/default.html";
/** QQ授权 */
NSString * const ACQQAppId = @"1104739169";
NSString * const ACQQAppKey = @"nJ9vASx3n7zUP0vQ";
NSString * const ACQQRedirectURL = @"http://github.com/tunnyios";
/** Wechat授权 */
NSString * const ACWechatAppId = @"wx4486760012956d1d";
NSString * const ACWechatSecret = @"0e2e90ae23a15c93768d9d50c0dca5fb";
NSString * const ACWechatRedirectURL = @"http://tunnyios.github.io";
/** 百度地图微博授权 */
NSString * const ACBaiduAppKey = @"sVLUnWrBkQpHrpKc8d0QeNFO";
/** 友盟授权 */
NSString * const ACYouMengAppKey = @"55cdacb0e0f55ab21a0010ff";


#pragma mark - Bmob数据库相关常量
/** BmobURL地址AccessKey */
NSString * const ACBmobAccessKey = @"1c75e4df89d6730f2b0a9f39b8694286";
/** BmobURL地址SecretKey */
NSString * const ACBmobSecretKey = @"0357";
/** BmobURL有效访问时间(单位秒) */
int const ACBmobValidTime = 86400;
/** Bmob服务器缩略图规格 50x50 */
NSUInteger const ACBmobThumbnailRuleID = 1;
/** Bmob服务器缩略图规格 180x180 */
NSUInteger const ACBmobMiddleRuleID = 2;


#pragma mark - 公共常量
/** 获取数据分页常量 */
NSUInteger const ACDataLimitCount = 20;


#pragma mark - 提示信息
/** 登录成功 */
NSString * const ACLoginSuccess = @"登录成功";
/** 注册成功 */
NSString * const ACRegisterSuccess = @"注册成功";

/** 重置密码 */
NSString * const ACRestPasswordSuccess = @"重置密码的邮件已经发送至您的邮箱";
NSString * const ACRestPasswordError = @"输入的邮箱还未注册";

/** 登录失败 */
NSString * const ACLoginError = @"登录失败";
/** 新浪微博登录失败 */
NSString * const ACSinaLoginError = @"没有安装新浪微博客户端";
/** 注册失败 */
NSString * const ACRegisterError = @"注册失败";
/** 邮件格式错误 */
NSString * const ACErrorEmail = @"邮箱不合法";
/** 邮箱地址不能为空 */
NSString * const ACEmptyEmail = @"请填写邮箱地址";
/** 用户名格式错误 */
NSString * const ACErrorUserName = @"昵称中不能包含(除_以外的)特殊字符， 最短3个字符最长不超过16个字符";
/** 密码不合法 */
NSString * const ACPasswordError = @"密码不能为空";

/** 获取热门路线失败 */
NSString * const ACSharedRouteGetListError = @"获取共享路线失败";

/** 获取排行榜失败 */
NSString * const ACRankGetListError = @"获取排行榜失败";
