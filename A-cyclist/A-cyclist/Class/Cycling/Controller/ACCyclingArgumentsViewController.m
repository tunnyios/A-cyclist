//
//  ACCyclingArgumentsViewController.m
//  A-cyclist
//
//  Created by tunny on 15/7/25.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACCyclingArgumentsViewController.h"
#import "ACNavigationViewController.h"
#import "ACCyclingArgumentScrollView.h"
#import "ACSettingGroupModel.h"
#import "ACSettingCellModel.h"
#import "ACCyclingDetailCell.h"
#import "ACCyclingDetailModel.h"
#import "ACRouteModel.h"
#import "ACGlobal.h"
#import "NSDate+Extension.h"

@interface ACCyclingArgumentsViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
/** 约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleViewLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightViewLeading;

/** storyboard中的属性 */
@property (weak, nonatomic) IBOutlet UIButton *trailBtn;
@property (weak, nonatomic) IBOutlet UIButton *graphicBtn;
@property (weak, nonatomic) IBOutlet UIButton *dataBtn;
/** scrollView */
@property (weak, nonatomic) IBOutlet ACCyclingArgumentScrollView *cyclingArgumentScrollView;
/** 详细参数tableView */
@property (weak, nonatomic) IBOutlet UITableView *detialTableView;
/** 数据数组(包含了groupModel，groupModel中又包含了cellModel) */
@property (nonatomic, strong) NSMutableArray *dataList;

/* 轨迹界面属性 */
/** 路线名称 */
@property (weak, nonatomic) IBOutlet UILabel *routeNameLabel;
/** 骑行里程 */
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
/** 骑行耗时 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/** 平均速度 */
@property (weak, nonatomic) IBOutlet UILabel *averageSpeedLabel;
/** 累计上升 */
@property (weak, nonatomic) IBOutlet UILabel *ascendAltitudeLabel;


@end

@implementation ACCyclingArgumentsViewController

- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    //1. 最先展示轨迹
    [self trailBtnClick];
    //2. 加载轨迹详细数据
    [self setDetailData];
    
    DLog(@"######route %@", self.route);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - storyboard中的按钮监听点击事件
/**
 *  点击返回按钮
 */
