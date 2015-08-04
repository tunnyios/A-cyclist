//
//  ACStep.m
//  A-cyclist
//
//  Created by tunny on 15/7/29.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACStepModel.h"

@implementation ACStepModel

+ (instancetype)stepModelWithLatitude:(NSString *)latitude longitude:(NSString *)longtitude altitude:(NSString *)altitude currentSpeed:(NSString *)currentSpeed distanceInterval:(NSString *)distanceInterval
{
    ACStepModel *step = [[ACStepModel alloc] init];
    step.latitude = latitude;
    step.longitude = longtitude;
    step.altitude = altitude;
    step.currentSpeed = currentSpeed;
    step.distanceInterval = distanceInterval;
    
    return step;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
    [aCoder encodeObject:self.longitude forKey:@"longitude"];
    [aCoder encodeObject:self.altitude forKey:@"altitude"];
    [aCoder encodeObject:self.currentSpeed forKey:@"currentSpeed"];
    [aCoder encodeObject:self.distanceInterval forKey:@"distanceInterval"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
        self.longitude = [aDecoder decodeObjectForKey:@"longitude"];
        self.altitude = [aDecoder decodeObjectForKey:@"altitude"];
        self.currentSpeed = [aDecoder decodeObjectForKey:@"currentSpeed"];
        self.distanceInterval = [aDecoder decodeObjectForKey:@"distanceInterval"];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{\n latitude = %@,\n longitude = %@,\n altitude = %@\n, currentSpeed = %@\n, distanceInterval = %@}", self.latitude, self.longitude, self.altitude, self.currentSpeed, self.distanceInterval];
}
@end
