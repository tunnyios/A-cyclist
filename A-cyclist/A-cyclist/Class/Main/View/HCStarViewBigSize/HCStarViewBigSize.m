//
//  HCStarViewBigSize.m
//  A-cyclist
//
//  Created by tunny on 15/8/11.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCStarViewBigSize.h"

@interface HCStarViewBigSize ()
@property (weak, nonatomic) IBOutlet UIButton *star1;
@property (weak, nonatomic) IBOutlet UIButton *star2;
@property (weak, nonatomic) IBOutlet UIButton *star3;
@property (weak, nonatomic) IBOutlet UIButton *star4;
@property (weak, nonatomic) IBOutlet UIButton *star5;

@end

@implementation HCStarViewBigSize

+ (instancetype)starViewBigSize
{
    HCStarViewBigSize *starView = [[[NSBundle mainBundle] loadNibNamed:@"HCStarViewBigSize" owner:self options:nil] lastObject];
    
    return starView;
}

- (IBAction)star1Click:(id)sender
{
    if (!self.star2.isSelected
        && !self.star3.isSelected
        && !self.star4.isSelected
        && !self.star5.isSelected) {
        
        self.star1.selected = !self.star1.isSelected;
    }
}

- (IBAction)star2Click:(id)sender
{
    if (self.star1.isSelected
        && !self.star3.isSelected
        && !self.star4.isSelected
        && !self.star5.isSelected) {
        self.star2.selected = !self.star2.isSelected;
    }
}

- (IBAction)star3Click:(id)sender
{
    if (self.star1.isSelected
        && self.star2.isSelected
        && !self.star4.isSelected
        && !self.star5.isSelected) {
        self.star3.selected = !self.star3.isSelected;
    }
}

- (IBAction)star4Click:(id)sender
{
    if (self.star1.isSelected
        && self.star2.isSelected
        && self.star3.isSelected
        && !self.star5.isSelected) {
        self.star4.selected = !self.star4.isSelected;
    }
}

- (IBAction)star5Click:(id)sender
{
    if (self.star1.isSelected
        && self.star2.isSelected
        && self.star3.isSelected
        && self.star4.isSelected) {
        self.star5.selected = !self.star5.isSelected;
    }
}

/**
 *  获取当前点亮的星星的个数
 */
- (NSInteger)getNumOfStarLight
{
    NSInteger num = 0;
    
    if (self.star1.isSelected) {
        num++;
        if (self.star2.isSelected) {
            num++;
            if (self.star3.isSelected) {
                num++;
                if (self.star4.isSelected) {
                    num++;
                    if (self.star5.isSelected) {
                        num++;
                    }
                }
            }
        }
    }
    
    return num;
}


@end
