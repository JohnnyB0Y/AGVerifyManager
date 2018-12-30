//
//  AGVerifyManager.m
//  Architecture
//
//  Created by JohnnyB0Y on 2017/6/3.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGVerifyManager.h"
#import <objc/runtime.h>

static NSString * const kAGVerifyManagerVerifyingBlock = @"kAGVerifyManagerVerifyingBlock";
static NSString * const kAGVerifyManagerCompletionBlock = @"kAGVerifyManagerCompletionBlock";

@interface AGVerifyManager ()
<AGVerifyManagerVerifying>

/** first error */
@property (nonatomic, strong) AGVerifyError *firstError;

/** 错误数组 */
@property (nonatomic, strong) NSMutableArray<AGVerifyError *> *errorsM;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary *> *executeDictM;

/** lock */
@property (nonatomic, strong) NSLock *lock;

@end

@implementation AGVerifyManager

- (instancetype)init
{
    self = [super init];
    if ( ! self ) return nil;
    
    _lock = [NSLock new];
    _executeDictM = [NSMutableDictionary dictionaryWithCapacity:5];
    
    return self;
}

#pragma mark - ---------- AGVerifyManagerVerifying ----------
- (AGVerifyManagerVerifyObjBlock)verifyObj
{
	return ^AGVerifyManager *(id<AGVerifyManagerVerifiable> verifier, id obj) {
		// 判断错误
		AGVerifyError *error;
		if ( [verifier respondsToSelector:@selector(ag_verifyObj:)] )
			error = [verifier ag_verifyObj:obj];
		
		if ( error ) {
			// 有错
			self.firstError = self.firstError ?: error;
			
			// 打包错误
			[self.errorsM addObject:error];
		}
		return self;
	};
}

- (AGVerifyManagerVerifyObjMsgBlock)verifyObjMsg
{
	return ^AGVerifyManager *(id<AGVerifyManagerVerifiable> verifier, id obj, NSString *msg) {
		// 判断错误
		AGVerifyError *error;
		if ( [verifier respondsToSelector:@selector(ag_verifyObj:)] )
			error = [verifier ag_verifyObj:obj];
		
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

#pragma mark - ---------- Public Methods ----------
- (void)ag_executeVerifying:(NS_NOESCAPE AGVerifyManagerVerifyingBlock)verifyingBlock
                 completion:(NS_NOESCAPE AGVerifyManagerCompletionBlock)completionBlock
{
    AGVerifyManager *manager = [NSThread isMainThread] ? self : ag_newAGVerifyManager();
    [AGVerifyManager performVerifyManager:manager verifying:verifyingBlock completion:completionBlock];
}

- (void)ag_addVerifyForKey:(NSString *)key
                 verifying:(AGVerifyManagerVerifyingBlock)verifyingBlock
                completion:(AGVerifyManagerCompletionBlock)completionBlock
{
    NSParameterAssert(key);
    NSParameterAssert(verifyingBlock);
    NSParameterAssert(completionBlock);
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:2];
    dictM[kAGVerifyManagerVerifyingBlock] = [verifyingBlock copy];
    dictM[kAGVerifyManagerCompletionBlock] = [completionBlock copy];
    
    [self.lock lock];
    [self.executeDictM setObject:dictM forKey:key];
    [self.lock unlock];
}

- (void)ag_removeVerifyBlockForKey:(NSString *)key
{
    NSParameterAssert(key);
    [self.lock lock];
    [self.executeDictM removeObjectForKey:key];
    [self.lock unlock];
}

- (void)ag_removeAllVerifyBlocks
{
    [self.lock lock];
    [self.executeDictM removeAllObjects];
    [self.lock unlock];
}

- (void)ag_executeVerifyBlockForKey:(NSString *)key
{
    NSParameterAssert(key);
    NSMutableDictionary *dictM = [self.executeDictM objectForKey:key];
    AGVerifyManagerVerifyingBlock verifyingBlock = dictM[kAGVerifyManagerVerifyingBlock];
    AGVerifyManagerCompletionBlock completionBlock = dictM[kAGVerifyManagerCompletionBlock];
    
    AGVerifyManager *manager = [NSThread isMainThread] ? self : ag_newAGVerifyManager();
    [AGVerifyManager performVerifyManager:manager verifying:verifyingBlock completion:completionBlock];
}

- (void) ag_executeAllVerifyBlocks
{
    for (NSString *key in self.executeDictM.allKeys) {
        [self ag_executeVerifyBlockForKey:key];
    }
}

- (void) ag_executeVerifyBlockInBackgroundForKey:(NSString *)key
{
    NSParameterAssert(key);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            [self ag_executeVerifyBlockForKey:key];
        }
    });
}

- (void) ag_executeAllVerifyBlocksInBackground
{
    for (NSString *key in self.executeDictM.allKeys) {
        [self ag_executeVerifyBlockInBackgroundForKey:key];
    }
}

#pragma mark - ---------- Private Methods ----------
+ (void) performVerifyManager:(AGVerifyManager *)manager
                    verifying:(NS_NOESCAPE AGVerifyManagerVerifyingBlock)verifyingBlock
                   completion:(NS_NOESCAPE AGVerifyManagerCompletionBlock)completionBlock
{
    manager->_firstError = nil;
    [manager->_errorsM removeAllObjects];
    
    verifyingBlock ? verifyingBlock(manager) : nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        completionBlock ? completionBlock(manager->_firstError, manager->_errorsM) : nil;
    });
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

AGVerifyManager * ag_newAGVerifyManager(void)
{
    return [AGVerifyManager new];
}
