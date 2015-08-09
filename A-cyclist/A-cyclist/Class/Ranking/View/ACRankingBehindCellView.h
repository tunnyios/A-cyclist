//
//  ACRankingBehindCellView.h
//  A-cyclist
//
//  Created by tunny on 15/8/9.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACRankingBehindCellModel;
@interface ACRankingBehindCellView : UITableViewCell
/** cell模型 */
@property (nonatomic, strong) ACRankingBehindCellModel *cellModel;

+ (instancetype)settingViewCellWithTableView:(UITableView *)tableView;
@end
