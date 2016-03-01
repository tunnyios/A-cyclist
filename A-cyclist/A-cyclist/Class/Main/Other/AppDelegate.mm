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
//#import "WeiboSDK.h"
#import "HCHttpTool.h"
#import "ACDataBaseTool.h"
#import "ACCacheDataTool.h"
#import "ACUserModel.h"
#import <BaiduMapAPI/BMapKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ACLoginViewController.h"
#import "UMSocial.h"
#import "SDWebImageManager.h"
//#import "UMSocialSinaSSOHandler.h"
//#import "UMSocialQQHandler.h"
//#import "SDWebImageManager.h"

//@interface AppDelegate () <WeiboSDKDelegate>
@interface AppDelegate ()
/** 百度地图管理者 */
@property (nonatomic, strong) BMKMapManager *bmkMapManager;
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置友盟社会化组件appkey
//    [UMSocialData setAppKey:@"55cdacb0e0f55ab21a0010ff"];
    //开启新浪微博SSO授权开关
//    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"https://api.weibo.com/oauth2/default.html"];
//    [UMSocialQQHandler setQQWithAppId:@"1104739169" appKey:@"nJ9vASx3n7zUP0vQ" url:@"http://github.com/tunnyios"];
    
    [Bmob registerWithAppKey:ACBmobAppKey];
//    [WeiboSDK enableDebugMode:YES];
//    [WeiboSDK registerApp:ACSinaAppKey];
    // 要使用百度地图，请先启动BaiduMapManager
    self.bmkMapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [self.bmkMapManager start:ACBaiduAppKey  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
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
    
//    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //向操作系统申请后台运行资格，能维持多久， 是不确定的
    __block UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        //当申请的后台运行时间已过期，则会执行这个block
        //关闭后台运行
        [application endBackgroundTask:task];
    }];
    
    if (!iOS8) {
        // 播放,一个没有声音的Mp3,目的是需要告诉苹果,我在播放东西,并不需要让用户听到.
        // 创建本地播放对象
        // url:要播放文件的url
        // 获取url,从bundle里面获取
        // 获取本地播放文件的url
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"silence.mp3" withExtension:nil];
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _player = player;
        
        // -1无限播放
        player.numberOfLoops = -1;
        
        [player prepareToPlay];
        
        [player play];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
//    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 *  当app接收到内存警告
 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    
    // 1.取消正在下载的操作
    [mgr cancelAll];
    
    // 2.清除内存缓存
    [mgr.imageCache clearMemory];
}


#pragma mark - 重写两个handle方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    return [TencentOAuth HandleOpenURL:url] ||
//    [WeiboSDK handleOpenURL:url delegate:self];
    
//    BOOL result = [UMSocialSnsService handleOpenURL:url];
//    if (result == FALSE) {
//        result = [TencentOAuth HandleOpenURL:url] ||
//        [WeiboSDK handleOpenURL:url delegate:self];
//    }
//    return result;
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    return [TencentOAuth HandleOpenURL:url] ||
//    [WeiboSDK handleOpenURL:url delegate:self];
    
//    BOOL result = [UMSocialSnsService handleOpenURL:url];
//    if (result == FALSE) {
//        result = [TencentOAuth HandleOpenURL:url] ||
//        [WeiboSDK handleOpenURL:url delegate:self];
//    }
//    return result;
    
    return YES;
}

# pragma mark - 新浪回调
//收到回复时的回调
#if 0
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
        } else if (user) {
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
                                       @"profile_image_url" : responseObject[@"avatar_large"],
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
                
                //跳转
                //创建tabbarController
                ACTabBarController *tabBarController = [[ACTabBarController alloc] init];
                self.window.rootViewController = tabBarController;
                
            } failure:^(NSError *error) {
                DLog(@"获取用户信息失败 error:%@", error);
            }];
        }
    }];
}

//发送请求时的回调
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{
}
#endif

@end
