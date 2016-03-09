//
//  ACCyclingArgumentsViewController.h
//  A-cyclist
//
//  Created by tunny on 15/7/25.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACBaseViewController.h"

@class ACRouteModel;
@interface ACCyclingArgumentsViewController : ACBaseViewController
/** 路线对象 */
@property (nonatomic, strong) ACRouteModel *route;

@end
