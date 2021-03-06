//
//  ATEnglishVerifier.m
//  AGVerifyManager
//
//  Created by JohnnyB0Y on 2018/12/31.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import "ATEnglishVerifier.h"
#import <AGCategories/NSString+AGJudge.h>

@implementation ATEnglishVerifier

- (AGVerifyError *)ag_verifyData:(id)data
{
    if ( [data isKindOfClass:[NSString class]] ) {
        NSString *string = (NSString *)data;
        if ( [string ag_containsEnglishCharacter] ) {
            self.error.msg = @"输入不能包含英文字符！";
        }
    }
    else {
        self.error.msg = @"类型错误";
    }
    
    return [super ag_verifyData:data];
}

@end
