//
//  HCTgHeaderView.h
//  01-day07-团购
//
//  Created by suhongcheng on 15/5/14.
//  Copyright (c) 2015年 suhongcheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACHotRoutesDetailTopView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
/** 图片url数组 */
@property (nonatomic, strong) NSArray *photoArray;

- (void)stopTimer;
@end
