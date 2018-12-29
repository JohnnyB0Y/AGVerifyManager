//
//  AGBaseVerifier.h
//  
//
//  Created by JohnnyB0Y on 2017/6/19.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGVerifyManager.h"

@interface AGBaseVerifier : NSObject

/** 错误信息 */
@property (nonatomic, copy) NSString *errorMsg;

#pragma mark - Base Verifier Methods
/** text 字符数 少于 length */
- (BOOL) minText:(NSString *)text limit:(NSUInteger)length;
/** text 字符数 多于 length */
- (BOOL) maxText:(NSString *)text limit:(NSUInteger)length;
/** 字符串是否包含 emoji */
- (BOOL) isContainsEmoji:(NSString *)string;

@end