- (IBAction)cancle:(id)sender
{
    if ([self.navigationController isKindOfClass:[ACNavigationViewController class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 *  轨迹按钮点击
 */
- (IBAction)trailBtnClick
{
    //1. 设置选中状态
    self.trailBtn.selected = YES;
    self.graphicBtn.selected = NO;
    self.dataBtn.selected = NO;
    
    //2. 切换scrollView的View
    self.cyclingArgumentScrollView.contentOffset = CGPointMake(0, 0);
    
    //3. 设置轨迹界面数据
    [self setTrailData];
}

/**
 *  图表按钮点击
 */
- (IBAction)graphicBtnClick
{
    //1. 设置选中状态
    self.trailBtn.selected = NO;
    self.graphicBtn.selected = YES;
    self.dataBtn.selected = NO;
    
    //2. 切换scrollView的View
    CGFloat offsetX = self.view.bounds.size.width;
    self.cyclingArgumentScrollView.contentOffset = CGPointMake(offsetX, 0);
}

/**
 *  数据按钮点击
 */
- (IBAction)dataBtnClick
{
    //1. 设置选中状态
    self.trailBtn.selected = NO;
    self.graphicBtn.selected = NO;
    self.dataBtn.selected = YES;
    
    //2. 切换scrollView的View
    CGFloat offsetX = self.view.bounds.size.width * 2;
    self.cyclingArgumentScrollView.contentOffset = CGPointMake(offsetX, 0);
    
    //3. 刷新tableView
    [self.detialTableView reloadData];
}


#pragma mark - 设置轨迹界面数据

- (void)setTrailData
{
    self.routeNameLabel.text = self.route.routeName;
    self.distanceLabel.text = self.route.distance;
    self.timeLabel.text = self.route.time;
    self.ascendAltitudeLabel.text = self.route.ascendAltitude;
    self.averageSpeedLabel.text = self.route.averageSpeed;
}


#pragma mark - 设置骑行详细数据

- (void)setDetailData
{
    self.detialTableView.delegate = self;
    self.detialTableView.dataSource = self;
    self.detialTableView.sectionFooterHeight = 0;
    self.detialTableView.sectionHeaderHeight = 20;
    self.detialTableView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);
    
    [self addGroup0];
    [self addGroup1];
    [self addGroup2];
    [self addGroup3];
}

- (void)addGroup0
{
    //数据部分
    ACCyclingDetailModel *cell0 = [ACCyclingDetailModel settingCellWithTitle:@"运动里程" subTitle:self.route.distance];
    
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    group.cellList = @[cell0];
    group.headerText = @"里程(km)";
    
    [self.dataList addObject:group];
}

- (void)addGroup1
{
    ACCyclingDetailModel *cell0 = [ACCyclingDetailModel settingCellWithTitle:@"平均速度" subTitle:self.route.averageSpeed];
    ACCyclingDetailModel *cell1 = [ACCyclingDetailModel settingCellWithTitle:@"极速" subTitle:self.route.maxSpeed];
    
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    group.cellList = @[cell0, cell1];
    group.headerText = @"速度(km/h)";
    
    [self.dataList addObject:group];
}

- (void)addGroup2
{
    ACCyclingDetailModel *cell0 = [ACCyclingDetailModel settingCellWithTitle:@"累计上升" subTitle:self.route.ascendAltitude];
    NSString *range = [NSString stringWithFormat:@"%@~%@", self.route.minAltitude, self.route.maxAltitude];
    ACCyclingDetailModel *cell1 = [ACCyclingDetailModel settingCellWithTitle:@"海拔范围" subTitle:range];
    
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    group.cellList = @[cell0, cell1];
    group.headerText = @"海拔(m)";
    
    [self.dataList addObject:group];
}

- (void)addGroup3
{
    ACCyclingDetailModel *cell0 = [ACCyclingDetailModel settingCellWithTitle:@"骑行时间" subTitle:self.route.time];
    NSString *creatTimeStr = [NSDate dateToString:self.route.createdAt WithFormatter:@"yyyy-MM-dd HH:mm"];
    ACCyclingDetailModel *cell1 = [ACCyclingDetailModel settingCellWithTitle:@"开始时间" subTitle:creatTimeStr];
    NSString *endTimeStr = [NSDate dateToString:self.route.cyclingEndTime WithFormatter:@"yyyy-MM-dd HH:mm"];
    ACCyclingDetailModel *cell2 = [ACCyclingDetailModel settingCellWithTitle:@"结束时间" subTitle:endTimeStr];
    
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    group.cellList = @[cell0, cell1, cell2];
    group.headerText = @"时间(h:m)";
    
    [self.dataList addObject:group];
}

#pragma mark - scrollView代理

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint currentPoint = scrollView.contentOffset;
    //根据偏移量计算出是第几个view
    //加上0.5进行四舍五入
    NSInteger page =  currentPoint.x / self.view.bounds.size.width + 0.5;
    
    //根据page切换button
    switch (page) {
        case 0:{    //轨迹
            self.trailBtn.selected = YES;
            self.graphicBtn.selected = NO;
            self.dataBtn.selected = NO;
            break;
        }
        case 1:{    //图表
            self.trailBtn.selected = NO;
            self.graphicBtn.selected = YES;
            self.dataBtn.selected = NO;
            break;
        }
        case 2:{    //数据
            self.trailBtn.selected = NO;
            self.graphicBtn.selected = NO;
            self.dataBtn.selected = YES;
            
            //添加数据View的数据
            [self.detialTableView reloadData];
            break;
        }
        default:
            break;
    }
    
}


#pragma mark - tableView代理方法和数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataList[section] cellList].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCyclingDetailCell *cell = [ACCyclingDetailCell settingViewCellWithTableView:tableView];
    
    //取分组模型
    ACSettingGroupModel *group = self.dataList[indexPath.section];
    //取cell模型
    ACCyclingDetailModel *cellModel = group.cellList[indexPath.row];
    
    cell.cellModel = cellModel;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //取分组模型
    ACSettingGroupModel *group = self.dataList[section];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = group.headerText;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    
    return label;
}

#pragma mark - 约束

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    //动态修改约束
    //设置scrollView的contentView的宽度为两个屏的宽度
    self.contentViewWidth.constant = CGRectGetWidth([UIScreen mainScreen].bounds) * 3;
    self.middleViewLeading.constant = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.rightViewLeading.constant = CGRectGetWidth([UIScreen mainScreen].bounds) * 2;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
