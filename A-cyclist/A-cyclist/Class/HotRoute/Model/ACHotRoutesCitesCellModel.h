//
//  ACHotRoutesCitesCellModel.h
//  A-cyclist
//
//  Created by tunny on 15/8/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 在模型中定义block，保存每个cell对应的操作 */
typedef void(^ACCitiesCellModelOption)(NSIndexPath *indexPath);

@interface ACHotRoutesCitesCellModel : NSObject
/** block */
@property (nonatomic, strong) ACCitiesCellModelOption option;
/** cityTitle */
@property (nonatomic, copy) NSString *cityName;

+ (instancetype)citiesWithName:(NSString *)cityName;
@end
