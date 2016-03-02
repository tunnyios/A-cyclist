//
//  ACBaseViewController.h
//  A-cyclist
//
//  Created by tunny on 16/2/29.
//  Copyright © 2016年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACBaseViewController : UIViewController
#pragma mark - SSO第三方登录
/**
 *  新浪微博SSO登录
 */
- (void)SSOByWeiboSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

/**
 *  QQ_SSO登录
 */
- (void)SSOByQQSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure;
@end
