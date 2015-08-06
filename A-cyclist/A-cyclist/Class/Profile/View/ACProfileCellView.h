//
//  ACProfileCellView.h
//  A-cyclist
//
//  Created by tunny on 15/8/5.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACProfileCellModel;
@interface ACProfileCellView : UITableViewCell
/** cellModel */
@property (nonatomic, strong) ACProfileCellModel *profileModel;

+ (instancetype)settingViewCellWithTableView:(UITableView *)tableView;
@end
