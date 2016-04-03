//
//  ACUserModel.m
//  A-cyclist
//
//  Created by tunny on 15/7/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACUserModel.h"
#import <BmobSDK/Bmob.h>
#import "ACUtility.h"

@implementation ACUserModel

+ (instancetype)userWithBmobUser:(BmobUser *)user
{
    ACUserModel *ACUser = [[ACUserModel alloc] init];
    ACUser.className = user.className;
    ACUser.username = user.username;
    ACUser.email = user.email;
    ACUser.mobilePhoneNumber = user.mobilePhoneNumber;
    ACUser.objectId = user.objectId;
    ACUser.createdAt = user.createdAt;
    ACUser.updatedAt = user.updatedAt;
    ACUser.emailVerified = [[user objectForKey:@"emailVerified"] boolValue];
    ACUser.location = [user objectForKey:@"location"];
    ACUser.signature = [user objectForKey:@"signature"];
    ACUser.weight = [user objectForKey:@"weight"];
    ACUser.profile_image_url = [user objectForKey:@"profile_image_url"];
    ACUser.avatar_large = [user objectForKey:@"avatar_large"];
    ACUser.gender = [user objectForKey:@"gender"];
    ACUser.accruedTime = [user objectForKey:@"accruedTime"];
    ACUser.accruedDistance = [user objectForKey:@"accruedDistance"];
    
    return ACUser;
}

/**
 *  归档
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.signature forKey:@"signature"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.weight forKey:@"weight"];
    [aCoder encodeObject:self.profile_image_url forKey:@"profile_image_url"];
    [aCoder encodeObject:self.avatar_large forKey:@"avatar_large"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.objectId forKey:@"objectId"];
    [aCoder encodeObject:self.accruedTime forKey:@"accruedTime"];
    [aCoder encodeObject:self.accruedDistance forKey:@"accruedDistance"];
}

/**
 *  解档
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.signature = [aDecoder decodeObjectForKey:@"signature"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.weight = [aDecoder decodeObjectForKey:@"weight"];
        self.profile_image_url = [aDecoder decodeObjectForKey:@"profile_image_url"];
        self.avatar_large = [aDecoder decodeObjectForKey:@"avatar_large"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.objectId = [aDecoder decodeObjectForKey:@"objectId"];
        self.accruedTime = [aDecoder decodeObjectForKey:@"accruedTime"];
        self.accruedDistance = [aDecoder decodeObjectForKey:@"accruedDistance"];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%p : %@>{\n className = %@;\n username = %@;\n signature = %@;\n password = %@;\n mobilePhoneNumber = %@;\n email = %@;\n location = %@;\n weight = %@;\n gender = %@;\n profile_image_url = %@;\n avatar_large = %@;\n objectId = %@;\n createdAt = %@;\n updatedAt = %@;\n emailVerified = %d;\n accruedTime = %@;\n accruedDistance = %@\n}", self, self.class, self.className, self.username, self.signature, self.password, self.mobilePhoneNumber, self.email, self.location, self.weight, self.gender, self.profile_image_url, self.avatar_large, self.objectId, self.createdAt, self.updatedAt, self.emailVerified, self.accruedTime, self.accruedDistance];
}
@end
