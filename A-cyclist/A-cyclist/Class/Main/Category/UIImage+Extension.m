//
//  UIImage+Tool.m
//  02-day15-图片裁剪
//
//  Created by suhongcheng on 15/5/28.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "UIImage+Extension.h"
#import "UIImageView+WebCache.h"

@implementation UIImage (Tool)

/**
 *  截屏(不包括状态栏)
 *
 *  @param view 视图veiw
 *
 *  @return 截取的视图image
 */
+ (instancetype) imageWithCaptureView: (UIView *)view
{
    //1. 创建位图上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    //2. 获取当前位图上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //3. 图层渲染时只能用render不能用draw
    [view.layer renderInContext:ctx];
    //4. 获取截屏图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return newImage;
}


/**
 *  裁剪图片为圆形带边框
 *
 *  @param name   图片名称
 *  @param border 图片圆形边框宽度
 *  @param color  边框颜色
 *
 *  @return 裁剪后的图片
 */
+ (instancetype)clipImageWithImage:(UIImage *)image border:(CGFloat)border borderColor:(UIColor *)color
{
    //获取旧图片
    UIImage *oldImage = image;
    
    //边距
    CGFloat borderW = border;
    CGFloat imageW = oldImage.size.width + 2 * borderW;
    CGFloat imageH = oldImage.size.height + 2 * borderW;
    CGFloat circleW = imageW >= imageH ? imageH : imageW;
    
    //创建位图上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(circleW, circleW), NO, 0.0);
    //获取位图上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置绘图信息
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, circleW, circleW)];
    //设置绘图状态
    [color setFill];
    //添加路径到图形上下文
    CGContextAddPath(ctx, path.CGPath);
    //渲染图形上下文到视图
    CGContextFillPath(ctx);
    
    //设置裁剪区域
    CGFloat smallCircleW = oldImage.size.width >= oldImage.size.height ? oldImage.size.height : oldImage.size.width;
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(borderW, borderW, smallCircleW, smallCircleW)];
    [clipPath addClip];
    //画图
    [oldImage drawAtPoint:CGPointMake(borderW, borderW)];
    
    //从当前图形上下文获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (void)clipImageWithView:(UIImageView *)view border:(CGFloat)border borderColor:(UIColor *)color radius:(CGFloat)radius
{
    //4行代码搞定 裁剪图片为圆形带边框
    view.layer.cornerRadius = radius; //图形的圆角半径
    view.layer.masksToBounds = YES;//裁剪超出layer的部分
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = border;
    
    //附加参数(可不要)
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(4, 4);
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowRadius = 2.0;
}

/**
 *  拉伸图片：只拉伸图片中间的一个像素点
 *
 *  @param name 需要拉伸的图片的名字
 *
 *  @return 返回一个可拉伸的图片
 */
+ (instancetype)imageWithStretchWithName:(NSString *)name
{
    //拉伸图片
    UIImage *image = [UIImage imageNamed:name];

    UIImage *newImage = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    return newImage;

}

/**
 *  拼接图片(垂直方向)
 */
//+ (instancetype)imageWithImageTop:(UIImage *)imageTop middle:(UIImage *)imageMiddle bottom:(UIImage *)imageBotton
//{
//    CGFloat newImgW = [UIScreen mainScreen].bounds.size.width;
//    CGFloat newImgH = imageTop.size.height + imageMiddle.size.height + imageBotton.size.height;
//    
//    CGSize newImgSize= CGSizeMake(newImgW,newImgH);
//    UIGraphicsBeginImageContext(newImgSize);
//    
//    [imageTop drawInRect:CGRectMake(0, 0, imageTop.size.width, imageTop.size.height)];
//    [imageMiddle drawInRect:CGRectMake(imageTop.size.height, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]
//    
//}

+ (instancetype)imageWithImageArray:(NSArray *)imageArray
{
    __block CGFloat newImgW = [UIScreen mainScreen].bounds.size.width;
    __block CGFloat newImgH = 0;
    
    [imageArray enumerateObjectsUsingBlock:^(UIImage *img, NSUInteger idx, BOOL *stop) {
//        newImgW = newImgW > img.size.width ? newImgW : img.size.width;
        newImgH += img.size.height + 5;
    }];
    
    CGSize newImgSize= CGSizeMake(newImgW,newImgH);
//    UIGraphicsBeginImageContext(newImgSize);
    UIGraphicsBeginImageContextWithOptions(newImgSize, NO, 0.0);
    
    //draw
//    UIImage *bgImg = [UIImage imageNamed:@"refresh_bg"];
//    [bgImg drawInRect:CGRectMake(0, 0, newImgW, newImgH)];
    
    CGFloat tempY = 0;
    for (int i = 0; i < imageArray.count; i++) {
        if (i > 0) {
            UIImage *preImg = imageArray[i - 1];
            tempY += (preImg.size.height + 5);
        }
        
        if (0 == i) {
            UIImage *img = imageArray[i];
            [img drawInRect:CGRectMake(0, tempY, img.size.width * 0.5, img.size.height * 0.5)];
        } else {
            UIImage *img = imageArray[i];
            [img drawInRect:CGRectMake(0, tempY, img.size.width, img.size.height)];
        }
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}
@end
