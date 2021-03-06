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
#import "ACUtility.h"
#import "NSDate+Extension.h"
#import "UIImage+Extension.h"
#import "UIColor+Tools.h"
#import "ACUploadSharedRouteController.h"
#import "ACUserModel.h"
#import "ACCacheDataTool.h"
#import "ACDataBaseTool.h"
#import "ACSharedTitleView.h"
#import "ACAnnotationView.h"
#import "ACAnnotationStartModel.h"
#import "ACAnnotationEndModel.h"
#import "UMSocial.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface ACCyclingArgumentsViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, BMKMapViewDelegate, UMSocialUIDelegate>
/** 约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleViewLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightViewLeading;

/** storyboard中的属性 */
@property (weak, nonatomic) IBOutlet UIButton *trailBtn;
@property (weak, nonatomic) IBOutlet UIButton *graphicBtn;
@property (weak, nonatomic) IBOutlet UIButton *dataBtn;
@property (weak, nonatomic) IBOutlet UIButton *sharedBtn;
@property (weak, nonatomic) IBOutlet UIView *argumentView;
@property (weak, nonatomic) IBOutlet UIView *speedView;
@property (weak, nonatomic) IBOutlet UIView *climbingView;
@property (weak, nonatomic) IBOutlet UIView *dateView;

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
/** 消耗热量 */
@property (weak, nonatomic) IBOutlet UILabel *kcalLabel;
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

/** 当前用户 */
@property (nonatomic, strong) ACUserModel *currentUser;
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
    _bmkMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    
    //判断当前用户与该路线的来源用户是否一致，若不一致，则隐藏上传路线按钮
    //此处不能用懒加载
    self.currentUser = [ACCacheDataTool getUserInfo];
    if (0 != self.currentUser.objectId.length && 0 != self.route.userObjectId.length) {
        if (![self.currentUser.objectId isEqualToString:self.route.userObjectId]) {
            //隐藏上传路线按钮
            self.sharedBtn.hidden = YES;
        } else {
            self.sharedBtn.hidden = NO;
        }
    } else {
        self.sharedBtn.hidden = NO;
    }
    
    //判断路线是否已分享
    if ([self.route.isShared isEqual:@1]) {
        //已分享，修改button
        [self.sharedBtn setTitle:@"删除已上传路线" forState:UIControlStateNormal];
    } else {
        [self.sharedBtn setTitle:@"上传热门路线" forState:UIControlStateNormal];
    }
    
    //1. 最先展示轨迹
    [self trailBtnClick];
    //2. 加载轨迹详细数据
    [self setDetailData];
    [self setGraphicData];
    self.circleChartView.route = self.route;
    
    DLog(@"route %@", self.route);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    DLog(@"cyclistArguments dealloc");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_bmkMapView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    //0. 判断路线是否已经分享过了
    if ([self.route.isShared isEqual:@1]) {
        //删除已分享路线
        [self showAlertWithTitle:@"提示" message:@"确定要移除已分享的路线吗？" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" handler:^{
           //delete
            __weak typeof (self)weakSelf = self;
            [ACDataBaseTool delPersonSharedRouteWithObjectId:self.route.personSharedRouteId resultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSDictionary *dict = @{@"isShared" : @0,
                                           @"personSharedRoute" : @""
                                           };
                    [ACDataBaseTool updateRouteWithUserObjectId:weakSelf.route.userObjectId routeStartDate:weakSelf.route.cyclingStartTime dict:dict andKeys:@[@"isShared", @"personSharedRoute"] withResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            weakSelf.route.isShared = @0;
                            //更新缓存
                            [ACCacheDataTool updateRouteWith:weakSelf.route routeOne:weakSelf.route.routeOne];
                            [weakSelf showMsgCenter:@"移除已分享路线成功"];
                        } else {
                            [weakSelf showMsgCenter:@"移除已分享路线失败，请稍后再试"];
                        }
                    }];
                } else {
                    [weakSelf showMsgCenter:@"移除已分享路线失败，请稍后再试"];
                }
            }];
        }];
        
    } else {
        //1. 截屏:截取路线地图图片
        UIImage *newImage = [self.bmkMapView takeSnapshot];
//        DLog(@"newImage is %@", newImage);
//        NSArray *array = @[newImage, self.route];
//        [self performSegueWithIdentifier:@"route2share" sender:array];
        
        ACUploadSharedRouteController *sharedRoute = [[UIStoryboard storyboardWithName:@"cycling" bundle:nil] instantiateViewControllerWithIdentifier:@"ACUploadSharedRouteController"];
        __weak typeof (self)weakSelf = self;
        sharedRoute.option = ^(BOOL isShared) {
            if (isShared) {
                //设置已共享
                weakSelf.route.isShared = @1;
                [weakSelf.sharedBtn setTitle:@"删除已上传路线" forState:UIControlStateNormal];
            }
        };
        sharedRoute.routeMapImage = newImage;
        sharedRoute.route = self.route;
        [self.navigationController pushViewController:sharedRoute animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ACUploadSharedRouteController *sharedRoute = segue.destinationViewController;
    __weak typeof (self)weakSelf = self;
    sharedRoute.option = ^(BOOL isShared) {
        if (isShared) {
            //设置已共享
            weakSelf.route.isShared = @1;
            [weakSelf.sharedBtn setTitle:@"删除已上传路线" forState:UIControlStateNormal];
        }
    };
    sharedRoute.routeMapImage = sender[0];
    sharedRoute.route = sender[1];
}

#pragma mark - 分享
/**
 *  点击了分享按钮
 */
- (IBAction)sharedBtnClick:(id)sender
{
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToSina, UMShareToWechatSession, UMShareToWechatTimeline]];
    //设置只分享图片
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeImage;
    [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeImage;
    //1.截图
    ACSharedTitleView *titleView = [ACSharedTitleView sharedTitleView];
    titleView.dateStr = [NSDate dateToString:self.route.cyclingStartTime WithFormatter:@"yyyy-MM-dd"];
    UIImage *titleImage = [UIImage imageWithCaptureView:titleView];
    UIImage *mapImage = [self.bmkMapView takeSnapshot];
    UIImage *argumentsImage = [UIImage imageWithCaptureView:self.argumentView];
    UIImage *speedImage = [UIImage imageWithCaptureView:self.speedView];
    UIImage *climbingImage = [UIImage imageWithCaptureView:self.climbingView];
    //2.拼图
    UIImage *newImage = [self imageWithImageArray:@[titleImage, mapImage, argumentsImage, speedImage, climbingImage]];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:ACYouMengAppKey
                                      shareText:nil
                                     shareImage:newImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:self];
}

