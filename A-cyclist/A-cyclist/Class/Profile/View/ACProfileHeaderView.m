//
//  ACProfileHeaderView.m
//  A-cyclist
//
//  Created by tunny on 15/8/6.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACProfileHeaderView.h"
#import "ACUserModel.h"
#import "ACGlobal.h"
#import "NSString+Extension.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Extension.h"

@interface ACProfileHeaderView ()
/** 累计时间 */
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
/** 累计距离 */
@property (weak, nonatomic) IBOutlet UILabel *totalDistanceLabel;
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation ACProfileHeaderView

- (void)setUser:(ACUserModel *)user
{
    _user = user;
    DLog(@"setUser user is %@", user);
    //加载数据
    if (user.accruedTime) {
        self.totalTimeLabel.text = [NSString timeStrWithSeconds:user.accruedTime.integerValue];
    } else {
        self.totalTimeLabel.text = @"00:00";
    }
    if (user.accruedDistance) {
        self.totalDistanceLabel.text = [NSString stringWithFormat:@"%@", user.accruedDistance];
    } else {
        self.totalDistanceLabel.text = @"0.00";
    }
    self.userNameLabel.text = user.username;
    
    //根据URL下载图片
    NSURL *url = [NSURL URLWithString:user.profile_image_url];
    [self.iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"signup_avatar_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            DLog(@"下载图片失败 error is %@", error);
        } else {
            DLog(@"下载图片成功");
        }
    }];
    //裁剪图片
    [UIImage clipImageWithView:self.iconView border:5 borderColor:[UIColor blueColor] radius:self.iconView.bounds.size.width * 0.5];
}

+ (instancetype)profileHeaderView
{
    ACProfileHeaderView *profileView = [[[NSBundle mainBundle] loadNibNamed:@"ACProfileHeaderView" owner:self options:nil] lastObject];
    
    return profileView;
}

@end
