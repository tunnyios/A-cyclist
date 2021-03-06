//
//  ACUploadSharedRouteController.h
//  A-cyclist
//
//  Created by tunny on 15/8/11.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACBaseViewController.h"

@class ACRouteModel;

//成功上传路线后
typedef void(^uploadSharedRoute)(BOOL);

@interface ACUploadSharedRouteController : ACBaseViewController
/** 路线地图Image */
@property (nonatomic, strong) UIImage *routeMapImage;
/** 路线对象 */
@property (nonatomic, strong) ACRouteModel *route;
/** 成功上传路线后的操作 */
@property (nonatomic, strong) uploadSharedRoute option;

@end
