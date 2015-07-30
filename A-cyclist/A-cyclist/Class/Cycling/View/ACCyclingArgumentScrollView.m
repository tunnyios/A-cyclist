//
//  ACCyclingArgumentScrollView.m
//  A-cyclist
//
//  Created by tunny on 15/7/30.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACCyclingArgumentScrollView.h"

@implementation ACCyclingArgumentScrollView

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
    CGSize scrollSize = self.bounds.size;
    NSLog(@"current:%@ size:%@", NSStringFromCGPoint(current), NSStringFromCGSize(scrollSize));
    if ((current.x < scrollSize.width) && (current.y < (scrollSize.height - 120))) {
        //在地图上
        NSLog(@"在地图上, 不滚动, view class is %@", view.class);
        return YES;
    } else {
        if ([view isKindOfClass:[UIButton class]]) {
            return YES;
        }
        return NO;
    }
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return NO;
}

@end
