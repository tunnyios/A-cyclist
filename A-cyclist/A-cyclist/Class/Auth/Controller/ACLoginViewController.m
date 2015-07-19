//
//  ACLoginViewController.m
//  A-cyclist
//
//  Created by tunny on 15/7/18.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACLoginViewController.h"
#import <BmobSDK/Bmob.h>
#import "ACGlobal.h"
#import "NSString+Extension.h"
#import "MBProgressHUD+MJ.h"

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
    if ([email isAvailEmail]) {
        [BmobUser loginInbackgroundWithAccount:email andPassword:_loginPwd.text block:^(BmobUser *user, NSError *error) {
            if (user) {
                [MBProgressHUD showSuccess:ACLoginSuccess];
                DLog(@"user #%@#", user);
                //跳转至主控制器
            } else {
                [MBProgressHUD showError:ACLoginError];
                return;
            }
        }];
    } else {
        [MBProgressHUD showError:ACErrorEmail];
    }
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
    if ([self.loginEmail.text isAvailEmail]) {
        //从数据库中查找匹配的邮箱地址
    } else {
        [MBProgressHUD showError:ACErrorEmail];
    }
}

#pragma mark - 第三方登录
- (IBAction)qqLogin
{

}

- (IBAction)weboLogin
{
    
}

- (IBAction)wechatLogin
{
    
}

@end
