//
//  AGBaseVerifier.m
//
//
//  Created by JohnnyB0Y on 2017/6/19.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGBaseVerifier.h"

@implementation AGBaseVerifier

#pragma mark - Base Verifier Methods
- (BOOL) minText:(NSString *)text limit:(NSUInteger)length
{
    return ! [self validText:text characterLength:length];
}

- (BOOL) maxText:(NSString *)text limit:(NSUInteger)length
{
    return [self validText:text characterLength:length+1];
}

#pragma mark 判断字符串除空格和回车后，有效的字符数
- (BOOL) validText:(NSString *)text characterLength:(NSInteger)length
{
    if ( text == nil || text.length < length ) return NO;
    
    BOOL isEmpty = NO;
    NSCharacterSet *set
    = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString
    = [text stringByTrimmingCharactersInSet:set];
    
    if ([trimedString length] >= length) {
        isEmpty = YES;
    }
    
    return isEmpty;
}

#pragma mark 字符串是否包含emoji
- (BOOL) isContainsEmoji:(NSString *)string
{
    __block BOOL isEomji = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1fbd0) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3 || ls == 0xfe0f) {
                 isEomji = YES;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
         
     }];
    
    return isEomji;
}

@end
