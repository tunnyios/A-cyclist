//
//  ACProfileCellModel.m
//  A-cyclist
//
//  Created by tunny on 15/8/5.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACProfileCellModel.h"
#import "ACRouteModel.h"
#import "NSDate+Extension.h"


@implementation ACProfileCellModel

+ (instancetype)profileCellWithTitle:(NSString *)title subTitle:(NSString *)subTitle route:(ACRouteModel *)route destClass:(__unsafe_unretained Class)destClass
{
    ACProfileCellModel *model = [[ACProfileCellModel alloc] init];
    
    model.title = title;
    model.subTitle = subTitle;
    if (route == nil) {
        model.timeStr = nil;
    } else {
        model.timeStr = [NSDate dateToString:route.cyclingStartTime WithFormatter:@"yyyy-mm-dd"];
    }
    model.destClass = destClass;
    
    return model;
}
@end
