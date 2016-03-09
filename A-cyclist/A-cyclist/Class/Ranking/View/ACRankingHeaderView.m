//
//  ACRankingHeaderView.m
//  A-cyclist
//
//  Created by tunny on 16/3/9.
//  Copyright © 2016年 tunny. All rights reserved.
//

#import "ACRankingHeaderView.h"
#import "ACUserModel.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Extension.h"
#import "ACGlobal.h"
#import "ACDataBaseTool.h"

@interface ACRankingHeaderView ()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
/** 累计里程 */
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
/** 排名 */
@property (weak, nonatomic) IBOutlet UILabel *rankingNumLabel;

@end

@implementation ACRankingHeaderView

+ (instancetype)headerView
{
    ACRankingHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"ACRankingHeaderView" owner:self options:nil] lastObject];
    
    return headerView;
}

- (void)setUserModel:(ACUserModel *)userModel
{
    _userModel = userModel;
    
    //1. 根据URL下载头像
    NSURL *url = [NSURL URLWithString:userModel.profile_image_url];
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
    self.userNameLabel.text = userModel.username;
    if (userModel.accruedDistance) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%@ km", userModel.accruedDistance];
        
        //3. 获取当前用户的排名
        [ACDataBaseTool getRankingNumWithUserId:userModel.objectId resultBlock:^(NSString *numStr, NSError *error) {
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

@end
