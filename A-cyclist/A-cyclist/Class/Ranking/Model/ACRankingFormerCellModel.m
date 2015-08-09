//
//  ACRankingFormerCellModel.m
//  A-cyclist
//
//  Created by tunny on 15/8/9.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACRankingFormerCellModel.h"

@implementation ACRankingFormerCellModel

+ (instancetype)settingCellWithTitle:(NSString *)title icon:(NSString *)icon location:(NSString *)location distance:(NSString *)distance suffixIcon:(NSString *)suffixIcon
{
    ACRankingFormerCellModel *cellModel = [self settingCellWithTitle:title icon:icon location:location distance:distance];
    
    cellModel.suffixIcon = suffixIcon;
    
    return cellModel;
}
@end
