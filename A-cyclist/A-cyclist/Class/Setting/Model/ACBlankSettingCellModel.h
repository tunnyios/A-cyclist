//
//  ACBlankSettingCellModel.h
//  A-cyclist
//
//  Created by tunny on 15/7/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACSettingCellModel.h"

@interface ACBlankSettingCellModel : ACSettingCellModel
/** subTitle */
@property (nonatomic, copy) NSString *subTitle;

/** 类方法，添加subTitle */
+ (instancetype)blankSettingCellWithTitle:(NSString *)title subTitle:(NSString *)subTitle icon:(NSString *)icon;
@end
