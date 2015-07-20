//
//  ACDataBaseTool.h
//  A-cyclist
//
//  Created by tunny on 15/7/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>


@class ACUserModel;
@interface ACDataBaseTool : NSObject

#pragma mark - 账户相关
/** 邮箱注册 */
+ (void)signUpWithUserName:(NSString *)userName email:(NSString *)email passWord:(NSString *)pwd block:(void(^)(BOOL isSuccessful, NSError *error))block;

/** 账户登录 */
+ (void)loginWithAccount:(NSString *)account passWord:(NSString *)pwd block:(void (^) (ACUserModel *user, NSError *error))block;

/** 重置密码--通过邮箱 */
+ (void)restPasswordWithEmail:(NSString *)email;

/** 更新用户资料 */
+ (void)updateUserInfoWithDict:(NSDictionary *)dict andKeys:(NSArray *)keys withResultBlock:(void (^) (BOOL isSuccessful, NSError *error))block;


#pragma mark - BQL查询类

/** 获取当前用户对象 */
+ (ACUserModel *)getCurrentUser;

/** 根据sql语句来查询数据库, 返回对象数组 */
+ (void)queryWithSQL:(NSString *)bql pValues:(NSArray *)pVlaues block:(void (^)(NSArray *result, NSError *error))block;



@end
