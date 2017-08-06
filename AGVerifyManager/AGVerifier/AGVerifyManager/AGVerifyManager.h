//
//  AGVerifyManager.h
//  Architecture
//
//  Created by JohnnyB0Y on 2017/6/3.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AGVerifyError, AGVerifyManager;
@protocol AGVerifyManagerVerifiable;
typedef void(^AGVerifyManagerVerifiedBlock)(AGVerifyError *firstError, NSArray<AGVerifyError *> *errors);

// 快捷构建方法
AGVerifyManager * ag_verifyManager();

#pragma mark - AGVerifyManager
@interface AGVerifyManager : NSObject

/** 开始验证 */
- (AGVerifyManager * (^)(id<AGVerifyManagerVerifiable>)) verify;

/** 验证完调用 */
- (void) verified:(AGVerifyManagerVerifiedBlock)verifiedBlock;

@end


#pragma mark - AGVerifyManagerVerifiable
@protocol AGVerifyManagerVerifiable <NSObject>

- (AGVerifyError *) verify;

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
