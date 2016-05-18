//
//  ACBaseTableViewController.m
//  A-cyclist
//
//  Created by tunny on 15/7/15.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACBaseTableViewController.h"
#import "ACSettingGroupModel.h"
#import "ACSettingCellModel.h"
#import "ACGlobal.h"
#import "ACNavUtility.h"
#import "ACSettingViewCell.h"
#import "ACArrowSettingCellModel.h"
#import "ACLogoutSettingViewCell.h"
#import "UIColor+Tools.h"
#import <UIView+Toast.h>

@interface ACBaseTableViewController ()

@end

@implementation ACBaseTableViewController

- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    
    return _dataList;
}

- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 20;
    
    self.tableView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataList[section] cellList].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    ACSettingViewCell *cell = [ACSettingViewCell settingViewCellWithTableView:tableView];

    //取分组模型
    ACSettingGroupModel *group = self.dataList[indexPath.section];
    //取cell模型
    ACSettingCellModel *cellModel = group.cellList[indexPath.row];

    cell.cellModel = cellModel;
    
    return cell;
}

#pragma mark - Table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //取分组模型
    ACSettingGroupModel *group = self.dataList[section];
    
    return group.headerText;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    //取分组模型
    ACSettingGroupModel *group = self.dataList[section];
    
    return group.footerText;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //取模型
    ACSettingGroupModel *group  = self.dataList[indexPath.section];
    ACSettingCellModel *cellModel = group.cellList[indexPath.row];
    
    //2.执行对应的选中操作
    if (cellModel.option) {
        cellModel.option(indexPath);
    }
    
    //3.跳转至下一控制器
    if ([cellModel isKindOfClass:[ACArrowSettingCellModel class]]) {
        ACArrowSettingCellModel *arrowModel = (ACArrowSettingCellModel *)cellModel;
        if (arrowModel.destClass) {
            //弹出下一个控制器
            UIViewController *vc = [[arrowModel.destClass alloc] init];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - 确定/取消 Alert弹窗
/**
 *  alert弹框提示
 */
-(void)showAlertMsg:(NSString *)msg cancelBtn:(NSString *)cancelBtnTitle{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  alert弹框提示选择，确定、取消
 */
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
            cancelBtnTitle:(NSString *)cancelBtnTitle
             otherBtnTitle:(NSString *)otherBtnTitle
                   handler:(void (^)())handler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelActoin = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureActoin = [UIAlertAction actionWithTitle:otherBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }];
    
    [alertController addAction:cancelActoin];
    [alertController addAction:sureActoin];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 是否加载蒙版
/**
 *  设置蒙版
 *
 *  @param msg 显示文字
 */
- (void)showHUD_Msg:(NSString *)msg
{
    if (!self.HUD)
    {
        if (self.navigationController.view == nil)
        {
            self.HUD = [MBProgressHUD initDefaultHUDWithView:self.view];
        }else
        {
            self.HUD = [MBProgressHUD initDefaultHUDWithView:self.navigationController.view];
        }
    }
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    if (msg.length) {
        self.HUD.labelText = msg;
    } else {
        self.HUD.labelText = @"正在加载";
    }
    [self.HUD show:YES];
}

#pragma mark 中间弹框
- (void)showMsgCenter:(NSString *)msg
{
    if ([msg isEqualToString:@""]) {
        [self.view makeToast:@"您的网络有问题，请稍后再试..." duration:2.5f position:CSToastPositionCenter];
    }else{
        [self.view makeToast:msg duration:2.5f position:CSToastPositionCenter];
    }
}

#pragma 设置导航栏样式和标题
- (void)setNavigation:(NSString *)title
{
    [ACNavUtility setNav:self.navigationController setNavItem:self.navigationItem setTitle:title];
}

#pragma 设置导航栏样式、标题和左边返回按钮
- (void)setNavigationWithBackItem:(NSString *)title withAction:(SEL)action
{
    [ACNavUtility setNav:self.navigationController setNavItem:self.navigationItem setTitle:title];
    self.navigationItem.leftBarButtonItem = [ACNavUtility setNavButtonWithImage:@"back_icon.png"
                                                                         target:self
                                                                         action:action
                                                                          frame:CGRectMake(0, 0, 20, 20)];
}

@end
