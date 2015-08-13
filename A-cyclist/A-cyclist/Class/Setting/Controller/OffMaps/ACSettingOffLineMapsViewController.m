//
//  ACSettingOffLineMapsViewController.m
//  A-cyclist
//
//  Created by tunny on 15/8/13.
//  Copyright (c) 2015年 tunny. All rights reserved.
//  根据cityID将已下载的离线地图状态存储到偏好设置

#import "ACSettingOffLineMapsViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "ACBlankSettingCellModel.h"
#import "ACSettingGroupModel.h"
#import "ACGlobal.h"
#import "ACCacheDataTool.h"
#import "ACShowAlertTool.h"
#import "MRCircularProgressView.h"


#define ACViewSize    self.view.bounds.size


@interface ACSettingOffLineMapsViewController () <BMKOfflineMapDelegate, UIAlertViewDelegate>
/** 离线地图 */
@property (nonatomic, strong) BMKOfflineMap* offlineMap;

/** 全国支持离线地图的城市 */
@property (nonatomic, strong) NSArray *arrayOfflineCityData;
/** 选中的城市中数组的最后一个子城市 */
@property (nonatomic, strong) NSString *lastChildCityName;
/** 当前选中的城市 */
@property (nonatomic, strong) BMKOLSearchRecord *currentItem;
/** 当前选中的行 */
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
/** 纪录是否正在下载 */
@property (nonatomic, assign) BOOL isDownload;


/** 进度条 */
@property (nonatomic, strong) MRCircularProgressView *progressView;
/** 蒙板 */
@property (nonatomic, strong) UIView *placeView;
@end

@implementation ACSettingOffLineMapsViewController

- (UIView *)placeView
{
    if (_placeView == nil) {
        
        _placeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ACViewSize.width, ACViewSize.height + 20)];
        _placeView.backgroundColor = [UIColor lightGrayColor];
        _placeView.alpha = 0.8;
        _placeView.hidden = YES;
        [self.view addSubview:_placeView];
    }
    
    return _placeView;
}

- (MRCircularProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[MRCircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _progressView.center = CGPointMake(ACViewSize.width * 0.5, ACViewSize.height * 0.5);
        
        [self.placeView addSubview:_progressView];
    }
    
    return _progressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"下载离线地图";
    
    //返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonAction)];
     self.navigationItem.leftBarButtonItem = back;
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    //初始化离线地图服务
    self.offlineMap = [[BMKOfflineMap alloc]init];
    //获取支持离线下载城市列表
    self.arrayOfflineCityData = [_offlineMap getOfflineCityList];
    
    //加载数据
    [self addData];
}

-(void)viewWillAppear:(BOOL)animated {
    //    [_mapView viewWillAppear];
    //    _mapView.delegate = self;
    _offlineMap.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    //    [_mapView viewWillDisappear];
    //    _mapView.delegate = nil; // 不用时，置nil
    _offlineMap.delegate = nil; // 不用时，置nil
}

/**
 *  返回按钮点击
 */
- (void)buttonAction
{
    if (!self.placeView.hidden) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"下载未完成,确定退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    } else {
        CATransition *caTran = [[CATransition alloc] init];
        caTran.duration = 2.0;
        caTran.delegate  = self;
        caTran.type = @"rippleEffect";
        [self.navigationController.view.layer addAnimation:caTran forKey:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        DLog(@"取消");
    } else {
        //删除当前选中城市的离线地图
        [self.offlineMap remove:self.currentItem.cityID];
        //隐藏进度条
        self.progressView.hidden = YES;
        
        CATransition *caTran = [[CATransition alloc] init];
        caTran.duration = 2.0;
        caTran.delegate  = self;
        caTran.type = @"rippleEffect";
        [self.navigationController.view.layer addAnimation:caTran forKey:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)addData
{
    NSMutableArray *cities = [NSMutableArray array];
    [self.arrayOfflineCityData enumerateObjectsUsingBlock:^(BMKOLSearchRecord* item, NSUInteger idx, BOOL *stop) {
        //subTitle转换包大小
        NSString *subTitle = [self getDataSizeString:item.size];
        //1. 从偏好设置中取出subTitle
        NSString *citySubTitle = [ACCacheDataTool objectForKeyFromPlist:item.cityName];
        if ([citySubTitle isEqualToString:@"已下载"]) {
            subTitle = citySubTitle;
        }
        
        ACBlankSettingCellModel *blank = [ACBlankSettingCellModel blankSettingCellWithTitle:item.cityName subTitle:subTitle icon:nil];
        
        blank.option = ^(NSIndexPath *indexPath){
            self.currentIndexPath = indexPath;
            self.currentItem =  self.arrayOfflineCityData[indexPath.row];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *downloadAction = [UIAlertAction actionWithTitle:@"下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                self.currentItem =  self.arrayOfflineCityData[indexPath.row];
                self.lastChildCityName = [(BMKOLSearchRecord *)[self.currentItem.childCities lastObject] cityName];;
                if (!self.lastChildCityName) {
                    self.lastChildCityName = self.currentItem.cityName;
                }
                DLog(@"开始下载 item.cityID is %d, lastChildCityName is %@", self.currentItem.cityID, self.lastChildCityName);
                [self.offlineMap start:self.currentItem.cityID];

            }];
            UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                self.currentItem =  self.arrayOfflineCityData[indexPath.row];
                BOOL isSuccessful = [self.offlineMap remove:self.currentItem.cityID];
                if (isSuccessful) {
                    //2. 修改对应Cell的subTitle
                    ACSettingGroupModel *groupModel = self.dataList[self.currentIndexPath.section];
                    ACBlankSettingCellModel *blankCellModel = groupModel.cellList[self.currentIndexPath.row];
                    blankCellModel.subTitle = [self getDataSizeString:self.currentItem.size];
                    [self.tableView reloadData];
                    //3. 保存偏好设置
                    [ACCacheDataTool setObjectToPlist:blankCellModel.subTitle forKey:self.currentItem.cityName];
                }
                
            }];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [alertController addAction:downloadAction];
            [alertController addAction:removeAction];
            [alertController addAction:cancleAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        };
        
        [cities addObject:blank];
    }];
    
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    group.cellList = cities;
    
    [self.dataList addObject:group];
}


