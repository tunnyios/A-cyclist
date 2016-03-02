//
//  ACCommonRequestHttp.m
//  A-cyclist
//
//  Created by tunny on 16/3/2.
//  Copyright © 2016年 tunny. All rights reserved.
//

#import "ACCommonRequestHttp.h"
#import "HCHttpTool.h"

@implementation ACCommonRequestHttp
/**
 *  从新浪微博获取用户详情
 *
 *  @param accessToken 获取的token
 *  @param uid         授权后获取的id
 */
+ (void)getUserDetailFromSinaWithAccessToken:(NSString *)accessToken uid:(NSString *)uid success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    if (!accessToken || !uid) {
        DLog(@"error is 参数不能为空");
        return;
    }
    NSString *url = @"https://api.weibo.com/2/users/show.json";
    NSDictionary *params = @{@"access_token" : accessToken,
                             @"uid" : uid};
    [HCHttpTool GET:url parameters:params success:^(id responseObject) {
        DLog(@"%@", responseObject);
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSError *error) {
        DLog(@"获取用户信息失败 error:%@", error);
        if (failure) {
            failure(error);
        }
    }];
}
@end
