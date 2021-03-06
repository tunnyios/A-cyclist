//
//  ACUserModel.h
//  A-cyclist
//
//  Created by tunny on 15/7/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BmobUser;
@interface ACUserModel : NSObject <NSCoding>
/**  昵称 */
@property (copy, nonatomic) NSString *username;
/** 个性签名 */
@property (nonatomic, copy) NSString *signature;
/** 密码 */
@property (copy, nonatomic) NSString *password;

/** 邮箱 */
@property (copy, nonatomic) NSString *email;

/** 手机号码 */
@property (copy, nonatomic) NSString *mobilePhoneNumber;

/** 邮箱是否验证 */
@property (nonatomic, assign) BOOL emailVerified;

/** 位置 */
@property (nonatomic, copy) NSString *location;

/** 体重 */
@property (nonatomic, strong) NSNumber *weight;

/** 性别，m：男、f：女、n：未知 */
@property (nonatomic, copy) NSString *gender;

/**
    头像
 {
     @"profile_image_url" : @"",
     @"avatar_large" : @"",
     @"width" : @"",
     @"height" : @""
 }
 */
@property (nonatomic, copy) NSString *profile_image_url;
@property (nonatomic, copy) NSString *avatar_large;

/** 累计时间(秒)*/
@property (nonatomic, strong) NSNumber *accruedTime;

/** 累计距离(km) */
@property (nonatomic, strong) NSNumber *accruedDistance;


/**	BmobObject对象的id */
@property(nonatomic, copy)NSString *objectId;

/** BmobObject对象的最后更新时间 */
@property(nonatomic, strong)NSDate *updatedAt;

/** BmobObject对象的生成时间 */
@property(nonatomic, strong)NSDate *createdAt;

/** BmobObject对象的表名 */
@property(nonatomic, copy)NSString * className;


+ (instancetype)userWithBmobUser:(BmobUser *)user;
@end
