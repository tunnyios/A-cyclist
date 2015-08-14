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

@interface ACSettingViewController () <UIAlertViewDelegate>

@end

@implementation ACSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addGroup0];

    [self addGroup1];
    
    [self addGroup2];
    
    [self addGroup3];
}

- (void)addGroup0
{
    //数据部分
    ACArrowSettingCellModel *cell0 = [ACArrowSettingCellModel arrowSettingCellModelWithTitle:@"编辑个人资料" icon:@"IDInfo" destClass:[ACSettingProfileInfoViewController class]];
    ACArrowSettingCellModel *cell1 = [ACArrowSettingCellModel arrowSettingCellModelWithTitle:@"离线地图" icon:@"sound_Effect" destClass:[ACSettingOffLineMapsViewController class]];
//    ACArrowSettingCellModel *cell2 = [ACArrowSettingCellModel arrowSettingCellModelWithTitle:@"推送与提醒" icon:@"MorePush" destClass:[UIViewController class]];
    
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    group.cellList = @[cell0, cell1];
    
    [self.dataList addObject:group];
}

- (void)addGroup1
{
    //1. 计算缓存数据的大小
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    CGFloat size = [NSFileManager folderSizeAtPath:cachePath];
    __block NSString *sutTitle = [NSString stringWithFormat:@"%.2f M", size];
    //数据部分
    ACBlankSettingCellModel *cell0 = [ACBlankSettingCellModel blankSettingCellWithTitle:@"清除缓存" subTitle:sutTitle icon:@"MoreNetease"];
    
    cell0.option = ^(NSIndexPath *indexPath){
        //弹出alert
        NSString *message = [NSString stringWithFormat:@"缓存大小为%@, 确定要清理缓存吗？", sutTitle];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    };
    
    ACSettingGroupModel *group1 = [[ACSettingGroupModel alloc] init];
    group1.cellList = @[cell0];
    
    [self.dataList addObject:group1];
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
    ACArrowSettingCellModel *cell0 = [ACArrowSettingCellModel arrowSettingCellModelWithTitle:@"检查新版本" icon:@"MoreUpdate" destClass:[UIViewController class]];
    ACArrowSettingCellModel *cell4 = [ACArrowSettingCellModel arrowSettingCellModelWithTitle:@"帮助" icon:@"MoreHelp" destClass:[UIViewController class]];
    ACArrowSettingCellModel *cell1 = [ACArrowSettingCellModel arrowSettingCellModelWithTitle:@"分享" icon:@"MoreShare" destClass:[UIViewController class]];
    ACArrowSettingCellModel *cell2 = [ACArrowSettingCellModel arrowSettingCellModelWithTitle:@"打赏与好评" icon:@"MoreNetease" destClass:[UIViewController class]];
    ACArrowSettingCellModel *cell3 = [ACArrowSettingCellModel arrowSettingCellModelWithTitle:@"关于Acyclist" icon:@"MoreAbout" destClass:[UIViewController class]];
    
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    group.cellList = @[cell0, cell4, cell1, cell2, cell3];
    
    [self.dataList addObject:group];
}

- (void)addGroup3
{
    //数据部分
    ACBlankSettingCellModel *cell0 = [ACBlankSettingCellModel settingCellWithTitle:nil icon:nil];
    
    ACSettingGroupModel *group = [[ACSettingGroupModel alloc] init];
    group.cellList = @[cell0];
    
    [self.dataList addObject:group];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
