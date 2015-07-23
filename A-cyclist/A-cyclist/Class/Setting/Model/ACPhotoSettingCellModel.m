//
//  ACPhotoSettingCellModel.m
//  A-cyclist
//
//  Created by tunny on 15/7/21.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACPhotoSettingCellModel.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Extension.h"

@implementation ACPhotoSettingCellModel

+ (instancetype)photoSettingCellWithTitle:(NSString *)title photoURL:(NSString *)photoURL orPhotoImage:(UIImage *)photoImage
{
    __block ACPhotoSettingCellModel *cellModel = [[self alloc] init];
    
    cellModel.title = title;
    cellModel.photoImage = photoImage;
    cellModel.photoURL = photoURL;
    
    return cellModel;
}
@end
