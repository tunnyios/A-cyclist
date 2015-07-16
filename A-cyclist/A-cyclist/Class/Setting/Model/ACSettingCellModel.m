//
//  ACSettingCellModel.m
//  A-cyclist
//
//  Created by tunny on 15/7/15.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACSettingCellModel.h"

@implementation ACSettingCellModel

+ (instancetype)settingCellWithTitle:(NSString *)title icon:(NSString *)icon
{
    ACSettingCellModel *cellModel = [[self alloc] init];
    
    cellModel.title = title;
    cellModel.icon = icon;
    
    return cellModel;
}
@end
