//
//  ACChangeNameController.h
//  A-cyclist
//
//  Created by tunny on 15/7/21.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ACChangeNameDelegate <NSObject>

@optional
- (void)changeNameWith:(NSString *)name;

@end

@interface ACChangeNameController : UIViewController

@property (nonatomic, weak) id<ACChangeNameDelegate> delegate;
@end
