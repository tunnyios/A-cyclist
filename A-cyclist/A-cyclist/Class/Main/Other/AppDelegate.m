//
//  AppDelegate.m
//  A-cyclist
//
//  Created by tunny on 15/7/13.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "AppDelegate.h"
#import "ACGlobal.h"
#import "UIColor+Tools.h"
#import "ACTabBarController.h"
#import <BmobSDK/Bmob.h>
#import "WeiboSDK.h"
#import "HCHttpTool.h"
#import "ACDataBaseTool.h"
#import "ACCacheDataTool.h"
#import "ACUserModel.h"

@interface AppDelegate ()<WeiboSDKDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Bmob registerWithAppKey:ACBmobAppKey];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:ACSinaAppKey];
    
    //1. 创建window
    self.window = [[UIWindow alloc] initWithFrame:ACScreenBounds];
    
    //2. 设置根控制器
    ACUserModel *user = [ACCacheDataTool getUserInfo];
    if (user) {
        //创建tabbarController
        ACTabBarController *tabBarController = [[ACTabBarController alloc] init];
        //设置根控制器
        self.window.rootViewController = tabBarController;
    } else {
        UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"ACLogin" bundle:nil];
        //设置根控制器
        self.window.rootViewController = loginSB.instantiateInitialViewController;
    }
    
//    UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"ACLogin" bundle:nil];
    //设置根控制器
//    self.window.rootViewController = loginSB.instantiateInitialViewController;
    
    //3. 显示window
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 重写两个handle方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

# pragma mark - 新浪回调
//收到回复时的回调
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    NSString *accessToken = [(WBAuthorizeResponse *)response accessToken];
    NSString *uid = [(WBAuthorizeResponse *)response userID];
    NSDate *expiresDate = [(WBAuthorizeResponse *)response expirationDate];
    DLog(@"acessToken:%@",accessToken);
    DLog(@"UserId:%@",uid);
    DLog(@"expiresDate:%@",expiresDate);
    if (!accessToken || !uid || !expiresDate) {
        return;
    }
    

    
    NSDictionary *dic = @{@"access_token":accessToken,@"uid":uid,@"expirationDate":expiresDate};
    //通过授权信息注册登录
    [BmobUser loginInBackgroundWithAuthorDictionary:dic platform:BmobSNSPlatformSinaWeibo block:^(BmobUser *user, NSError *error) {
        if (error) {
            DLog(@"weibo login error:%@",error);
        } else if (user){
            DLog(@"user objectid is :%@",user.objectId);
            //1. 发送请求从新浪微博获取用户详细信息
            NSString *url = @"https://api.weibo.com/2/users/show.json";
            NSDictionary *params = @{@"access_token" : accessToken,
                                     @"uid" : uid};
            [HCHttpTool GET:url parameters:params success:^(id responseObject) {
                DLog(@"%@", responseObject);
                /*
                 avatar_large
                 avatar_hd
                 profile_image_url
                 location
                 screen_name
                 */
                //2. 更新的数据到数据库中
                NSDictionary *dict = @{@"username" : responseObject[@"screen_name"],
                                       @"profile_image_url" : responseObject[@"profile_image_url"],
                                       @"avatar_large" : responseObject[@"avatar_large"],
                                       @"location" : responseObject[@"location"],
                                       @"gender" : responseObject[@"gender"]
                                       };
                NSArray *keys = @[@"username", @"profile_image_url", @"avatar_large", @"location", @"gender"];
                [ACDataBaseTool updateUserInfoWithDict:dict andKeys:keys withResultBlock:^(BOOL isSuccessful, NSError *error) {
                    DLog(@"isSuccessful is %d, error is %@", isSuccessful, error);
                }];
                
                //3. 本地缓存
                ACUserModel *user = [ACDataBaseTool getCurrentUser];
                DLog(@"user is %@", user);
                [ACCacheDataTool saveUserInfo:user withObjectId:user.objectId];
                
            } failure:^(NSError *error) {
                DLog(@"获取用户信息失败 error:%@", error);
            }];
            
            
            
            
            
            
            
            
            
            
            //跳转
            //创建tabbarController
            ACTabBarController *tabBarController = [[ACTabBarController alloc] init];
            self.window.rootViewController = tabBarController;
        }
    }];
}

//发送请求时的回调
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{
}


@end
