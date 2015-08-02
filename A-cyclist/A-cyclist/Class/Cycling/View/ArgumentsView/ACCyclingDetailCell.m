//
//  ACCyclingDetailCell.m
//  A-cyclist
//
//  Created by tunny on 15/8/1.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACCyclingDetailCell.h"
#import "ACCyclingDetailModel.h"

@implementation ACCyclingDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellModel:(ACCyclingDetailModel *)cellModel
{
    _cellModel = cellModel;
    self.textLabel.text = cellModel.title;
    self.detailTextLabel.text = cellModel.subTitle;
}

+ (instancetype)settingViewCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"detailCell";
    ACCyclingDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

@end
