//
//  ACUploadSharedRouteController.h
//  A-cyclist
//
//  Created by tunny on 15/8/11.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACRouteModel;
@interface ACUploadSharedRouteController : UIViewController

/** 路线地图Image */
@property (nonatomic, strong) UIImage *routeMapImage;
/** 路线对象 */
@property (nonatomic, strong) ACRouteModel *route;
@end
