//
//  ACPhotoSettingCellModel.h
//  A-cyclist
//
//  Created by tunny on 15/7/21.
//  Copyright (c) 2015年 tunny. All rights reserved.
//  头像cell

#import "ACSettingCellModel.h"

@interface ACPhotoSettingCellModel : ACSettingCellModel
/** photo */
@property (nonatomic, copy) NSString *photo;

+ (instancetype)photoSettingCellWithTitle:(NSString *)title photo:(NSString *)photo;

@end
