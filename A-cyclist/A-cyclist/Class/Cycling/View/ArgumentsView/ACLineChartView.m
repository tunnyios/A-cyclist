//
//  ACLineChartView.m
//  A-cyclist
//
//  Created by tunny on 15/8/2.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACLineChartView.h"
#import "ACRouteModel.h"
#import "ACLineChartLabelView.h"
#import "ACStepModel.h"
#import "UIColor+Tools.h"


#define AClineHeight 30

@interface ACLineChartView ()
//横竖轴距离间隔
@property (nonatomic, assign) NSInteger hInterval;
@property (nonatomic, assign) NSInteger vInterval;

//横竖轴显示标签
@property (nonatomic, strong) NSMutableArray *hDistanceArray;
@property (nonatomic, strong) NSMutableArray *vSpeedArray;
@property (nonatomic, strong) NSMutableArray *vAltitudeArray;

@end

@implementation ACLineChartView

- (NSMutableArray *)hDistanceArray
{
    if (_hDistanceArray == nil) {
        _hDistanceArray = [NSMutableArray array];
    }
    
    return _hDistanceArray;
}

- (NSMutableArray *)vSpeedArray
{
    if (_vSpeedArray == nil) {
        _vSpeedArray = [NSMutableArray array];
    }
    
    return _vSpeedArray;
}

