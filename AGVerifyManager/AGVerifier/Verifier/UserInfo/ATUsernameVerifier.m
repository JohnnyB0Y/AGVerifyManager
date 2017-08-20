//
//  ATUsernameVerifier.m
//  
//
//  Created by JohnnyB0Y on 2017/6/3.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "ATUsernameVerifier.h"

@implementation ATUsernameVerifier

- (AGVerifyError *)verify
{
    AGVerifyError *error;
    if ( self.verifyString.length == 0 ) {
        error = [AGVerifyError new];
        error.code = 20001;
        error.msg = @"用户名不能为空！";
    }
    else if ( self.verifyString.length > 10 ) {
        error = [AGVerifyError new];
        error.code = 20002;
        error.msg = @"用户名不能超过10个字符！";
    }
    
    return error;
}

@end
