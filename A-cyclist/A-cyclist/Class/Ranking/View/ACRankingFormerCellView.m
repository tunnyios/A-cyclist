//
//  ACRankingFormerCellView.m
//  A-cyclist
//
//  Created by tunny on 15/8/9.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACRankingFormerCellView.h"
#import "ACRankingFormerCellModel.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Extension.h"
#import "ACGlobal.h"


@interface ACRankingFormerCellView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *suffixView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceLabelWidth;
@end

@implementation ACRankingFormerCellView

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellModel:(ACRankingFormerCellModel *)cellModel
{
    _cellModel = cellModel;
    
    self.suffixView.image = [UIImage imageNamed:self.cellModel.suffixIcon];
    self.userNameLabel.text = self.cellModel.title;
    self.locationLabel.text = self.cellModel.location;
    self.distanceLabel.text = self.cellModel.distance;
    
    //下载图片
    NSURL *url = [NSURL URLWithString:self.cellModel.icon];
    [self.iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"signup_avatar_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            DLog(@"下载图片失败 error is %@", error);
        } else {
            DLog(@"下载图片成功");
        }
    }];
    //裁剪图片
    [UIImage clipImageWithView:self.iconView border:0 borderColor:[UIColor blueColor] radius:self.iconView.bounds.size.width * 0.5];
}

+ (instancetype)settingViewCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"rankingFormerCell";
    ACRankingFormerCellView *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (ACRankingFormerCellView *)[[[NSBundle mainBundle] loadNibNamed:@"ACRankingFormerCellView" owner:self options:nil] lastObject];
    }
    
    return cell;
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:19.0f]};
    CGRect distanceLabelRect = [self.distanceLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:dict context:nil];
    self.distanceLabelWidth.constant = distanceLabelRect.size.width + 1;
}

@end
