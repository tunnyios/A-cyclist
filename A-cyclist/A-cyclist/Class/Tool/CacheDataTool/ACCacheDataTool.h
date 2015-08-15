//
//  ACCacheDataTool.h
//  A-cyclist
//
//  Created by tunny on 15/7/20.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ACUserModel, ACRouteModel;
@interface ACCacheDataTool : NSObject

#pragma mark - 用户相关
/** 存储一条用户数据到本地数据库sqlite3 */
+ (void)saveUserInfo:(ACUserModel *)user withObjectId:(NSString *)objectId;

/** 更新一条用户数据到本地数据库 */
+ (void)updateUserInfo:(ACUserModel *)user  withObjectId:(NSString *)objectId;

/** 读取本地缓存的用户数据 */
+ (ACUserModel *)getUserInfo;

/* 删除用户信息 */
+ (BOOL)deleteUserData;

#pragma mark - 路线相关
/** 添加一条路线到sqlite3 */
+ (void)addRouteWith:(ACRouteModel *)route withUserObjectId:(NSString *)objectId;

/** 根据routeOne字段，获取一条路线 */
+ (ACRouteModel *)getRouteWith:(NSString *)routeOne;

/** 更新一条路线到sqlite3 */
+ (void)updateRouteWith:(ACRouteModel *)route routeOne:(NSString *)routeOne;

/** 从本地缓存中获取用户的所有路线 */
+ (NSArray *)getUserRouteWithid:(NSString *)objectId;

/** 从本地缓存中获取最远距离的一次骑行路线 */
+ (ACRouteModel *)getMaxDistanceRouteWithId:(NSString *)objectId;

/** 从本地缓存中获取最快极速的一次骑行路线 */
+ (ACRouteModel *)getMaxSpeedRouteWithId:(NSString *)objectId;

/** 从本地缓存中获取最快平均速度的一次骑行路线 */
+ (ACRouteModel *)getMaxAverageSpeedRouteWithId:(NSString *)objectId;

/** 从本地缓存中获取最长时间的一次骑行路线 */
+ (ACRouteModel *)getmaxTimeRouteWithId:(NSString *)objectId;


#pragma mark - 偏好设置存储

/** 存储数据到偏好设置 */
+ (void)setObjectToPlist:(id)value forKey:(NSString *)defaultName;

/** 从偏好设置中读取存储的数据 */
+ (id)objectForKeyFromPlist:(NSString *)defaultName;

@end
