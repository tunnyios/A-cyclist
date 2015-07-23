//
//  ACSettingViewCell.m
//  A-cyclist
//
//  Created by tunny on 15/7/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACSettingViewCell.h"
#import "ACSettingCellModel.h"
#import "ACBlankSettingCellModel.h"
#import "ACArrowSettingCellModel.h"
#import "ACArrowWithSubtitleSettingCellModel.h"
#import "ACPhotoSettingCellModel.h"
#import "ACGlobal.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Extension.h"

@interface ACSettingViewCell ()
/** small头像ImageView */
@property (nonatomic, strong) UIImageView *smallProtraitView;
@end

@implementation ACSettingViewCell

- (UIImageView *)smallProtraitView
{
    if (_smallProtraitView == nil) {
        _smallProtraitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_smallProtraitView setContentMode:UIViewContentModeScaleAspectFill];
        [_smallProtraitView setClipsToBounds:YES];
    }
    
    return _smallProtraitView;
}

- (void)setCellModel:(ACSettingCellModel *)cellModel
{
    _cellModel = cellModel;
    self.textLabel.text = cellModel.title;
    self.imageView.image = [UIImage imageNamed:cellModel.icon];
    
    if ([cellModel isKindOfClass:[ACBlankSettingCellModel class]]) {
        ACBlankSettingCellModel *blankModel = (ACBlankSettingCellModel *)cellModel;
        self.detailTextLabel.text = blankModel.subTitle;
        self.accessoryView.hidden = YES;
        
    } else if ([cellModel isKindOfClass:[ACArrowWithSubtitleSettingCellModel class]]) {
        self.accessoryView.hidden = NO;
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellArrow"]];
        ACArrowWithSubtitleSettingCellModel *blankModel = (ACArrowWithSubtitleSettingCellModel *)cellModel;
        self.detailTextLabel.text = blankModel.subTitle;
        
    } else if ([cellModel isKindOfClass:[ACArrowSettingCellModel class]]) {
        self.accessoryView.hidden = NO;
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellArrow"]];
        self.detailTextLabel.text = nil;
        
    } else if ([cellModel isKindOfClass:[ACPhotoSettingCellModel class]]) {
        ACPhotoSettingCellModel *photoModel = (ACPhotoSettingCellModel *)cellModel;
        self.detailTextLabel.text = nil;
        self.accessoryView.hidden = NO;
        //下载图片
        if (photoModel.photoImage) {
            self.smallProtraitView.image = photoModel.photoImage;
        } else {
            //根据url下载图片
            NSURL *url = [NSURL URLWithString:photoModel.photoURL];
            [self.smallProtraitView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"signup_avatar_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    DLog(@"url下载头像成功");
                } else {
                    DLog(@"url下载头像失败");
                }
            }];
        }
        
        //裁剪图片
        [UIImage clipImageWithView:self.smallProtraitView border:5 borderColor:[UIColor blueColor] radius:(self.smallProtraitView.bounds.size.width * 0.5)];
        self.accessoryView = self.smallProtraitView;
    } else {
        self.accessoryView.hidden = YES;
        self.detailTextLabel.text = nil;
    }
}

+ (instancetype)settingViewCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    ACSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
