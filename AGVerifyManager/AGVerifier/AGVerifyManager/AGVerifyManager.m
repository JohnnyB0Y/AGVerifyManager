//
//  AGVerifyManager.m
//  Architecture
//
//  Created by JohnnyB0Y on 2017/6/3.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGVerifyManager.h"
#import <objc/runtime.h>

@interface AGVerifyManager ()

/** first error */
@property (nonatomic, strong) AGVerifyError *firstError;

/** 错误数组 */
@property (nonatomic, strong) NSMutableArray<AGVerifyError *> *errorsM;

@end

@implementation AGVerifyManager
#pragma mark - ---------- Public Methods ----------
- (AGVerifyManagerVerifyBlock)verify
{
    // 无循环引用问题, 此处只是为了解决警告问题。
    __weak typeof(self) weakSelf = self;
    return ^AGVerifyManager *(id<AGVerifyManagerVerifiable> verifier) {
        __strong typeof(weakSelf) self = weakSelf;
        // 判断错误
        AGVerifyError *error;
        if ( [verifier respondsToSelector:@selector(verify)] )
            error = [verifier verify];
        
        if ( error ) {
            // 有错
            self.firstError = self.firstError ?: error;
            
            // 打包错误
            [self.errorsM addObject:error];
        }
        return self;
    };
}

- (AGVerifyManagerVerifyObjBlock)verify_Obj
{
    // 无循环引用问题, 此处只是为了解决警告问题。
    __weak typeof(self) weakSelf = self;
	return ^AGVerifyManager *(id<AGVerifyManagerInjectVerifiable> verifier,
							  id obj) {
        __strong typeof(weakSelf) self = weakSelf;
		// 判断错误
		AGVerifyError *error;
		if ( [verifier respondsToSelector:@selector(verifyObj:)] )
			error = [verifier verifyObj:obj];
		
		if ( error ) {
			// 有错
			self.firstError = self.firstError ?: error;
			
			// 打包错误
			[self.errorsM addObject:error];
		}
		return self;
	};
}

- (AGVerifyManagerVerifyObjMsgBlock)verify_Obj_Msg
{
    // 无循环引用问题, 此处只是为了解决警告问题。
    __weak typeof(self) weakSelf = self;
	return ^AGVerifyManager *(id<AGVerifyManagerInjectVerifiable> verifier,
							  id obj,
							  NSString *msg) {
		__strong typeof(weakSelf) self = weakSelf;
		// 判断错误
		AGVerifyError *error;
		if ( [verifier respondsToSelector:@selector(verifyObj:)] )
			error = [verifier verifyObj:obj];
		
		if ( error ) {
			// 有错
			error.msg = msg ?: error.msg;
			self.firstError = self.firstError ?: error;
			
			// 打包错误
			[self.errorsM addObject:error];
		}
		return self;
		
	};
}

- (AGVerifyManager *)verified:(AGVerifyManagerVerifiedBlock)verifiedBlock
{
    verifiedBlock ? verifiedBlock(self.firstError, [self.errorsM copy]) : nil;
    self.firstError = nil;
    self.errorsM = nil;
    return self;
}

#pragma mark - ----------- Getter Methods ----------
- (NSMutableArray *)errorsM
{
    if (_errorsM == nil) {
        _errorsM = [NSMutableArray arrayWithCapacity:5];
    }
    return _errorsM;
}

@end


#pragma mark -
@implementation AGVerifyError

#pragma mark - ----------- Override Methods ----------
- (NSString *) debugDescription
{
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:count];
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name] ?: @"nil";
        [dictM setObject:value forKey:name];
    }
    
    free(properties);
    
    return [NSString stringWithFormat:@"<%@: %p> -- %@", [self class] , self, dictM];
}

@end

AGVerifyManager * ag_verifyManager(void)
{
    return [AGVerifyManager new];
}

