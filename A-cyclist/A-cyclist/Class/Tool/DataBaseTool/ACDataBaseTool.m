//
//  ACDataBaseTool.m
//  A-cyclist
//
//  Created by tunny on 15/7/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACDataBaseTool.h"
#import "ACUserModel.h"
#import "ACGlobal.h"
#import <BmobSDK/BmobProFile.h>
#import "ACSharedRouteModel.h"
#import "ACSharedRoutePhotoModel.h"
#import "ACRouteModel.h"
#import "ACStepModel.h"
#import "NSArray+Log.h"
#import "NSDate+Extension.h"
#import "MJExtension.h"


@implementation ACDataBaseTool

#pragma mark - 账户相关
/**
 *  手机号码登录
 */
+ (void)signUpWithPhone:(NSString *)phoneNum smsMask:(NSString *)smsMask passWord:(NSString *)pwd success:(void (^)(ACUserModel *))success failure:(void (^)(NSError *))failure
{
    [BmobUser signOrLoginInbackgroundWithMobilePhoneNumber:phoneNum andSMSCode:smsMask block:^(BmobUser *user, NSError *error) {
        if (user) {
            if (success) {
                ACUserModel *ACUser = [ACUserModel userWithBmobUser:user];
                success(ACUser);
            }
        } else {
            if (failure) {
                failure(error);
            }
        }
    }];

}

/**
 *  请求获取验证码
 *  @param template 发送短信的模板名
 */
+ (void)requestSMSCodeWithPhoneNum:(NSString *)phoneNum template:(NSString *)templateStr block:(void (^)(int, NSError *))block
{
    //请求验证码
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:phoneNum andTemplate:templateStr resultBlock:^(int number, NSError *error) {
        if (block) {
            block(number, error);
        }
    }];
}

/**
 *  验证 验证码
 */
+ (void)verifySMSCodeWithPhoneNum:(NSString *)phoneNum code:(NSString *)smsCode block:(void (^)(BOOL, NSError *))block
{
    //验证
    [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:phoneNum andSMSCode:smsCode resultBlock:^(BOOL isSuccessful, NSError *error) {
        if (block) {
            block(isSuccessful, error);
        }
    }];
}

/**
 *  根据手机验证码重置密码
 */
+ (void)resetPasswordWithCode:(NSString *)smsCode password:(NSString *)password block:(void (^)(BOOL, NSError *))block
{
    [BmobUser resetPasswordInbackgroundWithSMSCode:smsCode andNewPassword:password block:^(BOOL isSuccessful, NSError *error) {
        if (block) {
            block(isSuccessful, error);
        }
    }];
}

/**
 *  邮箱注册
 *
 *  @param userName 昵称
 *  @param email    邮箱
 *  @param pwd      密码
 *  @param block    返回成功还是失败
 */
+ (void)signUpWithUserName:(NSString *)userName email:(NSString *)email passWord:(NSString *)pwd block:(void (^)(BOOL, NSError *))block
{
    BmobUser *bUser = [[BmobUser alloc] init];
    bUser.username = userName;
    [bUser setEmail:email];
    [bUser setPassword:pwd];
    
    [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (block) {
            block(isSuccessful, error);
        }
    }];
}

/**
 *  账户登录
 *
 *  @param account 账户名：可以是邮箱/用户名/手机号
 *  @param block   返回登录结果
 */
+ (void)loginWithAccount:(NSString *)account passWord:(NSString *)pwd block:(void (^)(ACUserModel *user, NSError *))block
{
    [BmobUser loginInbackgroundWithAccount:account andPassword:pwd block:^(BmobUser *user, NSError *error) {
        DLog(@"bmobuser #%@#", user);
        if (block) {
            ACUserModel *ACUser = (user) ? [ACUserModel userWithBmobUser:user] : nil;
            block(ACUser, error);
        }
    }];
}

/**
 *  通过授权信息注册登录
 *
 *  @param accessToken    获取的token
 *  @param uid            授权后获取的id
 *  @param expirationDate 授权后获取的id
 */
+ (void)loginWithAccessToken:(NSString *)accessToken uid:(NSString *)uid expirationDate:(NSDate *)expirationDate platform:(ACLoginPlatform)platform success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    if (!accessToken || !uid || !expirationDate) {
        DLog(@"error is 参数不能为空");
        return;
    }
    
    NSDictionary *dic = @{@"access_token":accessToken,@"uid":uid,@"expirationDate":expirationDate};
    [BmobUser loginInBackgroundWithAuthorDictionary:dic platform:(BmobSNSPlatform)platform block:^(BmobUser *user, NSError *error) {
        if (!error){
            if (success) {
                ACUserModel *ACUser = [ACUserModel userWithBmobUser:user];
                success(ACUser);
            }
        } else {
            if (failure) {
                failure(error);
            }
        }
    }];
}

/**
 *  根据邮箱重置密码
 */
