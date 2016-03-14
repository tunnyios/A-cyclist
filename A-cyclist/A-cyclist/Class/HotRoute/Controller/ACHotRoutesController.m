//
//  ACHotRoutesController.m
//  A-cyclist
//
//  Created by tunny on 15/8/10.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACHotRoutesController.h"
#import "ACHotRoutesCellView.h"
#import "ACHotRoutesCellModel.h"
#import "ACCacheDataTool.h"
#import "ACDataBaseTool.h"
#import "ACGlobal.h"
#import "ACHotRoutesDetailController.h"
#import "HCNewTypeButtonView.h"
#import "HCDropDownMenuView.h"
#import "ACHotRoutesCitiesController.h"
#import "MBProgressHUD+MJ.h"
#import <MJRefresh.h>
#import <UIView+Toast.h>

@interface ACHotRoutesController () <ACHotRoutesCityDelegate>
/** 数据数组(包含了cellModel) */
@property (nonatomic, strong) NSMutableArray *dataList;
/** 下拉菜单View */
@property (nonatomic, strong) HCDropDownMenuView *dropMenu;
/** 导航栏左边的button */
@property (nonatomic, strong) HCNewTypeButtonView *leftBtn;
/** selectedCityName */
@property (nonatomic, copy) NSString *selectedCityName;
/** pageIndex */
@property (nonatomic, assign) NSUInteger pageIndex;

@end

@implementation ACHotRoutesController

- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //1. 设置导航栏左侧按钮
    self.leftBtn = [HCNewTypeButtonView buttonWithTitle:@"北京" icon:@"route_city_arrow" heighIcon:@"route_city_arrow"];
    //监听按钮点击，弹出下拉菜单
    [self.leftBtn addTarget:self action:@selector(dropDownMenu:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
    
    self.tableView.rowHeight = 162;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.selectedCityName = @"北京";
    //上下拉刷新
    [self initRefreshView];
    //从服务器中获取路线
    [self setHotRoutesDataWithCityName:self.selectedCityName];
}

/** 点击首页的下拉菜单 */
- (void)dropDownMenu:(HCNewTypeButtonView *)button
{
    //创建下拉菜单
    self.dropMenu = [HCDropDownMenuView dropDownMenu];
    //设置下拉菜单容器(即背景图片)
    self.dropMenu.containerImage = @"";
    //设置下拉菜单内容
    ACHotRoutesCitiesController *contentController = [[ACHotRoutesCitiesController alloc] init];
    contentController.tableView.backgroundColor = [UIColor clearColor];
    contentController.delegate = self;
    contentController.view.frame = CGRectMake(0, 0, 200, 44 * 3);
    
    self.dropMenu.contentController = contentController;
    //显示
    [self.dropMenu showFromView:button];
    
    //dorpMenu的block,下拉菜单销毁，修改button的image
    self.dropMenu.block = ^(){
        [button setImage:[UIImage imageNamed:@"route_city_arrow"] forState:UIControlStateNormal];
    };
}

#pragma mark - 初始化上下拉刷新
- (void)initRefreshView
{
    //设置索引
    self.pageIndex = 1;
    __weak typeof (self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = 1;
        [weakSelf setHotRoutesDataWithCityName:self.selectedCityName];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex++;
        [weakSelf setHotRoutesDataWithCityName:self.selectedCityName];
    }];
}

#if 0
/**
 *  从缓存中获取数据
 *
 */
- (void)getCacheRoutesDataWithCityName:(NSString *)cityName
{
    __weak typeof (self)weakSelf = self;
    NSArray *sharedRoutes = [ACCacheDataTool getSharedRouteWithRouteClass:cityName];
    if (sharedRoutes.count > 0) {
        DLog(@"从本地获取...");
        //1. 设置dataList数据
        [sharedRoutes enumerateObjectsUsingBlock:^(ACSharedRouteModel *sharedRoute, NSUInteger idx, BOOL *stop) {
            ACHotRoutesCellModel *hotRouteCellModel = [ACHotRoutesCellModel hotRoute:sharedRoute];
            
            hotRouteCellModel.option = ^(){
                UIStoryboard *hotRoutesSB = [UIStoryboard storyboardWithName:@"hotRoutes" bundle:nil];
                ACHotRoutesDetailController *hotRoutesDetailController = [hotRoutesSB instantiateViewControllerWithIdentifier:@"hotRoutesDetail"];
                hotRoutesDetailController.sharedRoute = sharedRoute;
                
                [self.navigationController pushViewController:hotRoutesDetailController animated:YES];
            };
            [self.dataList addObject:hotRouteCellModel];
        }];
        
        //2. 回到主线程刷新数据
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}
#endif

/**
 *  从服务器获取数据
 */
- (void)setHotRoutesDataWithCityName:(NSString *)cityName
{
    [MBProgressHUD showMessage:@"正在加载"];
    __weak typeof (self)weakSelf = self;
    [ACDataBaseTool getSharedRouteListClass:cityName pageIndex:self.pageIndex resultBlock:^(NSArray *sharedRoutes, NSError *error) {
        if (error) {
            DLog(@"从服务器获取共享路线失败");
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [MBProgressHUD hideHUD];
            [weakSelf.view makeToast:ACSharedRouteGetListError duration:2.5f position:CSToastPositionCenter];
        } else {
            DLog(@"从服务器获取共享路线成功, sharedRoutes is %@", sharedRoutes);
            if (1 == self.pageIndex) {
                [weakSelf.dataList removeAllObjects];
            }
            
            //1. 设置dataList数据
            [sharedRoutes enumerateObjectsUsingBlock:^(ACSharedRouteModel *sharedRoute, NSUInteger idx, BOOL *stop) {
                ACHotRoutesCellModel *hotRouteCellModel = [ACHotRoutesCellModel hotRoute:sharedRoute];
                hotRouteCellModel.option = ^(){
                    UIStoryboard *hotRoutesSB = [UIStoryboard storyboardWithName:@"hotRoutes" bundle:nil];
                    ACHotRoutesDetailController *hotRoutesDetailController = [hotRoutesSB instantiateViewControllerWithIdentifier:@"hotRoutesDetail"];
                    hotRoutesDetailController.sharedRoute = sharedRoute;
                    
                    [weakSelf.navigationController pushViewController:hotRoutesDetailController animated:YES];
                };
                [weakSelf.dataList addObject:hotRouteCellModel];
                
                //2. 回到主线程刷新数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
                
                //3. 将这批同一cityName的热门路线添加到本地
                [ACCacheDataTool addSharedRouteListWith:sharedRoutes];
            }];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [MBProgressHUD hideHUD];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACHotRoutesCellView *cell = [ACHotRoutesCellView settingViewCellWithTableView:tableView];
    
    //取cell模型
    ACHotRoutesCellModel *cellModel = self.dataList[indexPath.row];
    
    cell.cellModel = cellModel;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //取模型
    ACHotRoutesCellModel *cellModel = self.dataList[indexPath.row];
    
    //2.执行对应的选中操作
    if (cellModel.option) {
        cellModel.option(indexPath);
    }
}


#pragma mark - 点击城市的代理事件
- (void)hotRoutesCityClick:(ACHotRoutesCitiesController *)citiesController cityName:(NSString *)cityName
{
    self.selectedCityName = cityName;
    //修改左上角的button的值
    [self.leftBtn setTitle:cityName forState:UIControlStateNormal];
    //销毁下拉菜单
    [self.dropMenu disMiss];
    
    //从数据库中获取热门路线，并刷新界面
    self.pageIndex = 1;
    [self setHotRoutesDataWithCityName:self.selectedCityName];
}

@end
