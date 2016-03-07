//
//  ACProfileController.m
//  A-cyclist
//
//  Created by tunny on 15/8/5.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACProfileController.h"
#import "ACSettingGroupModel.h"
#import "ACSettingCellModel.h"
#import "ACSettingViewCell.h"
#import "ACArrowWithSubtitleSettingCellModel.h"
#import "ACProfileCellView.h"
#import "ACProfileCellModel.h"
#import "ACUserModel.h"
#import "ACCacheDataTool.h"
#import "ACDataBaseTool.h"
#import "ACGlobal.h"
#import "NSDate+Extension.h"
#import "ACRouteModel.h"
#import "ACProfileHeaderView.h"
#import "ACCyclingArgumentsViewController.h"
#import "ACNavigationViewController.h"
#import "ACRouteHistoryController.h"
#import "MJRefresh.h"
#import "ACShowAlertTool.h"


@interface ACProfileController ()
/** 用户数据 */
@property (nonatomic, strong) ACUserModel *userModel;
/** 路线数组 */
@property (nonatomic, strong) NSArray *routeArray;
/** 最长距离路线 */
@property (nonatomic, strong) ACRouteModel *maxDistanceRoute;
/** 最快极速路线 */
@property (nonatomic, strong) ACRouteModel *maxSpeedRoute;
/** 最快平均速度路线 */
@property (nonatomic, strong) ACRouteModel *maxAverageRoute;
/** 最长时间路线 */
@property (nonatomic, strong) ACRouteModel *maxTimeRoute;

/** 纪录上一次刷新的时间 */
@property (nonatomic, strong) NSDate *perFreshDate;

@end

@implementation ACProfileController

- (ACUserModel *)userModel
{
    if (_userModel == nil) {
        _userModel = [ACCacheDataTool getUserInfo];
    }
    
    return _userModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 44;
    // 设置下拉刷新,加载数据
    //添加刷新控件
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

    //2. 从本地获取数据
    if (0 == self.routeArray.count) {
        self.routeArray = [ACCacheDataTool getUserRouteWithid:self.userModel.objectId];
        DLog(@"本地 routeArray is %@, count is %lu", self.routeArray, (unsigned long)self.routeArray.count);
    }
    
    //从本地获取最长距离路线数据
    if (nil == self.maxDistanceRoute) {
        self.maxDistanceRoute = [ACCacheDataTool getMaxDistanceRouteWithId:self.userModel.objectId];
    }
    if (nil == self.maxSpeedRoute) {
        self.maxSpeedRoute = [ACCacheDataTool getMaxSpeedRouteWithId:self.userModel.objectId];
    }
    if (nil == self.maxAverageRoute) {
        self.maxAverageRoute = [ACCacheDataTool getMaxAverageSpeedRouteWithId:self.userModel.objectId];
    }
    if (nil == self.maxTimeRoute) {
        self.maxTimeRoute = [ACCacheDataTool getmaxTimeRouteWithId:self.userModel.objectId];
    }
    DLog(@"本地：最长距离路线:%@\n 最快极速路线:%@\n 最快平均速度路线:%@\n 最长时间路线:%@", self.maxDistanceRoute, self.maxSpeedRoute, self.maxAverageRoute, self.maxTimeRoute);
    
    [self addGroup0];
    [self addGroup1];
}

- (void)addGroup0
{
    //加载数据
    NSString *subTitle = [NSString stringWithFormat:@"%lu", (unsigned long)self.routeArray.count];
    ACArrowWithSubtitleSettingCellModel *cell0 = [ACArrowWithSubtitleSettingCellModel arrowWithSubtitleCellWithTitle:@"骑行记录" subTitle:subTitle icon:nil destClass:nil];
    
    cell0.option = ^(NSIndexPath *indexPath){
        //跳转至对应的控制器
        if (self.routeArray) {
            ACRouteHistoryController *routeHistoryVC = [[ACRouteHistoryController alloc] init];
            routeHistoryVC.routeArrayModel = self.routeArray;
            //        tableVC.tableView.backgroundColor = [UIColor redColor];
            [self.navigationController pushViewController:routeHistoryVC animated:YES];
        }
    };
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    group.cellList = @[cell0];
    
    [self.dataList addObject:group];
}

