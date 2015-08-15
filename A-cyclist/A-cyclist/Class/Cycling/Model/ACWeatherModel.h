//
//  ACWeatherModel.h
//  A-cyclist
//
//  Created by tunny on 15/8/15.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ACWeatherModel : NSObject

/** 根据返回的icon找到对应天气图标 */
+ (UIImage *)imageNameWithIcon:(NSString *)iconStr;
@end
