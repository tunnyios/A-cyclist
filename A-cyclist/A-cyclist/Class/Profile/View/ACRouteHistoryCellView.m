//
//  ACRouteHistoryCellView.m
//  A-cyclist
//
//  Created by tunny on 15/8/8.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACRouteHistoryCellView.h"
#import "ACProfileCellModel.h"
#import "ACRouteModel.h"
#import "NSDate+Extension.h"

@interface ACRouteHistoryCellView ()
@property (weak, nonatomic) IBOutlet UILabel *routeStartTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeAverSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeKcalLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeAscendAltitudeLabel;
/** 已共享 */
@property (weak, nonatomic) IBOutlet UILabel *sharedRouteLabel;

@end
@implementation ACRouteHistoryCellView

- (void)awakeFromNib {
    // Initialization code
}

- (void)setProfileModel:(ACProfileCellModel *)profileModel
{
    _profileModel = profileModel;
    
    ACRouteModel *route = profileModel.route;
    self.routeStartTimeLabel.text = [NSDate dateToString:route.cyclingStartTime WithFormatter:@"yyyy-MM-dd"];
    self.routeDistanceLabel.text = [NSString stringWithFormat:@"%.2f", route.distance.doubleValue];
    self.routeTimeLabel.text = route.time;
    self.routeAverSpeedLabel.text = [NSString stringWithFormat:@"%@", route.averageSpeed];
    self.routeKcalLabel.text = [NSString stringWithFormat:@"%@", route.kcal];
    self.routeAscendAltitudeLabel.text = route.ascendAltitude;
    if ([route.isShared isEqual:@1]) {
        self.sharedRouteLabel.hidden = NO;
    } else {
        self.sharedRouteLabel.hidden = YES;
    }
}

+ (instancetype)settingViewCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"routeHistoryCell";
    ACRouteHistoryCellView *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (ACRouteHistoryCellView *)[[[NSBundle mainBundle] loadNibNamed:@"ACRouteHistoryCellView" owner:self options:nil] lastObject];
    }
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
