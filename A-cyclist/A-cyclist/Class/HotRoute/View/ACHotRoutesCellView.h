//
//  ACHotRoutesCell.h
//  A-cyclist
//
//  Created by tunny on 15/8/10.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACHotRoutesCellModel;
@interface ACHotRoutesCellView : UITableViewCell
/** cellModel */
@property (nonatomic, strong) ACHotRoutesCellModel *cellModel;

+ (instancetype)settingViewCellWithTableView:(UITableView *)tableView;
@end
