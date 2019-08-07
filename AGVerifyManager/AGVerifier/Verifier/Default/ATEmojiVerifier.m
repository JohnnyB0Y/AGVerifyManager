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

- (AGVerifyError *)ag_verifyData:(id)data
{
    if ( [data isKindOfClass:[NSString class]] ) {
        NSString *string = (NSString *)data;
        if ( [string ag_containsEmojiCharacter] ) {
            self.error.msg = @"输入不能包含表情字符！";
        }
    }
    else {
        self.error.msg = @"类型错误";
    }
    
    return [super ag_verifyData:data];
}

@end
