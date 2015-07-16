//
//  ACSettingViewCell.h
//  A-cyclist
//
//  Created by tunny on 15/7/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ACSettingCellModel;
@interface ACSettingViewCell : UITableViewCell
/** cell模型 */
@property (nonatomic, strong) ACSettingCellModel *cellModel;

+ (instancetype)settingViewCellWithTableView:(UITableView *)tableView;
@end