+ (void)restPasswordWithEmail:(NSString *)email
{
    [BmobUser requestPasswordResetInBackgroundWithEmail:email];
}

/**
 *  更新用户资料
 *
 *  @param dict  用户表的键值对儿
 *  @param block 结果信息
 */
+ (void)updateUserInfoWith:(ACUserModel *)user withResultBlock:(void (^)(BOOL, NSError *))block
{
    BmobUser *bUser = [BmobUser getCurrentUser];
    
    [bUser setObject:user.username forKey:@"username"];
    [bUser setObject:user.signature forKey:@"signature"];
    [bUser setObject:user.password forKey:@"password"];
    [bUser setObject:user.email forKey:@"email"];
    [bUser setObject:user.mobilePhoneNumber forKey:@"mobilePhoneNumber"];
    [bUser setObject:user.location forKey:@"location"];
    [bUser setObject:user.weight forKey:@"weight"];
    [bUser setObject:user.gender forKey:@"gender"];
    [bUser setObject:user.profile_image_url forKey:@"profile_image_url"];
    [bUser setObject:user.avatar_large forKey:@"avatar_large"];
    [bUser setObject:user.accruedTime forKey:@"accruedTime"];
    [bUser setObject:user.accruedDistance forKey:@"accruedDistance"];
    
    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (block) {
            block(isSuccessful, error);
        }
    }];
}

+ (void)updateUserInfoWithDict:(NSDictionary *)dict andKeys:(NSArray *)keys withResultBlock:(void (^)(BOOL, NSError *))block
{
    BmobUser *bUser = [BmobUser getCurrentUser];
    
    for (NSString *key in keys) {
        [bUser setObject:dict[key] forKey:key];
    }
    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (block) {
            block(isSuccessful, error);
        }
    }];
}

/**
 *  从数据库中获取当前用户信息
 */
+ (ACUserModel *)getCurrentUser
{
    BmobUser *user = [BmobUser getCurrentUser];
    DLog(@"bmobUser is %@", user);
    ACUserModel *ACUser = (user) ? [ACUserModel userWithBmobUser:user] : nil;
    
    return ACUser;
}

/**
 *  根据手机号检查是否已注册过
 */
+ (void)checkAlreadyUserWithPhoneNum:(NSString *)number withResultBlock:(void (^)(BOOL, NSError *))block
{
    BmobQuery *query = [BmobUser query];
    [query whereKey:@"mobilePhoneNumber" equalTo:number];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            block(YES, error);
        } else {
            block(NO, error);
        }
    }];
}

#pragma mark - 路线数据相关

+ (void)addRouteWith:(ACRouteModel *)route userObjectId:(NSString *)objectId resultBlock:(void (^)(BOOL, NSError *))block
{
    BmobObject *post = [BmobObject objectWithClassName:@"personRoute"];
    
    //设置共享路线参数
    [post setObject:route.isShared forKey:@"isShared"];
    //设置路线基本参数
    [post setObject:route.routeName forKey:@"routeName"];
    
    //将数组对象转数组字典
    NSMutableArray *steps = [NSMutableArray array];
    [route.steps enumerateObjectsUsingBlock:^(ACStepModel *step, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:step.altitude forKey:@"altitude"];
        [dict setObject:step.latitude forKey:@"latitude"];
        [dict setObject:step.longitude forKey:@"longitude"];
        [dict setObject:step.currentSpeed forKey:@"currentSpeed"];
        [dict setObject:step.distanceInterval forKey:@"distanceInterval"];
        
        [steps addObject:dict];
    }];
    
    [post setObject:steps forKey:@"steps"];
    [post setObject:route.distance forKey:@"distance"];
    [post setObject:route.time forKey:@"time"];
    [post setObject:route.timeNumber forKey:@"timeNumber"];
    [post setObject:route.averageSpeed forKey:@"averageSpeed"];
    [post setObject:route.maxSpeed forKey:@"maxSpeed"];
    [post setObject:route.userObjectId forKey:@"userObjectId"];
    
    [post setObject:route.maxAltitude forKey:@"maxAltitude"];
    [post setObject:route.minAltitude forKey:@"minAltitude"];
    [post setObject:route.ascendAltitude forKey:@"ascendAltitude"];
    [post setObject:route.ascendTime forKey:@"ascendTime"];
    [post setObject:route.ascendDistance forKey:@"ascendDistance"];
    [post setObject:route.flatTime forKey:@"flatTime"];
    [post setObject:route.flatDistance forKey:@"flatDistance"];
    [post setObject:route.descendTime forKey:@"descendTime"];
    [post setObject:route.descendDistance forKey:@"descendDistance"];
    
    [post setObject:route.cyclingEndTime forKey:@"cyclingEndTime"];
    [post setObject:route.cyclingStartTime forKey:@"cyclingStartTime"];
    [post setObject:route.routeOne forKey:@"routeOne"];
    [post setObject:route.kcal forKey:@"kcal"];

    //设置路线关联的作者记录
    BmobUser *author = [BmobUser objectWithoutDatatWithClassName:@"_User" objectId:objectId];
    [post setObject:author forKey:@"user"];
    
    //异步保存
    [post saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (block) {
            block(isSuccessful, error);
        }
    }];
}