#pragma mark - 离线地图代理
//离线地图delegate，用于获取通知
- (void)onGetOfflineMapState:(int)type withState:(int)state
{
    
    if (type == TYPE_OFFLINE_UPDATE) {
        //id为state的城市正在下载或更新，start后会毁掉此类型
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
        NSLog(@"城市名：%@,下载比例:%d, 匹配的城市名: %@",updateInfo.cityName,updateInfo.ratio, self.lastChildCityName);
        
        if (updateInfo.cityName) {
            [self.progressView setProgress:updateInfo.ratio * 0.01 animated:YES];
            self.progressView.valueLabel.text = updateInfo.cityName;
            if ([updateInfo.cityName isEqualToString:self.lastChildCityName] && 100 == updateInfo.ratio) {
                //1. 说明子城市都已经下载完成了,隐藏进度条
                self.placeView.hidden = YES;
                //2. 修改对应Cell的subTitle
                ACSettingGroupModel *groupModel = self.dataList[self.currentIndexPath.section];
                ACBlankSettingCellModel *blankCellModel = groupModel.cellList[self.currentIndexPath.row];
                blankCellModel.subTitle = @"已下载";
                [self.tableView reloadData];
                //3. 保存偏好设置
                [ACCacheDataTool setObjectToPlist:@"已下载" forKey:self.currentItem.cityName];
                
            } else {
                self.placeView.hidden = NO;
            }
        } else {
            self.placeView.hidden = YES;
        }
        
    }
    if (type == TYPE_OFFLINE_NEWVER) {
        //id为state的state城市有新版本,可调用update接口进行更新
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
        NSLog(@"是否有更新%d",updateInfo.update);
    }
    if (type == TYPE_OFFLINE_UNZIP) {
        //正在解压第state个离线包，导入时会回调此类型
    }
    if (type == TYPE_OFFLINE_ZIPCNT) {
        //检测到state个离线包，开始导入时会回调此类型
        NSLog(@"检测到%d个离线包",state);
        if(state==0)
        {
//            [self showImportMesg:state];
        }
    }
    if (type == TYPE_OFFLINE_ERRZIP) {
        //有state个错误包，导入完成后会回调此类型
        NSLog(@"有%d个离线包导入错误",state);
    }
    if (type == TYPE_OFFLINE_UNZIPFINISH) {
        NSLog(@"成功导入%d个离线包",state);
        //导入成功state个离线包，导入成功后会回调此类型
//        [self showImportMesg:state];
    }
    
}



#pragma mark 包大小转换工具类（将包大小转换成合适单位）
-(NSString *)getDataSizeString:(int) nSize
{
    NSString *string = nil;
    if (nSize<1024)
    {
        string = [NSString stringWithFormat:@"%dB", nSize];
    }
    else if (nSize<1048576)
    {
        string = [NSString stringWithFormat:@"%dK", (nSize/1024)];
    }
    else if (nSize<1073741824)
    {
        if ((nSize%1048576)== 0 )
        {
            string = [NSString stringWithFormat:@"%dM", nSize/1048576];
        }
        else
        {
            int decimal = 0; //小数
            NSString* decimalStr = nil;
            decimal = (nSize%1048576);
            decimal /= 1024;
            
            if (decimal < 10)
            {
                decimalStr = [NSString stringWithFormat:@"%d", 0];
            }
            else if (decimal >= 10 && decimal < 100)
            {
                int i = decimal / 10;
                if (i >= 5)
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 1];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 0];
                }
                
            }
            else if (decimal >= 100 && decimal < 1024)
            {
                int i = decimal / 100;
                if (i >= 5)
                {
                    decimal = i + 1;
                    
                    if (decimal >= 10)
                    {
                        decimal = 9;
                    }
                    
                    decimalStr = [NSString stringWithFormat:@"%d", decimal];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", i];
                }
            }
            
            if (decimalStr == nil || [decimalStr isEqualToString:@""])
            {
                string = [NSString stringWithFormat:@"%dMss", nSize/1048576];
            }
            else
            {
                string = [NSString stringWithFormat:@"%d.%@M", nSize/1048576, decimalStr];
            }
        }
    }
    else	// >1G
    {
        string = [NSString stringWithFormat:@"%dG", nSize/1073741824];
    }
    
    return string;
}



@end
