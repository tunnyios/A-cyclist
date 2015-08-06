//
//  ACProfileCellView.m
//  A-cyclist
//
//  Created by tunny on 15/8/5.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACProfileCellView.h"
#import "ACProfileCellModel.h"

@interface ACProfileCellView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation ACProfileCellView

- (void)awakeFromNib {
    // Initialization code
}

- (void)setProfileModel:(ACProfileCellModel *)profileModel
{
    _profileModel = profileModel;
    
    self.titleLabel.text = profileModel.title;
    self.timeLabel.text = profileModel.timeStr;
    self.subTitleLabel.text = profileModel.subTitle;
    
}

+ (instancetype)settingViewCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"profileCell";
    ACProfileCellView *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (ACProfileCellView *)[[[NSBundle mainBundle] loadNibNamed:@"ACProfileCellView" owner:self options:nil] lastObject];
    }
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
