//
//  ACRouteHistoryController.m
//  A-cyclist
//
//  Created by tunny on 15/8/8.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACRouteHistoryController.h"
#import "ACRouteModel.h"
#import "ACProfileCellModel.h"
#import "ACNavigationViewController.h"
#import "ACCyclingArgumentsViewController.h"
#import "ACSettingGroupModel.h"
#import "ACRouteHistoryCellView.h"

@interface ACRouteHistoryController ()

@end

@implementation ACRouteHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView.rowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addData];
}

- (void)addData
{
    [self.routeArrayModel enumerateObjectsUsingBlock:^(ACRouteModel *route, NSUInteger idx, BOOL *stop) {
        NSString *subTitle = [NSString stringWithFormat:@"%@", route.distance];
        ACProfileCellModel *profileCellM = [ACProfileCellModel profileCellWithTitle:route.routeName subTitle:subTitle route:route];
        
        profileCellM.option = ^(NSIndexPath *indexPath){
            UIStoryboard *ArgumentsSB = [UIStoryboard storyboardWithName:@"cycling" bundle:nil];
            ACNavigationViewController *cellNav = [ArgumentsSB instantiateViewControllerWithIdentifier:@"ACNavigationController"];
            ACCyclingArgumentsViewController *cellVC = (ACCyclingArgumentsViewController *)cellNav.topViewController;
            cellVC.route = route;
            [self.navigationController pushViewController:cellVC animated:YES];
        };
        
        NSMutableArray *arrayM = [NSMutableArray array];
        [arrayM addObject:profileCellM];
        ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
        group.cellList = arrayM;
        [self.dataList addObject:group];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取分组模型
    ACSettingGroupModel *group = self.dataList[indexPath.section];
    //取cell模型
    ACProfileCellModel *cellModel = group.cellList[indexPath.row];
    ACRouteHistoryCellView *cell = [ACRouteHistoryCellView settingViewCellWithTableView:tableView];
    cell.profileModel = cellModel;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //取模型
    ACSettingGroupModel *group  = self.dataList[indexPath.section];
    ACProfileCellModel *cellModel = group.cellList[indexPath.row];
    
    //2.执行对应的选中操作
    if (cellModel.option) {
        cellModel.option(indexPath);
    }
}

@end
