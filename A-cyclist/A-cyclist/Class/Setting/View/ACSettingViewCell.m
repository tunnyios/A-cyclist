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

@implementation ACSettingViewCell

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
        self.detailTextLabel.text = nil;
        self.accessoryView.hidden = NO;
        //下载图片
        ACPhotoSettingCellModel *photoModel = (ACPhotoSettingCellModel *)cellModel;
        NSURL *url = [NSURL URLWithString:photoModel.photo];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:url
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                UIImage *newImage = nil;
                                
                                UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
                                if (image) {
                                    newImage = [UIImage clipImageWithImage:image border:5 borderColor:[UIColor blueColor]];

                                } else {
                                    newImage = [UIImage clipImageWithImage:[UIImage imageNamed:@"signup_avatar_default"] border:5 borderColor:[UIColor blueColor]];
                                }
                                photoView.image = newImage;
                                self.accessoryView = photoView;
                            }];
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