/**
 *  根据路线的objectId来更新数据
 *
 *  @param route
 *  @param objectId     路线的objectId
 *  @param block
 */
+ (void)updateRouteWithUserObjectId:(NSString *)userObjectId routeStartDate:(NSDate *)startDate dict:(NSDictionary *)dict andKeys:(NSArray *)keys withResultBlock:(void (^)(BOOL, NSError *))block
{
//    BmobObject *routeObject = [BmobObject objectWithoutDatatWithClassName:@"personRoute"  objectId:routeObjectId];
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"personRoute"];
    
    //构造约束条件
    NSString *date = [NSDate dateToString:startDate WithFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSDictionary *condiction1 = @{@"user":@{@"__type":@"Pointer",@"className":@"_User",@"objectId":userObjectId}};
    NSDictionary *condiction2 = @{@"cyclingStartTime":@{@"__type": @"Date", @"iso": date}};
    NSArray *condictionArray = @[condiction1,condiction2];
    [bquery addTheConstraintByAndOperationWithArray:condictionArray];
    
    //匹配查询
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        DLog(@"array is %@, error is %@", array, error);
        //将BmobObject对象数组转换成Route对象数组
        if (!error) {
            BmobObject *routeObject = array.firstObject;
            for (NSString *key in keys) {
                [routeObject setObject:dict[key] forKey:key];
            }
            [routeObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (block) {
                    block(isSuccessful, error);
                }
            }];
        } else {
            if (block) {
                block(NO, error);
            }
        }
    }];
}

/**
 *  删除一条路线数据到数据库
 */
+ (void)delRouteWithRouteObjectId:(NSString *)routeObjectId success:(void (^)(BOOL))success failure:(void (^)(NSError *))failure
{
    BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"personRoute" objectId:routeObjectId];
    [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (!error) {
            success(isSuccessful);
        } else {
            failure(error);
        }
    }];
}

/**
 *  根据userObjectId 和 routeStartDate 获取一条personRoute
 *
 *  @param userObjectId
 *  @param startData    2014-07-15 00:00:00
 *  @param block
 */
+ (void)getRouteWithUserObjectId:(NSString *)userObjectId routeStartDate:(NSDate *)startDate resultBlock:(void (^)(ACRouteModel *, NSError *))block
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"personRoute"];
    
    //构造约束条件
    NSString *date = [NSDate dateToString:startDate WithFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSDictionary *condiction1 = @{@"user":@{@"__type":@"Pointer",@"className":@"_User",@"objectId":userObjectId}};
    NSDictionary *condiction2 = @{@"cyclingStartTime":@{@"__type": @"Date", @"iso": date}};
    NSArray *condictionArray = @[condiction1,condiction2];
    [bquery addTheConstraintByAndOperationWithArray:condictionArray];
    
    //匹配查询
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                DLog(@"array error is %@", error);
        //将BmobObject对象数组转换成Route对象数组
        NSArray *routeArray = nil;
        if (error == nil) {
            routeArray = [ACRouteModel routeModelArrayWithBmobObjectArray:array];
        }
        if (block) {
            DLog(@"routeArray error is %@", error);
            block(routeArray.firstObject, error);
        }
    }];
}



/**
 *  根据用户id获取数据库中的路线列表
 *  (约束关联对象查询)
 *  @param objectId
 *
 *  @return BmobObject对象数组
 */
+ (void)getRouteListWithUserObjectId:(NSString *)objectId pageIndex:(NSUInteger)pageIndex resultBlock:(void (^)(NSArray *, NSError *))block
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"personRoute"];
    
    //构造约束条件
    BmobQuery *inQuery = [BmobQuery queryWithClassName:@"_User"];
    [inQuery whereKey:@"objectId" equalTo:objectId];
    
    bquery.limit = ACDataLimitCount;
    bquery.skip = bquery.limit * (pageIndex - 1);
    //匹配查询
    [bquery whereKey:@"user" matchesQuery:inQuery];
    [bquery orderByDescending:@"cyclingEndTime"];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//        DLog(@"array is %@, error is %@", array, error);
        //将BmobObject对象数组转换成Route对象数组
        NSArray *routeArray = nil;
        if (error == nil) {
            routeArray = [ACRouteModel routeModelArrayWithBmobObjectArray:array];
        }
        if (block) {
            DLog(@"routeArray error is %@", error);
            block(routeArray, error);
        }
    }];
}

/**
 *  根据用户id查询数据库中，用户已经共享了的路线列表
 */
