//
//  ACSettingProfileInfoViewController.m
//  A-cyclist
//
//  Created by tunny on 15/7/20.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACSettingProfileInfoViewController.h"
#import "ACCacheDataTool.h"
#import "ACDataBaseTool.h"
#import "ACUserModel.h"
#import "ACGlobal.h"
#import "ACBlankSettingCellModel.h"
#import "ACArrowWithSubtitleSettingCellModel.h"
#import "ACSettingGroupModel.h"
#import "ACSettingViewCell.h"
#import "ACPhotoSettingCellModel.h"
#import "ACChangeNameController.h"
#import <BaiduMapAPI/BMapKit.h>

@interface ACSettingProfileInfoViewController () <ACChangeNameDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>
/** 用户数据模型 */
@property (nonatomic, strong) ACUserModel *user;
/** 百度定位服务 */
@property (nonatomic, strong) BMKLocationService *bmkLocationService;
/** 地理位置信息 */
//@property (nonatomic, copy) NSString *userLocation;

@end

@implementation ACSettingProfileInfoViewController

- (BMKLocationService *)bmkLocationService
{
    if (_bmkLocationService == nil) {
        //初始化BMKLocationService
        _bmkLocationService = [[BMKLocationService alloc]init];
        _bmkLocationService.delegate = self;
    }
    
    return _bmkLocationService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveClicked)];
    //指定最小距离更新(米)
    [BMKLocationService setLocationDistanceFilter:1000.f];
    
    //1. 读取本地数据库，展示数据
    self.user = [ACCacheDataTool getUserInfo];
    DLog(@"user %@", self.user);
    
    [self addGroup0With:self.user];
    
}

/**
 *  添加第一组数据
 *
 *  @param user 用户数据
 */
- (void)addGroup0With:(ACUserModel *)user
{
    //数据部分
    ACPhotoSettingCellModel *cell0 = [ACPhotoSettingCellModel photoSettingCellWithTitle:@"头像" photo:user.profile_image_url];
    cell0.option = ^(NSIndexPath *indexPath){
        //设置头像
        [self changeAvatarWith:indexPath];
    };
    
    ACArrowWithSubtitleSettingCellModel *cell1 = [ACArrowWithSubtitleSettingCellModel arrowWithSubtitleCellWithTitle:@"昵称" subTitle:user.username icon:nil];
    cell1.option = ^(NSIndexPath *indexPath){
        //修改昵称
        [self changeNicknameWith:indexPath];
    };
    
    NSString *gender = @"";
    if ([user.gender isEqualToString:@"m"]) {
        gender = @"男";
    } else {
        gender = @"女";
    }
    ACBlankSettingCellModel *cell2 = [ACBlankSettingCellModel blankSettingCellWithTitle:@"性别" subTitle:gender icon:nil];
    cell2.option = ^(NSIndexPath *indexPath){
        //设置性别
        [self changeGenderWith:indexPath];
    };
    
    ACBlankSettingCellModel *cell3 = [ACBlankSettingCellModel blankSettingCellWithTitle:@"地区" subTitle:(user.location ? user.location : @"未填写") icon:nil];
    cell3.option = ^(NSIndexPath *indexPath){
        //定位
        [self changeLocationWith:indexPath];
    };
    
    ACBlankSettingCellModel *cell4 = [ACBlankSettingCellModel blankSettingCellWithTitle:@"邮箱" subTitle:(user.email ? user.email : @"未填写") icon:nil];
    
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    group.cellList = @[cell0, cell1, cell2, cell3, cell4];
    
    [self.dataList addObject:group];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACSettingViewCell *cell = [ACSettingViewCell settingViewCellWithTableView:tableView];
    
    //取分组模型
    ACSettingGroupModel *group = self.dataList[indexPath.section];
    //取cell模型
    ACSettingCellModel *cellModel = group.cellList[indexPath.row];
    
    cell.cellModel = cellModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 90;
    } else {
        return 44;
    }
}

- (void)dealloc
{
    //视图销毁时，停止定位
    [self.bmkLocationService stopUserLocationService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 各个cell的点击事件的实现

/**
 *  设置头像
 */
- (void)changeAvatarWith:(NSIndexPath *)indexPath
{
    //1. 弹出UIAlertController选择图片或者相机
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:photoAction];
    [alertController addAction:cameraAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  设置昵称
 */
- (void)changeNicknameWith:(NSIndexPath *)indexPath
{
    //弹出控制器
    ACChangeNameController *changeNameVC = [[ACChangeNameController alloc] initWithNibName:@"ACChangeNameController" bundle:nil];
    changeNameVC.delegate = self;
    
    [self presentViewController:changeNameVC animated:YES completion:nil];
    
}

/**
 *  设置性别
 */
- (void)changeGenderWith:(NSIndexPath *)indexPath
{
    NSString *subTitle = @"";
    if ([self.user.gender isEqualToString:@"m"]) {
        self.user.gender = @"f";
        subTitle = @"女";
    } else {
        self.user.gender = @"m";
        subTitle = @"男";
    }
    
    //修改对应行的模型数据
    ACBlankSettingCellModel *model = [self.dataList[indexPath.section] cellList][indexPath.row];
    model.subTitle = subTitle;
    
    [self.tableView reloadData];
}

/**
 *  设置位置
 */
- (void)changeLocationWith:(NSIndexPath *)indexPath
{
    //启动LocationService
    [self.bmkLocationService startUserLocationService];
}

#pragma mark - BMKLocationServieDelegate

/**
 *  处理位置坐标更新
 *
 *  @param userLocation
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    DLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
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

#pragma mark - geoCoderSearchDelegate

/**
 *  获取反向地理编码结果
 *
 *  @param searcher
 *  @param result
 *  @param error
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        self.user.location = [NSString stringWithFormat:@"%@ %@", result.addressDetail.city, result.addressDetail.district];
        
        DLog(@"user.location is %@", self.user.location);
        //设置tableView的数据
        ACArrowWithSubtitleSettingCellModel *model = [self.dataList[0] cellList][3];
        model.subTitle = self.user.location;
        [self.tableView reloadData];
    }
}

#pragma mark - changeNameDelegate

/**
 *  修改了昵称时调用
 *
 *  @param name
 */
- (void)changeNameWith:(NSString *)name
{
    ACArrowWithSubtitleSettingCellModel *model = [self.dataList[0] cellList][1];
    model.subTitle = name;
    
    [self.tableView reloadData];
}

#pragma mark - 保存按钮的事件点击
- (void)saveClicked
{
    //1. 保存到本地缓存
    [ACCacheDataTool updateUserInfo:self.user withObjectId:self.user.objectId];
    
    //2. 保存到数据库
    [ACDataBaseTool updateUserInfoWith:self.user withResultBlock:^(BOOL isSuccessful, NSError *error) {
        DLog(@"保存用户信息成功到数据库");
    }];
}

@end
