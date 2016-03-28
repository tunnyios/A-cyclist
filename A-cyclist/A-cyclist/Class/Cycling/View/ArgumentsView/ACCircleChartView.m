//
//  ACCircleChartView.m
//  A-cyclist
//
//  Created by tunny on 15/8/2.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACCircleChartView.h"
#import "ACRouteModel.h"
#import "UIColor+Tools.h"
#import "ACGlobal.h"

@implementation ACCircleChartView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    [self setClearsContextBeforeDrawing: YES];
    // Drawing code
    NSArray *array = @[self.route.ascendDistance, self.route.flatDistance, self.route.descendDistance];
    DLog(@"array is %@", array);
    //获取图像上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置绘图信息
    CGPoint __block centerPoint = CGPointMake(self.center.x, self.center.y - 20);
    CGFloat __block radius = 60;
    CGFloat __block startAngle = 0;
    CGFloat __block endAngel = 0;
    
    [array enumerateObjectsUsingBlock:^(NSString *num, NSUInteger idx, BOOL *stop) {
        if ([num isEqualToString:@"0.00"]) {
            return ;
        }
        CGFloat scral = num.doubleValue / self.route.distance.doubleValue;
        startAngle = endAngel;
        if (idx == (array.count - 1)) {
            endAngel = M_PI * 2;
        } else {
            endAngel = startAngle + scral * M_PI * 2;
        }
        
        DLog(@"num is %@, distance is %@", num, self.route.distance);
        DLog(@"scral is %f, startAngle is %f, endAngle is %f", scral, startAngle, endAngel);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radius startAngle:startAngle endAngle:endAngel clockwise:YES];
        //添加一根线到圆点
        [path addLineToPoint:centerPoint];
        //封口
        [path closePath];
        //设置绘图状态,即填充颜色
        UIColor *color = nil;
        if (0 == idx) { //上坡
            color = [UIColor colorWithR:211 G:0 B:33 A:1];
        } else if (1 == idx) {  //平地
            color = [UIColor colorWithR:207 G:146 B:66 A:1];
        } else {    //下坡
            color = [UIColor colorWithR:39 G:153 B:44 A:1];
        }
        [color setFill];
        
        //将path添加到上下文
        CGContextAddPath(ctx, path.CGPath);
        //渲染将上下文添加到视图
        CGContextDrawPath(ctx, kCGPathFill);
    }];
}


@end
