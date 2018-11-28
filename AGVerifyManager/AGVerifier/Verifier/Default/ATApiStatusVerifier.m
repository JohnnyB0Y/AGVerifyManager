//
//  ATApiStatusVerifier.m
//  
//
//  Created by JohnnyB0Y on 2017/6/14.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  api status 验证器

#import "ATApiStatusVerifier.h"

@implementation ATApiStatusVerifier

- (AGVerifyError *)ag_verifyObj:(id)obj
{
    NSInteger status = [obj integerValue];
    AGVerifyError *error;
    if ( status == 0 ) {
        error = [AGVerifyError new];
        error.code = status;
        error.msg = @"请求失败！";
    }
    
    return error;
}

@end
