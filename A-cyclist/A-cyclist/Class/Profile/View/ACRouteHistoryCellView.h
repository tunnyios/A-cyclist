//
//  ACRouteHistoryCellView.h
//  A-cyclist
//
//  Created by tunny on 15/8/8.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACProfileCellModel;
@interface ACRouteHistoryCellView : UITableViewCell
/** cellModel */
@property (nonatomic, strong) ACProfileCellModel *profileModel;

+ (instancetype)settingViewCellWithTableView:(UITableView *)tableView;
@end