- (void)addGroup1
{
    //数据部分
    NSString *subTitle0 = @"";
    if (0 != self.maxDistanceRoute.steps.count) {
        subTitle0 = [NSString stringWithFormat:@"%.2f km", self.maxDistanceRoute.distance.doubleValue];
    }
    ACProfileCellModel *cell0 = [ACProfileCellModel profileCellWithTitle:@"最远骑行距离" subTitle:subTitle0 route:self.maxDistanceRoute];
    cell0.option = ^(NSIndexPath *indexPath){
        //跳转至对应的控制器
        if (self.maxDistanceRoute) {
            UIStoryboard *ArgumentsSB = [UIStoryboard storyboardWithName:@"cycling" bundle:nil];
            ACNavigationViewController *cell0Nav = [ArgumentsSB instantiateViewControllerWithIdentifier:@"ACNavigationController"];
            ACCyclingArgumentsViewController *cell0VC = (ACCyclingArgumentsViewController *)cell0Nav.topViewController;
            cell0VC.route = self.maxDistanceRoute;
            [self.navigationController pushViewController:cell0VC animated:YES];
        }
    };
    
    NSString *subTitle1 = @"";
    if (0 != self.maxSpeedRoute.steps.count) {
        subTitle1 = [NSString stringWithFormat:@"%.2f km/h", self.maxSpeedRoute.maxSpeed.doubleValue];
    }
    ACProfileCellModel *cell1 = [ACProfileCellModel profileCellWithTitle:@"极速" subTitle:subTitle1 route:self.maxSpeedRoute];
    cell1.option = ^(NSIndexPath *indexPath){
        //跳转至对应的控制器
        if (self.maxSpeedRoute) {
            UIStoryboard *ArgumentsSB = [UIStoryboard storyboardWithName:@"cycling" bundle:nil];
            ACNavigationViewController *cell1Nav = [ArgumentsSB instantiateViewControllerWithIdentifier:@"ACNavigationController"];
            ACCyclingArgumentsViewController *cell1VC = (ACCyclingArgumentsViewController *)cell1Nav.topViewController;
            cell1VC.route = self.maxSpeedRoute;
            [self.navigationController pushViewController:cell1VC animated:YES];
        }
    };
    
    NSString *subTitle2 = @"";
    if (0 != self.maxAverageRoute.steps.count) {
        subTitle2 = [NSString stringWithFormat:@"%.2f km/h", self.maxAverageRoute.averageSpeed.doubleValue];
    }
    ACProfileCellModel *cell2 = [ACProfileCellModel profileCellWithTitle:@"平均速度" subTitle:subTitle2 route:self.maxAverageRoute];
    cell2.option = ^(NSIndexPath *indexPath){
        //跳转至对应的控制器
        if (self.maxAverageRoute) {
            UIStoryboard *ArgumentsSB = [UIStoryboard storyboardWithName:@"cycling" bundle:nil];
            ACNavigationViewController *cell2Nav = [ArgumentsSB instantiateViewControllerWithIdentifier:@"ACNavigationController"];
            ACCyclingArgumentsViewController *cell2VC = (ACCyclingArgumentsViewController *)cell2Nav.topViewController;
            cell2VC.route = self.maxAverageRoute;
            [self.navigationController pushViewController:cell2VC animated:YES];
        }
    };
    
    NSString *subTitle3 = @"";
    if (0 != self.maxTimeRoute.steps.count) {
        subTitle3 = self.maxTimeRoute.time;
    }
    ACProfileCellModel *cell3 = [ACProfileCellModel profileCellWithTitle:@"单次最长时间" subTitle:subTitle3 route:self.maxTimeRoute];
    cell3.option = ^(NSIndexPath *indexPath){
        //跳转至对应的控制器
        if (self.maxTimeRoute) {
            UIStoryboard *ArgumentsSB = [UIStoryboard storyboardWithName:@"cycling" bundle:nil];
            ACNavigationViewController *cell3Nav = [ArgumentsSB instantiateViewControllerWithIdentifier:@"ACNavigationController"];
            ACCyclingArgumentsViewController *cell3VC = (ACCyclingArgumentsViewController *)cell3Nav.topViewController;
            cell3VC.route = self.maxTimeRoute;
            [self.navigationController pushViewController:cell3VC animated:YES];
        }
    };
    
    
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    group.cellList = @[cell0, cell1, cell2, cell3];
    group.headerText = @"个人最佳纪录";
    
    [self.dataList addObject:group];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView数据源方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取分组模型
    ACSettingGroupModel *group = self.dataList[indexPath.section];
    
    if (0 == indexPath.section && 0 == indexPath.row) { //第一个
        //取cell模型
        ACSettingCellModel *cellModel = group.cellList[indexPath.row];
        
        ACSettingViewCell *cell = [ACSettingViewCell settingViewCellWithTableView:tableView];
        cell.cellModel = cellModel;
        
        return cell;
    }
    
    //取cell模型
    ACProfileCellModel *cellModel = group.cellList[indexPath.row];
    ACProfileCellView *cell = [ACProfileCellView settingViewCellWithTableView:tableView];
    cell.profileModel = cellModel;
    
    return cell;
}