+ (void)getSharedRouteListWithUserObjectId:(NSString *)objectId pageIndex:(NSUInteger)pageIndex resultBlock:(void (^)(NSArray *, NSError *))block
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"personRoute"];
    
    //构造约束条件
    NSDictionary *condiction1 = @{@"user":@{@"__type":@"Pointer",@"className":@"_User",@"objectId":objectId}};
    NSDictionary *condiction2 = @{@"isShared":@1};
    NSArray *condictionArray = @[condiction1,condiction2];
    [bquery addTheConstraintByAndOperationWithArray:condictionArray];
    
    bquery.limit = ACDataLimitCount;
    bquery.skip = bquery.limit * (pageIndex - 1);
    [bquery orderByDescending:@"cyclingEndTime"];
    //匹配查询
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //        DLog(@"array is %@, error is %@", array, error);
        //将BmobObject对象数组转换成Route对象数组
        NSArray *routeArray = nil;
        if (error == nil) {
            routeArray = [ACRouteModel routeModelArrayWithBmobObjectArray:array];
        }
        if (block) {
            DLog(@"routeArray error is %@", error);
            block(routeArray, error);
        }
    }];
}

/**
 *  根据用户id获取当前用户的路线数量
 */
+ (void)getRouteListCountWithUserObjectId:(NSString *)objectId resultBlock:(void (^)(int, NSError *))block
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"personRoute"];
    [bquery whereKey:@"userObjectId" equalTo:objectId];
    [bquery countObjectsInBackgroundWithBlock:^(int number,NSError  *error){
        if (block) {
            block(number, error);
        }
    }];
}

/**
 *  根据用户id获取当前用户共享的路线数量
 */
+ (void)getSharedRouteListCountWithUserObjectId:(NSString *)objectId resultBlock:(void (^)(int, NSError *))block
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"personRoute"];
    [bquery whereKey:@"userObjectId" equalTo:objectId];
    //构造约束条件
    NSDictionary *condiction1 = @{@"userObjectId" : objectId};
    NSDictionary *condiction2 = @{@"isShared" : @1};
    NSArray *condictionArray = @[condiction1,condiction2];
    [bquery addTheConstraintByAndOperationWithArray:condictionArray];
    
    [bquery countObjectsInBackgroundWithBlock:^(int number,NSError  *error){
        if (block) {
            block(number, error);
        }
    }];
}

/**
 *  根据用户id获取当前用户的路线中最远距离的一条路线
 */
+ (void)getMaxDistanceRouteWithUserObjectId:(NSString *)objectId resultBlock:(void (^)(ACRouteModel *, NSError *))block
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"personRoute"];
    
    [bquery orderByDescending:@"distance"];
    //构造约束条件
    BmobQuery *inQuery = [BmobQuery queryWithClassName:@"_User"];
    [inQuery whereKey:@"objectId" equalTo:objectId];
    
    //匹配查询
    [bquery whereKey:@"user" matchesQuery:inQuery];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //        DLog(@"array is %@, error is %@", array, error);
        //将BmobObject对象数组转换成Route对象数组
        ACRouteModel *routeModel = [[ACRouteModel alloc] init];
        if (error == nil) {
            routeModel = [ACRouteModel routeModelWithBmobObject:(BmobObject *)array.firstObject];
        } else {
            DLog(@"maxDistanceRouteModel error is %@", error);
        }
        if (block) {
            block(routeModel, error);
        }
    }];
}

/**
 *  根据用户id获取当前用户的路线中最快极速的一条路线
 */
+ (void)getMaxSpeedRouteWithUserObjectId:(NSString *)objectId resultBlock:(void (^)(ACRouteModel *, NSError *))block
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"personRoute"];
    
    [bquery orderByDescending:@"maxSpeed"];
    //构造约束条件
    BmobQuery *inQuery = [BmobQuery queryWithClassName:@"_User"];
    [inQuery whereKey:@"objectId" equalTo:objectId];
    
    //匹配查询
    [bquery whereKey:@"user" matchesQuery:inQuery];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //        DLog(@"array is %@, error is %@", array, error);
        //将BmobObject对象数组转换成Route对象数组
        ACRouteModel *routeModel = [[ACRouteModel alloc] init];
        if (error == nil) {
            routeModel = [ACRouteModel routeModelWithBmobObject:(BmobObject *)array.firstObject];
        } else {
            DLog(@"maxSpeedRouteModel error is %@", error);
        }
        if (block) {
            block(routeModel, error);
        }
    }];
}

/**
 *  根据用户id获取当前用户的路线中最快平均速度的一条路线
 */
