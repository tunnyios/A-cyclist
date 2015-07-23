//
//  ACPhotoSettingCellModel.h
//  A-cyclist
//
//  Created by tunny on 15/7/21.
//  Copyright (c) 2015年 tunny. All rights reserved.
//  头像cell

#import "ACSettingCellModel.h"
#import <UIKit/UIKit.h>

@interface ACPhotoSettingCellModel : ACSettingCellModel
/** photo */
@property (nonatomic, copy) NSString *photoURL;

@property (nonatomic, strong) UIImage *photoImage;

+ (instancetype)photoSettingCellWithTitle:(NSString *)title photoURL:(NSString *)photoURL orPhotoImage:(UIImage *)photoImage;

@end
