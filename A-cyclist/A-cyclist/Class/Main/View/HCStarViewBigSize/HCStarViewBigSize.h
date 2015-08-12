//
//  HCStarViewBigSize.h
//  A-cyclist
//
//  Created by tunny on 15/8/11.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCStarViewBigSize : UIView

+ (instancetype)starViewBigSize;

/** 获取当前点亮的星星的个数 */
- (NSInteger)getNumOfStarLight;
@end
