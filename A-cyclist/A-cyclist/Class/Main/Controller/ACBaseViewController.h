//
//  ACBaseViewController.h
//  A-cyclist
//
//  Created by tunny on 16/2/29.
//  Copyright © 2016年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+MJ.h"

@interface ACBaseViewController : UIViewController
/** 蒙板加载框 */
@property (nonatomic, strong) MBProgressHUD *HUD;

/**
 *  新浪微博SSO登录
 */
- (void)SSOByWeiboSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

/**
 *  QQ_SSO登录
 */
- (void)SSOByQQSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

/**
 *  设置导航栏样式和标题
 */
- (void)setNavigation:(NSString *)title;

/**
 *  设置导航栏样式、标题和左边返回按钮
 */
- (void)setNavigationWithBackItem:(NSString *)title withAction:(SEL)action;

/**
 *  alert弹框提示
 */
-(void)showAlertMsg:(NSString *)msg cancelBtn:(NSString *)cancelBtnTitle;

/**
 *  确定/取消 Alert 弹窗
 */
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
            cancelBtnTitle:(NSString *)cancelBtnTitle
             otherBtnTitle:(NSString *)otherBtnTitle
                   handler:(void (^)())handler;

#pragma mark 是否加载蒙版
/**
 *  设置蒙版
 *
 *  @param msg 显示文字
 */
- (void)showHUD_Msg:(NSString *)msg;

/**
 *  中间弹框
 */
- (void)showMsgCenter:(NSString *)msg;


@end
