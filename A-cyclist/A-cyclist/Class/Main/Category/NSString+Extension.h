//
//  NSString+Extension.h
//  黑马微博2期
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

/** 计算文字的尺寸 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;

/** 文字的合法性检查 */
- (BOOL)isAvailQQ;
- (BOOL)isAvailPhoneNumber;
- (BOOL)isAvailIPAddress;
- (BOOL)isAvailEmail;
- (BOOL)isAvailUserName;


@end
