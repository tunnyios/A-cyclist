//
//  ACSharedRoutePhotoModel.m
//  A-cyclist
//
//  Created by tunny on 15/8/10.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACSharedRoutePhotoModel.h"

@implementation ACSharedRoutePhotoModel

+ (instancetype)routePhotoModelWithphoto:(NSString *)photoURL
{
    ACSharedRoutePhotoModel *photoModel = [[ACSharedRoutePhotoModel alloc] init];
    photoModel.photoURL = photoURL;
    
    return photoModel;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{\n photo = %@\n}", self.photoURL];
}
@end
