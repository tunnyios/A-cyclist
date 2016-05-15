//
//  ACRouteHistoryController.m
//  A-cyclist
//
//  Created by tunny on 15/8/8.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACRouteHistoryController.h"
#import "ACRouteModel.h"
#import "ACUserModel.h"
#import "ACProfileCellModel.h"
#import "ACNavigationViewController.h"
#import "ACCyclingArgumentsViewController.h"
#import "ACSettingGroupModel.h"
#import "ACRouteHistoryCellView.h"
#import "ACGlobal.h"
#import "ACDataBaseTool.h"
#import "ACCacheDataTool.h"
#import <MJRefresh.h>

@interface ACRouteHistoryController ()
/** 骑行轨迹数组 */
@property (nonatomic, strong) NSMutableArray *routeArrayModel;
@property (nonatomic, strong) ACUserModel *userInfo;
/** pageIndex */
@property (nonatomic, assign) NSUInteger pageIndex;

@end

@implementation ACRouteHistoryController
- (ACUserModel *)userInfo
{
    if (_userInfo == nil) {
        _userInfo = [ACCacheDataTool getUserInfo];
    }
    
    return _userInfo;
}

- (NSMutableArray *)routeArrayModel
{
    if (_routeArrayModel == nil) {
        _routeArrayModel = [NSMutableArray array];
    }
    
    return _routeArrayModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView.rowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initRefreshView];
    [self getRouteDataWithRouteType:self.routeType];
}

#pragma mark - 初始化上下拉刷新
- (void)initRefreshView
{
    //设置索引
    self.pageIndex = 1;
    __weak typeof (self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = 1;
        [weakSelf getRouteDataWithRouteType:weakSelf.routeType];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex++;
        [weakSelf getRouteDataWithRouteType:weakSelf.routeType];
    }];
}

- (void)addDataWithRouteList:(NSArray *)routes pageIndex:(NSUInteger)pageIndex
{
    if (1 == pageIndex) {
        [self.dataList removeAllObjects];
        if (![self.userObjectId isEqualToString:@""]) {
            [ACCacheDataTool clearPersonRoute];
        }
    }
    [routes enumerateObjectsUsingBlock:^(ACRouteModel *route, NSUInteger idx, BOOL *stop) {
        //此处唯一本地记录个人骑行路线
        if ([route.userObjectId isEqualToString:self.userObjectId]) {
            [ACCacheDataTool addRouteWith:route withUserObjectId:self.userObjectId];
        }
        
        NSString *subTitle = [NSString stringWithFormat:@"%@", route.distance];
        ACProfileCellModel *profileCellM = [ACProfileCellModel profileCellWithTitle:route.routeName subTitle:subTitle route:route];
        
        __weak typeof (self)weakSelf = self;
        profileCellM.option = ^(NSIndexPath *indexPath){
            UIStoryboard *ArgumentsSB = [UIStoryboard storyboardWithName:@"cycling" bundle:nil];
            ACNavigationViewController *cellNav = [ArgumentsSB instantiateViewControllerWithIdentifier:@"ACNavigationController"];
            ACCyclingArgumentsViewController *cellVC = (ACCyclingArgumentsViewController *)cellNav.topViewController;
            cellVC.route = route;
            [weakSelf.navigationController pushViewController:cellVC animated:YES];
        };
        
        ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
        [group.cellList addObject:profileCellM];
        [self.dataList addObject:group];
    }];
}

- (void)getRouteDataWithRouteType:(RouteListType)routeType
{
    [self showHUD_Msg:@"正在加载"];
    __weak typeof (self)weakSelf = self;
    if (RouteListTypePersonal == routeType) {   //个人路线
        [ACDataBaseTool getRouteListWithUserObjectId:self.userInfo.objectId pageIndex:self.pageIndex resultBlock:^(NSArray *routes, NSError *error) {
            [weakSelf.HUD hide:YES];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            
            if (!error) {
                [weakSelf addDataWithRouteList:routes pageIndex:weakSelf.pageIndex];
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf.HUD hideErrorMessage:ACRequestError];
                weakSelf.pageIndex--;
            }
        }];
    } else {    //个人已共享路线
        [ACDataBaseTool getSharedRouteListWithUserObjectId:self.userInfo.objectId pageIndex:self.pageIndex resultBlock:^(NSArray *routes, NSError *error) {
            [weakSelf.HUD hide:YES];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            if (!error) {
                [weakSelf addDataWithRouteList:routes pageIndex:weakSelf.pageIndex];
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf.HUD hideErrorMessage:ACRequestError];
                weakSelf.pageIndex--;
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取分组模型
    ACProfileCellModel *cellModel = nil;
    if (indexPath.row < [self.dataList count]) {
        ACSettingGroupModel *group = self.dataList[indexPath.section];
        //取cell模型
        cellModel = group.cellList[indexPath.row];
    }
    ACRouteHistoryCellView *cell = [ACRouteHistoryCellView settingViewCellWithTableView:tableView];
    cell.profileModel = cellModel;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //取模型
    if (indexPath.section < [self.dataList count]) {
        ACSettingGroupModel *group  = self.dataList[indexPath.section];
        ACProfileCellModel *cellModel = group.cellList[indexPath.row];
            
        //2.执行对应的选中操作
        if (cellModel.option) {
            cellModel.option(indexPath);
        }
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        NSMutableArray *tempArray = [self.dataList copy];
        __block ACSettingGroupModel *group  = tempArray[indexPath.section];
        ACProfileCellModel *cellModel = group.cellList[indexPath.row];
        __weak typeof (self)weakSelf = self;
        [ACDataBaseTool delRouteWithRouteObjectId:cellModel.route.objectId success:^(BOOL isSuccessful) {
            if (isSuccessful) {
                //此处唯一本地删除个人骑行路线
                if ([cellModel.route.objectId isEqualToString:weakSelf.userObjectId]) {
                    [ACCacheDataTool addRouteWith:cellModel.route withUserObjectId:weakSelf.userObjectId];
                }
                
                [weakSelf.dataList removeObject:group];

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
        } failure:^(NSError *error) {
            [weakSelf showMsgCenter:@"移除路线失败"];
        }];
    }
}

@end
