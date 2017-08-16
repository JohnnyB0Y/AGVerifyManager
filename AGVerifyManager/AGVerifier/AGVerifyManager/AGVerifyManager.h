//
//  AGVerifyManager.h
//  Architecture
//
//  Created by JohnnyB0Y on 2017/6/3.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AGVerifyError, AGVerifyManager;
@protocol AGVerifyManagerVerifiable, AGVerifyManagerInjectVerifiable;
typedef void(^AGVerifyManagerVerifiedBlock)(AGVerifyError *firstError,
                                            NSArray<AGVerifyError *> *errors);

// 快捷构建方法
AGVerifyManager * ag_verifyManager();

#pragma mark - AGVerifyManager
@interface AGVerifyManager : NSObject

/** 验证数据，数据由验证器携带 */
- (AGVerifyManager * (^)(id<AGVerifyManagerVerifiable> verifier)) verify;


/** 验证数据，数据直接参数传入 */
- (AGVerifyManager * (^)(id<AGVerifyManagerInjectVerifiable> verifier, id obj)) verifyObj;


/** 验证完调用 (无循环引用问题) */
- (void) verified:(AGVerifyManagerVerifiedBlock)verifiedBlock;

@end


#pragma mark - AGVerifyManagerVerifiable
@protocol AGVerifyManagerVerifiable <NSObject>

/** 验证数据，数据由验证器携带 */
- (AGVerifyError *) verify;

@end


#pragma mark - AGVerifyManagerInjectVerifiable
@protocol AGVerifyManagerInjectVerifiable <NSObject>

/** 验证数据，数据直接参数传入 */
- (AGVerifyError *) verifyObj:(id)obj;

@end


#pragma mark - AGVerifyError
@interface AGVerifyError : NSObject

/** 错误信息 */
@property (nonatomic, copy) NSString *msg;

/** 错误代码 */
@property (nonatomic, assign) NSInteger code;

/** 打包的错误信息 */
@property (nonatomic, copy) NSDictionary *userInfo;

@end
