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
#import "UIColor+Tools.h"

@interface ACProfileHeaderView ()
/** 累计时间 */
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
/** 累计距离 */
@property (weak, nonatomic) IBOutlet UILabel *totalDistanceLabel;
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
/** 个性签名 */
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;

/** 约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signatureLabelHeight;

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
        self.totalDistanceLabel.text = [NSString stringWithFormat:@"%.2f", user.accruedDistance.doubleValue];
    } else {
        self.totalDistanceLabel.text = @"0.00";
    }
    self.userNameLabel.text = user.username;
    self.signatureLabel.text = user.signature;

    //根据URL下载图片
    NSURL *url = [NSURL URLWithString:user.profile_image_url];
    [self.iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"signup_avatar_default"]];
    
    //裁剪图片
    [UIImage clipImageWithView:self.iconView border:4 borderColor:[UIColor whiteColor] radius:self.iconView.bounds.size.width * 0.5];
}

+ (instancetype)profileHeaderView
{
    ACProfileHeaderView *profileView = [[[NSBundle mainBundle] loadNibNamed:@"ACProfileHeaderView" owner:self options:nil] lastObject];
    
    return profileView;
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:12.0f]};
    CGRect signatureLabelRect = [self.signatureLabel.text boundingRectWithSize:CGSizeMake(ACScreenBounds.size.width - 118, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:dict context:nil];
    
    self.signatureLabelHeight.constant = (signatureLabelRect.size.height > 15) ? 29 : signatureLabelRect.size.height;
    
}

@end
