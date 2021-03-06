//
//  ATNumberVerifier.m
//  AGVerifyManager
//
//  Created by JohnnyB0Y on 2018/12/31.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import "ATNumberVerifier.h"
#import <AGCategories/NSString+AGJudge.h>

@implementation ATNumberVerifier

- (AGVerifyError *)ag_verifyData:(id)data
{
    AGVerifyError *error;
    if ( [data isKindOfClass:[NSString class]] ) {
        NSString *string = (NSString *)data;
        if ( [string ag_containsNumberCharacter] ) {
            error = AGVerifyError.defaultInstance.setMsg(@"输入不能包含数字字符！");
        }
    }
    else {
        error = AGVerifyError.defaultInstance.setMsg(@"类型错误");
    }
    
    return error;
}

@end
