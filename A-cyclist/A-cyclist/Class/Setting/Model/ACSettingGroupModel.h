//
//  ACSettingGroupModel.h
//  A-cyclist
//
//  Created by tunny on 15/7/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class ACSettingCellModel;
@interface ACSettingGroupModel : NSObject
/** header */
@property (nonatomic, copy) NSString *headerText;
/** footer */
@property (nonatomic, copy) NSString *footerText;
/** cell模型数组 */
@property (nonatomic, strong) NSArray *cellList;
@end
