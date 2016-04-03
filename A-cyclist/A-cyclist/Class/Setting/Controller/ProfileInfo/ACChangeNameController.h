//
//  ACChangeNameController.h
//  A-cyclist
//
//  Created by tunny on 15/7/21.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACBaseViewController.h"

typedef enum : NSUInteger {
    ChangeTextPushFromName, //来自修改昵称
    ChangeTextPushFromDesc, //来自修改签名
} ChangeTextPushFrom;

@protocol ACChangeNameDelegate <NSObject>

@optional
- (void)changeNameWith:(NSString *)name withType:(ChangeTextPushFrom)pushForm;

@end

@interface ACChangeNameController : ACBaseViewController
/** 传入文本 */
@property (nonatomic, copy) NSString *defaultText;
/** 来源 */
@property (nonatomic, assign) ChangeTextPushFrom pushFrom;
@property (nonatomic, weak) id<ACChangeNameDelegate> delegate;
@end
