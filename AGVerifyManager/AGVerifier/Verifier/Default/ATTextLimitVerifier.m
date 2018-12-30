//
//  ATTextLimitVerifier.m
//  
//
//  Created by JohnnyB0Y on 2017/6/19.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  文字限制验证器

#import "ATTextLimitVerifier.h"
#import <AGCategories/NSString+AGJudge.h>

@implementation ATTextLimitVerifier

- (AGVerifyError *)ag_verifyObj:(id)obj
{
    AGVerifyError *error;
    NSString *verifyString = obj;
    NSUInteger strLen = [verifyString ag_lengthOfCharacter];
    if ( strLen < self.minLimit ) {
        // 字数过少
        error = [AGVerifyError new];
        error.code = 3301;
        error.msg = self.minLimitMsg ?: [NSString stringWithFormat:@"字数不能少于%@字！", @(self.minLimit)];
    }
    else if ( strLen > self.maxLimit ) {
        // 字数超出
        error = [AGVerifyError new];
        error.code = 3302;
        error.msg = self.maxLimitMsg ?: [NSString stringWithFormat:@"字数不能超过%@字！", @(self.maxLimit)];
    }
    
    return error;
}

@end
