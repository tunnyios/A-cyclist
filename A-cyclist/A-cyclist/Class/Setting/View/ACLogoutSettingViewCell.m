//
//  ACLogoutSettingViewCell.m
//  A-cyclist
//
//  Created by tunny on 15/7/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACLogoutSettingViewCell.h"

@implementation ACLogoutSettingViewCell

+ (instancetype)settingViewCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"logoutCell";
    ACLogoutSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (ACLogoutSettingViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"ACLogoutSettingViewCell" owner:self options:nil] lastObject];
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
