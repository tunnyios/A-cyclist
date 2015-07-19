//
//  ViewController.h
//  keyboard处理
//  添加一个根据keyboard形变，移动控制器视图的基础控制器
//  (已添加keyboardTool)
//  Created by tunny on 15/7/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCBaseKeyboardViewController : UIViewController
/** 输入框View */
@property (weak, nonatomic) UIView *contentView;

@end

