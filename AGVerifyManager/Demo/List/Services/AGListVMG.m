//
//  AGListVMG.m
//  AGVerifyManager
//
//  Created by JohnnyB0Y on 2018/12/31.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import "AGListVMG.h"
#import "../Views/AGListCell.h"
#import "AGVerifyManager.h"
#import "ATChineseVerifier.h"
#import "ATEnglishVerifier.h"
#import "ATNumberVerifier.h"
#import "ATEmojiVerifier.h"

@implementation AGListVMG
@synthesize itemVMM = _itemVMM;

- (AGVMManager *)itemVMM
{
    if (_itemVMM == nil) {
        _itemVMM = ag_newAGVMManager(1);
        
        ATChineseVerifier *chinese = [ATChineseVerifier new];
        AGBaseVerifier *english = ATEnglishVerifier.defaultInstance;
        ATNumberVerifier *number = [ATNumberVerifier new];
        AGBaseVerifier *emoji = ATEmojiVerifier.defaultInstance;
        
        [_itemVMM ag_packageSection:^(AGVMSection * _Nonnull vms) {
            
            [vms ag_packageItemMergeData:^(AGViewModel * _Nonnull package) {
                package[kAGVMViewClass] = AGListCell.class;
                package[kAGVMViewH] = @(178);
            }];
            
            // 验证 Emoji
            AGViewModel *vm1 =
            [vms ag_packageItemData:^(AGViewModel * _Nonnull package) {
                
                package[kAGVMTitleText] = @"Emoji表情检测！";
                package[kAGVMDetailText] = @"1024";
                
                // 检验 - block
                __weak typeof(package) weakPackage = package;
                package[kAGVerifyManagerVerifyingBlock]
                = ag_verifyManagerCopyVerifyingBlock(^(id<AGVerifyManagerVerifying>  _Nonnull start) {
                    
                    start.verifyData(emoji, weakPackage[kAGVMDetailText]);
                });
                
            }];
            
            // 验证 数字
            AGViewModel *vm2 =
            [vms ag_packageItemData:^(AGViewModel * _Nonnull package) {
                
                package[kAGVMTitleText] = @"数字字符检测！";
                package[kAGVMDetailText] = @"😁24🍄";
                
                // 检验 - block
                __weak typeof(package) weakPackage = package;
                package[kAGVerifyManagerVerifyingBlock]
                = ag_verifyManagerCopyVerifyingBlock(^(id<AGVerifyManagerVerifying>  _Nonnull start) {
                    
                    start.verifyData(number, weakPackage[kAGVMDetailText]);
                });
                
            }];
            
            // 验证 英文
            AGViewModel *vm3 =
            [vms ag_packageItemData:^(AGViewModel * _Nonnull package) {
                
                package[kAGVMTitleText] = @"英文字符检测！";
                package[kAGVMDetailText] = @"😁🍄";
                
                // 检验 - block
                __weak typeof(package) weakPackage = package;
                package[kAGVerifyManagerVerifyingBlock]
                = ag_verifyManagerCopyVerifyingBlock(^(id<AGVerifyManagerVerifying>  _Nonnull start) {
                    
                    start.verifyData(english, weakPackage[kAGVMDetailText]);
                });
                
            }];
            
            // 验证 中文
            AGViewModel *vm4 =
            [vms ag_packageItemData:^(AGViewModel * _Nonnull package) {
                
                package[kAGVMTitleText] = @"中文字符检测！";
                package[kAGVMDetailText] = @"哈哈";
                
                // 检验 - block
                __weak typeof(package) weakPackage = package;
                package[kAGVerifyManagerVerifyingBlock]
                = ag_verifyManagerCopyVerifyingBlock(^(id<AGVerifyManagerVerifying>  _Nonnull start) {
                    
                    start.verifyData(chinese, weakPackage[kAGVMDetailText]);
                });
                
            }];
            
            // common vm
            [vms ag_packageCommonData:^(AGViewModel * _Nonnull package) {
                
                // 检测所有数据 block，在AGListViewController 使用。
                package[kAGVerifyManagerVerifyingBlock]
                = ag_verifyManagerCopyVerifyingBlock(^(id<AGVerifyManagerVerifying>  _Nonnull start) {
                    
                    start.verifyData(emoji, vm1[kAGVMDetailText]);
                    start.verifyData(number, vm2[kAGVMDetailText]);
                    start.verifyData(english, vm3[kAGVMDetailText]);
                    start.verifyData(chinese, vm4[kAGVMDetailText]);
                });
                
            }];
            
        } capacity:4];
        
    }
    return _itemVMM;
}

@end
