//
//  ATEmojiVerifier.m
//  AGVerifyManager
//
//  Created by JohnnyB0Y on 2017/8/6.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "ATEmojiVerifier.h"

@implementation ATEmojiVerifier

- (AGVerifyError *)verify
{
    AGVerifyError *error;
    if (  [self isContainsEmoji:self.verifyString] ) {
        error = [AGVerifyError new];
        error.msg = self.errorMsg ? self.errorMsg : @"输入不能包含表情字符！";
    }
    
    return error;
}

@end
