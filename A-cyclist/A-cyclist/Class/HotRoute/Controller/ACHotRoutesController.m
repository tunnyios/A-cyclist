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
#import "ACDataBaseTool.h"
#import "ACGlobal.h"
#import "ACHotRoutesDetailController.h"

@interface ACHotRoutesController ()
/** 数据数组(包含了cellModel) */
@property (nonatomic, strong) NSMutableArray *dataList;

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.rowHeight = 162;
    [self setHotRoutesData];
}

- (void)setHotRoutesData
{
    //从数据库中获取数据
    [ACDataBaseTool getSharedRouteListClass:@"上海" resultBlock:^(NSArray *sharedRoutes, NSError *error) {
        if (error) {
            DLog(@"从数据库中获取共享路线失败");
        } else {
            DLog(@"从数据库中获取共享路线成功, sharedRoutes is %@", sharedRoutes);
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
            [self.tableView reloadData];
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
    
//    //3.跳转至下一控制器
//    if ([cellModel isKindOfClass:[ACArrowSettingCellModel class]]) {
//        ACArrowSettingCellModel *arrowModel = (ACArrowSettingCellModel *)cellModel;
//        if (arrowModel.destClass) {
//            //弹出下一个控制器
//            UIViewController *vc = [[arrowModel.destClass alloc] init];
//            
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }
}

@end
