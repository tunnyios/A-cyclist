//
//  ACRankingBehindCellModel.m
//  A-cyclist
//
//  Created by tunny on 15/8/9.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACRankingBehindCellModel.h"

@implementation ACRankingBehindCellModel

+ (instancetype)settingCellWithTitle:(NSString *)title icon:(NSString *)icon location:(NSString *)location distance:(NSString *)distance suffixNum:(NSString *)suffixNum
{
    ACRankingBehindCellModel *cellModel = [self settingCellWithTitle:title icon:icon location:location distance:distance];
    
    cellModel.suffixNum = suffixNum;
    
    return cellModel;
}
@end
