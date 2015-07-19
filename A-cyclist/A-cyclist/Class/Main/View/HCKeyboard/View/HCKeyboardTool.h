//
//  HMKeyboardTool.h
//  作业-注册
//
//  Created by Vincent_Guo on 14-8-27.
//  Copyright (c) 2014年 vgios. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KeyboardItemTypePrevious,//上一个
    KeyboardItemTypeNext,//下一个
    KeyboardItemTypeDone//完成
}KeyboardItemType;

@class HCKeyboardTool;

@protocol HCKeyboardToolDelegate <NSObject>

- (void)keyboardTool:(HCKeyboardTool *)keyboardTool didClickItemType:(KeyboardItemType)itemType;

@end

@interface HCKeyboardTool : UIView

//添加代理
@property(nonatomic,weak) id<HCKeyboardToolDelegate> delgate;

+ (instancetype)keyboardTool;

@end
