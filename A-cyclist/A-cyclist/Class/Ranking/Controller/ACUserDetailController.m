//
//  ACUserDetailController.m
//  A-cyclist
//
//  Created by tunny on 15/8/9.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACUserDetailController.h"
#import "ACSettingGroupModel.h"
#import "ACSettingCellModel.h"
#import "ACSettingViewCell.h"
#import "ACArrowWithSubtitleSettingCellModel.h"
#import "ACSettingViewCell.h"
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
#import "ACShowAlertTool.h"


@interface ACUserDetailController ()
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

@end

@implementation ACUserDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView.rowHeight = 44;
    
    [self addGroup0];
    [self addGroup1];
    
    [self getRequestData];
}

- (void)addGroup0
{
    //加载数据
    NSString *subTitle = [NSString stringWithFormat:@"%lu", (unsigned long)self.routeArray.count];
    ACArrowWithSubtitleSettingCellModel *cell0 = [ACArrowWithSubtitleSettingCellModel arrowWithSubtitleCellWithTitle:@"已共享的路线" subTitle:subTitle icon:nil destClass:nil];
    
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    group.cellList = @[cell0];
    [self.dataList addObject:group];
}

- (void)addGroup1
{
    //数据部分
    NSString *subTitle0 = @"";
    if (0 != self.maxDistanceRoute.steps.count) {
        subTitle0 = [NSString stringWithFormat:@"%@ km", self.maxDistanceRoute.distance];
    }
    ACProfileCellModel *cell0 = [ACProfileCellModel profileCellWithTitle:@"最远骑行距离" subTitle:subTitle0 route:self.maxDistanceRoute];
    
    NSString *subTitle1 = @"";
    if (0 != self.maxSpeedRoute.steps.count) {
        subTitle1 = [NSString stringWithFormat:@"%@ km/h", self.maxSpeedRoute.maxSpeed];
    }
    ACProfileCellModel *cell1 = [ACProfileCellModel profileCellWithTitle:@"极速" subTitle:subTitle1 route:self.maxSpeedRoute];
    
    NSString *subTitle2 = @"";
    if (0 != self.maxAverageRoute.steps.count) {
        subTitle2 = [NSString stringWithFormat:@"%@ km/h", self.maxAverageRoute.averageSpeed];
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

#pragma mark - 获取请求数据
- (void)getRequestData
{
    [ACShowAlertTool showMessage:@"加载中..." onView:nil];
    //从数据库中获取该用户的数据
    __weak typeof (self)weakSelf = self;
    [ACDataBaseTool getAllMaxRoutesWithUserId:self.userModel.objectId success:^(NSDictionary *result) {
        DLog(@"resutl is %@", result);
        if (result.count > 0) {
            if ([(NSArray *)[result objectForKey:@"routeArray"] count] > 0) {
                weakSelf.routeArray = [result objectForKey:@"routeArray"];
            }
            if ([(ACRouteModel *)[result objectForKey:@"maxDistanceRoute"] objectId]) {
                weakSelf.maxDistanceRoute = [result objectForKey:@"maxDistanceRoute"];
            }
            if ([(ACRouteModel *)[result objectForKey:@"maxSpeedRoute"] objectId]) {
                weakSelf.maxSpeedRoute = [result objectForKey:@"maxSpeedRoute"];
            }
            if ([(ACRouteModel *)[result objectForKey:@"maxAverageRoute"] objectId]) {
                weakSelf.maxAverageRoute = [result objectForKey:@"maxAverageRoute"];
            }
            if ([(ACRouteModel *)[result objectForKey:@"maxTimeRoute"] objectId]) {
                weakSelf.maxTimeRoute = [result objectForKey:@"maxTimeRoute"];
            }
            
            [weakSelf.dataList removeAllObjects];
            [weakSelf addGroup0];
            [weakSelf addGroup1];
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
            [self.navigationController pushViewController:routeHistoryVC animated:YES];
        }
    } else {
        //跳转至对应的控制器
        if (cellModel.route.objectId) {
            UIStoryboard *ArgumentsSB = [UIStoryboard storyboardWithName:@"cycling" bundle:nil];
            ACNavigationViewController *cell2Nav = [ArgumentsSB instantiateViewControllerWithIdentifier:@"ACNavigationController"];
            ACCyclingArgumentsViewController *cell2VC = (ACCyclingArgumentsViewController *)cell2Nav.topViewController;
            cell2VC.route = cellModel.route;
            [self.navigationController pushViewController:cell2VC animated:YES];
        }
    }
}

@end
