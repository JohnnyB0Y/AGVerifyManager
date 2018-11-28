//
//  ATApiCodeVerifier.m
//
//
//  Created by JohnnyB0Y on 2017/6/14.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  api code 验证器

#import "ATApiCodeVerifier.h"

@implementation ATApiCodeVerifier

- (AGVerifyError *)ag_verifyObj:(id)obj
{
    NSInteger code = [obj integerValue];
    
    AGVerifyError *error = [AGVerifyError new];
    NSString *msg;
    
    switch (code) {
        case 1: {
            // 操作成功
            error = nil;
            
        } break;
            
        case 0: {
            msg = @"操作失败！";
            
        } break;
            
        case 500: {
            msg = @"服务器发生错误！";
            
        } break;
            
        case 10001: {
            msg = @"验证码发送失败！";
            
        } break;
            
            /** 
             
             中间省略一大段
             
             */
            
        default: {
            msg = @"网络异常，请稍后再试！";
        }
    }
    
    error.msg = msg;
    error.code = code;
    
    return error;
}

@end

