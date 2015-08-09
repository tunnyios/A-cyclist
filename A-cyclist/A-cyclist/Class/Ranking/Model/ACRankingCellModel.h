//
//  ACRankingCellModel.h
//  A-cyclist
//
//  Created by tunny on 15/8/9.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 在模型中定义block，保存每个cell对应的操作 */
typedef void(^ACSettingCellModelOption)();

@interface ACRankingCellModel : NSObject
/** title */
@property (nonatomic, copy) NSString *title;
/** location */
@property (nonatomic, copy) NSString *location;
/** distance */
@property (nonatomic, copy) NSString *distance;
/** icon */
@property (nonatomic, copy) NSString *icon;

/** block */
@property (nonatomic, strong) ACSettingCellModelOption option;

+ (instancetype)settingCellWithTitle:(NSString *)title icon:(NSString *)icon location:(NSString *)location distance:(NSString *)distance;
@end
