//
//  ATIsNullVerifier.h
//  
//
//  Created by JohnnyB0Y on 2017/6/19.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  判断是否空值验证器

#import "AGBaseVerifier.h"

@interface ATIsNullVerifier : AGBaseVerifier
<AGVerifyManagerVerifiable>

/** 要判断的对象 */
@property (nonatomic, strong) id verifierObj;

/** 空值错误信息 */
@property (nonatomic, copy) NSString *nullMsg;

@end
