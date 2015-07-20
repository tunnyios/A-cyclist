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
#import "MBProgressHUD+MJ.h"
#import "ACUserModel.h"


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
        [MBProgressHUD showError:ACErrorEmail];
        return;
    }
    
    NSString *pwd = _loginPwd.text;
    if (!pwd) {
        [MBProgressHUD showError:ACPasswordError];
        return;
    }
    
    //登录
    [ACDataBaseTool loginWithAccount:email passWord:pwd block:^(ACUserModel *user, NSError *error) {
        if (user) {
            [MBProgressHUD showSuccess:ACLoginSuccess];
            DLog(@"user #%@#", user);
            //跳转至主控制器
        } else {
            [MBProgressHUD showError:ACLoginError];
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
                [MBProgressHUD showSuccess:@"重置密码的邮件已经发送至您的邮箱"];
            } else {
                [MBProgressHUD showError:@"输入的邮箱还未注册"];
            }
        }];
    } else {
        [MBProgressHUD showError:ACEmptyEmail];
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
