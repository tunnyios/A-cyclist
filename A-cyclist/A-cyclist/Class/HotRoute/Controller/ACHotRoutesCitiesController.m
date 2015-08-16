//
//  ACHotRoutesCitiesController.m
//  A-cyclist
//
//  Created by tunny on 15/8/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACHotRoutesCitiesController.h"
#import "ACHotRoutesCitesCellModel.h"
#import "ACHotRoutesCitiesCellView.h"

@interface ACHotRoutesCitiesController ()
/** 城市列表 */
@property (nonatomic, strong) NSMutableArray *cityList;
@end

@implementation ACHotRoutesCitiesController

- (NSMutableArray *)cityList
{
    if (_cityList == nil) {
        _cityList = [NSMutableArray array];
    }
    
    return _cityList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 44;
    //从plist中加载城市
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cities.plist" ofType:nil]];
    
    [array enumerateObjectsUsingBlock:^(NSString *cityName, NSUInteger idx, BOOL *stop) {
        ACHotRoutesCitesCellModel *cityModel = [ACHotRoutesCitesCellModel citiesWithName:cityName];
        cityModel.option = ^(NSIndexPath *indexPath){
            if ([self.delegate respondsToSelector:@selector(hotRoutesCityClick:cityName:)]) {
                ACHotRoutesCitesCellModel *model = self.cityList[indexPath.row];
                [self.delegate hotRoutesCityClick:self cityName:model.cityName];
            }
        };
        
        [self.cityList addObject:cityModel];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cityList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACHotRoutesCitiesCellView *cell = [ACHotRoutesCitiesCellView settingViewCellWithTableView:tableView];
    
    ACHotRoutesCitesCellModel *cellModel = self.cityList[indexPath.row];
    cell.cellModel = cellModel;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //取模型
    ACHotRoutesCitesCellModel *cellModel = self.cityList[indexPath.row];
    
    //2.执行对应的选中操作
    if (cellModel.option) {
        cellModel.option(indexPath);
    }
}



@end
