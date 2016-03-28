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
#import "ACTabBarController.h"
#import "ACCacheDataTool.h"
#import "ACUtility.h"
#import "WeiboSDK.h"
#import "ACSettingProfileInfoViewController.h"
#import "ACRegisterViewController.h"

@interface ACLoginViewController ()<TencentSessionDelegate>
/** 输入框容器View */
@property (weak, nonatomic) IBOutlet UIView *containerView;
/** 用户名 */
@property (weak, nonatomic) IBOutlet UITextField *loginEmail;
/** 密码 */
@property (weak, nonatomic) IBOutlet UITextField *loginPwd;
/** tempUserModel */
@property (nonatomic, strong) ACUserModel *tempUserModel;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;



@end

@implementation ACLoginViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.hidden = YES;
    
    self.contentView = _containerView;
    [super viewDidLoad];
    
    if ([TencentOAuth iphoneQQInstalled]) {
        //注册
        self.qqBtn.hidden = NO;
    } else {
        self.qqBtn.hidden = YES;
    }
    if([WeiboSDK isWeiboAppInstalled]){
        //向新浪发送请求
        self.weiboBtn.hidden = NO;
    } else {
        self.weiboBtn.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    /* 手动移除通知，并退出键盘 */
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 登录相关
/**
 *  登录账户
 */
- (IBAction)login
{
    NSString *email = _loginEmail.text;
    if (![email isAvailPhoneNumber] && ![email isAvailEmail] &&![email isAvailUserName]) {
        [ACShowAlertTool showError:ACErrorEmail];
        return;
    }
    
    NSString *pwd = _loginPwd.text;
    if (!pwd) {
        [ACShowAlertTool showError:ACPasswordError];
        return;
    }
    
    //登录
    [ACShowAlertTool showMessage:@"登录中..." onView:nil];
    [ACDataBaseTool loginWithAccount:email passWord:pwd block:^(ACUserModel *user, NSError *error) {
        if (!error) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            //本地缓存
            [ACCacheDataTool saveUserInfo:user withObjectId:user.objectId];
            if (user.weight && ![user.weight isEqual:@0]) {
                //创建tabbarController跳转
                ACTabBarController *tabBarController = [[ACTabBarController alloc] init];
                window.rootViewController = tabBarController;
            } else {
                //跳转至settingProfileVC
                ACSettingProfileInfoViewController *setProfileVC = [[ACSettingProfileInfoViewController alloc] init];
                setProfileVC.pushFromType = PushFromTypeLogin;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:setProfileVC];
                window.rootViewController = nav;
            }
            [ACShowAlertTool hideMessage];
        } else {
            [ACShowAlertTool hideMessage];
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
    UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"ACLogin" bundle:nil];
    ACRegisterViewController *registerVc = [loginSB instantiateViewControllerWithIdentifier:@"register"];
    registerVc.from = RegisterPushFromTypeRegister;
    [self presentViewController:registerVc animated:YES completion:nil];
}

/**
 *  重置密码
 */
- (IBAction)findPwd
{
    UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"ACLogin" bundle:nil];
    ACRegisterViewController *registerVc = [loginSB instantiateViewControllerWithIdentifier:@"register"];
    registerVc.from = RegisterPushFromTypeRestPwd;
    [self presentViewController:registerVc animated:YES completion:nil];
    
//    NSString *email = self.loginEmail.text;
//    if ([email isAvailEmail]) {
//        //从数据库中查找匹配的邮箱地址
//        NSString *sql = [NSString stringWithFormat:@"select * from _User where email = '%@'", email];
//        DLog(@"sql #%@#",sql);
//        
//        [ACDataBaseTool queryWithSQL:sql pValues:nil block:^(NSArray *result, NSError *error) {
//            DLog(@"result #%@# error #%@#", result, error);
//            if (result.count > 0) {    //找到匹配的邮箱地址
//                [ACDataBaseTool restPasswordWithEmail:email];
//                [ACShowAlertTool showSuccess:ACRegisterSuccess];
//            } else {
//                [ACShowAlertTool showError:ACRegisterError];
//            }
//        }];
//    } else {
//        [ACShowAlertTool showError:ACEmptyEmail];
//    }
}

