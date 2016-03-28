//
//  ACDataBaseTool.h
//  A-cyclist
//
//  Created by tunny on 15/7/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

typedef enum : NSUInteger {
    ACLoginPlatformQQ = 0,
    ACLoginPlatformSinaWeibo,
    ACLoginPlatformWeiXin,
} ACLoginPlatform;

@class ACUserModel, ACRouteModel, ACSharedRouteModel;
@interface ACDataBaseTool : NSObject

#pragma mark - 账户相关
/**
 *  请求获取验证码
 *  @param template 发送短信的模板名
 */
+ (void)requestSMSCodeWithPhoneNum:(NSString *)phoneNum template:(NSString *)templateStr block:(void (^)(int number, NSError *error))block;


/**
 *  验证 验证码
 */
+ (void)verifySMSCodeWithPhoneNum:(NSString *)phoneNum code:(NSString *)smsCode block:(void (^)(BOOL isSuccessful, NSError *error))block;

/**
 *  根据手机验证码重置密码
 */
+ (void)resetPasswordWithCode:(NSString *)smsCode password:(NSString *)password block:(void (^)(BOOL isSuccessful, NSError *error))block;

/**
 *  手机号码注册登录
 */
+ (void)signUpWithPhone:(NSString *)phoneNum smsMask:(NSString *)smsMask passWord:(NSString *)pwd success:(void (^)(ACUserModel *user))success failure:(void (^)(NSError *error))failure;

/** 邮箱注册 */
+ (void)signUpWithUserName:(NSString *)userName email:(NSString *)email passWord:(NSString *)pwd block:(void(^)(BOOL isSuccessful, NSError *error))block;

/** 账户登录 */
+ (void)loginWithAccount:(NSString *)account passWord:(NSString *)pwd block:(void (^) (ACUserModel *user, NSError *error))block;

/**
 *  通过授权信息注册登录
 *
 *  @param accessToken    获取的token
 *  @param uid            授权后获取的id
 *  @param expirationDate 获取的过期时间
 *  @param platform       新浪微博，或者腾讯qq，微信
 */
+ (void)loginWithAccessToken:(NSString *)accessToken uid:(NSString *)uid expirationDate:(NSDate *)expirationDate platform:(ACLoginPlatform)platform success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

/** 重置密码--通过邮箱 */
+ (void)restPasswordWithEmail:(NSString *)email;

/** 更新用户资料 */
+ (void)updateUserInfoWith:(ACUserModel *)user withResultBlock:(void (^)(BOOL isSuccessful, NSError *error))block;
+ (void)updateUserInfoWithDict:(NSDictionary *)dict andKeys:(NSArray *)keys withResultBlock:(void (^) (BOOL isSuccessful, NSError *error))block;

/** 获取当前用户对象 */
+ (ACUserModel *)getCurrentUser;

/**
 *  根据手机号检查是否已注册过
 */
+ (void)checkAlreadyUserWithPhoneNum:(NSString *)number withResultBlock:(void (^)(BOOL isSuccessful, NSError *error))block;


#pragma mark - 路线数据相关

/* personRoute路线 */
/**
 *  添加一条个人路线数据到personRoute数据库
 */
+ (void)addRouteWith:(ACRouteModel *)route userObjectId:(NSString *)objectId resultBlock:(void (^) (BOOL isSuccessful, NSError *error))block;

/**
 *  更新一条路线数据到数据库
 */
+ (void)updateRouteWithUserObjectId:(NSString *)userObjectId routeStartDate:(NSDate *)startDate dict:(NSDictionary *)dict andKeys:(NSArray *)keys withResultBlock:(void (^) (BOOL isSuccessful, NSError *error))block;

/**
 *  删除一条路线数据到数据库
 */
+ (void)delRouteWithRouteObjectId:(NSString *)routeObjectId success:(void (^)(BOOL isSuccessful))success failure:(void (^)(NSError *error))failure;

/**
 *  根据userObjectId 和 creatTime 获取一条personRoute
 */
