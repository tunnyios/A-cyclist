//
//  ACLineChartLabelView.m
//  A-cyclist
//
//  Created by tunny on 15/8/3.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACLineChartLabelView.h"

@implementation ACLineChartLabelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setLineBreakMode:NSLineBreakByClipping];
        self.adjustsFontSizeToFitWidth = YES;
        [self setMinimumScaleFactor:12.0f];
        
        [self setNumberOfLines:1];
        [self setFont:[UIFont fontWithName:nil size:11.0f]];
        [self setTextColor: [UIColor grayColor]];
        self.backgroundColor = [UIColor clearColor];
        [self setTextAlignment:NSTextAlignmentLeft];
        self.userInteractionEnabled = YES;
        [self setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    }
    return self;
}


@end
