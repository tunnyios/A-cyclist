//
//  ACUserModel.h
//  A-cyclist
//
//  Created by tunny on 15/7/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

@interface ACUserModel : NSObject
/**  用户名 */
@property (copy, nonatomic) NSString *username;

/** 密码 */
@property (copy, nonatomic) NSString *password;

/** 邮箱 */
@property (copy, nonatomic) NSString *email;

/** 手机号码 */
@property (copy, nonatomic) NSString *mobilePhoneNumber;

/** 邮箱是否验证 */
@property (nonatomic, assign) BOOL emailVerified;

/**
    头像
 {
     @"thumbnail_pic" : @"",
     @"lage_pic" : @"",
     @"width" : @"",
     @"height" : @""
 }
 */
@property (nonatomic, strong) NSDictionary *avatar;

/**	BmobObject对象的id */
@property(nonatomic,copy)NSString *objectId;

/** BmobObject对象的最后更新时间 */
@property(nonatomic,retain)NSDate *updatedAt;

/** BmobObject对象的生成时间 */
@property(nonatomic,retain)NSDate *createdAt;

/** BmobObject对象的表名 */
@property(nonatomic,copy)NSString * className;
@end
