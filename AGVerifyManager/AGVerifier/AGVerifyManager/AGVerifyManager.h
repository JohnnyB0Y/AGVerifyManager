//
//  AGVerifyManager.h
//  Architecture
//
//  Created by JohnnyB0Y on 2017/6/3.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  GitHub: https://github.com/JohnnyB0Y/AGVerifyManager
//  简书:    http://www.jianshu.com/p/c1e49fcd4a15

#import <Foundation/Foundation.h>
@class AGVerifyError, AGVerifyManager;
@protocol AGVerifyManagerVerifiable, AGVerifyManagerVerifying;

NS_ASSUME_NONNULL_BEGIN

typedef void(^AGVerifyManagerVerifyingBlock)(id<AGVerifyManagerVerifying> start);

typedef void(^AGVerifyManagerCompletionBlock)(AGVerifyError * _Nullable firstError,
                                              NSArray<AGVerifyError *> * _Nullable errors);

typedef id<AGVerifyManagerVerifying> _Nonnull (^AGVerifyManagerVerifyObjBlock)(id<AGVerifyManagerVerifiable> verifier,
                                                                               id obj);

typedef id<AGVerifyManagerVerifying> _Nonnull (^AGVerifyManagerVerifyObjMsgBlock)(id<AGVerifyManagerVerifiable> verifier,
                                                                                  id obj,
                                                                                  NSString * _Nullable msg);


@interface AGVerifyManager : NSObject

#pragma mark 直接执行验证Block，不保留Block引用。
- (void) ag_executeVerifying:(NS_NOESCAPE AGVerifyManagerVerifyingBlock)verifyingBlock
                  completion:(NS_NOESCAPE AGVerifyManagerCompletionBlock)completionBlock;


#pragma mark 添加验证Block。
- (void) ag_addVerifyForKey:(NSString *)key
                  verifying:(AGVerifyManagerVerifyingBlock)verifyingBlock
                 completion:(AGVerifyManagerCompletionBlock)completionBlock;

#pragma mark 移除验证Block。
- (void) ag_removeVerifyBlockForKey:(NSString *)key;
- (void) ag_removeAllVerifyBlocks;

#pragma mark 执行验证Block。
- (void) ag_executeVerifyBlockForKey:(NSString *)key;
- (void) ag_executeAllVerifyBlocks;

/** 多线程执行验证Block，verifyingBlock 在其他线程下执行；completionBlock 回到主线程执行。*/
- (void) ag_executeVerifyBlockInBackgroundForKey:(NSString *)key;
- (void) ag_executeAllVerifyBlocksInBackground;

@end


#pragma mark - AGVerifyManagerVerifying
@protocol AGVerifyManagerVerifying <NSObject>

/** 验证数据，直接传入验证器、数据 */
@property (nonatomic, copy, readonly) AGVerifyManagerVerifyObjBlock verifyObj;

/** 验证数据，直接传入验证器、数据、错误提示信息 */
@property (nonatomic, copy, readonly) AGVerifyManagerVerifyObjMsgBlock verifyObjMsg;

@end


#pragma mark - AGVerifyManagerVerifiable
@protocol AGVerifyManagerVerifiable <NSObject>

/** 验证数据，数据直接参数传入 */
- (nullable AGVerifyError *) ag_verifyObj:(id)obj;

@end


#pragma mark - AGVerifyError
@interface AGVerifyError : NSObject

/** 错误信息 */
@property (nonatomic, copy, nullable) NSString *msg;

/** 打包的错误信息 */
@property (nonatomic, copy, nullable) NSDictionary *userInfo;

/** 错误代码 */
@property (nonatomic, assign) NSInteger code;

/** 被验证的对象 （传递出去，可以做特殊业务） */
@property (nonatomic, strong, nullable) id verifyObj;

@end


// 快捷构建方法
AGVerifyManager * ag_newAGVerifyManager(void);

NS_ASSUME_NONNULL_END
