//
//  ACRankingCellModel.m
//  A-cyclist
//
//  Created by tunny on 15/8/9.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACRankingCellModel.h"

@implementation ACRankingCellModel

+ (instancetype)settingCellWithTitle:(NSString *)title icon:(NSString *)icon location:(NSString *)location distance:(NSString *)distance
{
    ACRankingCellModel *cellModel = [[self alloc] init];
    cellModel.title = title;
    cellModel.icon = icon;
    cellModel.location = location;
    cellModel.distance = distance;
    
    return cellModel;
}
@end
