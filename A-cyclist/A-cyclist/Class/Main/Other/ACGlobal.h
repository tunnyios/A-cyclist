//
//  ACGlobal.h
//  A-cyclist
//
//  Created by tunny on 15/7/13.
//  Copyright (c) 2015年 tunny. All rights reserved.
//


#import <Foundation/Foundation.h>


//const定义



// 宏定义

#ifdef  DEBUG
#define DLog( s, ... ) NSLog( @"<%p %@:(%d) %s> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __func__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

#define ACScreenBounds  [UIScreen mainScreen].bounds

