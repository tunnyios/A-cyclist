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
/** 里程(km) */
@property (nonatomic, copy) NSString *distance;
/** 耗时 */
@property (nonatomic, copy) NSString *time;
/** 平均速度(km/h) */
@property (nonatomic, copy) NSString *averageSpeed;
/** 极速(km/h) */
@property (nonatomic, copy) NSString *maxSpeed;
/** 最高海拔(m) */
@property (nonatomic, copy) NSString *maxAltitude;
/** 最低海拔(m) */
@property (nonatomic, copy) NSString *minAltitude;
/** 累计上升海拔(m) */
@property (nonatomic, copy) NSString *ascendAltitude;

/** 上坡耗时 */
@property (nonatomic, copy) NSString *ascendTime;
/** 上坡距离(km) */
@property (nonatomic, copy) NSString *ascendDistance;
/** 平地耗时 */
@property (nonatomic, copy) NSString *flatTime;
/** 平地距离(km) */
@property (nonatomic, copy) NSString *flatDistance;
/** 下坡耗时 */
@property (nonatomic, copy) NSString *descendTime;
/** 下坡距离(km) */
@property (nonatomic, copy) NSString *descendDistance;

/** 卡路里计算(kcal) */
@property (nonatomic, copy) NSString *kcal;

/** 用户的id */
@property (nonatomic, copy) NSString *userObjectId;

/** 是否共享 */
@property (nonatomic, assign) NSNumber *isShared;
/** 路线热度 */
@property (nonatomic, copy) NSString *hotLevel;
/** 图片url列表 */
@property (nonatomic, strong) NSArray *imageList;

/** BmobObject对象的最后更新时间 */
@property(nonatomic,strong)NSDate *updatedAt;
/** BmobObject对象的生成时间 */
@property(nonatomic,strong)NSDate *createdAt;
/** 骑行结束时间 */
@property (nonatomic, strong) NSDate *cyclingEndTime;

@end
