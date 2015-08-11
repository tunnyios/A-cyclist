//
//  ACSharedRouteModel.h
//  A-cyclist
//
//  Created by tunny on 15/8/10.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BmobObject;
@interface ACSharedRouteModel : NSObject
/** name(中文) */
@property (nonatomic, copy) NSString *nameCN;
/** name(英文) */
@property (nonatomic, copy) NSString *nameEN;
/** 里程(km) */
@property (nonatomic, strong) NSNumber *distance;
/** 最高海拔(m) */
@property (nonatomic, strong) NSNumber *maxAlitude;
/** 难度级别 */
@property (nonatomic, strong) NSNumber *difficultyLevel;
/** 风景级别 */
@property (nonatomic, strong) NSNumber *sceneryLevel;
/** 路况级别 */
//@property (nonatomic, assign) NSNumber *roadLevel;
/** 来源：用户昵称 */
@property (nonatomic, copy) NSString *userName;
/** 图片url列表(3张风景最后一张为路线图) */
@property (nonatomic, strong) NSArray *imageList;
/** 路线描述 */
@property (nonatomic, copy) NSString *routeDesc;
/** 类别 */
@property (nonatomic, copy) NSString *classification;


/** 将bmobObject对象转换成Route对象 */
+ (ACSharedRouteModel *)sharedRouteModelWithBmobObject:(BmobObject *)bmobObj;

/** 将bmobObject对象数组转换成Route对象数组 */
+ (NSArray *)sharedRouteModelArrayWithBmobObjectArray:(NSArray *)bmobArray;
@end
