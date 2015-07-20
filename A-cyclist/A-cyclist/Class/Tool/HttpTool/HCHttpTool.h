//
//  HCHttpTool.h
//  HCSinaWeibo
//
//  Created by tunny on 15/6/29.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCFileParamsModel.h"

@interface HCHttpTool : NSObject

/** GET请求 */
+ (void)GET:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/** 普通POST请求 */
+ (void)POST:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/** 发送文件的POST请求 */
+ (void)POST:(NSString *)url parameters:(id)parameters constructingBodyWithBlock:(HCFileParamsModel *(^)())block success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


@end
