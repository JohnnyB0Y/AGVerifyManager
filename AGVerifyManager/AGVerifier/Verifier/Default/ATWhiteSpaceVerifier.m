//
//  ATWhiteSpaceVerifier.m
//  AGVerifyManager
//
//  Created by JohnnyB0Y on 2017/11/28.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "ATWhiteSpaceVerifier.h"

@implementation ATWhiteSpaceVerifier

- (AGVerifyError *)ag_verifyObj:(NSString *)obj
{
	AGVerifyError *error = [AGVerifyError new];
	if ( obj && ![obj isKindOfClass:[NSString class]] ) {
		error.code = 400;
		error.msg = @"输入内容格式错误！";
		return error;
	}
	
	NSRange range = [obj rangeOfString:@" "];
	if (range.location != NSNotFound) {
		//有空格
		error.code = 401;
		error.msg = @"文字包含空格！";
	} else {
		//没有空格
		error = nil;
	}
	
	return error;
}

@end
