//
//  ViewController.h
//  keyboard处理
//  添加一个根据keyboard形变，移动控制器视图的基础控制器
//  (已添加keyboardTool,)
//  注意点：使用时，如果涉及多个控制器继承自该控制器，一定要注意移除通知的时机,
//          添加键盘通知是在viewDidAppear方法中，移除键盘通知是在viewDidDisappear方法中
//  使用步骤：1. 重写viewDidAppear方法(首先调用父类方法)
//          2. 传入textField数组和设置textField与键盘的偏移量(有可能加上导航栏的高度)即可
//  Created by tunny on 15/7/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACBaseViewController.h"

@interface HCBaseKeyboardViewController : ACBaseViewController
/** 用来存储所有的textField */
@property (nonatomic, copy) NSMutableArray *textFieldArray;
/** 调节textField与键盘的偏移量,可以为0 */
@property (nonatomic, assign) CGFloat textFieldOffset;
/** 用来移动和参照的View */
@property (nonatomic, strong) UIView *contentView;

/** 移除键盘通知 */
- (void)clearTextFieldNotify;
@end

