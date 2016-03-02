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
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
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
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
