//
//  ACUserModel.m
//  A-cyclist
//
//  Created by tunny on 15/7/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACUserModel.h"
#import <BmobSDK/Bmob.h>

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
    ACUser.emailVerified = [user objectForKey:@"emailVerified"];
    ACUser.location = [user objectForKey:@"location"];
    ACUser.profile_image_url = [user objectForKey:@"profile_image_url"];
    ACUser.avatar_large = [user objectForKey:@"avatar_large"];
    ACUser.gender = [user objectForKey:@"gender"];
    
    return ACUser;
}

/**
 *  归档
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.profile_image_url forKey:@"profile_image_url"];
    [aCoder encodeObject:self.avatar_large forKey:@"avatar_large"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.objectId forKey:@"objectId"];
}

/**
 *  解档
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.profile_image_url = [aDecoder decodeObjectForKey:@"profile_image_url"];
        self.avatar_large = [aDecoder decodeObjectForKey:@"avatar_large"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.objectId = [aDecoder decodeObjectForKey:@"objectId"];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%p : %@>{\n className = %@;\n username = %@;\n password = %@;\n mobilePhoneNumber = %@;\n email = %@;\n location = %@;\n gender = %@;\n profile_image_url = %@;\n avatar_large = %@;\n objectId = %@;\n createdAt = %@;\n updatedAt = %@;\n emailVerified = %d;\n}", self, self.class, self.className, self.username, self.password, self.mobilePhoneNumber, self.email, self.location, self.gender, self.profile_image_url, self.avatar_large, self.objectId, self.createdAt, self.updatedAt, self.emailVerified];
}
@end