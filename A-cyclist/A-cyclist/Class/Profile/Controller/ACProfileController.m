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
#import "ACNavUtility.h"
#import "NSDate+Extension.h"
#import "ACRouteModel.h"
#import "ACProfileHeaderView.h"
#import "ACCyclingArgumentsViewController.h"
#import "ACNavigationViewController.h"
#import "ACRouteHistoryController.h"
#import "MJRefresh.h"
#import "ACShowAlertTool.h"

typedef enum : NSUInteger {
    RouteTypeMaxDistance,
    RouteTypeMaxSpeed,
    RouteTypeMaxAverageSpeed,
    RouteTypeMaxTimeRoute,
} RouteType;

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
    
    self.navigationItem.rightBarButtonItem = [ACNavUtility setNavButtonWithImage:@"tab_more_iphone_5" target:self action:@selector(settingBtnClick:) frame:CGRectMake(0, 0, 24, 4)];
    
    self.tableView.rowHeight = 44;
    // 设置下拉刷新,加载数据
    //添加刷新控件
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

    //2. 从本地获取数据
    if (0 == self.routeArray.count) {
        self.routeArray = [ACCacheDataTool getUserRouteWithid:self.userModel.objectId];
        DLog(@"本地 routeArray, count is %lu", (unsigned long)self.routeArray.count);
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
        //    DLog(@"本地：最长距离路线:%@\n 最快极速路线:%@\n 最快平均速度路线:%@\n 最长时间路线:%@", self.maxDistanceRoute, self.maxSpeedRoute, self.maxAverageRoute, self.maxTimeRoute);
        [self addGroup0];
        [self addGroup1];
        if (self.routeArray.count <= 0) {
            //下拉刷新
            [self.tableView.mj_header beginRefreshing];
        }
    }
}

- (void)settingBtnClick:(UIBarButtonItem *)item
{
    UIStoryboard *settingSB = [UIStoryboard storyboardWithName:@"setting" bundle:nil];
    UINavigationController *settingNav = [settingSB instantiateInitialViewController];
    UIViewController *settingVc = settingNav.topViewController;
    [self.navigationController pushViewController:settingVc animated:YES];
}

- (void)addGroup0
{
    //加载数据
    NSString *subTitle = [NSString stringWithFormat:@"%lu", (unsigned long)self.routeArray.count];
    ACArrowWithSubtitleSettingCellModel *cell0 = [ACArrowWithSubtitleSettingCellModel arrowWithSubtitleCellWithTitle:@"骑行记录" subTitle:subTitle icon:nil destClass:nil];
    
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
    
    NSString *subTitle1 = @"";
    if (0 != self.maxSpeedRoute.steps.count) {
        subTitle1 = [NSString stringWithFormat:@"%.2f km/h", self.maxSpeedRoute.maxSpeed.doubleValue];
    }
    ACProfileCellModel *cell1 = [ACProfileCellModel profileCellWithTitle:@"极速" subTitle:subTitle1 route:self.maxSpeedRoute];
    
    NSString *subTitle2 = @"";
    if (0 != self.maxAverageRoute.steps.count) {
        subTitle2 = [NSString stringWithFormat:@"%.2f km/h", self.maxAverageRoute.averageSpeed.doubleValue];
    }
    ACProfileCellModel *cell2 = [ACProfileCellModel profileCellWithTitle:@"平均速度" subTitle:subTitle2 route:self.maxAverageRoute];
    
    NSString *subTitle3 = @"";
    if (0 != self.maxTimeRoute.steps.count) {
        subTitle3 = self.maxTimeRoute.time;
    }
    ACProfileCellModel *cell3 = [ACProfileCellModel profileCellWithTitle:@"单次最长时间" subTitle:subTitle3 route:self.maxTimeRoute];
    
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
    
    if (0 == indexPath.section) {
        //跳转至对应的控制器
        if (self.routeArray.count > 0) {
            ACRouteHistoryController *routeHistoryVC = [[ACRouteHistoryController alloc] init];
            routeHistoryVC.routeArrayModel = self.routeArray;
            [routeHistoryVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:routeHistoryVC animated:YES];
        }
    } else {
        //跳转至对应的控制器
        if (cellModel.route.objectId) {
            UIStoryboard *ArgumentsSB = [UIStoryboard storyboardWithName:@"cycling" bundle:nil];
            ACNavigationViewController *cell2Nav = [ArgumentsSB instantiateViewControllerWithIdentifier:@"ACNavigationController"];
            ACCyclingArgumentsViewController *cell2VC = (ACCyclingArgumentsViewController *)cell2Nav.topViewController;
            cell2VC.route = cellModel.route;
            [cell2VC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:cell2VC animated:YES];
        }
    }
}


