//
//  ACRouteHistoryController.h
//  A-cyclist
//
//  Created by tunny on 15/8/8.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACBaseTableViewController.h"

typedef enum : NSUInteger {
    RouteListTypePersonal,  //个人路线
    RouteListTypeShared,    //个人已共享路线
} RouteListType;

@interface ACRouteHistoryController : ACBaseTableViewController
/** 路线来源类别 */
@property (nonatomic, assign) RouteListType routeType;

@end
