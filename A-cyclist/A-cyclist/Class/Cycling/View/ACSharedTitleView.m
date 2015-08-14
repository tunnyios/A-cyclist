//
//  ACSharedTitleView.m
//  A-cyclist
//
//  Created by tunny on 15/8/14.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACSharedTitleView.h"

@interface ACSharedTitleView ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation ACSharedTitleView

- (void)setDateStr:(NSString *)dateStr
{
    _dateStr = dateStr;
    
    self.timeLabel.text = dateStr;
}

+ (instancetype)sharedTitleView
{
    ACSharedTitleView *titleView = [[[NSBundle mainBundle] loadNibNamed:@"ACSharedTitleView" owner:self options:nil] lastObject];
    
    return titleView;
}

@end
