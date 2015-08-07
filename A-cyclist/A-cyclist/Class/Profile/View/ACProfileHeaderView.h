//
//  ACProfileHeaderView.h
//  A-cyclist
//
//  Created by tunny on 15/8/6.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACUserModel;
@interface ACProfileHeaderView : UIView
/** 用户模型 */
@property (nonatomic, strong) ACUserModel *user;

+ (instancetype)profileHeaderView;
@end
