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
#import "NSString+Extension.h"
#import "HCHttpTool.h"
#import "ACWeatherModel.h"


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
/** 用户 */
@property (nonatomic, strong) ACUserModel *user;

/* 用户相关参数记录 */
/** 累计时间(单位秒) */
@property (nonatomic, assign) NSTimeInterval accruedTime;
/** 累计距离(km) */
@property (nonatomic, assign) CLLocationDistance accruedDistance;

/* 轨迹记录 */
/** 记录上一次的位置 */
@property (nonatomic, strong) CLLocation *preLocation;
/** 两次位置的距离差(单位米) */
@property (nonatomic, copy) NSString *distanceInterval;
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
/** 记录当前总路程(单位米) */
@property (nonatomic, assign) CLLocationDistance totleDistance;
/** 当前耗时 */
@property (weak, nonatomic) IBOutlet UILabel *currentTimeConsuming;
/** 记录当前消耗的秒数 */
@property (nonatomic, assign) NSTimeInterval totleTime;
/** 平均速度 */
@property (weak, nonatomic) IBOutlet UILabel *currentAverageSpeed;
/** 最高速度 */
@property (weak, nonatomic) IBOutlet UILabel *currentMaxSpeed;
/** 最大速度 m/s */
@property (nonatomic, assign) CLLocationSpeed maxSpeed;
/** 海拔高度 */
@property (weak, nonatomic) IBOutlet UILabel *altitude;
/** 最高海拔 */
@property (nonatomic, assign) CLLocationDistance maxAltitude;
/** 最低海拔 */
@property (nonatomic, assign) CLLocationDistance minAltitude;
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

//天气相关
/** 当前的位置 */
@property (nonatomic, strong) BMKUserLocation *currentLocation;
@property (weak, nonatomic) IBOutlet UILabel *weatherTempLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
/** 当前城市名 */
@property (nonatomic, copy) NSString *currentCity;
@property (weak, nonatomic) IBOutlet UILabel *PM25Label;


@end

@implementation ACCyclingViewController

- (ACRouteModel *)route
{
    if (_route == nil) {
        _route = [[ACRouteModel alloc] init];
    }
    
    return _route;
}

- (ACUserModel *)user
{
    if (_user == nil) {
        _user = [ACCacheDataTool getUserInfo];
    }
    
    return _user;
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
    
    //设置位置频率(单位：米;必须要在开始定位之前设置)
    [BMKLocationService setLocationDistanceFilter:10000.f];
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    [_bmkLocationService startUserLocationService];
    
    self.bmkMapView.showsUserLocation = YES;
    self.bmkMapView.userTrackingMode = BMKUserTrackingModeFollow;
    
    //2. 定时更新天气(3小时)
    NSTimer *timer = [NSTimer timerWithTimeInterval:(3600 * 3) target:self selector:@selector(getWeather) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    //3. 定时更新PM(6小时)
    NSTimer *PMtimer = [NSTimer timerWithTimeInterval:(3600 * 6) target:self selector:@selector(getPM25) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:PMtimer forMode:NSRunLoopCommonModes];
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
        self.route.cyclingStartTime = [NSDate date];
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
    if (self.totleDistance < 5) {
        //提示轨迹太短，不保存记录
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"xxxxx" message:@"本次轨迹太短，将不会被保存" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //结束，隐藏暂停和结束按钮，显示开始按钮
            [self hideBtn];
        }];
        
        [alertVc addAction:cancleAction];
        [alertVc addAction:sureAction];
        [self presentViewController:alertVc animated:YES completion:nil];
    } else {
        //1. 弹框提醒是否结束
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"xxxxx" message:@"确定结束本次骑行吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //1. 保存到数据库，以及缓存中
            [self saveRouteData];
            //2. 结束，隐藏暂停和结束按钮，显示开始按钮
            [self hideBtn];
            //3. 执行结束功能，分析此次骑行状态，跳转控制器
            [self performSegueWithIdentifier:@"cyclingArgument" sender:self.route];
            
        }];
        
        [alertVc addAction:cancleAction];
        [alertVc addAction:sureAction];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
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
    
    NSString *latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    NSString *altitude = [NSString stringWithFormat:@"%ld", (long)location.altitude];
    NSString *speed = [NSString stringWithFormat:@"%.2f", fabs(location.speed * 3.6)];
    ACStepModel *step = [ACStepModel stepModelWithLatitude:latitude longitude:longitude altitude:altitude currentSpeed:speed distanceInterval:self.distanceInterval];
    DLog(@"step is %@", step);
    
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
        self.distanceInterval = [NSString stringWithFormat:@"%.2f", distance];
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
        self.maxSpeed = self.maxSpeed >= fabs(location.speed) ? self.maxSpeed : fabs(location.speed);
        //海拔高度
        self.altitude.text = [NSString stringWithFormat:@"%.0f M", location.altitude];
        self.maxAltitude = self.maxAltitude >= location.altitude ? self.maxAltitude : location.altitude;
        self.minAltitude = self.minAltitude <= location.altitude ? self.minAltitude : location.altitude;
        //最高海拔
        self.route.maxAltitude = [NSString stringWithFormat:@"%.0f", self.maxAltitude];
        //最低海拔
        self.route.minAltitude = [NSString stringWithFormat:@"%.0f", self.minAltitude];
        
        //计算上坡下坡
        if (location.altitude - self.preLocation.altitude > 0) {
            //海拔上升、上坡
            self.ascendingTime += timeInterval;
            self.ascendingDistance += distance;
            //累计上升
            self.ascendingAltitude += (location.altitude - self.preLocation.altitude);
            
        } else if (location.altitude - self.preLocation.altitude < 0) {
            //海拔下降、下坡
            self.descendingTime += timeInterval;
            self.descendingDistance += distance;
            
        } else {
            //海拔不变、平地
            self.flatTime += timeInterval;
            self.flatDistance += distance;
        }
        
        DLog(@"这次距离：%f米\n, 这次耗时：%f秒\n, 瞬时速度:%fkm/h\n, 总路程：%f米\n, 总时间:%f秒\n, 平均速度:%f\n, 极速:%f\n", distance, timeInterval, location.speed * 3.6, self.totleDistance, self.totleTime, averageSpeed * 3.6, self.maxSpeed * 3.6);
    } else {
        //极速
        self.maxSpeed = fabs(location.speed);
        // 瞬时速度
        self.currentSpeed.text = [NSString stringWithFormat:@"%.2f", fabs(location.speed * 3.6)];
        //距离间隔
        self.distanceInterval = @"0";
        self.maxAltitude = location.altitude;
        self.minAltitude = 0;
    }
    //最高速度label
    self.currentMaxSpeed.text = [NSString stringWithFormat:@"%.2f", self.maxSpeed * 3.6];
    
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
    NSString *time = [NSString timeStrWithSeconds:self.totleTime];
    
    self.currentTimeConsuming.text = time;