+ (void)getRouteWithUserObjectId:(NSString *)userObjectId routeStartDate:(NSDate *)startDate resultBlock:(void (^) (ACRouteModel *route, NSError *error))block;

/**
 *  根据用户id获取当前用户的路线列表
 */
+ (void)getRouteListWithUserObjectId:(NSString *)objectId pageIndex:(NSUInteger)pageIndex resultBlock:(void (^) (NSArray *routes, NSError *error))block;

/** 
 *  根据用户id获取当前用户的路线数量
 */
+ (void)getRouteListCountWithUserObjectId:(NSString *)objectId resultBlock:(void (^) (int routeCount, NSError *error))block;

/** 
 *  根据用户id获取当前用户已共享的路线列表
 */
+ (void)getSharedRouteListWithUserObjectId:(NSString *)objectId pageIndex:(NSUInteger)pageIndex resultBlock:(void (^) (NSArray *routes, NSError *error))block;

/**
 *  根据用户id获取当前用户的共享的路线数量
 */
+ (void)getSharedRouteListCountWithUserObjectId:(NSString *)objectId resultBlock:(void (^) (int routeCount, NSError *error))block;

/**
 *  根据用户id获取当前用户的路线中最远距离的一条路线
 */
+ (void)getMaxDistanceRouteWithUserObjectId:(NSString *)objectId resultBlock:(void (^) (ACRouteModel *route, NSError *error))block;

/**
 *  根据用户id获取当前用户的路线中最快极速的一条路线
 */
+ (void)getMaxSpeedRouteWithUserObjectId:(NSString *)objectId resultBlock:(void (^) (ACRouteModel *route, NSError *error))block;

/**
 *  根据用户id获取当前用户的路线中最快平均速度的一条路线
 */
+ (void)getMaxAverageSpeedRouteWithUserObjectId:(NSString *)objectId resultBlock:(void (^) (ACRouteModel *route, NSError *error))block;

/**
 *  根据用户id获取当前用户的路线中最长时间的一条路线
 */
+ (void)getMaxTimeRouteWithUserObjectId:(NSString *)objectId resultBlock:(void (^) (ACRouteModel *route, NSError *error))block;

/**
 *  获取共享的骑行路线
 *  获取最远骑行距离、极速、平均速度、单次最长时间路线
 */
+ (void)getShareAllMaxRoutesWithUserId:(NSString *)objectId success:(void (^)(NSDictionary *result))success failure:(void (^)(NSString  *error))failure;

/**
 *  获取个人的骑行路线
 *  获取最远骑行距离、极速、平均速度、单次最长时间路线
 */
+ (void)getPersonalAllMaxRoutesWithUserId:(NSString *)objectId success:(void (^)(NSDictionary *result))success failure:(void (^)(NSString  *error))failure;



/****************************** personSharedRoute表 personSharedRoute路线 **************************/
/** 添加一条共享路线到personSharedRoute数据库 */
+ (void)addPersonSharedRouteWith:(ACSharedRouteModel *)sharedRoute userObjectId:(NSString *)objectId resultBlock:(void (^) (BOOL isSuccessful, NSString *objectId, NSError *error))block;

/** 
 *  删除一条共享路线到personSharedRoute数据库
 */
+ (void)delPersonSharedRouteWithObjectId:(NSString *)objectId resultBlock:(void (^) (BOOL isSuccessful, NSError *error))block;


/****************************** sharedRoute表 sharedRoute路线 **************************/
/** 根据classification类别来获取sharedRoute列表 */
+ (void)getSharedRouteListClass:(NSString *)classification pageIndex:(NSUInteger)pageIndex resultBlock:(void (^) (NSArray *sharedRoutes, NSError *error))block;




#pragma mark - 排行相关
/** 根据userId获取当前用户的排名 */
+ (void)getRankingNumWithUserId:(NSString *)objectId resultBlock:(void (^) (NSString *numStr, NSError *error))block;

/** 对所有用户按累计里程进行降序排序 */
+ (void)getUserListWithPageIndex:(NSUInteger)pageIndex result:(void (^) (NSArray *userList, NSError *error))block;


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
