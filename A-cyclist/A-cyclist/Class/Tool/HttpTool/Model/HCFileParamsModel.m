//
//  HCFileParamsModel.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/29.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCFileParamsModel.h"

@implementation HCFileParamsModel


+ (instancetype)fileParamsModelWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType
{
    if (data && name && fileName) {
        HCFileParamsModel *model = [[HCFileParamsModel alloc] init];
        model.data = data;
        model.name = name;
        model.fileName = fileName;
        model.mimeType = mimeType;
        
        return model;
    } else {
        return nil;
    }
}

+ (instancetype)fileParamsModelWithURL:(NSURL *)url name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType
{
    if (url && name && fileName) {
        HCFileParamsModel *model = [[HCFileParamsModel alloc] init];
        model.url = url;
        model.name = name;
        model.fileName = fileName;
        model.mimeType = mimeType;
        
        return model;
    } else {
        return nil;
    }
}
@end
