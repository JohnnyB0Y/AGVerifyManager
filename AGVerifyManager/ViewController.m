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

@interface ViewController ()

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
    // 判断用户输入
    ATTextLimitVerifier *username =
    [ATTextLimitVerifier verifier:self.nameTextField.text];
    username.minLimit = 2;
    username.maxLimit = 7;
    username.maxLimitMsg =
    [NSString stringWithFormat:@"用户名不能超过%@个字符！", @(username.maxLimit)];
    
    // 判断是否包含 emoji 😈
    ATEmojiVerifier *emoji = [ATEmojiVerifier new];
    emoji.errorMsg = @"请输入非表情字符！";
    
    // 开始验证
    [ag_verifyManager()
     .verifyObj(emoji, self.nameTextField.text) // 用法一
     .verify(username) // 用法二
     verified:^(AGVerifyError *firstError, NSArray<AGVerifyError *> *errors) {
         
         if ( firstError ) {
             // 验证不通过
             self.resultLabel.text = firstError.msg;
             
         }
         else {
             // TODO
             self.resultLabel.text = @"验证通过！";
         }
     }];
    
}
@end
