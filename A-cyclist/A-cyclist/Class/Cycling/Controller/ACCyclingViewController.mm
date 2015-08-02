//
//  ACCyclingViewController.m
//  A-cyclist
//
//  Created by tunny on 15/7/24.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACCyclingViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "ACGlobal.h"
#import "ACUserModel.h"
#import "ACRouteModel.h"
#import "ACStepModel.h"
#import "ACDataBaseTool.h"
#import "ACCacheDataTool.h"
#import "ACCyclingArgumentsViewController.h"
#import "ACNavigationViewController.h"
#import "NSDate+Extension.h"


typedef enum : NSUInteger {
    HCTrailPause = 0,
    HCTrailStart,
    HCTrailEnd,
} HCTrail;

@interface ACCyclingViewController () <BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>

/** contentView的width的约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
/** mapView的leading约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapViewLeading;
/** 开始按钮 */
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
/** 暂停按钮 */
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
/** 结束按钮 */
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
/** 百度地图 */
@property (weak, nonatomic) IBOutlet BMKMapView *bmkMapView;
/** 百度定位服务 */
@property (nonatomic, strong) BMKLocationService *bmkLocationService;
/** 计时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 路线对象 */
@property (nonatomic, strong) ACRouteModel *route;


/* 轨迹记录 */
/** 记录上一次的位置 */
@property (nonatomic, strong) CLLocation *preLocation;
/** 位置数组 */
@property (nonatomic, strong) NSMutableArray *locationArrayM;
/** 轨迹 */
@property (nonatomic, strong) BMKPolyline *polyLine;
/** 轨迹记录状态 */
@property (nonatomic, assign) HCTrail trail;
/** 起点大头针 */
@property (nonatomic, strong) BMKPointAnnotation *startPoint;
/** 终点大头针 */
@property (nonatomic, strong) BMKPointAnnotation *endPoint;

/* 骑行参数 */
/** 当前骑行者所处的地区 */
@property (weak, nonatomic) IBOutlet UILabel *userZone;
/** 瞬时速度 */
@property (weak, nonatomic) IBOutlet UILabel *currentSpeed;
/** 当前里程 */
@property (weak, nonatomic) IBOutlet UILabel *currentMileage;
/** 记录当前总路程 */
@property (nonatomic, assign) CLLocationDistance totleDistance;
/** 当前耗时 */
@property (weak, nonatomic) IBOutlet UILabel *currentTimeConsuming;
/** 记录当前消耗的秒数 */
@property (nonatomic, assign) NSTimeInterval totleTime;
/** 平均速度 */
@property (weak, nonatomic) IBOutlet UILabel *currentAverageSpeed;
/** 最高速度 */
@property (weak, nonatomic) IBOutlet UILabel *currentMaxSpeed;
/** 海拔高度 */
@property (weak, nonatomic) IBOutlet UILabel *altitude;
/** 指南针 */
@property (weak, nonatomic) IBOutlet UIImageView *compass;

/* 上下坡 */
/** 累计上升距离 */
@property (nonatomic, assign) CLLocationDistance ascendingAltitude;
/** 上坡时间 */
@property (nonatomic, assign) NSTimeInterval ascendingTime;
/** 上坡距离 */
@property (nonatomic, assign) CLLocationDistance ascendingDistance;
/** 下坡时间 */
@property (nonatomic, assign) NSTimeInterval descendingTime;
/** 下坡距离 */
@property (nonatomic, assign) CLLocationDistance descendingDistance;
/** 平地时间 */
@property (nonatomic, assign) NSTimeInterval flatTime;
/** 平地距离 */
@property (nonatomic, assign) CLLocationDistance flatDistance;

@end

@implementation ACCyclingViewController

- (ACRouteModel *)route
{
    if (_route == nil) {
        _route = [[ACRouteModel alloc] init];
    }
    
    return _route;
}

