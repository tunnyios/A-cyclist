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
#import "WeiboSDK.h"
#import "ACTabBarController.h"
#import "ACCacheDataTool.h"


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

}

- (IBAction)weboLogin
{
    if([WeiboSDK isWeiboAppInstalled]){
        //向新浪发送请求
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
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

@end
