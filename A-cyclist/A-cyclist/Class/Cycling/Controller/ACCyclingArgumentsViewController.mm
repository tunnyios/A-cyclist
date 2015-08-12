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
#import "ACCircleChartView.h"
#import "ACLineChartView.h"
#import "ACStepModel.h"
#import "ACSettingGroupModel.h"
#import "ACSettingCellModel.h"
#import "ACCyclingDetailCell.h"
#import "ACCyclingDetailModel.h"
#import "ACRouteModel.h"
#import "ACGlobal.h"
#import "NSDate+Extension.h"
#import "UIImage+Extension.h"
#import <BaiduMapAPI/BMapKit.h>
#import "ACUploadSharedRouteController.h"

@interface ACCyclingArgumentsViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, BMKMapViewDelegate>
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
@property (weak, nonatomic) IBOutlet BMKMapView *bmkMapView;
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
/** 轨迹 */
@property (nonatomic, strong) BMKPolyline *polyLine;
/** 起点大头针 */
@property (nonatomic, strong) BMKPointAnnotation *startPoint;
/** 终点大头针 */
@property (nonatomic, strong) BMKPointAnnotation *endPoint;


/* 图表界面属性 */
/** circleChartView */
@property (weak, nonatomic) IBOutlet ACCircleChartView *circleChartView;
/** lineChartView */
@property (weak, nonatomic) IBOutlet ACLineChartView *lineChartView;
/** 最高海拔 */
@property (weak, nonatomic) IBOutlet UILabel *chartMaxAltitudeLabel;
/** 极速 */
@property (weak, nonatomic) IBOutlet UILabel *chartMaxSpeedLabel;
/** 上坡耗时 */
@property (weak, nonatomic) IBOutlet UILabel *chartAscendTimeLabel;
/** 上坡距离 */
@property (weak, nonatomic) IBOutlet UILabel *charAscendDistanceLabel;
/** 平地耗时 */
@property (weak, nonatomic) IBOutlet UILabel *chartFlatTimeLabel;
/** 平地距离 */
@property (weak, nonatomic) IBOutlet UILabel *charFlatDistanceLabel;
/** 下坡耗时 */
@property (weak, nonatomic) IBOutlet UILabel *chartDescendTimeLabel;
/** 下坡距离 */
@property (weak, nonatomic) IBOutlet UILabel *chartDescendDistanceLabel;

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
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //1. 最先展示轨迹
    [self trailBtnClick];
    //2. 加载轨迹详细数据
    [self setDetailData];
    [self setGraphicData];
    self.circleChartView.route = self.route;
    
    DLog(@"######route %@", self.route);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [_bmkMapView viewWillAppear];
    _bmkMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_bmkMapView viewWillDisappear];
    _bmkMapView.delegate = nil; // 不用时，置nil
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
    [ self onGetWalkPolyline];
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
    
    //3. 设置数据，刷新绘图
    [self setGraphicData];
    [self.circleChartView setNeedsDisplay];
    [self.lineChartView setNeedsDisplay];
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

/**
 *  点击上传路线按钮
 */
- (IBAction)uploadRoute:(id)sender
{
    //1. 截屏:截取路线地图图片
//    UIImage *newImage = [UIImage imageWithCaptureView:self.bmkMapView];
    UIImage *newImage = [self.bmkMapView takeSnapshot];
    DLog(@"newImage is %@", newImage);
    NSArray *array = @[newImage, self.route];
    [self performSegueWithIdentifier:@"route2share" sender:array];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ACUploadSharedRouteController *sharedRoute = segue.destinationViewController;
    sharedRoute.routeMapImage = sender[0];
    sharedRoute.route = sender[1];
}


#pragma mark - 设置轨迹界面数据

- (void)setTrailData
{
    self.routeNameLabel.text = self.route.routeName;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@", self.route.distance];
    self.timeLabel.text = self.route.time;
    self.ascendAltitudeLabel.text = self.route.ascendAltitude;
    self.averageSpeedLabel.text = [NSString stringWithFormat:@"%@", self.route.averageSpeed];
    
    //这是地图轨迹
    
}

/**
 *  绘制骑行轨迹路线
 */
