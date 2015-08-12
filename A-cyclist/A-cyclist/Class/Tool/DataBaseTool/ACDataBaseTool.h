//
//  ACDataBaseTool.h
//  A-cyclist
//
//  Created by tunny on 15/7/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>


@class ACUserModel, ACRouteModel, ACSharedRouteModel;
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

/* personRoute路线 */
/** 添加一条个人路线数据到personRoute数据库 */
+ (void)addRouteWith:(ACRouteModel *)route userObjectId:(NSString *)objectId resultBlock:(void (^) (BOOL isSuccessful, NSError *error))block;

/** 更新一条路线数据到数据库 */
+ (void)updateRouteWithUserObjectId:(NSString *)userObjectId routeStartDate:(NSDate *)startDate dict:(NSDictionary *)dict andKeys:(NSArray *)keys withResultBlock:(void (^) (BOOL isSuccessful, NSError *error))block;

/** 根据userObjectId 和 creatTime 获取一条personRoute */
+ (void)getRouteWithUserObjectId:(NSString *)userObjectId routeStartDate:(NSDate *)startDate resultBlock:(void (^) (ACRouteModel *route, NSError *error))block;

/** 根据用户id获取当前用户的路线列表 */
+ (void)getRouteListWithUserObjectId:(NSString *)objectId resultBlock:(void (^) (NSArray *routes, NSError *error))block;

/** 根据用户id获取当前用户已共享的路线列表 */
+ (void)getSharedRouteListWithUserObjectId:(NSString *)objectId resultBlock:(void (^) (NSArray *routes, NSError *error))block;

/** 根据用户id获取当前用户的路线中最远距离的一条路线 */
+ (void)getMaxDistanceRouteWithUserObjectId:(NSString *)objectId resultBlock:(void (^) (ACRouteModel *route, NSError *error))block;

/** 根据用户id获取当前用户的路线中最快极速的一条路线 */
+ (void)getMaxSpeedRouteWithUserObjectId:(NSString *)objectId resultBlock:(void (^) (ACRouteModel *route, NSError *error))block;

/** 根据用户id获取当前用户的路线中最快平均速度的一条路线 */
+ (void)getMaxAverageSpeedRouteWithUserObjectId:(NSString *)objectId resultBlock:(void (^) (ACRouteModel *route, NSError *error))block;

/** 根据用户id获取当前用户的路线中最长时间的一条路线 */
+ (void)getMaxTimeRouteWithUserObjectId:(NSString *)objectId resultBlock:(void (^) (ACRouteModel *route, NSError *error))block;


/* sharedRoute路线 */
/** 根据classification类别来获取sharedRoute列表 */
+ (void)getSharedRouteListClass:(NSString *)classification resultBlock:(void (^) (NSArray *sharedRoutes, NSError *error))block;

/** 添加一条共享路线到sharedRoute数据库 */
+ (void)addSharedRouteWith:(ACSharedRouteModel *)sharedRoute userObjectId:(NSString *)objectId resultBlock:(void (^) (BOOL isSuccessful, NSError *error))block;


#pragma mark - 排行相关
/** 根据userId获取当前用户的排名 */
+ (void)getRankingNumWithUserId:(NSString *)objectId resultBlock:(void (^) (NSString *numStr, NSError *error))block;

/** 对所有用户按累计里程进行降序排序 */
+ (void)getUserListWithResutl:(void (^) (NSArray *userList, NSError *error))block;


#pragma mark - BQL查询类
/** 根据sql语句来查询数据库, 返回对象数组 */
+ (void)queryWithSQL:(NSString *)bql pValues:(NSArray *)pVlaues block:(void (^)(NSArray *result, NSError *error))block;


#pragma mark - 文件相关
/** 上传单个文件到服务器 */
+ (void)uploadFileWithFilename:(NSString *)fileName fileData:(NSData *)data block:(void (^)(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url))block progress:(void (^)(CGFloat progress))progressBlock;

/** 上传多个文件到服务器 */
+ (void)uploadFilesWithDatas:(NSArray *)dataArray block:(void (^) (NSError *error, NSArray *fileNameArray, NSArray *urlArray))block progress:(void (^) (NSUInteger index, CGFloat progress))progressBlock;

/** 获取开启SecretKey安全验证后的url签名 */
+ (NSString *)signUrlWithFilename:(NSString *)filename url:(NSString *)urlString;

/** 在服务器上对上传的图片进行缩略图处理,并上传到服务器 */
+ (void)thumbnailImageWithFilename:(NSString *)filename ruleID:(NSUInteger)ruleNumber resultBlock:(void (^)(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url))block;

+ (void)thumbnailImageBySpecifiesTheWidth:(NSInteger)width height:(NSInteger)height quality:(NSInteger)quality sourceImageUrl:(NSString *)imageUrl resultBlock:(void (^)(NSString *filename, NSString *url, NSError *error))block;

@end
