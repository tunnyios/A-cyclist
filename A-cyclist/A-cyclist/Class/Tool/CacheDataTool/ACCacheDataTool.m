//
//  ACCacheDataTool.m
//  A-cyclist
//
//  Created by tunny on 15/7/20.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACCacheDataTool.h"
#import "ACUserModel.h"
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
}

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

@end
