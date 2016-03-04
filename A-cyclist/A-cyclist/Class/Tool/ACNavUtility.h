//
//  ACNavUtility.h
//  A-cyclist
//
//  Created by tunny on 16/3/2.
//  Copyright © 2016年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ACNavUtility : NSObject
#pragma 设置导航栏背景图片和标题
+ (void) setNav:(UINavigationController *)navigationController setNavItem:(UINavigationItem *)navigationItem setTitle:(NSString *)title;

#pragma 生成导航栏图片按钮
+ (UIBarButtonItem *) setNavButtonWithImage:(NSString *)imageName
                                     target:(id)target action:(SEL)action frame:(CGRect)frame;

#pragma 生成导航栏文字按钮
+ (UIBarButtonItem *) setNavButtonWithTitle:(NSString *)title
                                     target:(id)target action:(SEL)action frame:(CGRect)frame;
@end
