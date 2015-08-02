//
//  ACCyclingDetailModel.h
//  A-cyclist
//
//  Created by tunny on 15/8/2.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACCyclingDetailModel : NSObject
/** title */
@property (nonatomic, copy) NSString *title;
/** subtitile */
@property (nonatomic, copy) NSString *subTitle;

+ (instancetype)settingCellWithTitle:(NSString *)title subTitle:(NSString *)subTitle;
@end