+ (void)getMaxAverageSpeedRouteWithUserObjectId:(NSString *)objectId resultBlock:(void (^)(ACRouteModel *, NSError *))block
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"personRoute"];
    
    [bquery orderByDescending:@"averageSpeed"];
    //构造约束条件
    BmobQuery *inQuery = [BmobQuery queryWithClassName:@"_User"];
    [inQuery whereKey:@"objectId" equalTo:objectId];
    
    //匹配查询
    [bquery whereKey:@"user" matchesQuery:inQuery];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //        DLog(@"array is %@, error is %@", array, error);
        //将BmobObject对象数组转换成Route对象数组
        ACRouteModel *routeModel = [[ACRouteModel alloc] init];
        if (error == nil) {
            routeModel = [ACRouteModel routeModelWithBmobObject:(BmobObject *)array.firstObject];
        } else {
            DLog(@"maxAverageSpeedRouteModel error is %@", error);
        }
        if (block) {
            block(routeModel, error);
        }
    }];
}

/**
 *  根据用户id获取当前用户的路线中最长时间的一条路线
 */
+ (void)getMaxTimeRouteWithUserObjectId:(NSString *)objectId resultBlock:(void (^)(ACRouteModel *, NSError *))block
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"personRoute"];
    
    [bquery orderByDescending:@"timeNumber"];
    //构造约束条件
    BmobQuery *inQuery = [BmobQuery queryWithClassName:@"_User"];
    [inQuery whereKey:@"objectId" equalTo:objectId];
    
    //匹配查询
    [bquery whereKey:@"user" matchesQuery:inQuery];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //        DLog(@"array is %@, error is %@", array, error);
        //将BmobObject对象数组转换成Route对象数组
        ACRouteModel *routeModel = [[ACRouteModel alloc] init];
        if (error == nil) {
            routeModel = [ACRouteModel routeModelWithBmobObject:(BmobObject *)array.firstObject];
        } else {
            DLog(@"maxTimeRouteModel error is %@", error);
        }
        if (block) {
            block(routeModel, error);
        }
    }];
}


/**
 *  根据classification类别来获取sharedRoute列表
 *
 */
+ (void)getSharedRouteListClass:(NSString *)classification pageIndex:(NSUInteger)pageIndex resultBlock:(void (^)(NSArray *, NSError *))block
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"sharedRoute"];
    bquery.limit = ACDataLimitCount;
    bquery.skip = bquery.limit * (pageIndex - 1);
    
    [bquery orderByDescending:@"createdAt"];
    //构造约束条件
    [bquery whereKey:@"classification" equalTo:classification];
    
    //匹配查询
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        DLog(@"array is %@, error is %@", array, error);
        //将BmobObject对象数组转换成sharedRoute对象数组
        NSArray *routeArray = nil;
        if (error == nil) {
            routeArray = [ACSharedRouteModel sharedRouteModelArrayWithBmobObjectArray:array];
        }
        if (block) {
//            DLog(@"sharedRouteArray is %@, error is %@", routeArray, error);
            block(routeArray, error);
        }
    }];
}

/**
 *  添加一条共享路线到personSharedRoute数据库
 *
 *  @param sharedRoute 共享路线模型
 *  @param objectId    该路线的来源用户id
 *  @param block
 */
+ (void)addPersonSharedRouteWith:(ACSharedRouteModel *)sharedRoute userObjectId:(NSString *)objectId resultBlock:(void (^)(BOOL, NSString *, NSError *))block
{
    BmobObject *post = [BmobObject objectWithClassName:@"personSharedRoute"];
    
    //设置共享路线基本参数
    [post setObject:sharedRoute.nameCN forKey:@"nameCN"];
    [post setObject:sharedRoute.nameEN forKey:@"nameEN"];
    [post setObject:sharedRoute.distance forKey:@"distance"];
    [post setObject:sharedRoute.maxAlitude forKey:@"maxAlitude"];
    [post setObject:sharedRoute.difficultyLevel forKey:@"difficultyLevel"];
    [post setObject:sharedRoute.sceneryLevel forKey:@"sceneryLevel"];
    [post setObject:sharedRoute.userName forKey:@"userName"];
    [post setObject:sharedRoute.userObjectId forKey:@"userObjectId"];
    [post setObject:sharedRoute.routeDesc forKey:@"routeDesc"];
    [post setObject:sharedRoute.classification forKey:@"classification"];

    //将数组对象转数组字典
    NSMutableArray *imageArray = [NSMutableArray array];
    [sharedRoute.imageList enumerateObjectsUsingBlock:^(ACSharedRoutePhotoModel *photoModel, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:photoModel.photoURL forKey:@"photoURL"];
        
        [imageArray addObject:dict];
    }];
    [post setObject:imageArray forKey:@"imageList"];
    
    //设置路线关联的作者记录
    BmobUser *author = [BmobUser objectWithoutDatatWithClassName:@"_User" objectId:objectId];
    [post setObject:author forKey:@"user"];
    
    //异步保存
    [post saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (block) {
            block(isSuccessful, post.objectId, error);
        }
    }];
}

/**
 *  删除一条共享路线到personSharedRoute数据库
 *
 *  @param sharedRoute 共享路线模型
 *  @param objectId    共享路线objectID
 *  @param block
 */
