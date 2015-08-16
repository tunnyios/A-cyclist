//
//  HCNewTypeButton.h
//  HCSinaWeibo
//
//  Created by tunny on 15/6/18.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCNewTypeButtonView : UIButton

//创建一个新排版的button
- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon heighIcon:(NSString *)heighIcon;

+ (instancetype)buttonWithTitle:(NSString *)title icon:(NSString *)icon heighIcon:(NSString *)heighIcon;

/** 更新button的content */
- (void)setTitle:(NSString *)title icon:(NSString *)icon heighIcon:(NSString *)heighIcon;
@end
