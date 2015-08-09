//
//  ACUserDetailController.h
//  A-cyclist
//
//  Created by tunny on 15/8/9.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACBaseTableViewController.h"

@class ACUserModel;
@interface ACUserDetailController : ACBaseTableViewController
/** 用户数据 */
@property (nonatomic, strong) ACUserModel *userModel;

@end
