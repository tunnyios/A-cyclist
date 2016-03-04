//
//  ACBaseViewController.h
//  A-cyclist
//
//  Created by tunny on 16/2/29.
//  Copyright © 2016年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACBaseViewController : UIViewController
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
 *  确定/取消 Alert 弹窗 iOS7需要实现alertDelegate
 */
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
            cancelBtnTitle:(NSString *)cancelBtnTitle
             otherBtnTitle:(NSString *)otherBtnTitle
                   handler:(void (^)())handler;

@end
