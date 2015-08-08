//
//  ACCacheDataTool.m
//  A-cyclist
//
//  Created by tunny on 15/7/20.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACCacheDataTool.h"
#import "ACUserModel.h"
#import "ACRouteModel.h"
#import "ACGlobal.h"
#import "FMDB.h"

@implementation ACCacheDataTool

static FMDatabase *_db;

+ (void)initialize
{
    //打开数据库
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"acyclist.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    //创建表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_user (id integer PRIMARY KEY, user blob NOT NULL, objectId text NOT NULL UNIQUE);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_personRoute (id integer PRIMARY KEY, route blob NOT NULL, userObjectId text NOT NULL, distance text NOT NULL, maxSpeed text NOT NULL, averageSpeed text NOT NULL, timeNumber text NOT NULL);"];
}


#pragma mark - 用户相关
/**
 *  保存一条UserInfo到本地数据库
 */
+ (void)saveUserInfo:(ACUserModel *)user withObjectId:(NSString *)objectId
{
    //转换成NSData
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
    
    [_db executeUpdateWithFormat:@"INSERT INTO t_user(user, objectId) VALUES (%@, %@);", userData, objectId];
    
    DLog(@"保存UserInfo到本地数据库成功");
}

/**
 *  更新一条userInfo数据到本地缓存数据库
 *
 *  @param user
 *  @param objectId
 */
+ (void)updateUserInfo:(ACUserModel *)user withObjectId:(NSString *)objectId
{
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
    [_db executeUpdate:@"update t_user set user = ? where objectId = ?", userData, objectId];

    DLog(@"更新UserInfo到本地缓存成功");
}

/**
 *  获取缓存中的用户信息
 */
+ (ACUserModel *)getUserInfo
{
    NSString *sql = @"SELECT * FROM t_user";
    // 执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *statuses = [NSMutableArray array];
    while (set.next) {
        NSData *statusData = [set objectForColumnName:@"user"];
        ACUserModel *user = [NSKeyedUnarchiver unarchiveObjectWithData:statusData];
        [statuses addObject:user];
    }
    return [statuses lastObject];
}

#pragma mark - 路线相关

/**
 *  为本地缓存添加一条路线记录
 *
 *  @param route
 *  @param objectId 对应用户的objectId
 */
+ (void)addRouteWith:(ACRouteModel *)route withUserObjectId:(NSString *)objectId
{
    //转换成NSData
    NSData *routeData = [NSKeyedArchiver archivedDataWithRootObject:route];
    
    [_db executeUpdateWithFormat:@"INSERT INTO t_personRoute(route, userObjectId, distance, maxSpeed, averageSpeed, timeNumber) VALUES (%@, %@, %@, %@, %@, %@);", routeData, objectId, route.distance, route.maxSpeed, route.averageSpeed, route.timeNumber];
    
    DLog(@"保存UserRoute到本地数据库成功");
}

/**
 *  根据用户id获取用户的所有路线
 *
 *  @param objectId
 *
 *  @return 返回路线对象数组
 */
+ (NSArray *)getUserRouteWithid:(NSString *)objectId
{
    NSMutableArray *routeList = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_personRoute WHERE userObjectId = '%@'", objectId];
    DLog(@"sql is %@", sql);
    // 执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    while (set.next) {
        NSData *routeData = [set objectForColumnName:@"route"];
        ACRouteModel *route = [NSKeyedUnarchiver unarchiveObjectWithData:routeData];
        [routeList addObject:route];
    }
    return routeList;
}

/**
 *  根据用户id获取用户最远的一次骑行路线
 */
+ (ACRouteModel *)getMaxDistanceRouteWithId:(NSString *)objectId
{
    NSMutableArray *routeList = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_personRoute WHERE userObjectId = '%@' ORDER BY distance DESC", objectId];
//    select * from t_student order by age desc
    // 执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    while (set.next) {
        NSData *routeData = [set objectForColumnName:@"route"];
        ACRouteModel *route = [NSKeyedUnarchiver unarchiveObjectWithData:routeData];
        [routeList addObject:route];
    }
    return routeList.firstObject;
}
/**
 *  根据用户id获取用户最快极速的一次骑行路线
 */
+ (ACRouteModel *)getMaxSpeedRouteWithId:(NSString *)objectId
{
    NSMutableArray *routeList = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_personRoute WHERE userObjectId = '%@' ORDER BY maxSpeed DESC", objectId];
    //    select * from t_student order by age desc
    // 执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    while (set.next) {
        NSData *routeData = [set objectForColumnName:@"route"];
        ACRouteModel *route = [NSKeyedUnarchiver unarchiveObjectWithData:routeData];
        [routeList addObject:route];
    }
    return routeList.firstObject;
}

/**
 *  根据用户id获取用户最快平均速度的一次骑行路线
 */
+ (ACRouteModel *)getMaxAverageSpeedRouteWithId:(NSString *)objectId
{
    NSMutableArray *routeList = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_personRoute WHERE userObjectId = '%@' ORDER BY averageSpeed DESC", objectId];
    //    select * from t_student order by age desc
    // 执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    while (set.next) {
        NSData *routeData = [set objectForColumnName:@"route"];
        ACRouteModel *route = [NSKeyedUnarchiver unarchiveObjectWithData:routeData];
        [routeList addObject:route];
    }
    return routeList.firstObject;
}

/**
 *  根据用户id获取用户最长时间的一次骑行路线
 */
+ (ACRouteModel *)getmaxTimeRouteWithId:(NSString *)objectId
{
    NSMutableArray *routeList = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_personRoute WHERE userObjectId = '%@' ORDER BY timeNumber DESC", objectId];
    //    select * from t_student order by age desc
    // 执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    while (set.next) {
        NSData *routeData = [set objectForColumnName:@"route"];
        ACRouteModel *route = [NSKeyedUnarchiver unarchiveObjectWithData:routeData];
        [routeList addObject:route];
    }
    return routeList.firstObject;
}

@end
