//
//  ACSettingProfileInfoViewController.m
//  A-cyclist
//
//  Created by tunny on 15/7/20.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACSettingProfileInfoViewController.h"
#import "ACCacheDataTool.h"
#import "ACUserModel.h"
#import "ACGlobal.h"
#import "ACBlankSettingCellModel.h"
#import "ACArrowWithSubtitleSettingCellModel.h"
#import "ACSettingGroupModel.h"
#import "ACSettingViewCell.h"
#import "ACPhotoSettingCellModel.h"
#import "ACChangeNameController.h"

@interface ACSettingProfileInfoViewController () <ACChangeNameDelegate>
/** 用户数据模型 */
@property (nonatomic, strong) ACUserModel *user;

@end

@implementation ACSettingProfileInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    cell0.option = ^(){
        //设置头像
        [self changeAvatar];
    };
    
    ACArrowWithSubtitleSettingCellModel *cell1 = [ACArrowWithSubtitleSettingCellModel arrowWithSubtitleCellWithTitle:@"昵称" subTitle:user.username icon:nil];
    cell1.option = ^(){
        //修改昵称
        [self changeNickname];
    };
    
    NSString *gender = @"";
    if ([user.gender isEqualToString:@"m"]) {
        gender = @"男";
    } else {
        gender = @"女";
    }
    ACBlankSettingCellModel *cell2 = [ACBlankSettingCellModel blankSettingCellWithTitle:@"性别" subTitle:gender icon:nil];
    cell2.option = ^(){
        //设置性别
        [self changeGender];
    };
    
    ACBlankSettingCellModel *cell3 = [ACBlankSettingCellModel blankSettingCellWithTitle:@"地区" subTitle:(user.location ? user.location : @"未填写") icon:nil];
    cell3.option = ^(){
        //定位
        [self changeLocation];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 各个cell的点击事件的实现

/**
 *  设置头像
 */
- (void)changeAvatar
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
- (void)changeNickname
{
    //弹出控制器
    ACChangeNameController *changeNameVC = [[ACChangeNameController alloc] initWithNibName:@"ACChangeNameController" bundle:nil];
    changeNameVC.delegate = self;
    
    [self presentViewController:changeNameVC animated:YES completion:nil];
    
}

/**
 *  设置性别
 */
- (void)changeGender
{
    
}

/**
 *  设置位置
 */
- (void)changeLocation
{
    
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

@end
