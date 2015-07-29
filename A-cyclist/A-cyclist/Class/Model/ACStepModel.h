//
//  ACStep.h
//  A-cyclist
//
//  Created by tunny on 15/7/29.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACStepModel : NSObject <NSCoding>
/** 纬度 */
@property (nonatomic, copy) NSString *latitude;
/** 经度 */
@property (nonatomic, copy) NSString *longitude;
/** 海拔高度 */
@property (nonatomic, copy) NSString *altitude;

+ (instancetype)stepModelWithLatitude:(NSString *)latitude longitude:(NSString *)longtitude altitude:(NSString *)altitude;
@end