/**
 *  友盟分享的回掉方法
 */
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        [self showMsgCenter:@"分享成功"];
//        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

/**
 *  拼接需要分享的图片
 */
- (UIImage *)imageWithImageArray:(NSArray *)imageArray
{
    __block CGFloat newImgW = [UIScreen mainScreen].bounds.size.width;
    __block CGFloat newImgH = 0;
    
    [imageArray enumerateObjectsUsingBlock:^(UIImage *img, NSUInteger idx, BOOL *stop) {
        //        newImgW = newImgW > img.size.width ? newImgW : img.size.width;
        if (1 == idx) {
            newImgH += img.size.height * 0.5 + 5;
        } else {
            newImgH += img.size.height + 5;
        }
    }];
    
    CGSize newImgSize= CGSizeMake(newImgW,newImgH);
    //    UIGraphicsBeginImageContext(newImgSize);
    UIGraphicsBeginImageContextWithOptions(newImgSize, NO, 0.0);
    
    //draw
    UIImage *bgImg = [UIImage imageNamed:@"login_textfield_mid"];
    [bgImg drawInRect:CGRectMake(0, 0, newImgW, newImgH)];
    
    CGFloat tempY = 0;
    for (int i = 0; i < imageArray.count; i++) {
        if (2 == i) {
            UIImage *preImg = imageArray[i - 1];
            tempY += (preImg.size.height * 0.5 + 5);
        } else if (0 == i) {
        } else {
            UIImage *preImg = imageArray[i - 1];
            tempY += (preImg.size.height + 5);
        }
        
        if (1 == i) {
            UIImage *img = imageArray[i];
            [img drawInRect:CGRectMake(0, tempY, img.size.width * 0.5, img.size.height * 0.5)];
        } else {
            UIImage *img = imageArray[i];
            [img drawInRect:CGRectMake(0, tempY, img.size.width, img.size.height)];
        }
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}


#pragma mark - 设置轨迹界面数据

- (void)setTrailData
{
    self.routeNameLabel.text = self.route.routeName;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f", self.route.distance.doubleValue];
    self.timeLabel.text = self.route.time;
    self.kcalLabel.text = [NSString stringWithFormat:@"%@", self.route.kcal];
    self.ascendAltitudeLabel.text = self.route.ascendAltitude;
    self.averageSpeedLabel.text = [NSString stringWithFormat:@"%@", self.route.averageSpeed];
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
    BMKPointAnnotation *point;
    if ([title isEqualToString:@"起点"]) {
        point = [[ACAnnotationStartModel alloc] init];
    } else if ([title isEqualToString:@"终点"]) {
        point = [[ACAnnotationEndModel alloc] init];
    }
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
        polylineView.fillColor = [RGBColor(237, 65, 45, 1) colorWithAlphaComponent:1];
        polylineView.strokeColor = [RGBColor(237, 65, 45, 1) colorWithAlphaComponent:1];
        polylineView.lineWidth = 5.0;
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
    
    ACAnnotationView *annotationView = nil;
    if (annotationView == nil) {
        annotationView = [[ACAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    
    if ([annotation isKindOfClass:[ACAnnotationStartModel class]]) {
        annotationView.BMKimage = [UIImage imageNamed:@"Mine_runHistrotyDetails_startPoint"];
    } else if ( [annotation isKindOfClass:[ACAnnotationEndModel class]]) {
        annotationView.BMKimage = [UIImage imageNamed:@"Mine_runHistrotyDetails_endPoint"];
    }
    return annotationView;
}


#pragma mark - 设置图表界面数据
- (void)setGraphicData
{
//    self.chartMaxAltitudeLabel.text = self.route.maxAltitude;
    NSString *maxAltitudeStr = [NSString stringWithFormat:@"%@", self.route.maxAltitude];
    self.chartMaxAltitudeLabel.attributedText = [self creatDataLabelWithStr:[NSString stringWithFormat:@"%@m", maxAltitudeStr] unitCount:1 dataCount:maxAltitudeStr.length];
//    self.chartMaxSpeedLabel.text = [NSString stringWithFormat:@"%@", self.route.maxSpeed];
    NSString *maxSpeedStr = [NSString stringWithFormat:@"%@", self.route.maxSpeed];
    self.chartMaxSpeedLabel.attributedText = [self creatDataLabelWithStr:[NSString stringWithFormat:@"%@km/h", maxSpeedStr] unitCount:4 dataCount:maxSpeedStr.length];
 
    self.chartAscendTimeLabel.text = self.route.ascendTime;
    self.charAscendDistanceLabel.text = [NSString stringWithFormat:@"%@km",self.route.ascendDistance];
    self.chartFlatTimeLabel.text = self.route.flatTime;
    self.charFlatDistanceLabel.text = [NSString stringWithFormat:@"%@km",self.route.flatDistance];
    self.chartDescendTimeLabel.text = self.route.descendTime;
    self.chartDescendDistanceLabel.text = [NSString stringWithFormat:@"%@km",self.route.descendDistance];
    self.circleChartView.route = self.route;
    self.lineChartView.route = self.route;
}

/**
 *  生成最高海拔和最高速度的富文本字符串
 */
- (NSMutableAttributedString *)creatDataLabelWithStr:(NSString *)str unitCount:(NSInteger)unitCount dataCount:(NSInteger)dataCount;
{
    NSDictionary *speedFont = @{NSFontAttributeName : [UIFont systemFontOfSize:30.0f]};
    NSDictionary *kmFont = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]};
    
    NSArray *dictArray = @[@{@"textFormat" : speedFont,
                             @"loc" : @0,
                             @"len" : [NSNumber numberWithInteger:dataCount]},
                           @{@"textFormat" : kmFont,
                             @"loc" : [NSNumber numberWithInteger:dataCount],
                             @"len" : [NSNumber numberWithInteger:unitCount]}];
    return [ACUtility creatAttritudeStrWithStr:str dictArray:dictArray];
}


#pragma mark - 设置详细数据界面数据
- (void)setDetailData
{
    self.detialTableView.delegate = self;
    self.detialTableView.dataSource = self;
    self.detialTableView.sectionFooterHeight = 0;
    self.detialTableView.sectionHeaderHeight = 20;
    self.detialTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self addGroup0];
    [self addGroup1];
    [self addGroup2];
    [self addGroup3];
}

- (void)addGroup0
{
    //数据部分
    ACCyclingDetailModel *cell0 = [ACCyclingDetailModel settingCellWithTitle:@"运动里程" subTitle:[NSString stringWithFormat:@"%.2f", self.route.distance.doubleValue]];
    
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    [group.cellList addObject:cell0];
    group.headerText = @"  里程(km)";
    
    [self.dataList addObject:group];
}

- (void)addGroup1
{
    ACCyclingDetailModel *cell0 = [ACCyclingDetailModel settingCellWithTitle:@"平均速度" subTitle:[NSString stringWithFormat:@"%.2f", self.route.averageSpeed.doubleValue]];
    ACCyclingDetailModel *cell1 = [ACCyclingDetailModel settingCellWithTitle:@"极速" subTitle:[NSString stringWithFormat:@"%.2f", self.route.maxSpeed.doubleValue]];
    
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    [group.cellList addObject:cell0];
    [group.cellList addObject:cell1];
    group.headerText = @"  速度(km/h)";
    
    [self.dataList addObject:group];
}

- (void)addGroup2
{
    ACCyclingDetailModel *cell0 = [ACCyclingDetailModel settingCellWithTitle:@"累计上升" subTitle:self.route.ascendAltitude];
    NSString *range = [NSString stringWithFormat:@"%@~%@", self.route.minAltitude, self.route.maxAltitude];
    ACCyclingDetailModel *cell1 = [ACCyclingDetailModel settingCellWithTitle:@"海拔范围" subTitle:range];
    
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    [group.cellList addObject:cell0];
    [group.cellList addObject:cell1];
    group.headerText = @"  海拔(m)";
    
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
    [group.cellList addObject:cell0];
    [group.cellList addObject:cell1];
    [group.cellList addObject:cell2];
    group.headerText = @"  时间(h:m)";
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
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
