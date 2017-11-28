//
//  ViewController.m
//  AGVerifyManager
//
//  Created by JohnnyB0Y on 2017/8/6.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "ViewController.h"
#import "AGVerifyManager.h"
#import "ATTextLimitVerifier.h"
#import "ATEmojiVerifier.h"
#import "ATWhiteSpaceVerifier.h"
#import <AGViewModel/AGVMKit.h>

//
static NSString * const kViewControllerNameText;


@interface ViewController ()
<AGVerifyManagerInjectVerifiable>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

- (IBAction)verifyBtnClick:(UIButton *)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.nameTextField becomeFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)verifyBtnClick:(UIButton *)sender {
	
	/**
	 - 创建遵守<AGVerifyManagerVerifiable>或<AGVerifyManagerInjectVerifiable>协议的验证器类
	 - 实现<AGVerifyManagerVerifiable>或<AGVerifyManagerInjectVerifiable>协议方法
	 - 具体可参考 Demo
	 - 下面是使用过程
	 */
	
    // 1. 判断用户输入文字限制
    ATTextLimitVerifier *username =
    [ATTextLimitVerifier verifier:self.nameTextField.text];
    username.minLimit = 2;
    username.maxLimit = 7;
    username.maxLimitMsg =
    [NSString stringWithFormat:@"文字不能超过%@个字符！", @(username.maxLimit)];
    
    // 2. 判断文字是否包含 emoji 😈
    ATEmojiVerifier *emoji = [ATEmojiVerifier new];
    emoji.errorMsg = @"请输入非表情字符！";
	
	// 3. 判断文字是否包含空格
	ATWhiteSpaceVerifier *whiteSpaceVerifier = [ATWhiteSpaceVerifier new];
	
    // 4. 开始验证
    [ag_verifyManager()
	 
	 .verify(username) // 用法一
     .verify_Obj(emoji, self.nameTextField.text) // 用法二
	 .verify_Obj_Msg(whiteSpaceVerifier, self.nameTextField.text, @"文字不能包含空格！") // 用法三
     .verify_Obj(self, self.nameTextField) // 文本框闪烁
	 
     verified:^(AGVerifyError * _Nullable firstError, NSArray<AGVerifyError *> * _Nullable errors) {
         if ( firstError ) {
             // 验证不通过
			 self.resultLabel.textColor = [UIColor redColor];
             self.resultLabel.text = firstError.msg;
             
             // 文本框闪烁
             [errors enumerateObjectsUsingBlock:^(AGVerifyError * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 
                 // 根据你自身业务来处理
                 if ( obj.verifyObj == self.nameTextField ) {
                     // 取色
                     UIColor *color;
                     if ( obj.code == 100 ) {
                         color = [UIColor redColor];
                     }
                     else if ( obj.code == 200 ) {
                         color = [UIColor purpleColor];
                     }
                     // 动画
                     [UIView animateWithDuration:0.15 animations:^{
                         self.nameTextField.backgroundColor = color;
                     } completion:^(BOOL finished) {
                         self.nameTextField.backgroundColor = [UIColor whiteColor];
                     }];
                 }
                 
             }];
             
         }
         else {
             // TODO
			 self.resultLabel.textColor = [UIColor greenColor];
             self.resultLabel.text = @"验证通过！";
             self.nameTextField.backgroundColor = [UIColor whiteColor];
         }
     }];
    
}

/** 验证 示例 - 文字 < 2 闪红色，输入 > 7 闪紫色。由 code 控制 */
- (AGVerifyError *)verifyObj:(UITextField *)obj
{
    AGVerifyError *error = [AGVerifyError new];
    error.verifyObj = obj;
    if ( obj.text.length < 2 ) {
        error.code = 100;
    }
    else if ( obj.text.length > 7 ) {
        error.code = 200;
    }
    else {
        error = nil;
    }
    return error;
}

@end
