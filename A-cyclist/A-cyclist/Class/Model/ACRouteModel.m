//
//  ACRoute.m
//  A-cyclist
//
//  Created by tunny on 15/7/29.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACRouteModel.h"
#import "ACStepModel.h"

@implementation ACRouteModel

/**
 *  归档
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.routeName forKey:@"routeName"];
    [aCoder encodeObject:self.steps forKey:@"steps"];
    [aCoder encodeObject:self.distance forKey:@"distance"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.averageSpeed forKey:@"averageSpeed"];
    [aCoder encodeObject:self.maxSpeed forKey:@"maxSpeed"];
    [aCoder encodeObject:self.isShared forKey:@"isShared"];
    [aCoder encodeObject:self.hotLevel forKey:@"hotLevel"];
    [aCoder encodeObject:self.imageList forKey:@"imageList"];
    [aCoder encodeObject:self.userObjectId forKey:@"userObjectId"];
}

/**
 *  解档
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.routeName = [aDecoder decodeObjectForKey:@"routeName"];
        self.steps = [aDecoder decodeObjectForKey:@"steps"];
        self.distance = [aDecoder decodeObjectForKey:@"distance"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.averageSpeed = [aDecoder decodeObjectForKey:@"averageSpeed"];
        self.maxSpeed = [aDecoder decodeObjectForKey:@"maxSpeed"];
        self.isShared = [aDecoder decodeObjectForKey:@"isShared"];
        self.hotLevel = [aDecoder decodeObjectForKey:@"hotLevel"];
        self.imageList = [aDecoder decodeObjectForKey:@"imageList"];
        self.userObjectId = [aDecoder decodeObjectForKey:@"userObjectId"];
    }
    
    return self;
}

- (NSString *)description
{
//    return [NSString stringWithFormat:@" <%p:%@>\n {routeName = %@\n steps = %@\n distance = %@\n time = %@\n averageSpeed = %@\n maxSpeed = %@\n isShared = %@\n hotLevel = %@\n imageList = %@\n userObjectId = %@}", self.routeName, self, self.class, self.steps, self.distance, self.time, self.averageSpeed, self.maxSpeed, self.isShared, self.hotLevel, self.imageList, self.userObjectId];
    
    return [NSString stringWithFormat:@"##########<%p : %@>\n {\n routeName = %@,\n steps = %@,\n distance = %@,\n time = %@,\n averageSpeed = %@,\n maxSpeed = %@,\n isShared = %@,\n hotLevel = %@,\n imageList = %@,\n userObjectId = %@\n}", self, self.class, self.routeName, self.steps, self.distance, self.time, self.averageSpeed, self.maxSpeed, self.isShared, self.hotLevel, self.imageList, self.userObjectId];
}

@end