//    DLog(@"%ld, %@", (long)self.totleTime, time);
}


#pragma mark - BMKLocationServiceDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.currentLocation = userLocation;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //0. 获取位置，返地理编码，设置位置label内容
        [self setUserZoneWith:userLocation];
        //1. 根据位置坐标获取天气(程序运行阶段只执行一次，其他用定时器获取天气)
        [self getWeather];
    });
    
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
//    DLog(@"%f", userLocation.heading.magneticHeading);
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
        //设置当前城市名称用于PM获取
        DLog(@"result.addressDetail.city is %@", result.addressDetail.city);
        NSRange preRange = [result.addressDetail.city rangeOfString:@"市"];
        DLog(@"preRange is %@", NSStringFromRange(preRange));
        self.currentCity = [result.addressDetail.city substringToIndex:preRange.location];
        DLog(@"userZone is %@, self.currentCity is %@", self.userZone.text, self.currentCity);
        
        //获取PM25的值；程序运行阶段只执行一次，剩下的由定时器负责
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self getPM25];
        });
    }
}


#pragma mark - 数据的存储操作
- (void)saveRouteData
{
    NSString *timeName = [NSDate dateToString:self.route.cyclingStartTime WithFormatter:@"yyyy-MM-dd HH:mm"];
    //设置唯一键
    self.route.routeOne = [NSString stringWithFormat:@"%@%@", self.user.objectId, timeName];
    self.route.routeName = timeName;
    self.route.steps = self.locationArrayM;
    self.route.distance = [NSNumber numberWithDouble:self.currentMileage.text.doubleValue];
    self.route.time = self.currentTimeConsuming.text;
    self.route.timeNumber = [NSNumber numberWithDouble:[NSString stringWithFormat:@"%.2f", self.totleTime].doubleValue];
    self.route.averageSpeed = [NSNumber numberWithDouble:self.currentAverageSpeed.text.doubleValue];
    self.route.maxSpeed = [NSNumber numberWithDouble:self.currentMaxSpeed.text.doubleValue];
    self.route.isShared = [NSNumber numberWithInt:0];
    self.route.userObjectId = self.user.objectId;
    
    //计算卡路里
    double weight = 60;
    if (self.user.weight) {
        weight = self.user.weight.doubleValue;
    }
    double kcal = self.route.averageSpeed.doubleValue * weight * 9.7 * (self.route.timeNumber.doubleValue / 3600);
    self.route.kcal = [NSNumber numberWithDouble:[NSString stringWithFormat:@"%.0f", kcal].doubleValue];
    
    //上下坡相关
    //    self.route.maxAltitude = [NSString stringWithFormat:@"%.0f", self.];
    //    self.route.minAltitude = nil;
    self.route.ascendAltitude = [NSString stringWithFormat:@"%.0f", self.ascendingAltitude];
    self.route.ascendTime = [NSString timeStrWithSeconds:self.ascendingTime];
    self.route.ascendDistance = [NSString stringWithFormat:@"%.2f", self.ascendingDistance * 0.001];
    self.route.flatTime = [NSString timeStrWithSeconds:self.flatTime];
    self.route.flatDistance = [NSString stringWithFormat:@"%.2f", self.flatDistance * 0.001];
    self.route.descendTime = [NSString timeStrWithSeconds:self.descendingTime];
    self.route.descendDistance = [NSString stringWithFormat:@"%.2f", self.descendingDistance * 0.001];
    
    //开始和结束时间
    self.route.cyclingEndTime = [NSDate date];
    
    DLog(@"route.steps is %@\n, route is %@", self.route.steps, self.route);
    //存储到缓存
    [ACCacheDataTool addRouteWith:self.route withUserObjectId:self.user.objectId];
    
    //存储到数据库
    [ACDataBaseTool addRouteWith:self.route userObjectId:self.user.objectId resultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            DLog(@"存储路线到数据库成功");
        } else {
            DLog(@"存储路线到数据库失败 error is %@", error);
        }
    }];
}

