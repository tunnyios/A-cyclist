//
//  ACSharedTitleView.h
//  A-cyclist
//
//  Created by tunny on 15/8/14.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACSharedTitleView : UIView
/** 骑行日期 */
@property (nonatomic, copy) NSString *dateStr;

+ (instancetype)sharedTitleView;
@end
