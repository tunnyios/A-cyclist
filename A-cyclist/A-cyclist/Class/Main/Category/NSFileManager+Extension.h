//
//  NSFileManager+Extension.h
//  A-cyclist
//
//  Created by tunny on 15/8/15.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Extension)

/** 清理缓存 */
+ (void)clearCache:(NSString *)path;

/** 计算文件的大小(单位M) */
+ (float)fileSizeAtPath:(NSString *)path;

/** 计算目录的大小(单位M) */
+ (float)folderSizeAtPath:(NSString *)path;
@end
