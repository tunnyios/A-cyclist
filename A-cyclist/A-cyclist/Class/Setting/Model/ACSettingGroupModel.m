//
//  ACSettingGroupModel.m
//  A-cyclist
//
//  Created by tunny on 15/7/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACSettingGroupModel.h"

@implementation ACSettingGroupModel
- (NSMutableArray *)cellList
{
    if (_cellList == nil) {
        _cellList = [NSMutableArray array];
    }
    
    return _cellList;
}
@end
