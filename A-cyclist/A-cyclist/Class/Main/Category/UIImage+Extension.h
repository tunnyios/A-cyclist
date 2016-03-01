//
//  UIImage+Tool.h
//  02-day15-图片裁剪
//
//  Created by suhongcheng on 15/5/28.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tool)

/** 截屏 */
+ (instancetype)imageWithCaptureView: (UIView *)view;

/** 裁剪图片 */
+ (instancetype)clipImageWithImage:(UIImage *)image border:(CGFloat)border borderColor:(UIColor *)color;
+ (void)clipImageWithView:(UIImageView *)view border:(CGFloat)border borderColor:(UIColor *)color radius:(CGFloat)radius;

/** 拉伸图片 */
+ (instancetype)imageWithStretchWithName:(NSString *)name;

/** 拼接图片(垂直方向) */
+ (instancetype)imageWithImageArray:(NSArray *)imageArray;

/** 根据宽度等比例压缩图片 */
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
@end
