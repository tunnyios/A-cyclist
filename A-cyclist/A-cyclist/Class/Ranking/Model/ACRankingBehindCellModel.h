//
//  ACRankingBehindCellModel.h
//  A-cyclist
//
//  Created by tunny on 15/8/9.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACRankingCellModel.h"

@interface ACRankingBehindCellModel : ACRankingCellModel
/** 下标 排名 */
@property (nonatomic, copy) NSString *suffixNum;

+ (instancetype)settingCellWithTitle:(NSString *)title icon:(NSString *)icon location:(NSString *)location distance:(NSString *)distance suffixNum:(NSString *)suffixNum;
@end
