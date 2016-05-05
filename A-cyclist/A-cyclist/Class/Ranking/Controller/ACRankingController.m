//
//  ACRankingController.m
//  A-cyclist
//
//  Created by tunny on 15/8/8.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACRankingController.h"
#import "ACUserModel.h"
#import "ACCacheDataTool.h"
#import "ACDataBaseTool.h"
//#import "MBProgressHUD+MJ.h"
#import "ACGlobal.h"
#import "ACRankingFormerCellView.h"
#import "ACRankingBehindCellView.h"
#import "ACRankingFormerCellModel.h"
#import "ACRankingBehindCellModel.h"
#import "ACNavigationViewController.h"
#import "ACCyclingArgumentsViewController.h"
#import "ACUserDetailController.h"
#import "ACRankingHeaderView.h"
#import <MJRefresh.h>

@interface ACRankingController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 用户对象 */
@property (nonatomic, strong) ACUserModel *user;
/** 用户列表 */
@property (nonatomic, strong) NSMutableArray *dataList;
/** pageIndex */
@property (nonatomic, assign) NSUInteger pageIndex;

@end

@implementation ACRankingController

- (ACUserModel *)user
{
    if (_user == nil) {
        _user = [ACCacheDataTool getUserInfo];
    }
    
    return _user;
}

- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 64;
    self.tableView.sectionHeaderHeight = 120;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //上下拉刷新
    [self initRefreshView];
    //设置排名信息tableView
    [self setRankingData];
}

/**
 *  获取排名信息tableView
 */
- (void)setRankingData
{
    [self showHUD_Msg:@"正在加载"];
    __weak typeof (self)weakSelf = self;
    [ACDataBaseTool getUserListWithPageIndex:self.pageIndex result:^(NSArray *userList, NSError *error) {
        if (error) {
            DLog(@"从服务器中获取用户列表失败， error is %@", error);
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.HUD hide:YES];
            [weakSelf showMsgCenter:ACRankGetListError];
        } else {
            if (1 == weakSelf.pageIndex) {
                [weakSelf.dataList removeAllObjects];
            }
            
            [userList enumerateObjectsUsingBlock:^(ACUserModel *user, NSUInteger idx, BOOL *stop) {
                if (1 == weakSelf.pageIndex) {
                    if (idx < 3) {
                        ACRankingFormerCellModel *formerModel = [weakSelf creatFormerCellModelWithData:user idx:idx];
                        [weakSelf.dataList addObject:formerModel];
                    } else {
                        ACRankingBehindCellModel *behindModel = [weakSelf creatBehindCellModelWithData:user idx:idx];
                        [weakSelf.dataList addObject:behindModel];
                    }
                } else {
                    ACRankingBehindCellModel *behindModel = [weakSelf creatBehindCellModelWithData:user idx:idx];
                    [weakSelf.dataList addObject:behindModel];
                }
            }];
            
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.HUD hide:YES];
        }

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化上下拉刷新
- (void)initRefreshView
{
    //设置索引
    self.pageIndex = 1;
    __weak typeof (self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = 1;
        [weakSelf setRankingData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex++;
        [weakSelf setRankingData];
    }];
}

/**
 *  创建前三名
 */
- (ACRankingFormerCellModel *)creatFormerCellModelWithData:(ACUserModel *)user idx:(NSUInteger)idx
{
    NSString *distance = [NSString stringWithFormat:@"%.0f", user.accruedDistance.doubleValue];
    NSString *suffxIcon = [NSString stringWithFormat:@"Ranklist_No%lu", idx + 1];
    ACRankingFormerCellModel *formerModel = [ACRankingFormerCellModel settingCellWithTitle:user.username icon:user.profile_image_url location:user.location distance:distance suffixIcon:suffxIcon];
    __weak typeof (self)weakSelf = self;
    formerModel.option = ^(){
        UIStoryboard *rankSB = [UIStoryboard storyboardWithName:@"ranking" bundle:nil];
        ACUserDetailController *userDetailController = [rankSB instantiateViewControllerWithIdentifier:@"userDetailController"];
        userDetailController.userModel = user;
        [userDetailController setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:userDetailController animated:YES];
    };
    
    return formerModel;
}

/**
 *  创建后几名
 */
- (ACRankingBehindCellModel *)creatBehindCellModelWithData:(ACUserModel *)user idx:(NSUInteger)idx
{
    NSString *distance = [NSString stringWithFormat:@"%.0f", user.accruedDistance.doubleValue];
    NSString *suffxNum = [NSString stringWithFormat:@"%lu", (30 * (self.pageIndex - 1))+ idx + 1];
    ACRankingBehindCellModel *behindModel = [ACRankingBehindCellModel settingCellWithTitle:user.username icon:user.profile_image_url location:user.location distance:distance suffixNum:suffxNum];
    __weak typeof (self)weakSelf = self;
    behindModel.option = ^(){
        UIStoryboard *rankSB = [UIStoryboard storyboardWithName:@"ranking" bundle:nil];
        ACUserDetailController *userDetailController = [rankSB instantiateViewControllerWithIdentifier:@"userDetailController"];
        userDetailController.userModel = user;
        [userDetailController setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:userDetailController animated:YES];
    };
    
    return behindModel;
}


#pragma mark - tableView的数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 3) {
        ACRankingFormerCellView *cell = [ACRankingFormerCellView settingViewCellWithTableView:tableView];
        //取cell模型
        ACRankingFormerCellModel *cellModel = self.dataList[indexPath.row];
        cell.cellModel = cellModel;
        return cell;
        
    } else {
        ACRankingBehindCellView *cell = [ACRankingBehindCellView settingViewCellWithTableView:tableView];
        //取cell模型
        ACRankingBehindCellModel *cellModel = self.dataList[indexPath.row];
        cell.cellModel = cellModel;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ACRankingHeaderView *headerView = [ACRankingHeaderView headerView];
    headerView.userModel = self.user;
    return headerView;
}

#pragma mark - tableView的代理方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //取模型
    ACRankingCellModel *cellModel = self.dataList[indexPath.row];
    
    //2.执行对应的选中操作
    if (cellModel.option) {
        cellModel.option(indexPath);
    }
}

@end
