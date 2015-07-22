//
//  ACPhotoSettingCellModel.m
//  A-cyclist
//
//  Created by tunny on 15/7/21.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACPhotoSettingCellModel.h"

@implementation ACPhotoSettingCellModel

+ (instancetype)photoSettingCellWithTitle:(NSString *)title photo:(NSString *)photo
{
    ACPhotoSettingCellModel *cellModel = [[self alloc] init];
    
    cellModel.title = title;
    cellModel.photo = photo;
    
    return cellModel;
}
@end