#pragma mark - tableView代理方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        ACProfileHeaderView *profileView = [ACProfileHeaderView profileHeaderView];
        profileView.user = self.userModel;
        return profileView;
    } else {
        UILabel *label = [[UILabel alloc] init];
        label.text = [self.dataList[section] headerText];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:13];
        return label;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 264;
    } else {
        return 20;
    }
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


#pragma mark - 下拉刷新
/**
 *  实现下拉刷新(使用MJRefresh框架)
 */
- (void)dropDownRefreshStatus
{
//    [self.dataList removeAllObjects];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

/**
 *  下拉刷新控件的监听事件
 *  下拉刷新获取数据
 *  @param control
 */
- (void)loadNewData
{
    //1. 发送请求获取数据
    [self getDataFromDataBase];
    
    //2. 关闭刷新
    [self.tableView.mj_header endRefreshing];
}

- (void)getDataFromDataBase
{
    [ACShowAlertTool showMessage:@"加载中..." onView:nil];
    //从数据库中获取该用户的数据
    //0. 获取数据库中的用户已共享的路线列表
    [ACDataBaseTool getRouteListWithUserObjectId:self.userModel.objectId resultBlock:^(NSArray *routes, NSError *error) {
        if (error) {
            DLog(@"从数据库中获取用户路线数据失败, error:%@", error);
            
        } else {
            self.routeArray = routes;
            DLog(@"数据库 routes is %@", routes);
            
            ACArrowWithSubtitleSettingCellModel *arrowModel = [self.dataList[0] cellList][0];
            arrowModel.subTitle = [NSString stringWithFormat:@"%lu", (unsigned long)self.routeArray.count];
            [self.tableView reloadData];
            
            NSArray *cacheRouteArray = [ACCacheDataTool getUserRouteWithid:self.userModel.objectId];
            if (0 == cacheRouteArray.count) {   //本地数据库中对应id的路线为空
                //保存新的路线里表到本地缓存
                [self.routeArray enumerateObjectsUsingBlock:^(ACRouteModel *route, NSUInteger idx, BOOL *stop) {
                    [ACCacheDataTool addRouteWith:route withUserObjectId:self.userModel.objectId];
                }];
                DLog(@"本地 routeArray is %@, count is %lu", self.routeArray, (unsigned long)self.routeArray.count);
            }
        }
        
        //1. 获取最长距离路线数据
        [ACDataBaseTool getMaxDistanceRouteWithUserObjectId:self.userModel.objectId resultBlock:^(ACRouteModel *route, NSError *error) {
            if (error) {
                DLog(@"从数据库中获取最长距离数据失败, error:%@", error);
                
            } else {
                self.maxDistanceRoute = route;
                DLog(@"数据库：最长距离路线：%@", self.maxDistanceRoute);
                
                NSString *subTitleDistance = @"";
                NSString *timeStrDistance = @"";
                if (0 != self.maxDistanceRoute.steps.count) {
                    subTitleDistance = [NSString stringWithFormat:@"%.2f km", self.maxDistanceRoute.distance.doubleValue];
                    timeStrDistance = [NSDate dateToString:self.maxDistanceRoute.cyclingStartTime WithFormatter:@"yyyy-MM-dd"];
                }
                ACProfileCellModel *maxDistanceModle = [self.dataList[1] cellList][0];
                maxDistanceModle.subTitle = subTitleDistance;
                maxDistanceModle.timeStr = timeStrDistance;
                [self.tableView reloadData];
            }
            
            //2. 获取最快极速路线数据
            [ACDataBaseTool getMaxSpeedRouteWithUserObjectId:self.userModel.objectId resultBlock:^(ACRouteModel *route, NSError *error) {
                if (error) {
                    DLog(@"从数据库中获取最快极速数据失败, error:%@", error);
                    
                } else {
                    self.maxSpeedRoute = route;
                    DLog(@"数据库：最快极速路线：%@", self.maxSpeedRoute);
                    
                    NSString *subTitleSpeed = @"";
                    NSString *timeStrSpeed = @"";
                    if (0 != self.maxSpeedRoute.steps.count) {
                        subTitleSpeed = [NSString stringWithFormat:@"%.2f km/h", self.maxSpeedRoute.maxSpeed.doubleValue];
                        timeStrSpeed = [NSDate dateToString:self.maxSpeedRoute.cyclingStartTime WithFormatter:@"yyyy-MM-dd"];
                    }
                    ACProfileCellModel *maxSpeedModle = [self.dataList[1] cellList][1];
                    maxSpeedModle.subTitle = subTitleSpeed;
                    maxSpeedModle.timeStr = timeStrSpeed;
                    [self.tableView reloadData];
                }
                
                //3. 获取最快平均速度路线数据
                [ACDataBaseTool getMaxAverageSpeedRouteWithUserObjectId:self.userModel.objectId resultBlock:^(ACRouteModel *route, NSError *error) {
                    if (error) {
                        DLog(@"从数据库中获取最快平均速度数据失败, error:%@", error);
                        
                    } else {
                        self.maxAverageRoute = route;
                        DLog(@"数据库：最快平均速度路线：%@", self.maxAverageRoute);
                        
                        NSString *subTitleAverage = @"";
                        NSString *timeStrAverage = @"";
                        if (0 != self.maxAverageRoute.steps.count) {
                            subTitleAverage = [NSString stringWithFormat:@"%.2f km/h", self.maxAverageRoute.averageSpeed.doubleValue];
                            timeStrAverage = [NSDate dateToString:self.maxAverageRoute.cyclingStartTime WithFormatter:@"yyyy-MM-dd"];
                        }
                        ACProfileCellModel *maxAverageModle = [self.dataList[1] cellList][2];
                        maxAverageModle.subTitle = subTitleAverage;
                        maxAverageModle.timeStr = timeStrAverage;
                        [self.tableView reloadData];
                    }
                    
                    //4. 获取最长时间路线数据
                    [ACDataBaseTool getMaxTimeRouteWithUserObjectId:self.userModel.objectId resultBlock:^(ACRouteModel *route, NSError *error) {
                        if (error) {
                            DLog(@"从数据库中获取最长时间数据失败, error:%@", error);
                            
                        } else {
                            self.maxTimeRoute = route;
                            DLog(@"数据库：最长时间路线：%@", self.maxTimeRoute);
                            
                            NSString *subTitleTime = @"";
                            NSString *timeStrTime = @"";
                            if (0 != self.maxTimeRoute.steps.count) {
//                                subTitleTime = [NSString stringWithFormat:@"%@ km", self.maxTimeRoute.distance];
                                subTitleTime = self.maxTimeRoute.time;
                                timeStrTime = [NSDate dateToString:self.maxTimeRoute.cyclingStartTime WithFormatter:@"yyyy-MM-dd"];
                            }
                            ACProfileCellModel *maxTimeModle = [self.dataList[1] cellList][3];
                            maxTimeModle.subTitle = subTitleTime;
                            maxTimeModle.timeStr = timeStrTime;
                            [self.tableView reloadData];
                        }
                        
                        [ACShowAlertTool hideMessage];
                    }];
                }];
            }];
        }];
    }];

}


@end