- (NSMutableArray *)locationArrayM
{
    if (_locationArrayM == nil) {
        _locationArrayM = [NSMutableArray array];
    }
    
    return _locationArrayM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //1. 定位
    _bmkLocationService = [[BMKLocationService alloc] init];
    
    //设置更新位置频率(单位：米;必须要在开始定位之前设置)
    [BMKLocationService setLocationDistanceFilter:10000.f];
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    [_bmkLocationService startUserLocationService];
    
    self.bmkMapView.showsUserLocation = YES;
    self.bmkMapView.userTrackingMode = BMKUserTrackingModeFollow;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [_bmkMapView viewWillAppear];
    _bmkMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _bmkLocationService.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_bmkMapView viewWillDisappear];
    _bmkMapView.delegate = nil; // 不用时，置nil
    _bmkLocationService.delegate = nil;
}

#pragma mark - 按钮的监听事件

/**
 *  开始骑行
 */
- (IBAction)start
{
    //1. 开启骑行前清理各个lable的数值
    [self cleanLabel];
    
    [UIView animateWithDuration:1.0f animations:^{
        //1. 隐藏开始骑行按钮
        self.startBtn.alpha = 0;
        //2. 显示暂停和完成按钮
        self.pauseBtn.alpha = 1;
        self.endBtn.alpha = 1;
        
    } completion:^(BOOL finished) {
        self.route.createdAt = [NSDate date];
        //3. 开始骑行功能
        [self startCycling];
    }];
    
    
}

/**
 *  启动或暂停
 */
- (IBAction)beginOrPause
{
    self.pauseBtn.selected = !self.pauseBtn.isSelected;
    if (self.pauseBtn.isSelected) {
        //暂停
        //1. 暂停耗时
        [self pauseTimer];
        //2. 暂停记录轨迹
        [self stopRecord];
        
    } else {
        //启动
        //1. 继续计算耗时
        [self continueTimer];
        [self continueRecord];
    }
}

/**
 *  结束后隐藏暂停完成按钮
 *  显示开始按钮
 */
- (void)hideBtn
{
    //1. 显示开始骑行按钮
    self.startBtn.alpha = 1;
    //2. 隐藏暂停和完成按钮
    self.pauseBtn.alpha = 0;
    self.endBtn.alpha = 0;
    //3. 设置暂停按钮不选中
    self.pauseBtn.selected = NO;
    //4. 停止记录
    [self stopRecord];
    //5. 停止计时
    [self stopTimer];
}

/**
 *  开启骑行前清理各个lable的数值
 */
- (void)cleanLabel
{
    self.totleTime = 0;
    self.totleDistance = 0;
    self.currentSpeed.text = @"0.00";
    self.currentMileage.text = @"0.00";
    self.currentTimeConsuming.text = @"00:00";
    self.currentAverageSpeed.text = @"0.00";
    self.currentMaxSpeed.text = @"0.00";
}

/**
 *  完成、结束骑行
 */
- (IBAction)endCycling
{
    //1. 弹框提醒是否结束
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"xxxxx" message:@"确定结束本次骑行吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //1. 保存到数据库，以及缓存中
        [self saveData];
        //2. 结束，隐藏暂停和结束按钮，显示开始按钮
        [self hideBtn];
        //3. 执行结束功能，分析此次骑行状态，跳转控制器
        [self performSegueWithIdentifier:@"cyclingArgument" sender:self.route];
        
    }];
    
    [alertVc addAction:cancleAction];
    [alertVc addAction:sureAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}

/**
 *  执行segue之前的准备工作
 *  在执行segue之前调用，一般用来在两个控制器之间传值
 *  两个控制器之间传值，一般都是在有数据的那个控制器里操作
 *  @param segue
 *  @param sender
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ACNavigationViewController *nav = segue.destinationViewController;
    ACCyclingArgumentsViewController *cyclingArgumentVc = [nav.viewControllers firstObject];

    cyclingArgumentVc.route = sender;
}

#pragma mark - 骑行操作

- (void)startCycling
{
    //1. 耗时
    [self startTimer];
    //2. 设置更新位置频率(单位：米;必须要在开始定位之前设置)
    [self.bmkLocationService stopUserLocationService];
    [BMKLocationService setLocationDistanceFilter:1];
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    [_bmkLocationService startUserLocationService];
    
    self.bmkMapView.showsUserLocation = YES;
    self.bmkMapView.userTrackingMode = BMKUserTrackingModeFollow;
    //3. 开始记录轨迹
    [self startRecord];
}

#pragma mark - 轨迹记录相关
/**
 *  开始记录轨迹
 */
