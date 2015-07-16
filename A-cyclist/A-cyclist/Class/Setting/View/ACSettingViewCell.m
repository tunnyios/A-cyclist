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

@implementation ACSettingViewCell

- (void)setCellModel:(ACSettingCellModel *)cellModel
{
    _cellModel = cellModel;
    
    self.textLabel.text = cellModel.title;
    self.imageView.image = [UIImage imageNamed:cellModel.icon];
    
    if ([cellModel isKindOfClass:[ACBlankSettingCellModel class]]) {
        ACBlankSettingCellModel *blankModel = (ACBlankSettingCellModel *)cellModel;
        if (blankModel.subTitle) {
            self.detailTextLabel.text = blankModel.subTitle;
        }
    } else {
        self.detailTextLabel.text = nil;
    }
    
    if ([cellModel isKindOfClass:[ACArrowSettingCellModel class]]) {
        self.accessoryView.hidden = NO;
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellArrow"]];
    } else {
        self.accessoryView.hidden = YES;
    }
}

+ (instancetype)settingViewCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    ACSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ACSettingViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
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
