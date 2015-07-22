//
//  ACArrowWithSubtitleSettingCellModel.h
//  A-cyclist
//
//  Created by tunny on 15/7/21.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACSettingCellModel.h"

@interface ACArrowWithSubtitleSettingCellModel : ACSettingCellModel
/** subTitle */
@property (nonatomic, copy) NSString *subTitle;

/** 类方法，添加subTitle */
+ (instancetype)arrowWithSubtitleCellWithTitle:(NSString *)title subTitle:(NSString *)subTitle icon:(NSString *)icon;
@end
