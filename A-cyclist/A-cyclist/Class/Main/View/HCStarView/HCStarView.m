//
//  HCStartView.m
//  A-cyclist
//
//  Created by tunny on 15/8/11.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCStarView.h"

@interface HCStarView ()
@property (weak, nonatomic) IBOutlet UIButton *star1;
@property (weak, nonatomic) IBOutlet UIButton *star2;
@property (weak, nonatomic) IBOutlet UIButton *star3;
@property (weak, nonatomic) IBOutlet UIButton *star4;
@property (weak, nonatomic) IBOutlet UIButton *star5;

@end

@implementation HCStarView

+ (instancetype)starViewWithLevel:(NSInteger)level
{
    HCStarView *starView = [[[NSBundle mainBundle] loadNibNamed:@"HCStarView" owner:self options:nil] lastObject];
    
    //难度
    switch (level) {
        case 0:
            [starView zeroStar];
            break;
        case 1:
            [starView oneStar];
            break;
        case 2:
            [starView twoStar];
            break;
        case 3:
            [starView threeStar];
            break;
        case 4:
            [starView fourStar];
            break;
        case 5:
            [starView fiveStar];
            break;
            
        default:
            break;
    }

    
    return starView;
}

- (void)zeroStar
{
    self.star1.selected = NO;
    self.star2.selected = NO;
    self.star3.selected = NO;
    self.star4.selected = NO;
    self.star5.selected = NO;
}

- (void)oneStar
{
    self.star1.selected = YES;
    self.star2.selected = NO;
    self.star3.selected = NO;
    self.star4.selected = NO;
    self.star5.selected = NO;
}

- (void)twoStar
{
    self.star1.selected = YES;
    self.star2.selected = YES;
    self.star3.selected = NO;
    self.star4.selected = NO;
    self.star5.selected = NO;
}

- (void)threeStar
{
    self.star1.selected = YES;
    self.star2.selected = YES;
    self.star3.selected = YES;
    self.star4.selected = NO;
    self.star5.selected = NO;
}

- (void)fourStar
{
    self.star1.selected = YES;
    self.star2.selected = YES;
    self.star3.selected = YES;
    self.star4.selected = YES;
    self.star5.selected = NO;
}

- (void)fiveStar
{
    self.star1.selected = YES;
    self.star2.selected = YES;
    self.star3.selected = YES;
    self.star4.selected = YES;
    self.star5.selected = YES;
}

@end
