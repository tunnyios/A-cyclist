//
//  ACRankingFormerCellView.h
//  A-cyclist
//
//  Created by tunny on 15/8/9.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACRankingFormerCellModel;
@interface ACRankingFormerCellView : UITableViewCell
/** cell模型 */
@property (nonatomic, strong) ACRankingFormerCellModel *cellModel;

+ (instancetype)settingViewCellWithTableView:(UITableView *)tableView;
@end
