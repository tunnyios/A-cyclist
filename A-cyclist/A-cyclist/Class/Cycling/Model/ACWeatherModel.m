//
//  ACWeatherModel.m
//  A-cyclist
//
//  Created by tunny on 15/8/15.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACWeatherModel.h"

@implementation ACWeatherModel

+ (NSDictionary *)imageMap {
    // 1
    static NSDictionary *_imageMap = nil;
    if (! _imageMap) {
        // 2
        _imageMap = @{
                      @"01d" : @"weather-clear",
                      @"02d" : @"weather-few",
                      @"03d" : @"weather-few",
                      @"04d" : @"weather-broken",
                      @"09d" : @"weather-shower",
                      @"10d" : @"weather-rain",
                      @"11d" : @"weather-tstorm",
                      @"13d" : @"weather-snow",
                      @"50d" : @"weather-mist",
                      @"01n" : @"weather-moon",
                      @"02n" : @"weather-few-night",
                      @"03n" : @"weather-few-night",
                      @"04n" : @"weather-broken",
                      @"09n" : @"weather-shower",
                      @"10n" : @"weather-rain-night",
                      @"11n" : @"weather-tstorm",
                      @"13n" : @"weather-snow",
                      @"50n" : @"weather-mist",
                      };
    }
    return _imageMap;
}

/**
 *  根据返回的icon找到对应天气图标
 */
+ (UIImage *)imageNameWithIcon:(NSString *)iconStr
{
    NSString *icon = [ACWeatherModel imageMap][iconStr];
    return [UIImage imageNamed:icon];
}
@end
