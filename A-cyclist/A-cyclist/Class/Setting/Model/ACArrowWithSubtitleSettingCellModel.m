//
//  ACArrowWithSubtitleSettingCellModel.m
//  A-cyclist
//
//  Created by tunny on 15/7/21.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACArrowWithSubtitleSettingCellModel.h"

@implementation ACArrowWithSubtitleSettingCellModel

+ (instancetype)arrowWithSubtitleCellWithTitle:(NSString *)title subTitle:(NSString *)subTitle icon:(NSString *)icon
{
    ACArrowWithSubtitleSettingCellModel *cellModel = [self settingCellWithTitle:title icon:icon];
    
    cellModel.subTitle = subTitle;
    
    return cellModel;
}
@end