- (void)startRecord
{
    //清理地图
    [self cleanMap];
    
    self.trail = HCTrailStart;
}

/**
 *  继续记录轨迹
 */
- (void)continueRecord
{
    self.trail = HCTrailStart;
}

- (void)pauseRecord
{
    self.trail = HCTrailPause;
}

/**
 *  停止记录轨迹
 */
- (void)stopRecord
{
    self.trail = HCTrailEnd;
}

/**
 *  开始记录轨迹
 *
 *  @param userLocation 实时更新的位置信息
 */
- (void)startTrailRouteWithUserLocation:(BMKUserLocation *)userLocation
{
    CLLocation *location = userLocation.location;
    NSString *latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    NSString *altitude = [NSString stringWithFormat:@"%ld", (long)location.altitude];
    ACStepModel *step = [ACStepModel stepModelWithLatitude:latitude longitude:longitude altitude:altitude];
    
    //1. 每5米记录一个点
    if (self.locationArrayM.count > 0) {
        CLLocationDistance distance = [location distanceFromLocation:self.preLocation];
        DLog(@"distance:%f", distance);
        if (distance < 5) {
            return;
        }
    }
    
    //2. 每5米更新一次参数信息
    [self updateCyclingParamsInfoWithLocation:location];
    
    //3. 记录
    [self.locationArrayM addObject:step];
    DLog(@"count %lu", (unsigned long)self.locationArrayM.count);
    self.preLocation = location;
    
    //4. 绘图
    [self onGetWalkPolyline];
}

/**
 *  每5米更新骑行界面参数
 *
 *  @param userLocation
 */
- (void)updateCyclingParamsInfoWithLocation:(CLLocation *)location
{
    /*
     // CLLocation
     location.coordinate; 坐标, 包含经纬度
     location.altitude; 设备海拔高度 单位是米
     location.course; 设置前进方向 0表示北 90东 180南 270西
     location.horizontalAccuracy; 水平精准度
     location.verticalAccuracy; 垂直精准度
     location.timestamp; 定位信息返回的时间
     location.speed; 设备移动速度 单位是米/秒, 适用于行车速度而不太适用于不行
     */
    if (self.preLocation) {
        //计算上一次和这一次的距离差(直线距离)，这次距离
        CLLocationDistance distance = [location distanceFromLocation:self.preLocation];
        //计算两次的时间差,这次耗时
        NSTimeInterval timeInterval = [location.timestamp timeIntervalSinceDate:self.preLocation.timestamp];
        
        //总路程
        self.totleDistance += distance;
        //总时间
        self.totleTime += timeInterval;
        //计算平均速度
        CLLocationSpeed averageSpeed = self.totleDistance / self.totleTime;
     
        // 瞬时速度
        self.currentSpeed.text = [NSString stringWithFormat:@"%.2f", fabs(location.speed * 3.6)];
        // 当前里程
        self.currentMileage.text = [NSString stringWithFormat:@"%.2f", self.totleDistance * 0.001];
        // 平均速度
        self.currentAverageSpeed.text = [NSString stringWithFormat:@"%.2f", averageSpeed * 3.6];
        // 最高速度
        CLLocationSpeed maxSpeed = fabs(location.speed) > fabs(self.preLocation.speed) ? fabs(location.speed) : fabs(self.preLocation.speed);
        self.currentMaxSpeed.text = [NSString stringWithFormat:@"%.2f", maxSpeed * 3.6];
        //海拔高度
        self.altitude.text = [NSString stringWithFormat:@"%.0f M", location.altitude];

        //计算上坡下坡
        if (location.altitude - self.preLocation.altitude > 0) {
            //海拔上升、上坡
            //最高海拔
            self.route.maxAltitude = [NSString stringWithFormat:@"%.0f", location.altitude];
            self.ascendingTime += timeInterval;
            self.ascendingDistance += distance;
            //累计上升
            self.ascendingAltitude += (location.altitude - self.preLocation.altitude);
            
        } else if (location.altitude - self.preLocation.altitude < 0) {
            //海拔下降、下坡
            //最低海拔
            self.route.minAltitude = [NSString stringWithFormat:@"%.0f", location.altitude];
            self.descendingTime += timeInterval;
            self.descendingDistance += distance;
            
        } else {
            //海拔不变、平地
            self.route.maxAltitude = [NSString stringWithFormat:@"%.0f", location.altitude];
            self.route.minAltitude = [NSString stringWithFormat:@"%.0f", location.altitude];
            self.flatTime += timeInterval;
            self.flatDistance += distance;
        }
        
        DLog(@"这次距离：%f米\n, 这次耗时：%f秒\n, 瞬时速度:%fkm/h\n, 总路程：%f米\n, 总时间:%f秒\n, 平均速度:%f\n", distance, timeInterval, location.speed * 3.6, self.totleDistance, self.totleTime, averageSpeed * 3.6);
    }
}

