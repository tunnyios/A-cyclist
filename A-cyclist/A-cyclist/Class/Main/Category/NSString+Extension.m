//
//  NSString+Extension.m
//  
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "NSString+Extension.h"

#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

@implementation NSString (Extension)

/**
 *  根据最大宽度，计算文字的尺寸
 *
 *  @param font 文字类型大小等属性
 *  @param maxW 最大宽度
 *
 *  @return
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/**
 *  根据文字属性，计算文字尺寸
 *
 *  @param font 文字属性
 *
 *  @return
 */
- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

#pragma mark - 正则表达式文字合法性检查
- (BOOL)match:(NSString *)pattern
{
    // 1.创建正则表达式
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    // 2.测试字符串
    NSArray *results = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    return results.count > 0;
}

- (BOOL)isAvailQQ
{
    // 1.不能以0开头
    // 2.全部是数字
    // 3.5-11位
    return [self match:@"^[1-9]\\d{4,10}$"];
}

- (BOOL)isAvailPhoneNumber
{
    // 1.全部是数字
    // 2.11位
    // 3.以13\15\18\17开头
    return [self match:@"^1[3578]\\d{9}$"];
    // JavaScript的正则表达式:\^1[3578]\\d{9}$\
    
}

- (BOOL)isAvailIPAddress
{
    // 1-3个数字: 0-255
    // 1-3个数字.1-3个数字.1-3个数字.1-3个数字
    return [self match:@"^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$"];
}

- (BOOL)isAvailEmail
{
    /*开始必须是一个或者多个单词字符或者是-，加上@，然后又是一个或者多个单词字符或者是-。然后是点“.”和单词字符和-的组合，可以有一个或者多个组合。 */
    return [self match:@"^[A-Za-zd]+([-_.][A-Za-zd]+)*@([A-Za-zd]+[-.])+[A-Za-zd]{2,5}$"];
}

- (BOOL)isAvailUserName
{
    //1. 字母数字字符（英文字母和数字）
    //2. 下划线(_)
    //3. 最短3个字符最长不超过16个字符
    return [self match:@"^[a-zA-Z0-9_]{3,16}$"];
}


#pragma mark - 字符串样式转换
/**
 *  将秒数转换成h:m格式
 */
+ (NSString *)timeStrWithSeconds:(NSInteger)seconds
{
    NSInteger hour = seconds / (60 * 60);
    NSInteger minTemp = seconds % (60 * 60);
    NSInteger minute = minTemp / 60;
    //    NSInteger second = minTemp % 60;
    
    NSString *time = [NSString stringWithFormat:@"%02ld:%02ld", (long)hour, (long)minute];
    //    NSString *time = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hour, (long)minute, (long)second];
    
    return time;
}

@end
