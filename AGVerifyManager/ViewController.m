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
#import "ATBusyVerifier.h"
#import <AGCategories/NSString+AGJudge.h>
#import "Demo/List/Controllers/AGListViewController.h"

@interface ViewController ()
<AGVerifyManagerVerifiable>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

/** Manager */
@property (nonatomic, strong) AGVerifyManager *verifyManager;

/** background manager */
@property (nonatomic, strong) AGVerifyManager *verifyManager2;

- (IBAction)verifyBtnClick:(UIButton *)sender;

@end

@implementation ViewController
#pragma mark - ----------- Life Cycle ----------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"列表测试" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
    
    
    /**
     - 创建遵守并实现<AGVerifyManagerVerifiable>协议的验证器类；
     - 如：Emoji表情验证器、手机号码验证器 ...
     - 使用 AGVerifyManager 搭配相应的验证器对数据进行验证和结果回调。
     -
     - AGVerifyManager 可以直接执行验证，然后释放Block；
     - 也可以保存Block，通过Key个别进行验证，重复进行验证，或者在后台线程进行验证。
     -
     - 具体可参考 Demo
     - 下面是代码片段
     */
    
    // 1. 判断用户输入文字限制
    ATTextLimitVerifier *usernameVerifier = [ATTextLimitVerifier new];
    usernameVerifier.minLimit = 2;
    usernameVerifier.maxLimit = 7;
    usernameVerifier.maxLimitMsg =
    [NSString stringWithFormat:@"文字不能超过%@个字符！", @(usernameVerifier.maxLimit)];
    
    // 2. 判断文字是否包含 emoji 😈
    ATEmojiVerifier *emojiVerifier = [ATEmojiVerifier new];
    
    // 3. 判断文字是否包含空格
    ATWhiteSpaceVerifier *whiteSpaceVerifier = [ATWhiteSpaceVerifier new];
    
    // 4. 准备验证
    __weak typeof(self) weakSelf = self;
    [self.verifyManager ag_addVerifyForKey:@"key" verifying:^(id<AGVerifyManagerVerifying> start) {
        
        __strong typeof(weakSelf) self = weakSelf;
        
        start
        // 用法一：传入验证器和需要验证的数据；
        .verifyData(usernameVerifier, self.nameTextField.text)
        .verifyData(emojiVerifier, self.nameTextField.text)
        // 用法二：传入验证器、数据、提示的内容；
        .verifyDataWithMsg(whiteSpaceVerifier, self.nameTextField.text, @"文字不能包含空格！")
        // 用法三：传入验证器、数据、你想传递的对象；文本框闪烁
        .verifyDataWithContext(self, self.nameTextField.text, self.nameTextField);
        
    } completion:^(AGVerifyError * firstError, NSArray<AGVerifyError *> * errors) {
        
        __strong typeof(weakSelf) self = weakSelf;
        if ( firstError ) {
            // 验证不通过
            self.resultLabel.textColor = [UIColor redColor];
            self.resultLabel.text = firstError.msg;
            
            // 文本框闪烁
            [errors enumerateObjectsUsingBlock:^(AGVerifyError * obj, NSUInteger idx, BOOL * stop) {
                
                // 取出传递的对象，根据自身业务处理。
                if ( obj.context == self.nameTextField ) {
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
    
    
    // 测试耗时验证
    ATBusyVerifier *busy = [ATBusyVerifier new];
    self.verifyManager2 = ag_newAGVerifyManager();
    
    // 这里是为了测试才使用了 dispatch_group_t
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    for (int i = 0; i<24; i++) {
        
        NSString *intStr = [NSNumber numberWithInt:i].stringValue;
        dispatch_group_async(group, queue, ^{
            [self.verifyManager2 ag_addVerifyForKey:intStr verifying:^(id<AGVerifyManagerVerifying>  _Nonnull start) {
                
                // 耗时验证
                start
                .verifyData(busy, intStr)
                .verifyData(busy, intStr);
                
            } completion:^(AGVerifyError * _Nullable firstError, NSArray<AGVerifyError *> * _Nullable errors) {
                
                NSLog(@"耗时验证完成----------- %@", intStr);
                [errors enumerateObjectsUsingBlock:^(AGVerifyError * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSLog(@"%@", obj.msg);
                }];
                NSLog(@"-");
            }];
            
        });
    }
    
    // 这里是为了测试才使用了 dispatch_group_t
    dispatch_group_notify(group, queue, ^{
        [self.verifyManager2 ag_executeAllVerifyBlocksInBackground];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.nameTextField becomeFirstResponder];
}

#pragma mark - ---------- Event Methods ----------
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)verifyBtnClick:(UIButton *)sender {
	
    // 5. 执行验证
    [self.verifyManager ag_executeVerifyBlockForKey:@"key"];
}

- (void) rightBarButtonItemClick:(id)sender
{
    AGListViewController *vc = [[AGListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ----------- AGVerifyManagerVerifiable ----------
/** 验证 示例 - 文字 < 2 闪红色，输入 > 7 闪紫色。由 code 控制 */
- (AGVerifyError *)ag_verifyData:(NSString *)data
{
    AGVerifyError *error = [AGVerifyError new];
    NSUInteger strLen = [data ag_lengthOfCharacter];
    
    if ( strLen < 2 ) {
        error.code = 100;
    }
    else if ( strLen > 7 ) {
        error.code = 200;
    }
    else {
        error = nil;
    }
    return error;
}

#pragma mark - ----------- Getter Methods ----------
- (AGVerifyManager *)verifyManager
{
    if (_verifyManager == nil) {
        _verifyManager = [AGVerifyManager new];
    }
    return _verifyManager;
}

@end
