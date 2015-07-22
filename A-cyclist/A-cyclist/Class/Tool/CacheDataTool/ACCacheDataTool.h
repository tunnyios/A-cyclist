//
//  ACCacheDataTool.h
//  A-cyclist
//
//  Created by tunny on 15/7/20.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ACUserModel;
@interface ACCacheDataTool : NSObject

/** 存储一条用户数据到本地数据库sqlite3 */
+ (void)saveUserInfo:(ACUserModel *)user withObjectId:(NSString *)objectId;

/** 更新一条用户数据到本地数据库 */
+ (void)updateUserInfo:(ACUserModel *)user  withObjectId:(NSString *)objectId;

/** 读取本地缓存的用户数据 */
+ (ACUserModel *)getUserInfo;
@end