- (void)saveUserData
{
    self.accruedTime = self.user.accruedTime.doubleValue + self.totleTime;
    self.accruedDistance = self.user.accruedDistance.doubleValue + self.totleDistance;
    
    self.user.accruedTime = [NSNumber numberWithDouble:[NSString stringWithFormat:@"%.2f", self.accruedTime].doubleValue];
    self.user.accruedDistance = [NSNumber numberWithDouble:[NSString stringWithFormat:@"%.2f", self.accruedDistance].doubleValue];
    
    //存储到本地缓存
    [ACCacheDataTool updateUserInfo:self.user withObjectId:self.user.objectId];
    //存储到数据库
    [ACDataBaseTool updateUserInfoWith:self.user withResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            DLog(@"更新用户信息到数据库成功");
        } else {
            DLog(@"更新用户信息到数据库失败，error is %@", error);
        }
    }];
}


#pragma mark - 天气
- (void)getWeather
{
    //0. 获取位置，返地理编码，设置位置label内容(每3小时，跟随天气更新一次位置信息)
    [self setUserZoneWith:self.currentLocation];
    
    //获取天气和温度
    NSString *url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f", self.currentLocation.location.coordinate.latitude, self.currentLocation.location.coordinate.longitude];
    DLog(@"天气url is %@, currentLocation is %@", url, self.currentLocation);
    [HCHttpTool GET:url parameters:nil success:^(id responseObject) {
//        DLog(@"天气responseObject is %@", responseObject);
        //天气icon
        NSString *weatherIcon = [responseObject[@"weather"] firstObject][@"icon"];
        UIImage *weatherImg = [ACWeatherModel imageNameWithIcon:weatherIcon];
        
        //温度(得到的是绝对温度K)
        NSDictionary *main = responseObject[@"main"];
        NSNumber *weatherTemp = main[@"temp"];
        //温度转换(绝对温度－－>摄氏温度)
        NSString *tempStr = [NSString stringWithFormat:@"%.0f度", (weatherTemp.doubleValue - 273.15)];
        
        //设置天气和温度到View
        self.weatherTempLabel.text = tempStr;
        self.weatherImageView.image = weatherImg;
        DLog(@"icon is %@, temp is %@, tempStr is %@", weatherIcon, weatherTemp, tempStr);
        
    } failure:^(NSError *error) {
        DLog(@"天气 error is %@", error);
    }];
}

/**
 *  获取PM25
 */
- (void)getPM25
{
    //获取PM25
    NSString *cityUTF8 = [self.currentCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://web.juhe.cn:8080/environment/air/pm?city=%@&key=9ceadd86cbfb2d84b5e4219ff38e54b4", cityUTF8];
    DLog(@"PM25 url is %@", url);
    
    [HCHttpTool GET:url parameters:nil success:^(id responseObject) {
//        DLog(@"PM25 responseObject is %@", responseObject);
        NSArray *result = responseObject[@"result"];
        NSString *PM25 = [result firstObject][@"PM2.5"];
        self.PM25Label.text = PM25;
        DLog(@"PM25 is %@", PM25);
    } failure:^(NSError *error) {
        DLog(@"PM25 error is %@", error);
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