+ (void)delPersonSharedRouteWithObjectId:(NSString *)objectId resultBlock:(void (^)(BOOL, NSError *))block
{
    BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"personSharedRoute"  objectId:objectId];
    [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (block) {
            block(isSuccessful, error);
        }
    }];
}

/**
 *  获取最远骑行距离、极速、平均速度、单次最长时间路线
 *  以及共享路线详情
 */
+ (void)getShareAllMaxRoutesWithUserId:(NSString *)objectId success:(void (^)(NSDictionary *result))success failure:(void (^)(NSString  *error))failure
{
    //0. 获取数据库中的用户已共享的路线列表
    __block NSNumber *routeCounts = nil;
    __block ACRouteModel *maxDistanceRoute = nil;
    __block ACRouteModel *maxSpeedRoute = nil;
    __block ACRouteModel *maxAverageRoute = nil;
    __block ACRouteModel *maxTimeRoute = nil;
    [ACDataBaseTool getSharedRouteListCountWithUserObjectId:objectId resultBlock:^(int routeCount, NSError *error) {
        if (error) {
            DLog(@"从数据库中获取用户路线数据失败, error:%@", error);
        } else {
            routeCounts = [NSNumber numberWithInt:routeCount];
        }
        
        //1. 获取最长距离路线数据
        [ACDataBaseTool getMaxDistanceRouteWithUserObjectId:objectId resultBlock:^(ACRouteModel *route, NSError *error) {
            if (error) {
                DLog(@"从数据库中获取最长距离数据失败, error:%@", error);
            } else {
                maxDistanceRoute = route;
            }
            
            //2. 获取最快极速路线数据
            [ACDataBaseTool getMaxSpeedRouteWithUserObjectId:objectId resultBlock:^(ACRouteModel *route, NSError *error) {
                if (error) {
                    DLog(@"从数据库中获取最快极速数据失败, error:%@", error);
                } else {
                    maxSpeedRoute = route;
                }
                
                //3. 获取最快平均速度路线数据
                [ACDataBaseTool getMaxAverageSpeedRouteWithUserObjectId:objectId resultBlock:^(ACRouteModel *route, NSError *error) {
                    if (error) {
                        DLog(@"从数据库中获取最快平均速度数据失败, error:%@", error);
                    } else {
                        maxAverageRoute = route;
                    }
                    
                    //4. 获取最长时间路线数据
                    [ACDataBaseTool getMaxTimeRouteWithUserObjectId:objectId resultBlock:^(ACRouteModel *route, NSError *error) {
                        if (error) {
                            DLog(@"从数据库中获取最长时间数据失败, error:%@", error);
                        } else {
                            maxTimeRoute = route;
                        }
                        
                        if (routeCounts && maxDistanceRoute && maxSpeedRoute && maxAverageRoute && maxTimeRoute) {
                            if (success) {
                                NSDictionary *dict = @{@"routeCount" : routeCounts,
                                                       @"maxDistanceRoute" : maxDistanceRoute,
                                                       @"maxSpeedRoute" : maxSpeedRoute,
                                                       @"maxAverageRoute" : maxAverageRoute,
                                                       @"maxTimeRoute" : maxTimeRoute};
                                success(dict);
                            }
                        } else {
                            if (failure) {
                                failure(@"获取路线失败");
                            }
                        }
                    }];
                }];
            }];
        }];
    }];
}


/**
 *  获取最远骑行距离、极速、平均速度、单次最长时间路线
 *  以及个人路线详情
 */
