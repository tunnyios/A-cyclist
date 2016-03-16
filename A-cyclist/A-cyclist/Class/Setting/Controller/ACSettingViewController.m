//
//  ACSettingViewController.m
//  A-cyclist
//
//  Created by tunny on 15/7/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACSettingViewController.h"
#import "ACSettingGroupModel.h"
#import "ACSettingCellModel.h"
#import "ACArrowSettingCellModel.h"
#import "ACBlankSettingCellModel.h"
#import "ACSettingProfileInfoViewController.h"
#import "ACSettingViewCell.h"
#import "ACLogoutSettingViewCell.h"
#import "ACSettingOffLineMapsViewController.h"
#import "SDImageCache.h"
#import "NSFileManager+Extension.h"
#import "ACShowAlertTool.h"
#import "ACCacheDataTool.h"
#import "ACLoginViewController.h"
#import "ACSettingFeedbackViewController.h"

@interface ACSettingViewController () <UIAlertViewDelegate>

@end

@implementation ACSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self addGroup0];

    [self addGroup1];
    
    [self addGroup2];
    
    [self addGroup3];
}

- (void)addGroup0
{
    //数据部分
    ACArrowSettingCellModel *cell0 = [ACArrowSettingCellModel arrowSettingCellModelWithTitle:@"编辑个人资料" icon:@"setting_icon_profile" destClass:[ACSettingProfileInfoViewController class]];
    ACArrowSettingCellModel *cell1 = [ACArrowSettingCellModel arrowSettingCellModelWithTitle:@"离线地图" icon:@"setting_icon_map" destClass:[ACSettingOffLineMapsViewController class]];
//    ACArrowSettingCellModel *cell2 = [ACArrowSettingCellModel arrowSettingCellModelWithTitle:@"推送与提醒" icon:@"MorePush" destClass:[UIViewController class]];
    
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    group.cellList = @[cell0, cell1];
    
    [self.dataList addObject:group];
}

- (void)addGroup1
{
    //计算缓存数据的大小
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    CGFloat size = [NSFileManager folderSizeAtPath:cachePath];
    __block NSString *sutTitle = [NSString stringWithFormat:@"%.2f M", size];
    
    //数据部分
    ACBlankSettingCellModel *cell0 = [ACBlankSettingCellModel blankSettingCellWithTitle:@"清除缓存" subTitle:sutTitle icon:@"setting_icon_clean"];
    
    cell0.option = ^(NSIndexPath *indexPath){
        //弹出alert
        NSString *message = [NSString stringWithFormat:@"缓存大小为%@, 确定要清理缓存吗？", sutTitle];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    };
    
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    group.cellList = @[cell0];
    [self.dataList addObject:group];
}


#pragma mark - 清理缓存 alertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) { //清理缓存
        [ACShowAlertTool showMessage:@"清理缓存" onView:nil];
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        [NSFileManager clearCache:cachePath];
        
        //修改dataList数据
        ACSettingGroupModel *group = self.dataList[1];
        ACBlankSettingCellModel *blank = group.cellList[0];
        blank.subTitle = @"0 M";
        [self.tableView reloadData];
        [ACShowAlertTool hideMessage];
    }
}

- (void)addGroup2
{
    //数据部分
//    ACArrowSettingCellModel *cell0 = [ACArrowSettingCellModel arrowSettingCellModelWithTitle:@"检查新版本" icon:@"MoreUpdate" destClass:[UIViewController class]];
    ACArrowSettingCellModel *cell1 = [ACArrowSettingCellModel arrowSettingCellModelWithTitle:@"反馈" icon:@"setting_icon_feedback" destClass:nil];
    cell1.option = ^(NSIndexPath *indexPath){
        UIStoryboard *settingSB = [UIStoryboard storyboardWithName:@"setting" bundle:nil];
        ACSettingFeedbackViewController *feedBackVC = [settingSB instantiateViewControllerWithIdentifier:@"settingFeedback"];
        
        [feedBackVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:feedBackVC animated:YES];
    };
    
//    ACArrowSettingCellModel *cell1 = [ACArrowSettingCellModel arrowSettingCellModelWithTitle:@"分享" icon:@"MoreShare" destClass:[UIViewController class]];
    ACArrowSettingCellModel *cell2 = [ACArrowSettingCellModel arrowSettingCellModelWithTitle:@"打赏与好评" icon:@"setting_icon_rate" destClass:[UIViewController class]];
    ACArrowSettingCellModel *cell3 = [ACArrowSettingCellModel arrowSettingCellModelWithTitle:@"关于Acyclist" icon:@"setting_icon_about" destClass:[UIViewController class]];
    
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    group.cellList = @[cell1, cell2, cell3];
    [self.dataList addObject:group];
}

- (void)addGroup3
{
    //数据部分
    ACBlankSettingCellModel *cell0 = [ACBlankSettingCellModel settingCellWithTitle:nil icon:nil];
    cell0.option = ^(NSIndexPath *indexPath){
        //退出登录
        [self logout];
    };
    
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    group.cellList = @[cell0];
    [self.dataList addObject:group];
}

/**
 *  退出登录
 */
- (void)logout
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [ACShowAlertTool showSuccess:@"退出成功"];
        //删除用户数据
        [ACCacheDataTool deleteUserData];
        
        //跳转到登录界面
        UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"ACLogin" bundle:nil];
        //设置根控制器
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = loginSB.instantiateInitialViewController;
        
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:logoutAction];
    [alertController addAction:cancleAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((self.dataList.count - 1) == indexPath.section) {
        ACLogoutSettingViewCell *cell = [ACLogoutSettingViewCell settingViewCellWithTableView:tableView];
        return cell;
    }
    
    ACSettingViewCell *cell = [ACSettingViewCell settingViewCellWithTableView:tableView];
    
    //取分组模型
    ACSettingGroupModel *group = self.dataList[indexPath.section];
    //取cell模型
    ACSettingCellModel *cellModel = group.cellList[indexPath.row];
    
    cell.cellModel = cellModel;
    
    return cell;
}


@end
