//
//  ACLoginViewController.h
//  A-cyclist
//
//  Created by tunny on 15/7/18.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseKeyboardViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>

@interface ACLoginViewController : HCBaseKeyboardViewController
@property (nonatomic, retain)TencentOAuth *tencentOAuth;
@end