+ (void)getPersonalAllMaxRoutesWithUserId:(NSString *)objectId success:(void (^)(NSDictionary *result))success failure:(void (^)(NSString  *error))failure
{
    //0. 获取数据库中的用户已共享的路线列表
    __block NSNumber *routeCounts = nil;
    __block ACRouteModel *maxDistanceRoute = nil;
    __block ACRouteModel *maxSpeedRoute = nil;
    __block ACRouteModel *maxAverageRoute = nil;
    __block ACRouteModel *maxTimeRoute = nil;
    [ACDataBaseTool getRouteListCountWithUserObjectId:objectId resultBlock:^(int routeCount, NSError *error) {
        if (error) {
            DLog(@"从数据库中获取用户路线数据失败, error:%@", error);
        } else {
            routeCounts = [NSNumber numberWithInt:routeCount];
        }
        
        //1. 获取最长距离路线数据
        [ACDataBaseTool getMaxDistanceRouteWithUserObjectId:objectId resultBlock:^(ACRouteModel *route, NSError *error) {
            if (error) {
                DLog(@"从数据库中获取最长距离数据失败, error:%@", error);
            } else {
                maxDistanceRoute = route;
            }
            
            //2. 获取最快极速路线数据
            [ACDataBaseTool getMaxSpeedRouteWithUserObjectId:objectId resultBlock:^(ACRouteModel *route, NSError *error) {
                if (error) {
                    DLog(@"从数据库中获取最快极速数据失败, error:%@", error);
                } else {
                    maxSpeedRoute = route;
                }
                
                //3. 获取最快平均速度路线数据
                [ACDataBaseTool getMaxAverageSpeedRouteWithUserObjectId:objectId resultBlock:^(ACRouteModel *route, NSError *error) {
                    if (error) {
                        DLog(@"从数据库中获取最快平均速度数据失败, error:%@", error);
                    } else {
                        maxAverageRoute = route;
                    }
                    
                    //4. 获取最长时间路线数据
                    [ACDataBaseTool getMaxTimeRouteWithUserObjectId:objectId resultBlock:^(ACRouteModel *route, NSError *error) {
                        if (error) {
                            DLog(@"从数据库中获取最长时间数据失败, error:%@", error);
                        } else {
                            maxTimeRoute = route;
                        }
                        
                        if (routeCounts && maxDistanceRoute && maxSpeedRoute && maxAverageRoute && maxTimeRoute) {
                            if (success) {
                                NSDictionary *dict = @{@"routeCount" : routeCounts,
                                                       @"maxDistanceRoute" : maxDistanceRoute,
                                                       @"maxSpeedRoute" : maxSpeedRoute,
                                                       @"maxAverageRoute" : maxAverageRoute,
                                                       @"maxTimeRoute" : maxTimeRoute};
                                success(dict);
                            }
                        } else {
                            if (failure) {
                                failure(@"获取路线失败");
                            }
                        }
                    }];
                }];
            }];
        }];
    }];
}

#pragma mark - 排行相关
/**
 *  获取用户当前的排名
 */
+ (void)getRankingNumWithUserId:(NSString *)objectId resultBlock:(void (^)(NSString *, NSError *))block
{
     //name是上传到云端的参数名称，值是bmob，云端代码可以通过调用request.body.name获取这个值
     NSDictionary  *dic = [NSDictionary  dictionaryWithObject:objectId forKey:@"objectId"];
     //test对应你刚刚创建的云端代码名称
     [BmobCloud callFunctionInBackground:@"getUserRanking" withParameters:dic block:^(id object, NSError *error) {
         if (block) {
             DLog(@"object is %@, error is %@", object, error);
             block((NSString *)object, error);
         }
     }] ;
}

+ (NSArray *)userModelArrayWithBmobUserArray:(NSArray *)array
{
    NSMutableArray *userArrayM = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(BmobUser *obj, NSUInteger idx, BOOL *stop) {
        if (obj) {
            ACUserModel *user = [ACUserModel userWithBmobUser:obj];
            [userArrayM addObject:user];
        }
    }];
    
    return userArrayM;
}

/**
 *  对所有用户按累计里程进行降序排序
 */
+ (void)getUserListWithPageIndex:(NSUInteger)pageIndex result:(void (^)(NSArray *, NSError *))block
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"_User"];
    bquery.limit = ACDataLimitCount;
    bquery.skip = bquery.limit * (pageIndex - 1);
    //排序
    [bquery orderByDescending:@"accruedDistance"];
    
    //匹配查询
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //        DLog(@"array is %@, error is %@", array, error);
        //将BmobUser对象数组转换成ACUser对象数组
        NSArray *userArray = nil;
        if (error == nil) {
            userArray = [self userModelArrayWithBmobUserArray:array];
        }
        if (block) {
            DLog(@"userArray is %@, error is %@", userArray, error);
            block(userArray, error);
        }
    }];

}


#pragma mark - 查询相关

/**
 *  根据sql语句来普通查询数据库
 *
 *  @param bql       sql语句
 *  @param pVlaues   ?占位符的替代物
 *  @param block     id result:存的是对象数组
 */
+ (void)queryWithSQL:(NSString *)bql pValues:(NSArray *)pVlaues block:(void (^)(NSArray *, NSError *))block
{
    BmobQuery   *bquery = [[BmobQuery alloc] init];
    
    if (pVlaues.count > 0) {
        [bquery queryInBackgroundWithBQL:bql pvalues:pVlaues block:^(BQLQueryResult *result, NSError *error) {
            if (block) {
                block(result.resultsAry, error);
            }
        }];
    } else {
        [bquery queryInBackgroundWithBQL:bql block:^(BQLQueryResult *result, NSError *error) {
            if (block) {
                block(result.resultsAry, error);
            }
        }];
    }
}


#pragma mark - 文件相关

/**
 *  使用NSData的方式上传单个文件到Bmob数据库
 *
 *  PS:利用文件名的方式下载：下载的文件存放路径为：Library/Caches/DownloadFile/
 *
 *  @param fileName      文件名
 *  @param data          NSData
 *  @param block         返回结果
            fileName    返回文件名(可用作文件下载的参数)
            url         并非完整的URL，只是最终访问的url的一部分
 *  @param progressBlock
 */
