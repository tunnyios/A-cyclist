//
//  ACHotRoutesCitiesCellView.h
//  A-cyclist
//
//  Created by tunny on 15/8/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACHotRoutesCitesCellModel;
@interface ACHotRoutesCitiesCellView : UITableViewCell
/** cellModel */
@property (nonatomic, strong) ACHotRoutesCitesCellModel *cellModel;

+ (instancetype)settingViewCellWithTableView:(UITableView *)tableView;
@end
