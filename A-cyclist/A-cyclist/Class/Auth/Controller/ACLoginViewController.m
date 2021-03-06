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
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self initSomethingForSuper];
    
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    /* 手动移除通知，并退出键盘 */
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  设置基类属性
 */
- (void)initSomethingForSuper
{
    //传入textField数组
    self.textFieldArray = [NSMutableArray arrayWithArray:@[self.loginEmail, self.loginPwd]];
    //传入textField与键盘的偏移位置(64为多余的导航栏高度)
    self.textFieldOffset = 10 + 64;
    //传入需要移动和参照的View
    self.contentView = self.containerView;
}

#pragma mark - 登录相关
/**
 *  登录账户
 */
- (IBAction)login
{
    NSString *email = _loginEmail.text;
    if (![email isAvailPhoneNumber] && ![email isAvailEmail] &&![email isAvailUserName]) {
        [self.HUD hideErrorMessage:ACErrorEmail];
        return;
    }
    
    NSString *pwd = _loginPwd.text;
    if (!pwd) {
        [self.HUD hideErrorMessage:ACPasswordError];
        return;
    }
    
    //登录
    [self showHUD_Msg:@"正在登录"];
    __weak typeof (self)weakSelf = self;
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
            [weakSelf.HUD hide:YES];
        } else {
            [weakSelf.HUD hide:YES];
            [weakSelf.HUD hideErrorMessage:ACLoginError];
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
        [self.HUD hideErrorMessage:ACSinaLoginError];
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
        [self.HUD hideErrorMessage:ACSinaLoginError];
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
    [self showHUD_Msg:@"正在登录"];
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
    [self.HUD hide:YES];
    ACSettingProfileInfoViewController *setProfileVC = [[ACSettingProfileInfoViewController alloc] init];
    setProfileVC.pushFromType = PushFromTypeLogin;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:setProfileVC];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    keyWindow.rootViewController = nav;
}

@end