/**
 *  绘制骑行轨迹路线
 */
- (void)onGetWalkPolyline
{
    //轨迹点
    NSUInteger count = self.locationArrayM.count;
    BMKMapPoint *tempPoints = new BMKMapPoint[count];
    
    [self.locationArrayM enumerateObjectsUsingBlock:^(ACStepModel *step, NSUInteger idx, BOOL *stop) {
        
        CLLocationDegrees latitude = [step.latitude doubleValue];
        CLLocationDegrees longitude = [step.longitude doubleValue];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        BMKMapPoint locationPoint = BMKMapPointForCoordinate(location.coordinate);
        tempPoints[idx] = locationPoint;
        
        //设置起点
        if (!self.startPoint) {
            self.startPoint = [self creatPointWithLocaiton:location title:@"起点"];
        }
    }];
    
    //移除原有的绘图
    if (self.polyLine) {
        [_bmkMapView removeOverlay:self.polyLine];
    }
    
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
 *  清空数组以及地图上的轨迹
 */
- (void)cleanMap
{
    //清空数组
    [self.locationArrayM removeAllObjects];
    //清屏
    if (_startPoint) {
        [_bmkMapView removeAnnotation:self.startPoint];
    }
    if (_endPoint) {
        [_bmkMapView removeAnnotation:self.endPoint];
    }
    if (_polyLine) {
        [_bmkMapView removeOverlay:self.polyLine];
    }
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


#pragma mark - 耗时相关

- (void)startTimer
{
    //1. 设置计时器
    self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)pauseTimer
{
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)continueTimer
{
    [self.timer setFireDate:[NSDate date]];
}

- (void)stopTimer
{
    [self.timer invalidate];
}

- (void)updateTimer:(NSTimer *)timer
{
    self.totleTime += 1;
    NSString *time = [self dateWithSeconds:self.totleTime];
    
    self.currentTimeConsuming.text = time;
    DLog(@"%ld, %@", (long)self.totleTime, time);
}

- (NSString *)dateWithSeconds:(NSInteger)seconds
{
    NSInteger hour = seconds / (60 * 60);
    NSInteger minTemp = seconds % (60 * 60);
    NSInteger minute = minTemp / 60;
//    NSInteger second = minTemp % 60;
    
    NSString *time = [NSString stringWithFormat:@"%02ld:%02ld", (long)hour, (long)minute];
//    NSString *time = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hour, (long)minute, (long)second];
    
    return time;
}

#pragma mark - BMKLocationServiceDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //1. 获取位置，返地理编码，设置位置label内容
    [self setUserZoneWith:userLocation];
    
    //2. 轨迹记录
    [self.bmkMapView updateLocationData:userLocation];
    DLog(@"location:<%f, %f>", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    
    if (HCTrailStart == self.trail) {
        //开始记录轨迹
        [self startTrailRouteWithUserLocation:userLocation];
    } else if (HCTrailEnd == self.trail) {
        //设置终点大头针
        self.endPoint = [self creatPointWithLocaiton:userLocation.location title:@"终点"];
        self.trail = HCTrailPause;
    }
    
}

/**
 *  根据位置信息，返地理编码出骑行者当前所在的地区
 *
 *  @param userLocation
 */
- (void)setUserZoneWith:(BMKUserLocation *)userLocation
{
    //根据坐标返地理编码
    BMKGeoCodeSearch *geocodesearch = [[BMKGeoCodeSearch alloc] init];
    geocodesearch.delegate = self;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        DLog(@"反geo检索发送成功");
    }
    else
    {
        DLog(@"反geo检索发送失败");
    }

}


- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    DLog(@"%f", userLocation.heading.magneticHeading);
    //将角度转弧度
    CGFloat angle = (userLocation.heading.magneticHeading * M_PI) / 180;
    self.compass.layer.transform = CATransform3DMakeRotation(-angle, 0, 0, 1);
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


#pragma mark - BMKGeoCodeSearchDelegate

/**
 *  反地理编码结果
 *
 *  @param searcher
 *  @param result
 *  @param updateViewConstraints 
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        //设置骑行者当前的地区数据
        self.userZone.text = [NSString stringWithFormat:@"%@ %@", result.addressDetail.city, result.addressDetail.district];
        DLog(@"userZone is %@", self.userZone.text);
    }
}


#pragma mark - 数据的存储操作
- (void)saveData
{
    //1. 获取当前用户
    ACUserModel *userModel = [ACCacheDataTool getUserInfo];

    NSString *timeName = [NSDate dateToString:[NSDate date] WithFormatter:@"yyyy-MM-dd HH:mm"];
    self.route.routeName = timeName;
    self.route.steps = self.locationArrayM;
    self.route.distance = self.currentMileage.text;
    self.route.time = self.currentTimeConsuming.text;
    self.route.averageSpeed = self.currentAverageSpeed.text;
    self.route.maxSpeed = self.currentMaxSpeed.text;
    self.route.isShared = 0;
    self.route.hotLevel = nil;
    self.route.imageList = nil;
    self.route.userObjectId = userModel.objectId;
    
    //上下坡相关
    //    self.route.maxAltitude = [NSString stringWithFormat:@"%.0f", self.];
    //    self.route.minAltitude = nil;
    self.route.ascendAltitude = [NSString stringWithFormat:@"%.0f", self.ascendingAltitude];
    self.route.ascendTime = [self dateWithSeconds:self.ascendingTime];
    self.route.ascendDistance = [NSString stringWithFormat:@"%.2f", self.ascendingDistance * 0.001];
    self.route.flatTime = [self dateWithSeconds:self.flatTime];
    self.route.flatDistance = [NSString stringWithFormat:@"%.2f", self.flatDistance * 0.001];
    self.route.descendTime = [self dateWithSeconds:self.descendingTime];
    self.route.descendDistance = [NSString stringWithFormat:@"%.2f", self.descendingDistance * 0.001];
    
    //开始和结束时间
    self.route.cyclingEndTime = [NSDate date];
    
    DLog(@"route.steps is %@\n, route is %@", self.route.steps, self.route);
    //存储到缓存
    [ACCacheDataTool addRouteWith:self.route withUserObjectId:userModel.objectId];
    
    //存储到数据库
    [ACDataBaseTool addRouteWith:self.route userObjectId:userModel.objectId resultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            DLog(@"存储路线到数据库成功");
        } else {
            DLog(@"存储路线到数据库失败 error is %@", error);
        }
    }];
}


#pragma mark - 更新约束

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    /** 在这里更新约束 */
    //设置scrollView的contentView的宽度为两个屏的宽度
    self.contentViewWidth.constant = CGRectGetWidth([UIScreen mainScreen].bounds) * 2;
    self.mapViewLeading.constant = CGRectGetWidth([UIScreen mainScreen].bounds);
}

@end
