//
//  ACHotRoutesCitiesCellView.m
//  A-cyclist
//
//  Created by tunny on 15/8/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACHotRoutesCitiesCellView.h"
#import "ACHotRoutesCitesCellModel.h"

@interface ACHotRoutesCitiesCellView ()
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

@end

@implementation ACHotRoutesCitiesCellView

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellModel:(ACHotRoutesCitesCellModel *)cellModel
{
    _cellModel = cellModel;
    
    self.cityNameLabel.text = cellModel.cityName;
}

+ (instancetype)settingViewCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"citiesCell";
    ACHotRoutesCitiesCellView *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (ACHotRoutesCitiesCellView *)[[[NSBundle mainBundle] loadNibNamed:@"ACHotRoutesCitiesCellView" owner:self options:nil] lastObject];
    }
    
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TopBar_bg-1"]];
    return cell;
}

@end
