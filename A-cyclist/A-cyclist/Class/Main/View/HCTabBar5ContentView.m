//
//  HCTabBar5ContentView.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/18.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCTabBar5ContentView.h"

@interface HCTabBar5ContentView()
@property (nonatomic, strong) UIButton *plusBtn;

@end

@implementation HCTabBar5ContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundImage = [UIImage imageNamed:@"tabbar_img~iphone"];
    }
    
    return self;
}

/**
 *  添加一个button到tabBar的正中间
 */
- (UIButton *)plusBtn
{
    if (_plusBtn == nil) {
        //添加一个button到tabBar
        _plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plusBtn setImage:[UIImage imageNamed:@"tab_cycling_iphone_3"] forState:UIControlStateNormal];
        [_plusBtn setImage:[UIImage imageNamed:@"tab_cycling_white_iphone_3"] forState:UIControlStateHighlighted];
        [_plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [_plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        _plusBtn.userInteractionEnabled = NO;
        
        [self addSubview:_plusBtn];
    }
    
    return _plusBtn;
}

/**
 *  重新布局tabBar的子控件的位置
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //2. 重新布局tabBar的子控件位置
    __block CGFloat barX  = 0;
    __block CGFloat barY = 0;
    __block CGFloat barW = self.frame.size.width / 5;
    __block CGFloat barH = self.frame.size.height;
    __block int index = 0;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        //1. 找出UITabBarButton，系统的UITabButton是私有的，外界不能使用
        Class class = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:class]) {
            //排列位置
            barX = index * barW;
            view.frame = CGRectMake(barX, barY, barW, barH);
            
            index++;
        }
    }];
    
    //1. 设置button的位置
    CGFloat buttonX = self.frame.size.width * 0.5;
    CGFloat buttonY = self.frame.size.height * 0.5;
    CGFloat buttonW = self.frame.size.width / 5;
    CGFloat buttonH = self.frame.size.height;
    self.plusBtn.center = CGPointMake(buttonX, buttonY);
    self.plusBtn.bounds = CGRectMake(0, 0, buttonW, buttonH);

}

@end
