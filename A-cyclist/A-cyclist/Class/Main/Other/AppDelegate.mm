//
//  AppDelegate.m
//  A-cyclist
//
//  Created by tunny on 15/7/13.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "AppDelegate.h"
#import "ACGlobal.h"
#import "ACUtility.h"
#import "UIColor+Tools.h"
#import "ACTabBarController.h"
#import "HCHttpTool.h"
#import "ACDataBaseTool.h"
#import "ACCacheDataTool.h"
#import "ACUserModel.h"
#import <AVFoundation/AVFoundation.h>
#import "ACLoginViewController.h"
#import "ACSettingProfileInfoViewController.h"
#import "ACCommonRequestHttp.h"
#import "SDWebImageManager.h"
#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import <UMSocialWechatHandler.h>
#import "WeiboSDK.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobMessage.h>

@interface AppDelegate () <WeiboSDKDelegate>
/** 百度地图管理者 */
@property (nonatomic, strong) BMKMapManager *bmkMapManager;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (strong, nonatomic) UIView *lunchView;
/** <#Description#> */
@property (nonatomic, strong) UIImageView *imageV;
/** timeIndex */
@property (nonatomic, assign) NSUInteger timerIndex;
/** <#Description#> */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置启动动画并跳转
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    UIViewController* myvc = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = myvc;
    
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Launch Screen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    self.lunchView = viewController.view;
    [self.window addSubview:self.lunchView];
    self.imageV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.imageV.image = [UIImage imageNamed:@"default0"];
    self.timerIndex = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(updateImage:) userInfo:nil repeats:YES];
    [self.lunchView addSubview:self.imageV];
    [self.window bringSubviewToFront:self.lunchView];
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:ACYouMengAppKey];
    //取消友盟自带的弹窗
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:ACSinaAppKey
                                              secret:ACSinaSecret
                                         RedirectURL:ACSinaRedirectURL];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:ACQQAppId appKey:ACQQAppKey url:ACQQRedirectURL];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:ACWechatAppId appSecret:ACWechatSecret url:ACWechatRedirectURL];
    
    [Bmob registerWithAppKey:ACBmobAppKey];
    // 要使用百度地图，请先启动BaiduMapManager
    self.bmkMapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [self.bmkMapManager start:ACBaiduAppKey  generalDelegate:nil];
    if (!ret) {
        DLog(@"manager start failed!");
    }
    
    //注册推送通知
    UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc]init];
    categorys.identifier=@"com.bmob.bmobpushdemo";
    UIUserNotificationSettings *userNotifiSetting = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categorys,nil]];
    [[UIApplication sharedApplication] registerUserNotificationSettings:userNotifiSetting];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    return YES;
}

- (void)updateImage:(NSTimer *)timer
{
    self.timerIndex++;
    [UIView animateWithDuration:0.2f animations:^{
        NSString *imageStr = [NSString stringWithFormat:@"default%lu", (unsigned long)self.timerIndex];
        self.imageV.image = [UIImage imageNamed:imageStr];
    } completion:^(BOOL finished) {
        if (12 == self.timerIndex) {
            [self.lunchView removeFromSuperview];
            [self.timer invalidate];
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
        }
    }];
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

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    //注册成功后上传Token至服务器
    BmobInstallation  *currentIntallation = [BmobInstallation currentInstallation];
    [currentIntallation setDeviceTokenFromData:deviceToken];
    [currentIntallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
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
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        return [TencentOAuth HandleOpenURL:url] ||
        [WeiboSDK handleOpenURL:url delegate:self];
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        return [TencentOAuth HandleOpenURL:url] ||
        [WeiboSDK handleOpenURL:url delegate:self];
    }
    return result;
}

# pragma mark - 新浪回调
//收到回复时的回调
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    __block NSString *accessToken = [(WBAuthorizeResponse *)response accessToken];
    __block NSString *uid = [(WBAuthorizeResponse *)response userID];
    __block NSDate *expiresDate = [(WBAuthorizeResponse *)response expirationDate];
    if (!accessToken || !uid || !expiresDate) {
        return;
    }
    //通过授权信息注册登录
    [ACDataBaseTool loginWithAccessToken:accessToken uid:uid expirationDate:expiresDate platform:ACLoginPlatformSinaWeibo success:^(id result) {
        DLog(@"user objectid is :%@",result);
        ACUserModel *userModel = (ACUserModel *)result;
        if (userModel.weight && ![userModel.weight isEqual:@0]) {
            //本地缓存
            [ACCacheDataTool saveUserInfo:userModel withObjectId:userModel.objectId];
            //创建tabbarController跳转
            ACTabBarController *tabBarController = [[ACTabBarController alloc] init];
            self.window.rootViewController = tabBarController;
        } else {
            //1. 发送请求从新浪微博获取用户详细信息
            [ACCommonRequestHttp getUserDetailFromSinaWithAccessToken:accessToken uid:uid success:^(id result) {
                DLog(@"%@", result);
                //3. 本地缓存
                userModel.username = [ACUtility stringWithId:[result objectForKey:@"screen_name"]];
                userModel.profile_image_url = [ACUtility stringWithId:[result objectForKey:@"avatar_large"]];
                userModel.avatar_large = [ACUtility stringWithId:[result objectForKey:@"avatar_large"]];
                userModel.location = [ACUtility stringWithId:[result objectForKey:@"location"]];
                userModel.gender = [ACUtility stringWithId:[result objectForKey:@"gender"]];
//                userModel.accruedDistance = @0;
//                userModel.accruedTime = @0;
                [ACCacheDataTool saveUserInfo:userModel withObjectId:userModel.objectId];
                
                //跳转至settingProfileVC
                ACSettingProfileInfoViewController *setProfileVC = [[ACSettingProfileInfoViewController alloc] init];
                setProfileVC.pushFromType = PushFromTypeLogin;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:setProfileVC];
                self.window.rootViewController = nav;
            } failure:^(NSError *error) {
                DLog(@"获取用户信息失败 error:%@", error);
            }];
        }
        
    } failure:^(NSError *error) {
        DLog(@"weibo login error:%@",error);
    }];
}

//发送请求时的回调
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{
}

@end
