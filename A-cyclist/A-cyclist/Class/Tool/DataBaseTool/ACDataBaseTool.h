//
//  ACDataBaseTool.h
//  A-cyclist
//
//  Created by tunny on 15/7/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>


@class ACUserModel, ACRouteModel;
@interface ACDataBaseTool : NSObject

#pragma mark - 账户相关
/** 邮箱注册 */
+ (void)signUpWithUserName:(NSString *)userName email:(NSString *)email passWord:(NSString *)pwd block:(void(^)(BOOL isSuccessful, NSError *error))block;

/** 账户登录 */
+ (void)loginWithAccount:(NSString *)account passWord:(NSString *)pwd block:(void (^) (ACUserModel *user, NSError *error))block;

/** 重置密码--通过邮箱 */
+ (void)restPasswordWithEmail:(NSString *)email;

/** 更新用户资料 */
+ (void)updateUserInfoWith:(ACUserModel *)user withResultBlock:(void (^)(BOOL isSuccessful, NSError *error))block;
+ (void)updateUserInfoWithDict:(NSDictionary *)dict andKeys:(NSArray *)keys withResultBlock:(void (^) (BOOL isSuccessful, NSError *error))block;

/** 获取当前用户对象 */
+ (ACUserModel *)getCurrentUser;


#pragma mark - 路线数据相关
/** 添加一条路线数据到数据库 */
+ (void)addRouteWith:(ACRouteModel *)route userObjectId:(NSString *)objectId resultBlock:(void (^) (BOOL isSuccessful, NSError *error))block;

/** 更新一条路线数据到数据库 */

/** 根据用户id获取当前用户的路线列表 */
+ (void)getRouteListWithUserObjectId:(NSString *)objectId resultBlock:(void (^) (NSArray *routes, NSError *error))block;

/** 根据用户id获取当前用户的路线中最远距离的一条路线 */
+ (void)getMaxDistanceRouteWithUserObjectId:(NSString *)objectId resultBlock:(void (^) (ACRouteModel *route, NSError *error))block;

/** 根据用户id获取当前用户的路线中最快极速的一条路线 */
+ (void)getMaxSpeedRouteWithUserObjectId:(NSString *)objectId resultBlock:(void (^) (ACRouteModel *route, NSError *error))block;

/** 根据用户id获取当前用户的路线中最快平均速度的一条路线 */
+ (void)getMaxAverageSpeedRouteWithUserObjectId:(NSString *)objectId resultBlock:(void (^) (ACRouteModel *route, NSError *error))block;

/** 根据用户id获取当前用户的路线中最长时间的一条路线 */
+ (void)getMaxTimeRouteWithUserObjectId:(NSString *)objectId resultBlock:(void (^) (ACRouteModel *route, NSError *error))block;


#pragma mark - BQL查询类
/** 根据sql语句来查询数据库, 返回对象数组 */
+ (void)queryWithSQL:(NSString *)bql pValues:(NSArray *)pVlaues block:(void (^)(NSArray *result, NSError *error))block;

#pragma mark - 文件相关

/** 上传文件到服务器 */
+ (void)uploadFileWithFilename:(NSString *)fileName fileData:(NSData *)data block:(void (^)(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url))block progress:(void (^)(CGFloat progress))progressBlock;

/** 获取开启SecretKey安全验证后的url签名 */
+ (NSString *)signUrlWithFilename:(NSString *)filename url:(NSString *)urlString;

/** 在服务器上对上传的图片进行缩略图处理,并上传到服务器 */
+ (void)thumbnailImageWithFilename:(NSString *)filename ruleID:(NSUInteger)ruleNumber resultBlock:(void (^)(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url))block;

+ (void)thumbnailImageBySpecifiesTheWidth:(NSInteger)width height:(NSInteger)height quality:(NSInteger)quality sourceImageUrl:(NSString *)imageUrl resultBlock:(void (^)(NSString *filename, NSString *url, NSError *error))block;

@end
