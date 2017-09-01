//
//  AGVMManager.h
//  Architecture
//
//  Created by JohnnyB0Y on 2017/6/7.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  viewModel 生产者

#import "AGVMProtocol.h"
#import "AGVMSection.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - interface
@interface AGVMManager : NSObject

@property (nonatomic, strong, readonly, nullable) AGViewModel *commonVM;

@property (nonatomic, strong, readonly, nullable) NSMutableArray<AGVMSection *> *sectionArrM;
@property (nonatomic, assign, readonly) NSUInteger count;

@property (nonatomic, weak, readonly, nullable) AGVMSection *firstSection;
@property (nonatomic, weak, readonly, nullable) AGVMSection *lastSection;

#pragma mark - 快速创建 vmm
/**
 快速创建vmm

 @param capacity sectionArrM 每次增量拷贝的内存大小
 @return vmm
 */
+ (instancetype) ag_VMManagerWithItemCapacity:(NSUInteger)capacity;


#pragma mark - 自己拼装数据 （不用担心循环引用问题）
/**
 拼装 section 数据

 @param block 传递 section 的 block
 @param capacity section 中 itemArr 每次增量拷贝的内存大小
 @return 一组数据对象
 */
- (AGVMSection *) ag_packageSection:(nullable NS_NOESCAPE AGVMPackageSectionBlock)block
                           capacity:(NSUInteger)capacity;


/**
 打包公共数据

 @param package 打包block
 @param capacity 字典每次增量拷贝的内存大小
 @return 打包好的 View Model
 */
- (AGViewModel *) ag_packageCommonData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package
                              capacity:(NSUInteger)capacity;
- (AGViewModel *)ag_packageCommonData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package;


#pragma mark - 修改数据
#pragma mark 添加
- (void) ag_addSection:(AGVMSection *)section;
- (void) ag_addSectionsFromArray:(NSArray<AGVMSection *> *)sections;

#pragma mark 插入
- (void) ag_insertSectionsFromVMManager:(AGVMManager *)vmm
                                atIndex:(NSUInteger)index;

- (void) ag_insertSectionsFromArray:(NSArray<AGVMSection *> *)vmsArr
                            atIndex:(NSUInteger)index;

- (void) ag_insertSection:(AGVMSection *)section
                  atIndex:(NSUInteger)index;

- (void) ag_insertSectionPackage:(NS_NOESCAPE AGVMPackageSectionBlock)package
                         atIndex:(NSUInteger)index;

- (void) ag_insertSectionPackage:(NS_NOESCAPE AGVMPackageSectionBlock)package
                         atIndex:(NSUInteger)index
                        capacity:(NSUInteger)capacity;

#pragma mark 移除
- (void) ag_removeAllSections;
- (void) ag_removeLastObject;
- (void) ag_removeSectionAtIndex:(NSUInteger)index;

#pragma mark 合并
/** 合并 commonVM、sectionArrM */
- (void) ag_mergeFromVMManager:(AGVMManager *)vmm;

#pragma mark 更新
- (void) ag_updateSectionPackage:(NS_NOESCAPE AGVMPackageSectionBlock)package
                         atIndex:(NSUInteger)index;

- (void) setObject:(AGVMSection *)vms
atIndexedSubscript:(NSUInteger)idx;

#pragma mark 取出
- (nullable AGVMSection *) objectAtIndexedSubscript:(NSUInteger)idx;

#pragma mark 交换
- (void) ag_exchangeSectionAtIndex:(NSUInteger)idx1 withSectionAtIndex:(NSUInteger)idx2;

#pragma mark 替换
- (void) ag_replaceSectionAtIndex:(NSUInteger)index withSection:(AGVMSection *)section;

#pragma mark 遍历
/** 遍历所有 section */
- (void) ag_enumerateSectionsUsingBlock:(void (NS_NOESCAPE ^)(AGVMSection *vms, NSUInteger idx, BOOL *stop))block;

/** 遍历所有 section 的 item */
- (void) ag_enumerateSectionItemsUsingBlock:(void (NS_NOESCAPE ^)(AGViewModel *vm, NSIndexPath *indexPath, BOOL *stop))block;

/** 遍历所有 section 的 header、footer vm */
- (void) ag_enumerateSectionHeaderFooterVMsUsingBlock:(void (NS_NOESCAPE ^)(AGViewModel *vm, NSIndexPath *indexPath, BOOL *stop))block;

@end


#pragma mark - 快捷函数
/** 快速创建 AGVMManager 实例 */
AGVMManager * ag_VMManager(NSUInteger capacity);


NS_ASSUME_NONNULL_END

