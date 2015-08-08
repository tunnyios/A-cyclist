//
//  ACProfileCellModel.h
//  A-cyclist
//
//  Created by tunny on 15/8/5.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACSettingCellModel.h"

/** 在模型中定义block，保存每个cell对应的操作 */
typedef void(^ACSettingCellModelOption)(NSIndexPath *);

@class ACRouteModel;
@interface ACProfileCellModel : NSObject
/** title */
@property (nonatomic, copy) NSString *title;
/** time */
@property (nonatomic, copy) NSString *timeStr;
/** subTitle */
@property (nonatomic, copy) NSString *subTitle;
/** block */
@property (nonatomic, strong) ACSettingCellModelOption option;
/** 路线模型 */
@property (nonatomic, strong) ACRouteModel *route;

+ (instancetype)profileCellWithTitle:(NSString *)title subTitle:(NSString *)subTitle route:(ACRouteModel *)route;

@end
