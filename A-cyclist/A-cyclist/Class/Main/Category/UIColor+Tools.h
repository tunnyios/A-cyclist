//
//  UIColor+Tools.h
//  HCSinaWeibo
//
//  Created by suhongcheng on 15/6/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Tools)

/**
 *  随机色
 */
+ (instancetype)colorWithRandom;

/**
 *  RGBA色
 */
+ (instancetype)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a;

@end