- (void)onGetWalkPolyline
{
    //移除原有的绘图
    if (self.polyLine) {
        [_bmkMapView removeOverlay:self.polyLine];
    }
    if (self.startPoint) {
        [_bmkMapView removeAnnotation:self.startPoint];
    }
    if (self.endPoint) {
        [_bmkMapView removeAnnotation:self.endPoint];
    }
    
    //轨迹点
    NSUInteger count = self.route.steps.count;
    __block BMKMapPoint *tempPoints = new BMKMapPoint[count];
    
    [self.route.steps enumerateObjectsUsingBlock:^(ACStepModel *step, NSUInteger idx, BOOL *stop) {
        
        CLLocationDegrees latitude = [step.latitude doubleValue];
        CLLocationDegrees longitude = [step.longitude doubleValue];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        BMKMapPoint locationPoint = BMKMapPointForCoordinate(location.coordinate);
        tempPoints[idx] = locationPoint;
        
        //设置起点
        if (idx == 0) {
            self.startPoint = [self creatPointWithLocaiton:location title:@"起点"];
        }
        //设置终点
        if (idx == count - 1) {
            self.endPoint = [self creatPointWithLocaiton:location title:@"终点"];
        }
    }];
    
    // 通过points构建BMKPolyline
    self.polyLine = [BMKPolyline polylineWithPoints:tempPoints count:count];
    
    //添加路线,绘图
    if (self.polyLine) {
        [_bmkMapView addOverlay:self.polyLine];
    }
    delete []tempPoints;
    [self mapViewFitPolyLine:self.polyLine];
}

/**
 *  添加一个大头针
 *
 *  @param location
 */
- (BMKPointAnnotation *)creatPointWithLocaiton:(CLLocation *)location title:(NSString *)title;
{
    BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
    point.coordinate = location.coordinate;
    point.title = title;
    
    [_bmkMapView addAnnotation:point];
    
    return point;
}

/**
 *  根据polyline设置地图范围
 *
 *  @param polyLine
 */
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_bmkMapView setVisibleMapRect:rect];
    _bmkMapView.zoomLevel = _bmkMapView.zoomLevel - 0.3;
}


#pragma mark - BMKMapViewDelegate

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

/**
 *  只有在添加大头针的时候会调用，直接在viewDidload中不会调用
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"renameMark";
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
        annotationView.pinColor = BMKPinAnnotationColorPurple;
        // 从天上掉下效果
        annotationView.animatesDrop = YES;
        // 设置可拖拽
        annotationView.draggable = YES;
    }
    return annotationView;
}


#pragma mark - 设置图表界面数据
- (void)setGraphicData
{
    self.chartMaxAltitudeLabel.text = self.route.maxAltitude;
    self.chartMaxSpeedLabel.text = [NSString stringWithFormat:@"%@", self.route.maxSpeed];
 
    self.chartAscendTimeLabel.text = self.route.ascendTime;
    self.charAscendDistanceLabel.text = [NSString stringWithFormat:@"%@ km",self.route.ascendDistance];
    self.chartFlatTimeLabel.text = self.route.flatTime;
    self.charFlatDistanceLabel.text = [NSString stringWithFormat:@"%@ km",self.route.flatDistance];
    self.chartDescendTimeLabel.text = self.route.descendTime;
    self.chartDescendDistanceLabel.text = [NSString stringWithFormat:@"%@ km",self.route.descendDistance];
    self.circleChartView.route = self.route;
    self.lineChartView.route = self.route;
}


#pragma mark - 设置详细数据界面数据
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
    ACCyclingDetailModel *cell0 = [ACCyclingDetailModel settingCellWithTitle:@"运动里程" subTitle:[NSString stringWithFormat:@"%@", self.route.distance]];
    
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    group.cellList = @[cell0];
    group.headerText = @"里程(km)";
    
    [self.dataList addObject:group];
}

- (void)addGroup1
{
    ACCyclingDetailModel *cell0 = [ACCyclingDetailModel settingCellWithTitle:@"平均速度" subTitle:[NSString stringWithFormat:@"%@", self.route.averageSpeed]];
    ACCyclingDetailModel *cell1 = [ACCyclingDetailModel settingCellWithTitle:@"极速" subTitle:[NSString stringWithFormat:@"%@", self.route.maxSpeed]];
    
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
    NSString *creatTimeStr = [NSDate dateToString:self.route.cyclingStartTime WithFormatter:@"yyyy-MM-dd HH:mm"];
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