+ (void)uploadFileWithFilename:(NSString *)fileName fileData:(NSData *)data block:(void (^)(BOOL, NSError *, NSString *, NSString *))block progress:(void (^)(CGFloat))progressBlock
{
    [BmobProFile uploadFileWithFilename:fileName fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url,BmobFile *bmobFile) {
        DLog(@"database: filename:%@\n url:%@\n bmobfile.filename:%@\n bmobfile.group:%@ bmobfile.url:%@", fileName, url, bmobFile.name, bmobFile.group, bmobFile.url);
        if (block) {
            block(isSuccessful, error, bmobFile.name, bmobFile.url);
        }
    } progress:^(CGFloat progress) {
        if (progressBlock) {
            progressBlock(progress);
        }
    }];
}

/**
 *  通过NSData上传多个文件到服务器
 *
 *  @param dataArray     字典数组，包括filename, data
 *      NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"image.jpg",@"filename",data1,@"data",nil];
 *  @param block        返回url数组、filename数组
 *  @param progressBlock    进度：index表示正在上传的文件其路径在数组中的索引，progress表示该文件的上传进度
 */
+ (void)uploadFilesWithDatas:(NSArray *)dataArray block:(void (^)(NSError *, NSArray *, NSArray *))block progress:(void (^)(NSUInteger, CGFloat))progressBlock
{    
    //上传文件，dataArray 数组中存放NSDictionary，NSDictionary里面的格式为@{@"filename":@"你的文件名",@"data":文件的data}
    [BmobProFile uploadFilesWithDatas:dataArray resultBlock:^(NSArray *filenameArray, NSArray *urlArray, NSArray *bmobFileArray,NSError *error) {
        DLog(@"database: filenameArray:%@\n urlArray:%@\n bmobfileArray:%@\n error:%@\n", filenameArray, urlArray, bmobFileArray, error);
        if (error) {
            if (block) {
                block(error, filenameArray, urlArray);
            }
        } else {
            //路径数组和url数组（url数组里面的元素为NSString）
            NSMutableArray *fileNameList = [NSMutableArray array];
            NSMutableArray *urlList = [NSMutableArray array];
            for (BmobFile* bmobFile in bmobFileArray ) {
                [fileNameList addObject:bmobFile.name];
                [urlList addObject:bmobFile.url];
            }
            
            if (block) {
                block(error, fileNameList, urlList);
            }
        }
    } progress:^(NSUInteger index, CGFloat progress) {
        //index表示正在上传的文件其路径在数组当中的索引，progress表示该文件的上传进度
        DLog(@"index %lu progress %f",(unsigned long)index,progress);
        if (progressBlock) {
            progressBlock(index, progress);
        }
    }];
}


/**
 *  获取开启SecretKey安全验证后的url签名
 *
 *  @param filename  上传后返回的文件名
 *  @param urlString 上传后返回的文件url地址
 *  @param validTime 有效访问时间 单位：秒
 *
 *  @return 返回完整的url地址，可以使用http方式下载的url地址
 */
+ (NSString *)signUrlWithFilename:(NSString *)filename url:(NSString *)urlString
{
    NSString *url = [BmobProFile signUrlWithFilename:filename url:urlString validTime:ACBmobValidTime accessKey:ACBmobAccessKey secretKey:ACBmobSecretKey];
    
    return url;
}

/**
 *  在服务器上对上传的图片进行缩略图处理
 *
 *  @param filename
 *  @param ruleNumber   缩略图规格ID
 *  @param block
 */
+ (void)thumbnailImageWithFilename:(NSString *)filename ruleID:(NSUInteger)ruleNumber resultBlock:(void (^)(BOOL, NSError *, NSString *, NSString *))block
{
    //对文件名为4E80C2958534450DB1D5DF5A97777A0A.jpg进行规格ID为2的缩略图处理
    [BmobProFile thumbnailImageWithFilename:filename ruleID:ruleNumber resultBlock:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url, BmobFile *file) {
        
        DLog(@"thumbnail:\n filename:%@\n url:%@\n bmobfile:%@\n error:%@\n isSuccessful:%d\n", filename, url, file, error, isSuccessful);
        
        if (block) {
            block(isSuccessful, error, filename, url);
        }
    }];
}

+ (void)thumbnailImageBySpecifiesTheWidth:(NSInteger)width height:(NSInteger)height quality:(NSInteger)quality sourceImageUrl:(NSString *)imageUrl resultBlock:(void (^)(NSString *, NSString *, NSError *))block
{
    [BmobImage thumbnailImageBySpecifiesTheWidth:width height:height quality:quality sourceImageUrl:imageUrl outputType:kBmobImageOutputBmobFile resultBlock:^(id object, NSError *error) {
        
        DLog(@"object is %@\n error is %@\n", object, error);
        BmobFile *imageFile = (BmobFile *)object;
        if (block) {
            block(imageFile.name, imageFile.url, error);
        }
    }];

}




@end
