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
#import "ACRouteModel.h"
#import "ACStepModel.h"
#import "NSArray+Log.h"
#import "MJExtension.h"


@implementation ACDataBaseTool

#pragma mark - 账户相关
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
            ACUserModel *ACUser = [ACUserModel userWithBmobUser:user];
            
            block(ACUser, error);
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
    [bUser setObject:user.password forKey:@"password"];
    [bUser setObject:user.email forKey:@"email"];
    [bUser setObject:user.mobilePhoneNumber forKey:@"mobilePhoneNumber"];
    [bUser setObject:user.location forKey:@"location"];
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
    ACUserModel *ACUser = [ACUserModel userWithBmobUser:user];
    
    return ACUser;
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

    //设置帖子关联的作者记录
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
 *  将bmobObject对象数组转换成Route对象数组
 */
//+ (NSArray *)routeModelArrayWithBmobObjectArray:(NSArray *)bmobArray
//{
//    NSMutableArray *routeArrayM = [NSMutableArray array];
//    [bmobArray enumerateObjectsUsingBlock:^(BmobObject *bmobObj, NSUInteger idx, BOOL *stop) {
//        ACRouteModel *routeModel = [self routeModelWithBmobObject:bmobObj];
//        [routeArrayM addObject:routeModel];
//    }];
//    
////    DLog(@"routeArrayM is %@", routeArrayM);
//    return routeArrayM;
//}

/**
 *  将bmobObject对象转换成Route对象
 */
//+ (ACRouteModel *)routeModelWithBmobObject:(BmobObject *)bmobObj
//{
//    ACRouteModel *routeModel = [[ACRouteModel alloc] init];
//    routeModel.routeName = [bmobObj objectForKey:@"routeName"];
//
//    NSArray *stepArray = [bmobObj objectForKey:@"steps"];
//    __block NSMutableArray *stepsArrayM = [NSMutableArray array];
//    [stepArray enumerateObjectsUsingBlock:^(NSDictionary *stepDict, NSUInteger idx, BOOL *stop) {
//        ACStepModel *step = [[ACStepModel alloc] init];
//        step.latitude = stepDict[@"latitude"];
//        step.longitude = stepDict[@"longitude"];
//        step.altitude = stepDict[@"altitude"];
//        step.currentSpeed = stepDict[@"currentSpeed"];
//        step.distanceInterval = stepDict[@"distanceInterval"];
//        
//        [stepsArrayM addObject:step];
//    }];
//    routeModel.steps = stepsArrayM;
//
//    routeModel.distance = [bmobObj objectForKey:@"distance"];
//    routeModel.time = [bmobObj objectForKey:@"time"];
//    routeModel.timeNumber = [bmobObj objectForKey:@"timeNumber"];
//    routeModel.averageSpeed = [bmobObj objectForKey:@"averageSpeed"];
//    routeModel.maxSpeed = [bmobObj objectForKey:@"maxSpeed"];
//    routeModel.maxAltitude = [bmobObj objectForKey:@"maxAltitude"];
//    routeModel.minAltitude = [bmobObj objectForKey:@"minAltitude"];
//    routeModel.ascendAltitude = [bmobObj objectForKey:@"ascendAltitude"];
//    routeModel.ascendTime = [bmobObj objectForKey:@"ascendTime"];
//    routeModel.ascendDistance = [bmobObj objectForKey:@"ascendDistance"];
//    routeModel.flatTime = [bmobObj objectForKey:@"flatTime"];
//    routeModel.flatDistance = [bmobObj objectForKey:@"flatDistance"];
//    routeModel.descendTime = [bmobObj objectForKey:@"descendTime"];
//    routeModel.descendDistance = [bmobObj objectForKey:@"descendDistance"];
//    routeModel.userObjectId = [bmobObj objectForKey:@"userObjectId"];
//    routeModel.isShared = [bmobObj objectForKey:@"isShared"];
//    routeModel.cyclingStartTime = [bmobObj objectForKey:@"cyclingStartTime"];
//    routeModel.cyclingEndTime = [bmobObj objectForKey:@"cyclingEndTime"];
//    
////    DLog(@"routeModel is %@", routeModel);
//    return routeModel;
//}

/**
 *  根据用户id获取数据库中的路线列表
 *  (约束关联对象查询)
 *  @param objectId
 *
 *  @return BmobObject对象数组
 */
+ (void)getRouteListWithUserObjectId:(NSString *)objectId resultBlock:(void (^)(NSArray *, NSError *))block
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"personRoute"];
    
    //构造约束条件
    BmobQuery *inQuery = [BmobQuery queryWithClassName:@"_User"];
    [inQuery whereKey:@"objectId" equalTo:objectId];
    
    //匹配查询
    [bquery whereKey:@"user" matchesQuery:inQuery];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//        DLog(@"array is %@, error is %@", array, error);
        //将BmobObject对象数组转换成Route对象数组
        NSArray *routeArray = nil;
        if (error == nil) {
            routeArray = [ACRouteModel routeModelArrayWithBmobObjectArray:array];
        }
        if (block) {
            DLog(@"routeArray is %@, error is %@", routeArray, error);
            block(routeArray, error);
        }
    }];
}

/**
 *  根据用户id查询数据库中，用户已经共享了的路线列表
 */
+ (void)getSharedRouteListWithUserObjectId:(NSString *)objectId resultBlock:(void (^)(NSArray *, NSError *))block
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"personRoute"];
    
    //构造约束条件
    NSDictionary *condiction1 = @{@"objectId":@{@"__type":@"Pointer",@"className":@"_User",@"objectId":objectId}};
    NSDictionary *condiction2 = @{@"isShared":@1};
    NSArray *condictionArray = @[condiction1,condiction2];
    [bquery addTheConstraintByOrOperationWithArray:condictionArray];
    
    //匹配查询
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //        DLog(@"array is %@, error is %@", array, error);
        //将BmobObject对象数组转换成Route对象数组
        NSArray *routeArray = nil;
        if (error == nil) {
            routeArray = [ACRouteModel routeModelArrayWithBmobObjectArray:array];
        }
        if (block) {
            DLog(@"routeArray is %@, error is %@", routeArray, error);
            block(routeArray, error);
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
        }
        if (block) {
            DLog(@"maxDistanceRouteModel is %@, error is %@", routeModel, error);
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
        }
        if (block) {
            DLog(@"maxSpeedRouteModel is %@, error is %@", routeModel, error);
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
        }
        if (block) {
            DLog(@"maxAverageSpeedRouteModel is %@, error is %@", routeModel, error);
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
        }
        if (block) {
            DLog(@"maxTimeRouteModel is %@, error is %@", routeModel, error);
            block(routeModel, error);
        }
    }];
}

/**
 *  根据classification类别来获取sharedRoute列表
 *
 */
+ (void)getSharedRouteListClass:(NSString *)classification resultBlock:(void (^)(NSArray *, NSError *))block
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"sharedRoute"];
    
    //构造约束条件
    [bquery whereKey:@"classification" equalTo:classification];
    
    //匹配查询
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //        DLog(@"array is %@, error is %@", array, error);
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
        ACUserModel *user = [ACUserModel userWithBmobUser:obj];
        
        [userArrayM addObject:user];
    }];
    
    return userArrayM;
}

/**
 *  对所有用户按累计里程进行降序排序
 */
+ (void)getUserListWithResutl:(void (^)(NSArray *, NSError *))block
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"_User"];
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
 *  使用NSData的方式上传文件到Bmob数据库
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
 *  在服务器上对上传的图片进行缩略图处理,并上传到服务器
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
