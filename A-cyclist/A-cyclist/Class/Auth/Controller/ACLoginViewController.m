//
//  ACLoginViewController.m
//  A-cyclist
//
//  Created by tunny on 15/7/18.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACLoginViewController.h"
#import "ACDataBaseTool.h"
#import "ACGlobal.h"
#import "NSString+Extension.h"
#import "ACShowAlertTool.h"
#import "ACUserModel.h"
//#import "WeiboSDK.h"
#import "ACTabBarController.h"
#import "ACCacheDataTool.h"
#import "ACUtility.h"
//#import "UMSocial.h"


@interface ACLoginViewController ()
/** 输入框容器View */
@property (weak, nonatomic) IBOutlet UIView *containerView;
/** 用户名 */
@property (weak, nonatomic) IBOutlet UITextField *loginEmail;
/** 密码 */
@property (weak, nonatomic) IBOutlet UITextField *loginPwd;

@end

@implementation ACLoginViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.hidden = YES;
    
    self.contentView = _containerView;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 登录相关
/**
 *  登录账户
 */
- (IBAction)login
{
    NSString *email = _loginEmail.text;
    if (![email isAvailEmail]) {
        [ACShowAlertTool showError:ACErrorEmail];
        return;
    }
    
    NSString *pwd = _loginPwd.text;
    if (!pwd) {
        [ACShowAlertTool showError:ACPasswordError];
        return;
    }
    
    //登录
    [ACDataBaseTool loginWithAccount:email passWord:pwd block:^(ACUserModel *user, NSError *error) {
        if (!error) {
            [ACShowAlertTool showSuccess:ACLoginSuccess];
            DLog(@"user #%@#", user);
            
            //缓存数据到本地
            [ACCacheDataTool saveUserInfo:user withObjectId:user.objectId];
            
            /* 手动移除通知，并退出键盘 */
            [self.view endEditing:YES];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            //跳转至主控制器
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            ACTabBarController *tabBarController = [[ACTabBarController alloc] init];
            
            window.rootViewController = tabBarController;
            [self.navigationController pushViewController:tabBarController animated:YES];
        } else {
            [ACShowAlertTool showError:ACLoginError];
            return;
        }
    }];
}

/**
 *  注册
 */
- (IBAction)newUserRegister
{
    /* 手动移除通知，并退出键盘 */
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"ACLogin" bundle:nil];
    UIViewController *registerVc = [loginSB instantiateViewControllerWithIdentifier:@"register"];
    [self presentViewController:registerVc animated:YES completion:nil];
}

/**
 *  重置密码
 */
- (IBAction)findPwd
{
    NSString *email = self.loginEmail.text;
    if ([email isAvailEmail]) {
        //从数据库中查找匹配的邮箱地址
        NSString *sql = [NSString stringWithFormat:@"select * from _User where email = '%@'", email];
        DLog(@"sql #%@#",sql);
        
        [ACDataBaseTool queryWithSQL:sql pValues:nil block:^(NSArray *result, NSError *error) {
            DLog(@"result #%@# error #%@#", result, error);
            if (result.count > 0) {    //找到匹配的邮箱地址
                [ACDataBaseTool restPasswordWithEmail:email];
                [ACShowAlertTool showSuccess:ACRegisterSuccess];
            } else {
                [ACShowAlertTool showError:ACRegisterError];
            }
        }];
    } else {
        [ACShowAlertTool showError:ACEmptyEmail];
    }
}

#pragma mark - 第三方登录
- (IBAction)qqLogin
{
    [self SSOByQQSuccess:^(id result) {
//        [ACDataBaseTool loginWithAccessToken:[result objectForKey:@"accessToken"] uid:[result objectForKey:@"uid"] expirationDate:[result objectForKey:@"sss"] platform:<#(ACLoginPlatform)#> success:<#^(id result)success#> failure:<#^(NSError *error)failure#>]
        
    } failure:^(NSError *error) {
        
    }];
//    if ([TencentOAuth iphoneQQInstalled]) {
//        //注册
//        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104739169" andDelegate:self];
//        //授权
//        NSArray *permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,nil];
//        [_tencentOAuth authorize:permissions inSafari:NO];
//        [_tencentOAuth getUserInfo];
//
//    } else {
//        [ACShowAlertTool showError:ACSinaLoginError];
//    }
}

- (IBAction)weboLogin
{
    [self SSOByWeiboSuccess:^(id result) {
        
    } failure:^(NSError *error) {
        
    }];
    
//    if([WeiboSDK isWeiboAppInstalled]){
//        //向新浪发送请求
//        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
//        request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
//        request.scope = @"all";
//        [WeiboSDK sendRequest:request];
//        
//        DLog(@"微博按钮点击");
//    } else {
//        [ACShowAlertTool showError:ACSinaLoginError];
//        
//    }
}

