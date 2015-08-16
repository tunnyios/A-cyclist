//
//  ACSharedRouteModel.m
//  A-cyclist
//
//  Created by tunny on 15/8/10.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACSharedRouteModel.h"
#import "ACSharedRoutePhotoModel.h"
#import <BmobSDK/Bmob.h>
#import "ACGlobal.h"
#import "MJExtension.h"

@implementation ACSharedRouteModel

MJCodingImplementation

+ (NSDictionary *)objectClassInArray
{
    return @{@"imageList" : [ACSharedRoutePhotoModel class]};
}

/**
 *  将bmobObject对象转换成Route对象
 */
+ (ACSharedRouteModel *)sharedRouteModelWithBmobObject:(BmobObject *)bmobObj
{
    ACSharedRouteModel *routeModel = [[ACSharedRouteModel alloc] init];

    routeModel.nameCN = [bmobObj objectForKey:@"nameCN"];
    
    NSArray *imageArray = [bmobObj objectForKey:@"imageList"];
    __block NSMutableArray *imageArrayM = [NSMutableArray array];
    [imageArray enumerateObjectsUsingBlock:^(NSDictionary *imageDict, NSUInteger idx, BOOL *stop) {
        ACSharedRoutePhotoModel *photo = [[ACSharedRoutePhotoModel alloc] init];
        photo.photoURL = imageDict[@"photoURL"];
        [imageArrayM addObject:photo];
    }];
    routeModel.imageList = imageArrayM;
    
    routeModel.distance = [bmobObj objectForKey:@"distance"];
    routeModel.nameEN = [bmobObj objectForKey:@"nameEN"];
    routeModel.maxAlitude = [bmobObj objectForKey:@"maxAlitude"];
    routeModel.difficultyLevel = [bmobObj objectForKey:@"difficultyLevel"];
    routeModel.sceneryLevel = [bmobObj objectForKey:@"sceneryLevel"];
    routeModel.userName = [bmobObj objectForKey:@"userName"];
    routeModel.userObjectId = [bmobObj objectForKey:@"userObjectId"];
    routeModel.routeDesc = [bmobObj objectForKey:@"routeDesc"];
    routeModel.classification = [bmobObj objectForKey:@"classification"];
    
//    DLog(@"routeModel is %@", routeModel);
    return routeModel;
}

/**
 *  将bmobObject对象数组转换成Route对象数组
 */
+ (NSArray *)sharedRouteModelArrayWithBmobObjectArray:(NSArray *)bmobArray
{
    NSMutableArray *routeArrayM = [NSMutableArray array];
    [bmobArray enumerateObjectsUsingBlock:^(BmobObject *bmobObj, NSUInteger idx, BOOL *stop) {
        ACSharedRouteModel *routeModel = [self sharedRouteModelWithBmobObject:bmobObj];
        [routeArrayM addObject:routeModel];
    }];
    
    //    DLog(@"routeArrayM is %@", routeArrayM);
    return routeArrayM;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%p : %@>\n {\n nameCN = %@,\n nameEN = %@,\n distance = %@,\n maxAltitude is %@,\n difficultyLevel = %@,\n sceneryLevel = %@,\n userName = %@,userObjectId = %@,\n \n routeDesc = %@,\n imageList = %@,\n classification = %@\n}", self, self.class, self.nameCN, self.nameEN, self.distance, self.maxAlitude, self.difficultyLevel, self.sceneryLevel, self.userName, self.userObjectId, self.routeDesc, self.imageList, self.classification];
}
@end
