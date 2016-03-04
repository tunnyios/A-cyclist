//
//  ACSettingProfileInfoViewController.h
//  A-cyclist
//
//  Created by tunny on 15/7/20.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACBaseTableViewController.h"

typedef enum : NSUInteger {
    PushFromTypeOther,
    PushFromTypeLogin,
} PushFromType;

@interface ACSettingProfileInfoViewController : ACBaseTableViewController
/** pushFrom */
@property (nonatomic, assign) PushFromType pushFromType;

@end