- (IBAction)wechatLogin
{
    
}


#pragma mark - QQ的回调函数
//- (void)tencentDidLogin{
//    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length]){
//        //  记录登录用户的OpenID、Token以及过期时间
//        NSString *accessToken = _tencentOAuth.accessToken;
//        NSString *uid = _tencentOAuth.openId;
//        NSDate *expiresDate = _tencentOAuth.expirationDate;
////        NSLog(@"acessToken:%@",accessToken);
////        NSLog(@"UserId:%@",uid);
////        NSLog(@"expiresDate:%@",expiresDate);
////        NSDictionary *dic = @{@"access_token":accessToken,@"uid":uid,@"expirationDate":expiresDate};
//        
//        //通过授权信息注册登录
//        [ACDataBaseTool loginWithAccessToken:accessToken uid:uid expirationDate:expiresDate platform:ACLoginPlatformQQ success:^(id result) {
//            NSLog(@"user objectid is :%@",result);
//            [_tencentOAuth getUserInfo];
//            //                ShowUserMessageViewController *showUser = [[ShowUserMessageViewController alloc] init];
//            //                showUser.title = @"用户信息";
//            //
//            //                [self.navigationController pushViewController:showUser animated:YES];
//        } failure:^(NSError *error) {
//            NSLog(@"weibo login error:%@",error);
//        }];
////        [BmobUser loginInBackgroundWithAuthorDictionary:dic platform:BmobSNSPlatformQQ block:^(BmobUser *user, NSError *error) {
////            if (error) {
////                
////            } else if (user){
////                NSLog(@"user objectid is :%@",user.objectId);
////                [_tencentOAuth getUserInfo];
//////                ShowUserMessageViewController *showUser = [[ShowUserMessageViewController alloc] init];
//////                showUser.title = @"用户信息";
//////                
//////                [self.navigationController pushViewController:showUser animated:YES];
////            }
////        }];
//    }
//    
//}

//- (void)tencentDidNotLogin:(BOOL)cancelled{
//}
//
//- (void)tencentDidNotNetWork{
//}

/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
//- (void)getUserInfoResponse:(APIResponse*) response
//{
//    [ACShowAlertTool showMessage:@"登录中..." onView:nil];
//    DLog(@"%@", response.jsonResponse);
//    /*
//     "nickname":"Peter",
//     province = 上海;
//     city = 浦东新区;
//     "figureurl_qq_1":"http:q.qlogo.cn/qqapp/100312990/DE1931D5330620DBD07FB4A5422917B6/40",
//     
//     "figureurl_qq_2":"http:q.qlogo.cn/qqapp/100312990/DE1931D5330620DBD07FB4A5422917B6/100",
//     
//     "gender":"男",
//     */
//    NSString *gender = @"m";
//    if ([response.jsonResponse[@"gender"] isEqualToString:@"女"]) {
//        gender = @"f";
//    }
//    NSString *location = @"";
//    NSString *province = response.jsonResponse[@"province"];
//    NSString *city = response.jsonResponse[@"city"];
//    if ( 0 != province.length && 0 != city.length ) {
//        location = [NSString stringWithFormat:@"%@ %@", province, city];
//    }
//    //2. 更新的数据到数据库中
//    NSDictionary *dict = @{@"username" : response.jsonResponse[@"nickname"],
//                           @"profile_image_url" : response.jsonResponse[@"figureurl_qq_2"],
//                           @"avatar_large" : response.jsonResponse[@"figureurl_qq_2"],
//                           @"location" : location,
//                           @"gender" : gender,
//                           };
//    NSArray *keys = @[@"username", @"profile_image_url", @"avatar_large", @"location", @"gender"];
//    [ACDataBaseTool updateUserInfoWithDict:dict andKeys:keys withResultBlock:^(BOOL isSuccessful, NSError *error) {
//        DLog(@"qq isSuccessful is %d, error is %@", isSuccessful, error);
//        if (isSuccessful) {
//            //3. 本地缓存
//            ACUserModel *user = [ACDataBaseTool getCurrentUser];
//            DLog(@"qq user is %@", user);
//            [ACCacheDataTool saveUserInfo:user withObjectId:user.objectId];
//            
//            //跳转
//            [ACShowAlertTool hideMessage];
//            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//            ACTabBarController *tabBarController = [[ACTabBarController alloc] init];
//            keyWindow.rootViewController = tabBarController;
//            [self.navigationController pushViewController:tabBarController animated:YES];
//        }
//    }];
//}

@end
