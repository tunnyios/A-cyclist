//
//  ACTabBarController.m
//  A-cyclist
//
//  Created by tunny on 15/7/14.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACTabBarController.h"
#import "HCTabBar5ContentView.h"
#import "UIColor+Tools.h"
#import "ACGlobal.h"


@interface ACTabBarController ()

@end

@implementation ACTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIStoryboard *profileSB = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
    UIStoryboard *routeSB = [UIStoryboard storyboardWithName:@"route" bundle:nil];
    UIStoryboard *cyclingSB = [UIStoryboard storyboardWithName:@"cycling" bundle:nil];
    UIStoryboard *rankingSB = [UIStoryboard storyboardWithName:@"ranking" bundle:nil];
    UIStoryboard *settingSB = [UIStoryboard storyboardWithName:@"setting" bundle:nil];

    UIViewController *profileVc = [profileSB instantiateInitialViewController];
    [self creatChildViewController:profileVc title:@"我的" icon:@"tab_profile_iphone_1" selectedIcon:@"tab_profile_white_iphone_1"];
    profileVc.view.backgroundColor = [UIColor colorWithRandom];
    
    UINavigationController *routeNav = [routeSB instantiateInitialViewController];
    UIViewController *routeVc = routeNav.topViewController;
    [self creatChildViewController:routeVc title:@"路线" icon:@"tab_route_iphone_4" selectedIcon:@"tab_route_white_iphone_4"];
    routeVc.view.backgroundColor = [UIColor colorWithRandom];

    UIViewController *cyclingVc = [cyclingSB instantiateInitialViewController];
    cyclingVc.view.backgroundColor = [UIColor colorWithRandom];
    
    UINavigationController *rankingNav = [rankingSB instantiateInitialViewController];
    UIViewController *rankingVc = rankingNav.topViewController;
    [self creatChildViewController:rankingVc title:@"排行榜" icon:@"tab_ranking_iphone_2" selectedIcon:@"tab_ranking_white_iphone_2"];
    rankingVc.view.backgroundColor = [UIColor colorWithRandom];

    UINavigationController *settingNav = [settingSB instantiateInitialViewController];
    UIViewController *settingVc = settingNav.topViewController;
    [self creatChildViewController:settingVc title:@"更多" icon:@"tab_more_iphone_5" selectedIcon:@"tab_more_white_iphone_5"];
    settingVc.view.backgroundColor = [UIColor colorWithRandom];
    
    self.viewControllers = @[profileVc,
                             rankingNav,
                             cyclingVc,
                             routeNav,
                             settingNav];
    
    //用自定义的tabBar来替换系统自己的taBar
    HCTabBar5ContentView *tabBars = [[HCTabBar5ContentView alloc] init];
    //KVC赋值
    [self setValue:tabBars forKey:@"tabBar"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  添加一个子控制器的tabBarItem
 *
 *  @param vc           子控制器
 *  @param title
 *  @param icon
 *  @param selectedIcon
 */
- (void)creatChildViewController:(UIViewController *)vc title:(NSString *)title icon:(NSString *)icon selectedIcon:(NSString *)selectedIcon
{
    
    //设置选中字体颜色
    NSDictionary *titleFont = @{NSFontAttributeName : [UIFont systemFontOfSize:13],
                                NSForegroundColorAttributeName : [UIColor orangeColor]
                                };
    [vc.tabBarItem setTitleTextAttributes:titleFont forState:UIControlStateSelected];
    
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:icon];
    //设置系统选中tabBarItem不自动渲染选中图片
    UIImage *selectedImage = [[UIImage imageNamed:selectedIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = selectedImage;
}

#pragma mark - HCTabBar5ContentViewDelegate
/**
 *  设置自定义按钮的点击处理事件
 *
 *  @param tabBar
 */
- (void)tabBar5ContenViewWithTabBar:(HCTabBar5ContentView *)tabBar
{
    UIStoryboard *cyclingSB = [UIStoryboard storyboardWithName:@"cycling" bundle:nil];
    UIViewController *cyclingVc = [cyclingSB instantiateInitialViewController];
    
    [self presentViewController:cyclingVc animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
