//
//  ACSettingCellModel.h
//  A-cyclist
//
//  Created by tunny on 15/7/15.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 在模型中定义block，保存每个cell对应的操作 */
typedef void(^ACSettingCellModelOption)(NSIndexPath *);

@interface ACSettingCellModel : NSObject
/** title */
@property (nonatomic, copy) NSString *title;
/** icon */
@property (nonatomic, copy) NSString *icon;
/** block */
@property (nonatomic, strong) ACSettingCellModelOption option;

+ (instancetype)settingCellWithTitle:(NSString *)title icon:(NSString *)icon;
@end
