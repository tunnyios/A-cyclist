//
//  ACCyclingDetailModel.m
//  A-cyclist
//
//  Created by tunny on 15/8/2.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACCyclingDetailModel.h"

@implementation ACCyclingDetailModel

+ (instancetype)settingCellWithTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    ACCyclingDetailModel *model = [[ACCyclingDetailModel alloc] init];
    
    model.title = title;
    model.subTitle = subTitle;
    return model;
}
@end
