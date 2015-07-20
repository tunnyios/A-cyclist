//
//  HCFileParamsModel.h
//  HCSinaWeibo
//
//  Created by tunny on 15/6/29.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCFileParamsModel : NSObject
/** 需要上传的文件的URL路径 */
@property (nonatomic, copy) NSURL *url;
/** 需要上传的文件的具体数据NSData */
@property (nonatomic, strong) NSData *data;
/** 服务器那边接收文件用的参数名 */
@property (nonatomic, copy) NSString *name;
/** （告诉服务器）所上传文件的文件名 */
@property (nonatomic, copy) NSString *fileName;
/** 所上传文件的文件类型 */
@property (nonatomic, copy) NSString *mimeType;


+ (instancetype)fileParamsModelWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

+ (instancetype)fileParamsModelWithURL:(NSURL *)url name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

@end
