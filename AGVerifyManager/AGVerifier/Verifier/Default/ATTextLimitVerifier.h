//
//  ATTextLimitVerifier.h
//  
//
//  Created by JohnnyB0Y on 2017/6/19.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  文字限制验证器

#import "AGVerifyManager.h"

@interface ATTextLimitVerifier : NSObject
<AGVerifyManagerVerifiable>

/** 最少限制字数 */
@property (nonatomic, assign) NSInteger minLimit;
/** 最多限制字数 */
@property (nonatomic, assign) NSInteger maxLimit;

/** 最少限制字数错误信息 */
@property (nonatomic, copy) NSString *minLimitMsg;
/** 最多限制字数错误信息 */
@property (nonatomic, copy) NSString *maxLimitMsg;

@end
