//
//  ACHotRoutesCellModel.h
//  A-cyclist
//
//  Created by tunny on 15/8/10.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 在模型中定义block，保存每个cell对应的操作 */
typedef void(^ACSettingCellModelOption)();

@class ACSharedRouteModel;
@interface ACHotRoutesCellModel : NSObject
/** sharedRoute */
@property (nonatomic, strong) ACSharedRouteModel *sharedRoute;
/** block */
@property (nonatomic, strong) ACSettingCellModelOption option;

+ (instancetype)hotRoute:(ACSharedRouteModel *)sharedRoute;
@end
