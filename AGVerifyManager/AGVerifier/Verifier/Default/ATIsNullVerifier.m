//
//  ATIsNullVerifier.m
//  
//
//  Created by JohnnyB0Y on 2017/6/19.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  判断是否空值验证器

#import "ATIsNullVerifier.h"

@implementation ATIsNullVerifier

- (AGVerifyError *)verify
{
    AGVerifyError *error;
    
    if ( ! self.verifierObj ) {
        // 空对象
        error = [AGVerifyError new];
        error.code = 4000;
        error.msg = self.nullMsg ? self.nullMsg : @"数据为空！";
    }
    
    return error;
}

@end
