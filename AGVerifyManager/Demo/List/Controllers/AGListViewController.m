//
//  AGListViewController.m
//  AGVerifyManager
//
//  Created by JohnnyB0Y on 2018/12/31.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import "AGListViewController.h"
#import <AGViewModel/AGVMKit.h>
#import "AGListCell.h"
#import "AGListVMG.h"
#import "AGVerifyManager.h"
#import <SVProgressHUD.h>

@interface AGListViewController ()

/** vmg */
@property (nonatomic, strong) AGListVMG *listVMG;

@end

@implementation AGListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
    
    // 注册 cell
    [AGListCell ag_registerCellBy:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.listVMG.itemVMM.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.listVMG.itemVMM[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AGViewModel *vm = self.listVMG.itemVMM[indexPath.section][indexPath.row];
    
    Class<AGTableCellReusable> cellCls = vm[kAGVMViewClass];
    UITableViewCell *cell = [cellCls ag_dequeueCellBy:tableView for:indexPath];
    
    //
    [cell setViewModel:vm];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AGViewModel *vm = self.listVMG.itemVMM[indexPath.section][indexPath.row];
    return [vm[kAGVMViewH] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark - ---------- Event Methods ----------
- (void) rightBarButtonItemClick:(id)sender
{
    // 模拟提交数据
    
    // 检测所有数据 (block 在 AGListVMG 类中封装)
    AGVerifyManagerVerifyingBlock block = self.listVMG.itemVMM.fs.cvm[kAGVerifyManagerVerifyingBlock];
    
    [AGVerifyManager.defaultInstance ag_executeVerifying:block completion:^(AGVerifyError * _Nullable firstError, NSArray<AGVerifyError *> * _Nullable errors) {
        
        if ( firstError ) {
            
            [SVProgressHUD showErrorWithStatus:firstError.msg];
            
        }
        
    }];
    
}

#pragma mark - ----------- Getter Methods ----------
- (AGListVMG *)listVMG
{
    if (_listVMG == nil) {
        _listVMG = [AGListVMG new];
    }
    return _listVMG;
}
@end
