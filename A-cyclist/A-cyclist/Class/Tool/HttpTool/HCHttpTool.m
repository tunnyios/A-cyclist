//
//  HCHttpTool.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/29.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCHttpTool.h"
#import "AFNetworking.h"

@implementation HCHttpTool

/**
 *  GET请求
 */
+ (void)GET:(NSString *)url parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    [mgr GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  普通的POST请求
 */
+ (void)POST:(NSString *)url parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    [mgr POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  发送带有文件的POST请求
 */
+ (void)POST:(NSString *)url parameters:(id)parameters constructingBodyWithBlock:(HCFileParamsModel *(^)())block success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    [mgr POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (block) {
            HCFileParamsModel *fileParmas = block();
            
            if (fileParmas.data.length) {
                [formData appendPartWithFileData:fileParmas.data name:fileParmas.name fileName:fileParmas.fileName mimeType:fileParmas.mimeType];
            } else if (fileParmas.url) {
                [formData appendPartWithFileURL:fileParmas.url name:fileParmas.name fileName:fileParmas.fileName mimeType:fileParmas.mimeType error:nil];
            }
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
