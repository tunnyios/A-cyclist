//
//  ACHotRoutesCitesCellModel.m
//  A-cyclist
//
//  Created by tunny on 15/8/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACHotRoutesCitesCellModel.h"

@implementation ACHotRoutesCitesCellModel

+ (instancetype)citiesWithName:(NSString *)cityName
{
    ACHotRoutesCitesCellModel *citiesModel = [[ACHotRoutesCitesCellModel alloc] init];
    citiesModel.cityName = cityName;
    
    return citiesModel;
}

@end
