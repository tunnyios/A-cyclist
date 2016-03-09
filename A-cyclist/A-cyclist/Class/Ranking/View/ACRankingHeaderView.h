//
//  ACRankingHeaderView.h
//  A-cyclist
//
//  Created by tunny on 16/3/9.
//  Copyright © 2016年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACUserModel;
@interface ACRankingHeaderView : UIView
/** 用户模型 */
@property (nonatomic, strong) ACUserModel *userModel;

+ (instancetype)headerView;
@end
