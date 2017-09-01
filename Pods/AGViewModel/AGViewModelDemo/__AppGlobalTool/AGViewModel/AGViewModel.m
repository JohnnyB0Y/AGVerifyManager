//
//  AGViewModel.m
//  Architecture
//
//  Created by JohnnyB0Y on 2017/4/23.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  视图-模型 绑定

#import "AGViewModel.h"
#import <objc/runtime.h>

#pragma mark - implementation
@implementation AGViewModel {
    AGVMConfigDataBlock _configDataBlock;
    
    struct AGResponeMethods {
        unsigned int ag_callDelegateToDoForInfo         : 1;
        unsigned int ag_callDelegateToDoForViewModel    : 1;
        unsigned int ag_callDelegateToDoForAction       : 1;
    } _responeMethod;
}

#pragma mark - ----------- Life Cycle ----------
+ (instancetype) ag_viewModelWithModel:(NSDictionary *)bindingModel
                              capacity:(NSUInteger)capacity
{
    AGViewModel *vm = [self new];
    vm->_bindingModel = ag_mutableDict(capacity);
    [vm ag_mergeModelFromDictionary:bindingModel];
    return vm;
}

+ (instancetype) ag_viewModelWithModel:(NSDictionary *)bindingModel
{
    AGViewModel *vm = [self new];
    vm->_bindingModel = bindingModel ? [bindingModel mutableCopy] : ag_mutableDict(6);
    return vm;
}

- (void)dealloc
{
    _configDataBlock = nil;
}

#pragma mark - ---------- Public Methods ----------
#pragma mark 设置绑定视图
- (void) ag_setBindingView:(UIView<AGVMIncludable> *)bindingView
{
    [self ag_setBindingView:bindingView configDataBlock:nil];
}

- (void) ag_setBindingView:(UIView<AGVMIncludable> *)bindingView
           configDataBlock:(AGVMConfigDataBlock)configDataBlock
{
    _bindingView        = bindingView;
    _configDataBlock    = configDataBlock;
    
    // 判断 bv 是否实现方法
    if (!_configDataBlock && [bindingView respondsToSelector:@selector(setViewModel:)])
    {
        _configDataBlock = ^( AGViewModel *vm, UIView<AGVMIncludable> *bv, NSMutableDictionary *bm ){
            [bv setViewModel:vm];
        };
    }
}

#pragma mark 设置绑定代理
/** 设置代理 */
- (void) ag_setDelegate:(id<AGVMDelegate>)delegate
           forIndexPath:(NSIndexPath *)indexPath
{
    self.delegate = delegate;
    self.indexPath = indexPath;
}

#pragma mark 绑定视图后，可以让视图做一些事情
/** 获取 bindingView 的 size */
- (CGSize) ag_sizeOfBindingView
{
    return [self ag_sizeOfBindingView:_bindingView];
}

/** 当 bindingView 为空时，直接传进去计算 size */
- (CGSize) ag_sizeOfBindingView:(UIView<AGVMIncludable> *)bv
{
    CGFloat height = [self[kAGVMViewH] floatValue];
    CGFloat width = [self[kAGVMViewW] floatValue];
    CGSize bindingViewS = CGSizeMake(width, height);
    
    if ( [bv respondsToSelector:@selector(ag_viewModel:sizeForBindingView:)] ) {
        bindingViewS = [bv ag_viewModel:self sizeForBindingView:bindingViewS];
        // 记录数据
        self[kAGVMViewW] = @(bindingViewS.width);
        self[kAGVMViewH] = @(bindingViewS.height);
    }
    return bindingViewS;
}

/** bindingView 对 view model 做处理 */
- (void) ag_viewModelProcess
{
    if ( [_bindingView respondsToSelector:@selector(ag_viewModelProcess:)] ) {
        [_bindingView ag_viewModelProcess:self];
    }
}

#pragma mark 辅助方法
- (void)ag_refreshViewByUpdateModelInBlock:(AGVMUpdateModelBlock)block
{
    if ( block ) block( _bindingModel );
    
    if ( _configDataBlock && _bindingView.viewModel == self ) {
        _configDataBlock( self, _bindingView, _bindingModel );
    }
}

/** 合并 bindingModel */
- (void) ag_mergeModelFromViewModel:(AGViewModel *)vm
{
    [self ag_mergeModelFromDictionary:vm.bindingModel];
}

- (void) ag_mergeModelFromDictionary:(NSDictionary *)dict
{
    dict.count > 0 ? [self.bindingModel addEntriesFromDictionary:dict] : nil;
}

#pragma mark - 其他方法
- (void)ag_callDelegateToDoForInfo:(NSDictionary *)info
{
    if ( _responeMethod.ag_callDelegateToDoForInfo ) {
        [_delegate ag_viewModel:self callDelegateToDoForInfo:info];
    }
}

- (void)ag_callDelegateToDoForViewModel:(AGViewModel *)info
{
    if ( _responeMethod.ag_callDelegateToDoForViewModel ) {
        [_delegate ag_viewModel:self callDelegateToDoForViewModel:info];
    }
}

- (void)ag_callDelegateToDoForAction:(SEL)action
{
    if ( _responeMethod.ag_callDelegateToDoForAction ) {
        [_delegate ag_viewModel:self callDelegateToDoForAction:action];
    }
}

#pragma mark - ---------- Private Methods ----------


#pragma mark - ------------ Override Methods --------------
- (id)objectForKeyedSubscript:(NSString *)key;
{
    return key ? _bindingModel[key] : nil;
}

- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key;
{
    if ( ! key || ! obj ) return;
    self.bindingModel[key] = obj;
}

- (NSString *) debugDescription
{
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableDictionary *dictM = ag_mutableDict(count);
    for ( int i = 0; i<count; i++ ) {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name] ?: @"nil";
        [dictM setObject:value forKey:name];
    }
    
    free(properties);
    return [NSString stringWithFormat:@"<%@: %p> -- %@", [self class] , self, dictM];
}

#pragma mark - ----------- Setter Methods ----------
- (void)setDelegate:(id<AGVMDelegate>)delegate
{
    _delegate = delegate;
    
    // 记录代理实现方法
    _responeMethod.ag_callDelegateToDoForInfo
    = [_delegate respondsToSelector:@selector(ag_viewModel:callDelegateToDoForInfo:)];
    
    _responeMethod.ag_callDelegateToDoForViewModel
    = [_delegate respondsToSelector:@selector(ag_viewModel:callDelegateToDoForViewModel:)];
    
    _responeMethod.ag_callDelegateToDoForAction
    = [_delegate respondsToSelector:@selector(ag_viewModel:callDelegateToDoForAction:)];
}

@end



#pragma mark - 快捷函数
/** 快速创建 AGViewModel 实例 */
AGViewModel * ag_viewModel(NSDictionary *bindingModel)
{
    return [AGViewModel ag_viewModelWithModel:bindingModel];
}

/** 快速创建可变字典函数 */
NSMutableDictionary * ag_mutableDict(NSUInteger capacity)
{
    return [NSMutableDictionary dictionaryWithCapacity:capacity];
}

/** 快速创建可变数组函数 */
NSMutableArray * ag_mutableArray(NSUInteger capacity)
{
    return [NSMutableArray arrayWithCapacity:capacity];
}

/** 快速创建可变数组函数, 包含 Null 对象 */
NSMutableArray * ag_mutableNullArray(NSUInteger capacity)
{
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:capacity];
    for (NSInteger i = 0; i < capacity; i++) {
        [arrM addObject:[NSNull null]];
    }
    return arrM;
}