- (NSMutableArray *)vAltitudeArray
{
    if (_vAltitudeArray == nil) {
        _vAltitudeArray = [NSMutableArray array];
    }
    
    return _vAltitudeArray;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"awakeFormNib");
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"initWithCoder");
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    //clean array
    [self.hDistanceArray removeAllObjects];
    [self.vAltitudeArray removeAllObjects];
    [self.vSpeedArray removeAllObjects];
    
    // Drawing code
    CGFloat viewW = self.bounds.size.width;
    CGFloat viewH = self.bounds.size.height;
    
    //设置数据
    self.hInterval = (viewW - (2 * AClineHeight)) * 0.2;
    self.vInterval = (viewH - (2 *AClineHeight)) * 0.2;
    
    double totleAltitude = self.route.maxAltitude.doubleValue - self.route.minAltitude.doubleValue;
    double altitudeInterval = totleAltitude * 0.2;
    for (int i = 0; i < 6; i++) {
        [self.vAltitudeArray addObject:[NSString stringWithFormat:@"%.0f", self.route.minAltitude.doubleValue + altitudeInterval * i]];
    }
    NSLog(@"vAltitudeArray is %@", self.vAltitudeArray);
    
    double speedInterval = self.route.maxSpeed.doubleValue * 0.2;
    for (int i = 0; i < 6; i++) {
        [self.vSpeedArray addObject:[NSString stringWithFormat:@"%.0f", 0 + speedInterval * i]];
    }
    NSLog(@"vSpeedArray is %@", self.vSpeedArray);
    
    double distanceInterval = self.route.distance.doubleValue * 1000 * 0.2;
    for (int i = 0; i < 6 ; i++) {
        double distance = 0 + distanceInterval * i;
        if (distance > 1000.0) {
            [self.hDistanceArray addObject:[NSString stringWithFormat:@"%.2f km", distance * 0.001]];
        } else {
            [self.hDistanceArray addObject:[NSString stringWithFormat:@"%.0f m", distance]];
        }
    }
    NSLog(@"hDistanceArray is %@", self.hDistanceArray);
    NSLog(@"arraySpeed is %@", self.route.steps);
    
    //画图
    [self setClearsContextBeforeDrawing: YES];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    UIBezierPath *pathDistance = [UIBezierPath bezierPath];
    UIBezierPath *pathAltitude = [UIBezierPath bezierPath];
    UIBezierPath *pathSpeed = [UIBezierPath bezierPath];
    
    //1. 添加横纵轴标签和横线
    int tmpY = viewH;
    for (int i = 0; i < self.vSpeedArray.count; i++) {
        CGPoint altitudePoint = CGPointMake(30, tmpY - 30);
        CGPoint speedPoint = CGPointMake(viewW, tmpY - 30);
        CGPoint distancePoint = CGPointMake(30, tmpY - 30);
        
        ACLineChartLabelView *labelAltitude = [[ACLineChartLabelView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        labelAltitude.center = CGPointMake(altitudePoint.x - 15, altitudePoint.y - self.vInterval * i);
        [labelAltitude setTextAlignment:NSTextAlignmentCenter];
        [labelAltitude setBackgroundColor:[UIColor clearColor]];
        [labelAltitude setTextColor:[UIColor darkGrayColor]];
        [labelAltitude setText:[self.vAltitudeArray objectAtIndex:i]];
        [self addSubview:labelAltitude];
        
        ACLineChartLabelView *labelSpeed = [[ACLineChartLabelView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        labelSpeed.center = CGPointMake(speedPoint.x - 15, speedPoint.y - self.vInterval * i);
        [labelSpeed setTextAlignment:NSTextAlignmentCenter];
        [labelSpeed setBackgroundColor:[UIColor clearColor]];
        [labelSpeed setTextColor:[UIColor colorWithR:0 G:98 B:184 A:1]];
        [labelSpeed setText:[self.vSpeedArray objectAtIndex:i]];
        [self addSubview:labelSpeed];
        
        ACLineChartLabelView *labelDistance = [[ACLineChartLabelView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        labelDistance.center = CGPointMake(distancePoint.x + self.hInterval * i, distancePoint.y + 15);
        [labelDistance setTextAlignment:NSTextAlignmentCenter];
        [labelDistance setBackgroundColor:[UIColor clearColor]];
        [labelDistance setTextColor:[UIColor darkGrayColor]];
        [labelDistance setText:[self.hDistanceArray objectAtIndex:i]];
        [self addSubview:labelDistance];
        
        if (i == self.vSpeedArray.count - 1) {
            ACLineChartLabelView *labelAltitudeName = [[ACLineChartLabelView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
            [labelAltitudeName setTextAlignment:NSTextAlignmentCenter];
            [labelAltitudeName setBackgroundColor:[UIColor clearColor]];
            [labelAltitudeName setTextColor:[UIColor darkGrayColor]];
            [labelAltitudeName setText:@"海拔(m)"];
            [self addSubview:labelAltitudeName];
            
            ACLineChartLabelView *labelSpeedName = [[ACLineChartLabelView alloc] initWithFrame:CGRectMake(speedPoint.x - 60, 0, 60, 30)];
            [labelSpeedName setTextAlignment:NSTextAlignmentCenter];
            [labelSpeedName setBackgroundColor:[UIColor clearColor]];
            [labelSpeedName setTextColor:[UIColor colorWithR:0 G:98 B:184 A:1]];
            [labelSpeedName setText:@"速度(km/h)"];
            [self addSubview:labelSpeedName];
        }
        
        //画线
        [pathDistance moveToPoint:CGPointMake(altitudePoint.x, altitudePoint.y - self.vInterval * i)];
        [pathDistance addLineToPoint:CGPointMake(speedPoint.x - 30, speedPoint.y - self.vInterval * i)];
        if (i == 0) {   //实线
            CGFloat lengths[] = {10, 0};
            CGContextSetLineDash(context, 0, lengths,2);
            //把路径添加到上下文
            CGContextAddPath(context, pathDistance.CGPath);
            //渲染
            CGContextStrokePath(context);
        } else {    //虚线
            CGFloat lengths[] = {5,5};
            CGContextSetLineDash(context, 0, lengths,2);
        }
    }
    //把路径添加到上下文
    CGContextAddPath(context, pathDistance.CGPath);
    //渲染
    CGContextStrokePath(context);
    
    //2. 画点和线条
    CGContextSetLineWidth(context, 1.5f);//主线宽度
    CGFloat lengths[] = {10, 0};
    CGContextSetLineDash(context, 0, lengths,2);
    NSUInteger count = self.route.steps.count;
    double trueHInterval = 0;
    double accruedDistance = 0;
    double trueVIntervalAltitude = 0;
    double trueVintervalSpeed = 0;

    CGPoint basePoint = CGPointMake(30, viewH - 30);
    //海拔线
    [pathAltitude moveToPoint:basePoint];
    for (int i = 0; i < count; i++) {
        ACStepModel *step = self.route.steps[i];
        trueVIntervalAltitude = (step.altitude.doubleValue / totleAltitude) * (viewH - 2 * AClineHeight);
        accruedDistance += step.distanceInterval.doubleValue;
        trueHInterval = (accruedDistance / (self.route.distance.doubleValue * 1000)) * (viewW - 2 * AClineHeight);
        CGPoint tempPoint = CGPointMake(basePoint.x + trueHInterval, basePoint.y - trueVIntervalAltitude);
        NSLog(@"<%f : %f>, trueVIntervalAltitude is %f, trueHInterval is %f, viewH is %f, totleAltitude is %f", basePoint.x + trueHInterval, basePoint.y - trueVIntervalAltitude, trueVIntervalAltitude, trueHInterval, viewH, totleAltitude);
        [pathAltitude addLineToPoint:tempPoint];
        [pathAltitude moveToPoint:tempPoint];
    }
    //把路径添加到上下文
    CGContextAddPath(context, pathAltitude.CGPath);
    [[UIColor darkGrayColor] set];
    //渲染
    CGContextStrokePath(context);
    
    //速度线
    accruedDistance = 0;
    [pathSpeed moveToPoint:basePoint];
    for (int i = 0; i < count; i++) {
        ACStepModel *step = self.route.steps[i];
        trueVintervalSpeed = (step.currentSpeed.doubleValue / self.route.maxSpeed.doubleValue) * (viewH - 2 * AClineHeight);
        accruedDistance += step.distanceInterval.doubleValue;
        trueHInterval = (accruedDistance / (self.route.distance.doubleValue * 1000)) * (viewW - 2 * AClineHeight);
        CGPoint tempPoint = CGPointMake(basePoint.x + trueHInterval, basePoint.y - trueVintervalSpeed);
        NSLog(@"(%f : %f)", basePoint.x + trueHInterval, basePoint.y - trueVintervalSpeed);
        [pathSpeed addLineToPoint:tempPoint];
        [pathSpeed moveToPoint:tempPoint];
    }
    //把路径添加到上下文
    CGContextAddPath(context, pathSpeed.CGPath);
    [[UIColor colorWithR:0 G:98 B:184 A:1] set];
    //渲染
    CGContextStrokePath(context);
}

@end
