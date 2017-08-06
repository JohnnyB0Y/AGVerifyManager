//
//  AGVerifyManager.m
//  Architecture
//
//  Created by JohnnyB0Y on 2017/6/3.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGVerifyManager.h"

AGVerifyManager * ag_verifyManager()
{
    return [AGVerifyManager new];
}

@interface AGVerifyManager ()

/** first error */
@property (nonatomic, strong) AGVerifyError *firstError;

/** 是否出错 */
@property (nonatomic, assign) BOOL isError;

/** 错误数组 */
@property (nonatomic, strong) NSMutableArray<AGVerifyError *> *errorsM;

@end

@implementation AGVerifyManager
#pragma mark - ---------- Public Methods ----------
- (AGVerifyManager *(^)(id<AGVerifyManagerVerifiable>))verify
{
    return ^AGVerifyManager *(id<AGVerifyManagerVerifiable> verifier) {
        // 判断错误
        AGVerifyError *error = verifier.verify;
        
        if (error) {
            // 有错
            _isError = YES;
            
            if ( ! self->_firstError ) {
                self->_firstError = error;
            }
            // 打包错误
            [self.errorsM addObject:error];
            
        }
        
        return self;
    };
}

- (void)verified:(AGVerifyManagerVerifiedBlock)verifiedBlock
{
    if ( verifiedBlock ) {
        verifiedBlock(self.firstError, [self.errorsM copy]);
    }
    
    self.firstError = nil;
    self.errorsM = nil;
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
@end
