//
//  ATEmojiVerifier.m
//  AGVerifyManager
//
//  Created by JohnnyB0Y on 2017/8/6.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "ATEmojiVerifier.h"
#import <AGCategories/NSString+AGJudge.h>

@implementation ATEmojiVerifier

- (AGVerifyError *)ag_verifyObj:(id)obj
{
    AGVerifyError *error;
    if ( [obj isKindOfClass:[NSString class]] ) {
        NSString *string = (NSString *)obj;
        if ( [string ag_containsEmojiCharacter] ) {
            error = [AGVerifyError new];
            error.msg = @"输入不能包含表情字符！";
        }
    }
    else {
        error = [AGVerifyError new];
        error.msg = @"类型错误";
    }
    
    return error;
}

@end
