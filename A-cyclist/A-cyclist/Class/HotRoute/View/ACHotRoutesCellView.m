//
//  ACHotRoutesCell.m
//  A-cyclist
//
//  Created by tunny on 15/8/10.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACHotRoutesCellView.h"
#import "ACHotRoutesCellModel.h"
#import "ACSharedRouteModel.h"
#import "ACSharedRoutePhotoModel.h"
#import "UIImageView+WebCache.h"
#import "HCStarView.h"
#import "ACGlobal.h"

@interface ACHotRoutesCellView ()
@property (weak, nonatomic) IBOutlet UILabel *nameCNLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameENLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIView *starView;

@end

@implementation ACHotRoutesCellView

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellModel:(ACHotRoutesCellModel *)cellModel
{
    _cellModel = cellModel;
    
    ACSharedRouteModel *sharedRoute = cellModel.sharedRoute;
    self.nameCNLabel.text = sharedRoute.nameCN;
    self.nameENLabel.text = sharedRoute.nameEN;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@ km", sharedRoute.distance];
    self.altitudeLabel.text = [NSString stringWithFormat:@"海拔: <%@ m", sharedRoute.maxAlitude];
    //难度
    HCStarView *starView = [HCStarView starViewWithLevel:sharedRoute.difficultyLevel.integerValue];
    starView.frame = self.starView.bounds;
    [self.starView addSubview:starView];
    
    //下载图片
    ACSharedRoutePhotoModel *photoModel = [sharedRoute.imageList firstObject];
    NSURL *url = [NSURL URLWithString:photoModel.photoURL];
    [self.backImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"route_cell_default_icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            DLog(@"下载热门路线图片失败, error is %@", error);
        } else {
            DLog(@"下载热门路线图片成功");
        }
    }];
    
}

+ (instancetype)settingViewCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"hotRoutesCell";
    ACHotRoutesCellView *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (ACHotRoutesCellView *)[[[NSBundle mainBundle] loadNibNamed:@"ACHotRoutesCellView" owner:self options:nil] lastObject];
    }
    
    return cell;
}
@end
