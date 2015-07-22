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
#import "ACSettingViewCell.h"
#import "ACArrowSettingCellModel.h"
#import "ACLogoutSettingViewCell.h"
#import "UIColor+Tools.h"

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
        cellModel.option();
    }
    
    //3.跳转至下一控制器
    if ([cellModel isKindOfClass:[ACArrowSettingCellModel class]]) {
        ACArrowSettingCellModel *arrowModel = (ACArrowSettingCellModel *)cellModel;
        if (arrowModel.destClass) {
            //弹出下一个控制器
            UIViewController *vc = [[arrowModel.destClass alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


@end
