//
//  ViewController.h
//  keyboard处理
//  添加一个根据keyboard形变，移动控制器视图的基础控制器
//  (已添加keyboardTool)
//  注意点：使用时，如果涉及多个控制器继承自该控制器，一定要注意移除通知的时机
//  PS:可能需要手动移除通知
//  Created by tunny on 15/7/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCBaseKeyboardViewController : UIViewController
/** 输入框View */
@property (weak, nonatomic) UIView *contentView;

@end

