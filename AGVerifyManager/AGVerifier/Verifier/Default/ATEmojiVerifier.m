//
//  ATEmojiVerifier.m
//  AGVerifyManager
//
//  Created by JohnnyB0Y on 2017/8/6.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "ATEmojiVerifier.h"

@implementation ATEmojiVerifier

- (AGVerifyError *)ag_verifyObj:(id)obj
{
    AGVerifyError *error;
    if ( [obj isKindOfClass:[NSString class]] ) {
        if ( [self isContainsEmoji:(NSString *)obj] ) {
            error = [AGVerifyError new];
            error.msg = self.errorMsg ?: @"输入不能包含表情字符！";
        }
    }
    else {
        error = [AGVerifyError new];
        error.msg = @"类型错误";
    }
    
    return error;
}

@end
