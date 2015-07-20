//
//  ACRegisterViewController.m
//  A-cyclist
//
//  Created by tunny on 15/7/18.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACRegisterViewController.h"
#import "ACDataBaseTool.h"
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
    NSString *email = _registerEmail.text;
    if (![email isAvailEmail]) {
        [MBProgressHUD showError:ACErrorEmail];
        return;
    }

    NSString *nickName = _registerName.text;
    if (![nickName isAvailUserName]) {
        [MBProgressHUD showError:ACErrorUserName];
        return;
    }
    
    NSString *pwd = _registerPwd.text;
    if (!pwd) {
        [MBProgressHUD showError:ACPasswordError];
        return;
    }
    
    /* 邮箱注册 */
    [ACDataBaseTool signUpWithUserName:nickName email:email passWord:pwd block:^(BOOL isSuccessful, NSError *error) {
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
