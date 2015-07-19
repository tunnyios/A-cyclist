//
//  HCKeyboardTool.m
//  作业-注册
//
//  Created by Vincent_Guo on 14-8-27.
//  Copyright (c) 2014年 vgios. All rights reserved.
//

#import "HCKeyboardTool.h"

@interface HCKeyboardTool()

- (IBAction)previous:(id)sender;

- (IBAction)next:(id)sender;
- (IBAction)done:(id)sender;

@end

@implementation HCKeyboardTool

+(instancetype)keyboardTool{
    return [[[NSBundle mainBundle] loadNibNamed:@"HCKeyboardTool" owner:nil options:nil] lastObject];
}

//上一个
- (IBAction)previous:(id)sender {
    
    //判断代理有没有实现相应的方法
    if ([self.delgate respondsToSelector:@selector(keyboardTool:didClickItemType:)]) {
        [self.delgate keyboardTool:self didClickItemType:KeyboardItemTypePrevious];
    }
}


//下一个
- (IBAction)next:(id)sender {
    //判断代理有没有实现相应的方法
    if ([self.delgate respondsToSelector:@selector(keyboardTool:didClickItemType:)]) {
        [self.delgate keyboardTool:self didClickItemType:KeyboardItemTypeNext];
    }
    
}

//完成
- (IBAction)done:(id)sender {
    
    //判断代理有没有实现相应的方法
    if ([self.delgate respondsToSelector:@selector(keyboardTool:didClickItemType:)]) {
        [self.delgate keyboardTool:self didClickItemType:KeyboardItemTypeDone];
    }
}
@end
