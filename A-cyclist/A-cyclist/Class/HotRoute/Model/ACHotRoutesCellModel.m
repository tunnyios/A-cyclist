//
//  ACHotRoutesCellModel.m
//  A-cyclist
//
//  Created by tunny on 15/8/10.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACHotRoutesCellModel.h"

@implementation ACHotRoutesCellModel

+ (instancetype)hotRoute:(ACSharedRouteModel *)sharedRoute
{
    ACHotRoutesCellModel *cellModel = [[ACHotRoutesCellModel alloc] init];
    cellModel.sharedRoute = sharedRoute;
    
    return cellModel;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{\n%@\n}", self.sharedRoute];
}
@end
