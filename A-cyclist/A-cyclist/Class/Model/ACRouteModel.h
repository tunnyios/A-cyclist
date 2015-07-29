//
//  ACRoute.h
//  A-cyclist
//
//  Created by tunny on 15/7/29.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACRouteModel : NSObject <NSCoding>
/** 路线名称 */
@property (nonatomic, copy) NSString *routeName;
/** 轨迹 */
@property (nonatomic, strong) NSMutableArray *steps;
/** 里程 */
@property (nonatomic, assign) NSNumber *distance;
/** 耗时 */
@property (nonatomic, copy) NSString *time;
/** 平均速度 */
@property (nonatomic, copy) NSString *averageSpeed;
/** 极速 */
@property (nonatomic, copy) NSString *maxSpeed;
/** 用户的id */
@property (nonatomic, copy) NSString *userObjectId;

/** 是否共享 */
@property (nonatomic, assign) NSNumber *isShared;
/** 路线热度 */
@property (nonatomic, copy) NSString *hotLevel;
/** 图片url列表 */
@property (nonatomic, strong) NSArray *imageList;

/** BmobObject对象的最后更新时间 */
@property(nonatomic,retain)NSDate *updatedAt;
/** BmobObject对象的生成时间 */
@property(nonatomic,retain)NSDate *createdAt;

@end
