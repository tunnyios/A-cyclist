//
//  ACCommonRequestHttp.h
//  A-cyclist
//
//  Created by tunny on 16/3/2.
//  Copyright © 2016年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACGlobal.h"

@interface ACCommonRequestHttp : NSObject
/**
 *  从新浪微博获取用户详情
 *
 *  @param accessToken 获取的token
 *  @param uid         授权后获取的id
 */
+ (void)getUserDetailFromSinaWithAccessToken:(NSString *)accessToken uid:(NSString *)uid success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

@end
