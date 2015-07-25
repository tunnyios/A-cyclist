//
//  ACScrollView.m
//  A-cyclist
//
//  Created by tunny on 15/7/25.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACScrollView.h"

@implementation ACScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    // 获取一个UITouch
    UITouch *touch = [touches anyObject];
    
    // 获取当前的位置
    CGPoint current = [touch locationInView:self];
    NSLog(@"current is %@", NSStringFromCGPoint(current));
    CGFloat x = [UIScreen mainScreen].bounds.size.width;
    if (current.x >= x + 10) {
        //在地图上
        NSLog(@"在地图上, 不滚动");
        return YES;
    } else {
        return NO;
    }
}



@end
