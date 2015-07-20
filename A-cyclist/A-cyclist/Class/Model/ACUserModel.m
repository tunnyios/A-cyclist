//
//  ACUserModel.m
//  A-cyclist
//
//  Created by tunny on 15/7/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACUserModel.h"

@implementation ACUserModel

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%p : %@>{\n className = %@;\n username = %@;\n mobilePhoneNumber = %@;\n email = %@;\n objectId = %@;\n createdAt = %@;\n updatedAt = %@;\n emailVerified = %d;\n}", self, self.class, self.className, self.username, self.mobilePhoneNumber, self.email, self.objectId, self.createdAt, self.updatedAt, self.emailVerified];
}
@end
