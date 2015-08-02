//
//  ACCyclingDetailCell.h
//  A-cyclist
//
//  Created by tunny on 15/8/1.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACCyclingDetailModel;
@interface ACCyclingDetailCell : UITableViewCell
/** 详细骑行数据cell模型 */
@property (nonatomic, strong) ACCyclingDetailModel *cellModel;

+ (instancetype)settingViewCellWithTableView:(UITableView *)tableView;
@end
