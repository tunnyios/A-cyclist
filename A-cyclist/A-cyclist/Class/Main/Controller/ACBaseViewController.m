//
//  ACBaseViewController.m
//  A-cyclist
//
//  Created by tunny on 16/2/29.
//  Copyright © 2016年 tunny. All rights reserved.
//

#import "ACBaseViewController.h"
#import "UMSocial.h"
#import "ACGlobal.h"
#import "ACUtility.h"
#import "ACNavUtility.h"
#import <UIView+Toast.h>

@interface ACBaseViewController ()

@end

@implementation ACBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SSO第三方登录
/**
 *  新浪微博SSO登录
 */
- (void)SSOByWeiboSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //          获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            DLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            NSDictionary *dict = @{@"userName"  :   [ACUtility stringWithId:snsAccount.userName],
                                   @"uid"       :   [ACUtility stringWithId:snsAccount.usid],
                                   @"accessToken":  [ACUtility stringWithId:snsAccount.accessToken]
                                   };
            if (success) {
                success(dict);
            }
            
        } else {
            if (failure) {
                failure(response.error);
            }
        }
    });
}

/**
 *  QQ_SSO登录
 */
- (void)SSOByQQSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response) {
        //          获取QQ用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            DLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            NSDictionary *dict = @{@"userName"  :   [ACUtility stringWithId:snsAccount.userName],
                                   @"uid"       :   [ACUtility stringWithId:snsAccount.usid],
                                   @"accessToken":  [ACUtility stringWithId:snsAccount.accessToken]
                                   };
            if (success) {
                success(dict);
            }
            
        } else {
            if (failure) {
                failure(response.error);
            }
        }
    });
}

#pragma 设置导航栏样式和标题
- (void)setNavigation:(NSString *)title
{
    [ACNavUtility setNav:self.navigationController setNavItem:self.navigationItem setTitle:title];
}

#pragma 设置导航栏样式、标题和左边返回按钮
- (void)setNavigationWithBackItem:(NSString *)title withAction:(SEL)action
{
    [ACNavUtility setNav:self.navigationController setNavItem:self.navigationItem setTitle:title];
    self.navigationItem.leftBarButtonItem = [ACNavUtility setNavButtonWithImage:@"back_icon.png"
                                                                        target:self
                                                                        action:action
                                                                       frame:CGRectMake(0, 0, 20, 20)];
}

#pragma mark - 确定/取消 Alert弹窗
/**
 *  alert弹框提示
 */
-(void)showAlertMsg:(NSString *)msg cancelBtn:(NSString *)cancelBtnTitle{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  alert弹框提示选择，确定、取消
 */
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
            cancelBtnTitle:(NSString *)cancelBtnTitle
             otherBtnTitle:(NSString *)otherBtnTitle
                   handler:(void (^)())handler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelActoin = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureActoin = [UIAlertAction actionWithTitle:otherBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }];
    
    [alertController addAction:cancelActoin];
    [alertController addAction:sureActoin];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 中间弹框
- (void)showMsgCenter:(NSString *)msg
{
    if ([msg isEqualToString:@""]) {
        [self.view makeToast:@"您的网络有问题，请稍后再试..." duration:2.5f position:CSToastPositionCenter];
    }else{
        [self.view makeToast:msg duration:2.5f position:CSToastPositionCenter];
    }
}

@end
