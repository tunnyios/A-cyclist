//
//  ACArrowSettingCellModel.h
//  A-cyclist
//
//  Created by tunny on 15/7/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACSettingCellModel.h"

@interface ACArrowSettingCellModel : ACSettingCellModel
/** 跳转至下一控制器的属性 */
@property (nonatomic, strong) Class destClass;

/** 添加类方法，增加跳转控制器参数 */
+ (instancetype)arrowSettingCellModelWithTitle:(NSString *)title icon:(NSString *)icon destClass:(Class)destClass;
@end
