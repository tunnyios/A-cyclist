//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+MJ.h"

@implementation MBProgressHUD (MJ)

+ (instancetype)initDefaultHUDWithView:(UIView *)view
{
    MBProgressHUD *HUD = [[self alloc] initWithView:view];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [view addSubview:HUD];
    
    return HUD;
}

/**
 *  延迟隐藏HUDMessage
 */
- (void)hideHUDWithText:(NSString *)text icon:(NSString *)icon afterDelay:(CGFloat)delay
{
    self.labelText = text;
    self.labelFont = [UIFont boldSystemFontOfSize:14.f];
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    self.mode = MBProgressHUDModeCustomView;
    [self hide:YES afterDelay:delay];
}

/**
 *  延迟隐藏加载成功
 */
- (void)hideSuccessMessage:(NSString *)success
{
    if (success == nil || [success isEqualToString:@""]) {
        [self hide:true];
    }else{
        [self hideHUDWithText:success icon:@"success.png" afterDelay:2.0f];
    }
}

/**
 *  延迟隐藏加载失败
 */
- (void)hideErrorMessage:(NSString *)error
{
    [self hideHUDWithText:error icon:@"error.png" afterDelay:2.0f];
}


@end
