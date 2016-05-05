//
//  MBProgressHUD+MJ.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (MJ)

/**
 *  创建默认的HUD
 */
+ (instancetype)initDefaultHUDWithView:(UIView *)view;

/**
 *  延迟隐藏加载成功
 */
- (void)hideSuccessMessage:(NSString *)success;

/**
 *  延迟隐藏加载失败
 */
- (void)hideErrorMessage:(NSString *)error;
@end
