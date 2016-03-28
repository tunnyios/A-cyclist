//
//  ACRegisterViewController.m
//  A-cyclist
//
//  Created by tunny on 15/7/18.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACRegisterViewController.h"
#import "ACDataBaseTool.h"
#import "ACCacheDataTool.h"
#import "ACGlobal.h"
#import "ACUtility.h"
#import "ACUserModel.h"
#import "NSString+Extension.h"
#import "ACShowAlertTool.h"
#import "ACSettingProfileInfoViewController.h"

@interface ACRegisterViewController ()
/** 手机号 */
@property (weak, nonatomic) IBOutlet UITextField *registerPhone;
/** 验证码 */
@property (weak, nonatomic) IBOutlet UITextField *registerSms;
/** 密码 */
@property (weak, nonatomic) IBOutlet UITextField *registerPwd;
/** 输入框容器view */
@property (weak, nonatomic) IBOutlet UIView *containterView;
/** 获取验证码按钮 */
@property (weak, nonatomic) IBOutlet UIButton *smsNumBtn;
/** timer */
@property (nonatomic, strong) NSTimer *timer;
/** 记录秒数 */
@property (nonatomic, assign) NSUInteger seconds;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation ACRegisterViewController

- (void)viewDidLoad {
    self.contentView = _containterView;
    [super viewDidLoad];

    if (RegisterPushFromTypeRegister == self.from) {    //登录
        [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    } else if (RegisterPushFromTypeRestPwd == self.from) {  //重置
        [self.registerBtn setTitle:@"重置" forState:UIControlStateNormal];
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
    // 销毁timer
    [self.timer invalidate];
    // 置nil
    self.timer = nil;
}

/**
 *  返回登录界面
 */
- (IBAction)cancleBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  点击获取验证码
 */
- (IBAction)getMaskNum:(id)sender
{
    if (![self.registerPhone.text isAvailPhoneNumber]) {
        [self showMsgCenter:ACInvalidPhone];
        return;
    }
    __weak typeof (self)weakSelf = self;
    //如果已经注册过了禁止注册
    [ACDataBaseTool checkAlreadyUserWithPhoneNum:self.registerPhone.text withResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [weakSelf showMsgCenter:@"该号码已注册"];
            return;
        }
    }];

    //请求验证码
    [ACDataBaseTool requestSMSCodeWithPhoneNum:self.registerPhone.text template:nil block:^(int number, NSError *error) {
        if (error) {
            [weakSelf showMsgCenter:@"发送验证码失败，请稍后再试"];
        } else {
            //创建一个时钟
            weakSelf.seconds = 60;
            weakSelf.smsNumBtn.userInteractionEnabled = NO;
            weakSelf.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:weakSelf.timer forMode:NSRunLoopCommonModes];
        }
    }];
}

- (void)updateTimer:(NSTimer *)timer
{
    if (0 == self.seconds) {
        //停止时钟
        [self.timer invalidate];
        [self.smsNumBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.smsNumBtn.userInteractionEnabled = YES;
    } else {
        NSString *temp = [NSString stringWithFormat:@"%lu 秒", (unsigned long)self.seconds];
        [self.smsNumBtn setTitle:temp forState:UIControlStateNormal];
        self.seconds--;
    }

}

/**
 *  注册账户
 */
- (IBAction)registerAcount
{
    __block NSString *phoneNum = self.registerPhone.text;
    if (![phoneNum isAvailPhoneNumber]) {
        [ACShowAlertTool showError:ACInvalidPhone];
        return;
    }
    if (self.registerSms.text.length <= 0) {
        [ACShowAlertTool showError:ACInvalidSMSMask];
        return;
    }
    
    __block NSString *pwd = self.registerPwd.text;
    if (!pwd) {
        [ACShowAlertTool showError:ACPasswordError];
        return;
    }
    //验证用户
    __weak typeof (self)weakSelf = self;
    if (RegisterPushFromTypeRegister == self.from) {    //注册
        //注册登录
        [ACShowAlertTool showMessage:@"注册登录中..." onView:nil];
        [ACDataBaseTool signUpWithPhone:phoneNum smsMask:self.registerSms.text passWord:pwd success:^(ACUserModel *user) {
            [ACShowAlertTool hideMessage];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            user.password = pwd;
            //本地缓存
            [ACCacheDataTool saveUserInfo:user withObjectId:user.objectId];
            //跳转至settingProfileVC
            ACSettingProfileInfoViewController *setProfileVC = [[ACSettingProfileInfoViewController alloc] init];
            setProfileVC.pushFromType = PushFromTypeLogin;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:setProfileVC];
            window.rootViewController = nav;
        } failure:^(NSError *error) {
            [ACShowAlertTool hideMessage];
            [ACShowAlertTool showError:ACLoginError];
        }];
    } else if (RegisterPushFromTypeRestPwd == self.from) {  //重置密码
        [ACShowAlertTool showMessage:@"正在加载" onView:nil];
        [ACDataBaseTool resetPasswordWithCode:weakSelf.registerSms.text password:pwd block:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [ACShowAlertTool hideMessage];
                [ACShowAlertTool showSuccess:ACRestPasswordSuccess];
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            } else {
                [ACShowAlertTool hideMessage];
                [ACShowAlertTool showSuccess:ACRestPasswordError];
            }
        }];
    }
}

@end
