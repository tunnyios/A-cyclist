//
//  ACBlankSettingCellModel.m
//  A-cyclist
//
//  Created by tunny on 15/7/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACBlankSettingCellModel.h"

@implementation ACBlankSettingCellModel

+ (instancetype)blankSettingCellWithTitle:(NSString *)title subTitle:(NSString *)subTitle icon:(NSString *)icon
{
    ACBlankSettingCellModel *cellModel = [self settingCellWithTitle:title icon:icon];
    
    cellModel.subTitle = subTitle;
    
    return cellModel;
}
@end
