//
//  ATUsernameVerifier.m
//  
//
//  Created by JohnnyB0Y on 2017/6/3.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "ATUsernameVerifier.h"

@implementation ATUsernameVerifier

- (AGVerifyError *)ag_verifyObj:(NSString *)obj
{
	AGVerifyError *error = [AGVerifyError new];
	if ( obj && ![obj isKindOfClass:[NSString class]] ) {
		error.code = 400;
		error.msg = @"输入内容格式错误！";
		return error;
	}
	
	if ( obj.length == 0 ) {
		error.code = 20001;
		error.msg = @"用户名不能为空！";
	}
	else if ( obj.length > 10 ) {
		error.code = 20002;
		error.msg = @"用户名不能超过10个字符！";
	}
	else {
		error = nil;
	}
	
	return error;
}

@end
