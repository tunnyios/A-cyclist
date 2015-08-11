//
//  ACSharedRoutePhotoModel.h
//  A-cyclist
//
//  Created by tunny on 15/8/10.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACSharedRoutePhotoModel : NSObject
/** 路线配图 */
@property (nonatomic, copy) NSString *photoURL;

+ (instancetype)routePhotoModelWithphoto:(NSString *)photoURL;
@end
