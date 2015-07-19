//
//  ACRegisterViewController.m
//  A-cyclist
//
//  Created by tunny on 15/7/18.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACRegisterViewController.h"
#import <BmobSDK/Bmob.h>
#import "ACGlobal.h"
#import "NSString+Extension.h"
#import "MBProgressHUD+MJ.h"

@interface ACRegisterViewController ()
/** 昵称 */
@property (weak, nonatomic) IBOutlet UITextField *registerName;
/** 邮箱 */
@property (weak, nonatomic) IBOutlet UITextField *registerEmail;
/** 密码 */
@property (weak, nonatomic) IBOutlet UITextField *registerPwd;
/** 输入框容器view */
@property (weak, nonatomic) IBOutlet UIView *containterView;

@end

@implementation ACRegisterViewController

- (void)viewDidLoad {
    self.contentView = _containterView;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  返回登录界面
 */
- (IBAction)cancleBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  注册账户
 */
- (IBAction)register
{
    BmobUser *bUser = [[BmobUser alloc] init];
    
    NSString *email = _registerEmail.text;
    if ([email isAvailEmail]) {
        [bUser setEmail:email];
    } else {
        [MBProgressHUD showError:ACErrorEmail];
        return;
    }
    
    NSString *nickName = _registerName.text;
    if ([nickName isAvailUserName]) {
//        [bUser setUserName:nickName];
        bUser.username = nickName;
    } else {
        [MBProgressHUD showError:ACErrorUserName];
        return;
    }
    
    [bUser setPassword:_registerPwd.text];
    [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:ACRegisterSuccess];
            //跳转至主控制器
        } else {
            [MBProgressHUD showError:ACRegisterError];
            return;
        }
    }];
}

@end