#pragma mark - 下拉刷新
/**
 *  实现下拉刷新(使用MJRefresh框架)
 */
- (void)dropDownRefreshStatus
{
    [self.tableView.mj_header beginRefreshing];
}

/**
 *  下拉刷新控件的监听事件
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
    __weak typeof (self)weakSelf = self;
    [ACDataBaseTool getPersonalAllMaxRoutesWithUserId:self.userModel.objectId success:^(NSDictionary *result) {
        DLog(@"resutl is %@", result);
        if (result.count > 0) {
            if ([(NSArray *)[result objectForKey:@"routeArray"] count] > 0) {
                weakSelf.routeArray = [result objectForKey:@"routeArray"];
                ACArrowWithSubtitleSettingCellModel *arrowModel = [self.dataList[0] cellList][0];
                arrowModel.subTitle = [NSString stringWithFormat:@"%lu", (unsigned long)self.routeArray.count];
                
                //清空本地路线数据库
                BOOL blTmp = [ACCacheDataTool clearPersonRoute];
                if (blTmp) {   //本地数据库中对应id的路线为空
                    //保存新的路线里表到本地缓存
                    [self.routeArray enumerateObjectsUsingBlock:^(ACRouteModel *route, NSUInteger idx, BOOL *stop) {
                        [ACCacheDataTool addRouteWith:route withUserObjectId:self.userModel.objectId];
                    }];
                }
            }
            if ([(ACRouteModel *)[result objectForKey:@"maxDistanceRoute"] objectId]) {
                weakSelf.maxDistanceRoute = [result objectForKey:@"maxDistanceRoute"];
                [self setCellModelWithRoute:weakSelf.maxDistanceRoute type:RouteTypeMaxDistance];
            }
            if ([(ACRouteModel *)[result objectForKey:@"maxSpeedRoute"] objectId]) {
                weakSelf.maxSpeedRoute = [result objectForKey:@"maxSpeedRoute"];
                [self setCellModelWithRoute:weakSelf.maxSpeedRoute type:RouteTypeMaxSpeed];
            }
            if ([(ACRouteModel *)[result objectForKey:@"maxAverageRoute"] objectId]) {
                weakSelf.maxAverageRoute = [result objectForKey:@"maxAverageRoute"];
                [self setCellModelWithRoute:weakSelf.maxAverageRoute type:RouteTypeMaxAverageSpeed];
            }
            if ([(ACRouteModel *)[result objectForKey:@"maxTimeRoute"] objectId]) {
                weakSelf.maxTimeRoute = [result objectForKey:@"maxTimeRoute"];
                [self setCellModelWithRoute:weakSelf.maxTimeRoute type:RouteTypeMaxTimeRoute];
            }
            
            [weakSelf.tableView reloadData];
        } else {
            DLog(@"获取数据为空");
        }
        [ACShowAlertTool hideMessage];
    } failure:^(NSString *error) {
        [ACShowAlertTool hideMessage];
        [weakSelf showMsgCenter:ACRequestError];
    }];
}

/**
 *  修改cellModel模型
 */
- (void)setCellModelWithRoute:(ACRouteModel *)route type:(RouteType)routeType
{
    NSString *subTitle = @"";
    NSString *timeStr = @"";
    NSUInteger section = 0;
    NSUInteger row = 0;
    if (0 != route.steps.count) {
        switch (routeType) {
            case RouteTypeMaxDistance:{
                subTitle = [NSString stringWithFormat:@"%.2f km", route.distance.doubleValue];
                section = 1;
                row = 0;
                break;
            }
            case RouteTypeMaxSpeed:{
                subTitle = [NSString stringWithFormat:@"%.2f km/h", route.maxSpeed.doubleValue];
                section = 1;
                row = 1;
                break;
            }
            case RouteTypeMaxAverageSpeed:{
                subTitle = [NSString stringWithFormat:@"%.2f km/h", route.averageSpeed.doubleValue];
                section = 1;
                row = 2;
                break;
            }
            case RouteTypeMaxTimeRoute:{
                subTitle = route.time;
                section = 1;
                row = 3;
                break;
            }
            default:
                break;
        }
        
        timeStr = [NSDate dateToString:route.cyclingStartTime WithFormatter:@"yyyy-MM-dd"];
    }
    ACProfileCellModel *maxTimeModle = [self.dataList[section] cellList][row];
    maxTimeModle.subTitle = subTitle;
    maxTimeModle.timeStr = timeStr;
    maxTimeModle.route = route;
}


@end
