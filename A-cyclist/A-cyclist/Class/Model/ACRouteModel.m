//
//  ACRoute.m
//  A-cyclist
//
//  Created by tunny on 15/7/29.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACRouteModel.h"
#import "ACStepModel.h"
#import "ACRoutePhotoModel.h"
#import "MJExtension.h"

@implementation ACRouteModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"steps" : [ACStepModel class],
             @"imageList" : [ACRoutePhotoModel class]
             };
}

/**
 *  归档
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.routeName forKey:@"routeName"];
    [aCoder encodeObject:self.steps forKey:@"steps"];
    [aCoder encodeObject:self.distance forKey:@"distance"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.timeNumber forKey:@"timeNumber"];
    [aCoder encodeObject:self.averageSpeed forKey:@"averageSpeed"];
    [aCoder encodeObject:self.maxSpeed forKey:@"maxSpeed"];
    [aCoder encodeObject:self.isShared forKey:@"isShared"];
    [aCoder encodeObject:self.hotLevel forKey:@"hotLevel"];
    [aCoder encodeObject:self.imageList forKey:@"imageList"];
    [aCoder encodeObject:self.userObjectId forKey:@"userObjectId"];
    
    [aCoder encodeObject:self.maxAltitude forKey:@"maxAltitude"];
    [aCoder encodeObject:self.minAltitude forKey:@"minAltitude"];
    [aCoder encodeObject:self.ascendAltitude forKey:@"ascendAltitude"];
    [aCoder encodeObject:self.ascendTime forKey:@"ascendTime"];
    [aCoder encodeObject:self.ascendDistance forKey:@"ascendDistance"];
    [aCoder encodeObject:self.flatTime forKey:@"flatTime"];
    [aCoder encodeObject:self.flatDistance forKey:@"flatDistance"];
    [aCoder encodeObject:self.descendTime forKey:@"descendTime"];
    [aCoder encodeObject:self.descendDistance forKey:@"descendDistance"];
//    [aCoder encodeObject:self.kcal forKey:@"kcal"];
    
    [aCoder encodeObject:self.cyclingEndTime forKey:@"cyclingEndTime"];
    [aCoder encodeObject:self.cyclingStartTime forKey:@"cyclingStartTime"];
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
        self.timeNumber = [aDecoder decodeObjectForKey:@"timeNumber"];
        self.averageSpeed = [aDecoder decodeObjectForKey:@"averageSpeed"];
        self.maxSpeed = [aDecoder decodeObjectForKey:@"maxSpeed"];
        self.isShared = [aDecoder decodeObjectForKey:@"isShared"];
        self.hotLevel = [aDecoder decodeObjectForKey:@"hotLevel"];
        self.imageList = [aDecoder decodeObjectForKey:@"imageList"];
        self.userObjectId = [aDecoder decodeObjectForKey:@"userObjectId"];
        
        self.maxAltitude = [aDecoder decodeObjectForKey:@"maxAltitude"];
        self.minAltitude = [aDecoder decodeObjectForKey:@"minAltitude"];
        self.ascendAltitude = [aDecoder decodeObjectForKey:@"ascendAltitude"];
        self.ascendTime = [aDecoder decodeObjectForKey:@"ascendTime"];
        self.ascendDistance = [aDecoder decodeObjectForKey:@"ascendDistance"];
        self.flatTime = [aDecoder decodeObjectForKey:@"flatTime"];
        self.flatDistance = [aDecoder decodeObjectForKey:@"flatDistance"];
        self.descendTime = [aDecoder decodeObjectForKey:@"descendTime"];
        self.descendDistance = [aDecoder decodeObjectForKey:@"descendDistance"];
//        self.kcal = [aDecoder decodeObjectForKey:@"kcal"];
        
        self.cyclingEndTime = [aDecoder decodeObjectForKey:@"cyclingEndTime"];
        self.cyclingStartTime = [aDecoder decodeObjectForKey:@"cyclingStartTime"];
    }
    
    return self;
}

- (NSString *)description
{
//    return [NSString stringWithFormat:@" <%p:%@>\n {routeName = %@\n steps = %@\n distance = %@\n time = %@\n averageSpeed = %@\n maxSpeed = %@\n isShared = %@\n hotLevel = %@\n imageList = %@\n userObjectId = %@}", self.routeName, self, self.class, self.steps, self.distance, self.time, self.averageSpeed, self.maxSpeed, self.isShared, self.hotLevel, self.imageList, self.userObjectId];
    
    return [NSString stringWithFormat:@"<%p : %@>\n {\n routeName = %@,\n steps = %@,\n distance = %@,\n time = %@,\n timeNumber = %@,\n averageSpeed = %@,\n maxSpeed = %@,\n maxAltitude = %@,\n minAltitude = %@,\n ascendAltitude = %@,\n ascendTime = %@,\n ascendDistance = %@,\n flatTime = %@,\n flatDistance = %@,\n descendTime = %@,\n descendDistance = %@,\n kcal = %@,\n isShared = %@,\n hotLevel = %@,\n imageList = %@,\n userObjectId = %@,\n cyclingStartTime = %@,\n cyclingEndTime = %@\n}", self, self.class, self.routeName, self.steps, self.distance, self.time, self.timeNumber, self.averageSpeed, self.maxSpeed, self.maxAltitude, self.minAltitude, self.ascendAltitude, self.ascendTime, self.ascendDistance, self.flatTime, self.flatDistance, self.descendTime, self.descendDistance, @"self.kcal", self.isShared, self.hotLevel, self.imageList, self.userObjectId, self.cyclingStartTime, self.cyclingEndTime];
}

@end