#pragma mark - 第三方登录
- (IBAction)qqLogin
{
    if ([TencentOAuth iphoneQQInstalled]) {
        //注册
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:ACQQAppId andDelegate:self];
        //授权
        NSArray *permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,nil];
        [self.tencentOAuth authorize:permissions inSafari:NO];

    } else {
        [ACShowAlertTool showError:ACSinaLoginError];
    }
}

- (IBAction)weboLogin
{
    if([WeiboSDK isWeiboAppInstalled]){
        //向新浪发送请求
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = ACSinaRedirectURL;
        request.scope = @"all";
        [WeiboSDK sendRequest:request];
        DLog(@"微博按钮点击");
    } else {
        [ACShowAlertTool showError:ACSinaLoginError];
    }
}

- (IBAction)wechatLogin
{
    
}


#pragma mark - QQ的回调函数
- (void)tencentDidLogin
{
    if (self.tencentOAuth.accessToken && 0 != [self.tencentOAuth.accessToken length]){
        //  记录登录用户的OpenID、Token以及过期时间
        NSString *accessToken = self.tencentOAuth.accessToken;
        NSString *uid = self.tencentOAuth.openId;
        NSDate *expiresDate = self.tencentOAuth.expirationDate;
        
        //通过授权信息注册登录
        [ACDataBaseTool loginWithAccessToken:accessToken uid:uid expirationDate:expiresDate platform:ACLoginPlatformQQ success:^(id result) {
            DLog(@"user objectid is :%@",result);
            self.tempUserModel = (ACUserModel *)result;
            if (self.tempUserModel.weight && ![self.tempUserModel.weight isEqual:@0]) {
                //本地缓存
                [ACCacheDataTool saveUserInfo:self.tempUserModel withObjectId:self.tempUserModel.objectId];
                //创建tabbarController跳转
                ACTabBarController *tabBarController = [[ACTabBarController alloc] init];
                UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
                keyWindow.rootViewController = tabBarController;
            } else {
                [self.tencentOAuth getUserInfo];
            }
        } failure:^(NSError *error) {
            DLog(@"weibo login error:%@",error);
        }];
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{

}

- (void)tencentDidNotNetWork
{

}

/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response
{
    [ACShowAlertTool showMessage:@"登录中..." onView:nil];
    DLog(@"%@", response.jsonResponse);
    
    NSString *gender = @"m";
    if ([response.jsonResponse[@"gender"] isEqualToString:@"女"]) {
        gender = @"f";
    }
    NSString *location = @"";
    NSString *province = response.jsonResponse[@"province"];
    NSString *city = response.jsonResponse[@"city"];
    if ( 0 != province.length && 0 != city.length ) {
        location = [NSString stringWithFormat:@"%@ %@", province, city];
    }
    //3. 本地缓存
    self.tempUserModel.username = [ACUtility stringWithId:[response.jsonResponse objectForKey:@"nickname"]];
    self.tempUserModel.profile_image_url = [ACUtility stringWithId:[response.jsonResponse objectForKey:@"figureurl_qq_2"]];
    self.tempUserModel.avatar_large = [ACUtility stringWithId:[response.jsonResponse objectForKey:@"figureurl_qq_2"]];
    self.tempUserModel.location = location;
    self.tempUserModel.gender = gender;
    [ACCacheDataTool saveUserInfo:self.tempUserModel withObjectId:self.tempUserModel.objectId];
    
    //跳转至settingProfileVC
    [ACShowAlertTool hideMessage];
    ACSettingProfileInfoViewController *setProfileVC = [[ACSettingProfileInfoViewController alloc] init];
    setProfileVC.pushFromType = PushFromTypeLogin;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:setProfileVC];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    keyWindow.rootViewController = nav;
}

@end
