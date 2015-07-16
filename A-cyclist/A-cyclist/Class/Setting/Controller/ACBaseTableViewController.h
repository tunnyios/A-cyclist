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
@end
