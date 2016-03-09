//
//  ACUtility.m
//  A-cyclist
//
//  Created by tunny on 16/3/2.
//  Copyright © 2016年 tunny. All rights reserved.
//  

#import "ACUtility.h"
#import "KeychainItemWrapper.h"
#import "ACGlobal.h"

ACUserModel *ACUser;
// 设备ID
NSString *deviceId = nil;

@implementation ACUtility

#pragma mark 接收转字符串处理
+ (NSString *)stringWithId:(id)value
{
    NSString *strValue = nil;
    if (value == nil || [value isEqual:[NSNull null]]) {
        strValue = @"";
    }else{
        if ([value isKindOfClass:[NSNumber class]]) {
            strValue = [NSString stringWithFormat:@"%@",value];
        }else{
            strValue = value;
        }
        strValue = [strValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return strValue;
}

#pragma mark 处理日期
+ (NSString *)formDateToString:(NSString *)strDate
{
    if (strDate == nil || [strDate isEqual:[NSNull null]]) {
        return @"";
    }
    NSArray *arrayDate = [strDate componentsSeparatedByString:@"."];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:[arrayDate objectAtIndex:0]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:date];
}

#pragma mark 计算时间
+ (NSString *)computationTimer:(NSString *)timeStr
{
    NSString *dateStr = [[timeStr componentsSeparatedByString:@"."] firstObject];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    NSDate *nowDate = [NSDate date];
    
    NSTimeInterval timeDistance = [nowDate timeIntervalSinceDate:date];
    
    //比当前时间更晚（本地时间错误）
    if (timeDistance<60) {
        //低于1分钟统一刚刚
        dateStr = @"刚刚";
    }else{
        //计算时间距离
        if (timeDistance < 60*60){
            //一小时内（分钟前展示）
            dateStr = [NSString stringWithFormat:@"%d分钟前", (int)timeDistance/(60) + 1];
        }else if (timeDistance < 24*60*60){
            //一天以内（小时前展示）
            dateStr = [NSString stringWithFormat:@"%d小时前", (int)timeDistance/(60*60)];
        }else{
            [dateFormatter setDateFormat:@"MM-dd"];
            //超过一天（几天前展示）
            dateStr =  [dateFormatter stringFromDate:date];
        }
    }
    return dateStr;
}

#pragma 显示弹出信息
+ (void)showMessage:(NSString *)msg target:(id)target
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:target cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark /*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符(2015年12约18日，更改只判断1开头或是否是11位)
    NSString *phoneRegex = @"^(1[0-9])\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark 获取设备ID
+ (void)getUUID
{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"AcyclistDeciveId" accessGroup:nil];
    deviceId = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    if ([deviceId isEqualToString:@""]) {
        deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        //保存账户名称
        //[keychainItem setObject:deviceId forKey:(__bridge id)kSecAttrService];
    }
    DLog(@"deviceId: %@", deviceId);
}

#pragma mark - 设置字号
+ (UIFont *)setFontWithSize:(CGFloat)size
{
    UIFont *font = [[UIFont alloc] init];
    if (isiOS9) {
        font = [UIFont fontWithName:@"PingFangSC-Light" size:size];
    } else {
        font = [UIFont fontWithName:@"STHeitiSC-Light" size:size];
    }
    
    return font;
}

@end
