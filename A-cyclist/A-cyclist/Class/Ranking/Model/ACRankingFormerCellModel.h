//
//  ACRankingFormerCellModel.h
//  A-cyclist
//
//  Created by tunny on 15/8/9.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACRankingCellModel.h"

@interface ACRankingFormerCellModel : ACRankingCellModel
/** 下标 排名图片 */
@property (nonatomic, copy) NSString *suffixIcon;

+ (instancetype)settingCellWithTitle:(NSString *)title icon:(NSString *)icon location:(NSString *)location distance:(NSString *)distance suffixIcon:(NSString *)suffixIcon;
@end
