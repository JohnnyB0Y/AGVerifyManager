//
//  AGListCell.m
//  AGVerifyManager
//
//  Created by JohnnyB0Y on 2018/12/31.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import "AGListCell.h"
#import "AGVerifyManager.h"

@interface AGListCell ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

/** 验证管理者  */
@property (nonatomic, strong) AGVerifyManager *verifyManager;

@end

@implementation AGListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
    
}

#pragma mark - ---------- Event Methods ----------
- (void) textFieldEditingChanged:(UITextField *)tf
{
    // 字符检测
    self.viewModel[kAGVMDetailText] = tf.text;
    
    AGVerifyManagerVerifyingBlock block = self.viewModel[kAGVerifyManagerVerifyingBlock];
    [self.verifyManager ag_executeVerifying:block completion:^(AGVerifyError * _Nullable firstError, NSArray<AGVerifyError *> * _Nullable errors) {
        
        if ( firstError ) {
            
            [UIView animateWithDuration:0.15 animations:^{
                tf.backgroundColor = [UIColor whiteColor];
            } completion:^(BOOL finished) {
                tf.backgroundColor = [UIColor redColor];
            }];
        }
        else {
            tf.backgroundColor = [UIColor whiteColor];
        }
        
    }];
    
}

#pragma mark - ----------- Setter Methods ----------
- (void)setViewModel:(AGViewModel *)viewModel
{
    [super setViewModel:viewModel];
    
    NSString *title = viewModel[kAGVMTitleText];
    NSString *detail = viewModel[kAGVMDetailText];
    NSString *subTitle = viewModel[kAGVMSubTitleText];
    
    self.titleLabel.text = title;
    self.textField.text = detail;
    self.msgLabel.text = subTitle;
    
    [self textFieldEditingChanged:self.textField];
}

#pragma mark - ----------- Getter Methods ----------
- (AGVerifyManager *)verifyManager
{
    if (_verifyManager == nil) {
        _verifyManager = ag_newAGVerifyManager();
    }
    return _verifyManager;
}

@end
