//
//  ACArrowSettingCellModel.m
//  A-cyclist
//
//  Created by tunny on 15/7/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACArrowSettingCellModel.h"

@implementation ACArrowSettingCellModel

+ (instancetype)arrowSettingCellModelWithTitle:(NSString *)title icon:(NSString *)icon destClass:(Class)destClass
{
    ACArrowSettingCellModel *arrowModel = [self settingCellWithTitle:title icon:icon];
    
    arrowModel.destClass = destClass;
    
    return arrowModel;
}

@end
