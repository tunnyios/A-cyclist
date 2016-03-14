//
//  ACRegisterViewController.h
//  A-cyclist
//
//  Created by tunny on 15/7/18.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseKeyboardViewController.h"

typedef enum : NSUInteger {
    RegisterPushFromTypeRegister,   //注册
    RegisterPushFromTypeRestPwd,    //重置密码
} RegisterPushFromType;

@interface ACRegisterViewController : HCBaseKeyboardViewController
/** 来源 */
@property (nonatomic, assign) RegisterPushFromType from;

@end
