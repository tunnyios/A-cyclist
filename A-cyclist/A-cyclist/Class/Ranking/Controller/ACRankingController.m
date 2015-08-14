//
//  ACRankingController.m
//  A-cyclist
//
//  Created by tunny on 15/8/8.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACRankingController.h"
#import "ACUserModel.h"
#import "ACCacheDataTool.h"
#import "ACDataBaseTool.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Extension.h"
#import "ACGlobal.h"
#import "ACRankingFormerCellView.h"
#import "ACRankingBehindCellView.h"
#import "ACRankingFormerCellModel.h"
#import "ACRankingBehindCellModel.h"
#import "ACNavigationViewController.h"
#import "ACCyclingArgumentsViewController.h"
#import "ACUserDetailController.h"


@interface ACRankingController ()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
/** 累计里程 */
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
/** 排名 */
@property (weak, nonatomic) IBOutlet UILabel *rankingNumLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 用户对象 */
@property (nonatomic, strong) ACUserModel *user;
/** 用户列表 */
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation ACRankingController

- (ACUserModel *)user
{
    if (_user == nil) {
        _user = [ACCacheDataTool getUserInfo];
    }
    
    return _user;
}

- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 64;
    //1. 设置用户信息View
    [self setUserData];
    //2. 设置排名信息tableView
    [self setRankingData];
}

/**
 *  设置用户信息View
 */
- (void)setUserData
{
    //1. 根据URL下载头像
    NSURL *url = [NSURL URLWithString:self.user.profile_image_url];
    [self.iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"signup_avatar_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            DLog(@"下载图片失败 error is %@", error);
        } else {
            DLog(@"下载图片成功");
        }
    }];
    //裁剪图片
    [UIImage clipImageWithView:self.iconView border:2 borderColor:[UIColor colorWithRed:158 green:185 blue:224 alpha:1] radius:self.iconView.bounds.size.width * 0.5];
    
    //2. 设置其他数据
    self.userNameLabel.text = self.user.username;
    if (self.user.accruedDistance) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%@ km", self.user.accruedDistance];
        
        //3. 获取当前用户的排名
        [ACDataBaseTool getRankingNumWithUserId:self.user.objectId resultBlock:^(NSString *numStr, NSError *error) {
            if (!error) {
                self.rankingNumLabel.text = [NSString stringWithFormat:@"%@ 名", numStr];
            } else {
                DLog(@"从数据库获取当前用户排名失败，error is %@", error);
            }
        }];
    } else {    //数据库中accruedDistance 为NULL
        self.distanceLabel.text = @"0 km";
        self.rankingNumLabel.text = @"未上榜";
    }
    
    
}

/**
 *  设置排名信息tableView
 */
- (void)setRankingData
{
    [ACDataBaseTool getUserListWithResutl:^(NSArray *userList, NSError *error) {
        if (error) {
            DLog(@"从数据库中获取用户列表失败， error is %@", error);
        } else {
            [userList enumerateObjectsUsingBlock:^(ACUserModel *user, NSUInteger idx, BOOL *stop) {
                if (idx < 3) {
                    NSString *distance = [NSString stringWithFormat:@"%.0f", user.accruedDistance.doubleValue];
                    NSString *suffxIcon = [NSString stringWithFormat:@"Ranklist_No%lu", idx + 1];
                    ACRankingFormerCellModel *formerModel = [ACRankingFormerCellModel settingCellWithTitle:user.username icon:user.profile_image_url location:user.location distance:distance suffixIcon:suffxIcon];
                    
                    formerModel.option = ^(){
//                        ACUserDetailController *userDetailController = [[ACUserDetailController alloc] init];
                        UIStoryboard *rankSB = [UIStoryboard storyboardWithName:@"ranking" bundle:nil];
                        ACUserDetailController *userDetailController = [rankSB instantiateViewControllerWithIdentifier:@"userDetailController"];
                        userDetailController.userModel = user;
//                        ACNavigationViewController *nav = [[ACNavigationViewController alloc] initWithRootViewController:userDetailController];
                        [self.navigationController pushViewController:userDetailController animated:YES];
                    };
                    [self.dataList addObject:formerModel];
                    
                } else {
                    NSString *distance = [NSString stringWithFormat:@"%.0f", user.accruedDistance.doubleValue];
                    NSString *suffxNum = [NSString stringWithFormat:@"%lu", idx + 1];
                    ACRankingBehindCellModel *behindModel = [ACRankingBehindCellModel settingCellWithTitle:user.username icon:user.profile_image_url location:user.location distance:distance suffixNum:suffxNum];
                    
                    behindModel.option = ^(){
                        ACUserDetailController *userDetailController = [[ACUserDetailController alloc] init];
                        userDetailController.userModel = user;
                        ACNavigationViewController *nav = [[ACNavigationViewController alloc] initWithRootViewController:userDetailController];
                        [self.navigationController pushViewController:nav animated:YES];
                    };
                    [self.dataList addObject:behindModel];
                }
            }];
            
            [self.tableView reloadData];
        }

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView的数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 3) {
        ACRankingFormerCellView *cell = [ACRankingFormerCellView settingViewCellWithTableView:tableView];
        //取cell模型
        ACRankingFormerCellModel *cellModel = self.dataList[indexPath.row];
        cell.cellModel = cellModel;
        return cell;
        
    } else {
        ACRankingBehindCellView *cell = [ACRankingBehindCellView settingViewCellWithTableView:tableView];
        //取cell模型
        ACRankingBehindCellModel *cellModel = self.dataList[indexPath.row];
        cell.cellModel = cellModel;
        return cell;
    }
}


#pragma mark - tableView的代理方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //取模型
    ACRankingCellModel *cellModel = self.dataList[indexPath.row];
    
    //2.执行对应的选中操作
    if (cellModel.option) {
        cellModel.option(indexPath);
    }
}


@end
