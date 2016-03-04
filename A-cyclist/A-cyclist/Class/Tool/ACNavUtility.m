//
//  ACNavUtility.m
//  A-cyclist
//
//  Created by tunny on 16/3/2.
//  Copyright © 2016年 tunny. All rights reserved.
//

#import "ACNavUtility.h"
#import "ACGlobal.h"
#import "ACUtility.h"

@implementation ACNavUtility
#pragma 设置导航栏背景图片和标题
+ (void) setNav:(UINavigationController *) navigationController setNavItem:(UINavigationItem *) navigationItem setTitle:(NSString *)title  {
    //设置导航栏背景图
    [self setNavBg:navigationController];
    //设置导航栏标题
    [self setTitle:title forNavItem:navigationItem];
}

#pragma 设置导航栏背景图
+ (void) setNavBg:(UINavigationController *)navController {
    UIImage *navImage = [UIImage imageNamed:@"navBg.png"];
    //设置导航栏背景图片
    [navController.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
}

#pragma 设置导航栏自定义标题
+ (void) setTitle:(NSString *)title forNavItem:(UINavigationItem *)navItem {
    //自定义导航栏标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [ACUtility setFontWithSize:16.0f];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    navItem.titleView = titleLabel;
}

#pragma 生成导航栏图片按钮
+ (UIBarButtonItem *) setNavButtonWithImage:(NSString *)imageName
                                     target:(id)target action:(SEL)action frame:(CGRect)frame {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = frame;
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return barBtn;
}

#pragma 生成导航栏文字按钮
+ (UIBarButtonItem *) setNavButtonWithTitle:(NSString *)title
                                     target:(id)target action:(SEL)action frame:(CGRect)frame; {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [ACUtility setFontWithSize:15.0f];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    btn.frame = frame;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return barBtn;
}

@end
