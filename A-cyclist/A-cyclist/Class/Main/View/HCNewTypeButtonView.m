//
//  HCNewTypeButton.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/18.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCNewTypeButtonView.h"

@implementation HCNewTypeButtonView

/** 边距 */
#define ButtonMargin    2

/**
 *  设置按钮的title和图片
 */
- (void)setBtnTitle:(NSString *)title icon:(NSString *)icon heighIcon:(NSString *)heighIcon
{
    //1. 设置title和图片
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:heighIcon] forState:UIControlStateHighlighted];
    self.imageView.contentMode = UIViewContentModeCenter;
}

/**
 *  计算title的frame,并设置內边距
 */
- (void)setBtnFrame
{
    //计算title的frame和image的Size
    NSDictionary *titleFont = @{NSFontAttributeName : [UIFont systemFontOfSize:17]
                                };
    CGRect titleFrame = [self.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine attributes:titleFont context:nil];
    CGSize imageSize = self.currentImage.size;
    
    //设置button位置
    CGFloat btnW = titleFrame.size.width + imageSize.width + ButtonMargin * 4;
    CGFloat btnH = (titleFrame.size.height > imageSize.height) ? titleFrame.size.height : imageSize.height;
    self.bounds = CGRectMake(0, 0, btnW, btnH);
    
    //修改title和image的内边距
    CGFloat titleMargin = imageSize.width + ButtonMargin;
    CGFloat imageMargin = titleFrame.size.width + ButtonMargin;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -titleMargin, 0, titleMargin);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, imageMargin, 0, -imageMargin);
}

/**
 *  创建一个新排版的button
 *  title在左边，图标在右边
 *  @param title     标题
 *  @param icon      普通图标
 *  @param heighIcon 高亮图标
 *
 *  @return
 */
- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon heighIcon:(NSString *)heighIcon
{
    self = [super init];
    if (self) {
        if (title && icon) {
            //1. 设置title和图片
            [self setBtnTitle:title icon:icon heighIcon:heighIcon];
            
            //2. 计算title的frame,并设置內边距
            [self setBtnFrame];
        }
    }
    return self;
}

/**
 *  创建一个新排版的button
 *  title在左边，图标在右边
 *  @param title     标题
 *  @param icon      普通图标
 *  @param heighIcon 高亮图标
 * 
 *  @return 返回新排版的button,
 */
+ (instancetype)buttonWithTitle:(NSString *)title icon:(NSString *)icon heighIcon:(NSString *)heighIcon
{
    return [[HCNewTypeButtonView alloc] initWithTitle:title icon:icon heighIcon:heighIcon];
}


/**
 *  更新button的content
 *
 *  @param title     newTitle
 *  @param icon      newImage
 *  @param heighIcon newImage
 */
- (void)setTitle:(NSString *)title icon:(NSString *)icon heighIcon:(NSString *)heighIcon
{
    if (title && icon) {
        //1. 设置title和图片
        [self setBtnTitle:title icon:icon heighIcon:heighIcon];
        
        //2. 计算title的frame,并设置內边距
        [self setBtnFrame];
    }
}


@end
