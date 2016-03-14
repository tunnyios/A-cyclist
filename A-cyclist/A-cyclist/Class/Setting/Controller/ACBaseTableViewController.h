//
//  ACBaseTableViewController.h
//  A-cyclist
//
//  Created by tunny on 15/7/15.
//  Copyright (c) 2015年 tunny. All rights reserved.
//
/**
 一个cell交给一个模型去管理，每一组也交给一个模型去管理，
 cell中的不一样的功能的cell，为了更面相对象，就不用枚举来做，
 再分别交给一个模型，都继承自cell原来cell的模型
 */

#import <UIKit/UIKit.h>

@interface ACBaseTableViewController : UITableViewController
/** 数据数组(包含了groupModel，groupModel中又包含了cellModel) */
@property (nonatomic, strong) NSMutableArray *dataList;

/**
 *  alert弹框提示
 */
-(void)showAlertMsg:(NSString *)msg cancelBtn:(NSString *)cancelBtnTitle;

/**
 *  确定/取消 Alert 弹窗
 */
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
            cancelBtnTitle:(NSString *)cancelBtnTitle
             otherBtnTitle:(NSString *)otherBtnTitle
                   handler:(void (^)())handler;

/**
 *  中间弹框
 */
- (void)showMsgCenter:(NSString *)msg;

/**
 *  设置导航栏样式和标题
 */
- (void)setNavigation:(NSString *)title;

/**
 *  设置导航栏样式、标题和左边返回按钮
 */
- (void)setNavigationWithBackItem:(NSString *)title withAction:(SEL)action;

@end
