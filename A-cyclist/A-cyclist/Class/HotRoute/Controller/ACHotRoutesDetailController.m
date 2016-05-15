//
//  ACHotRoutesDetailController.m
//  A-cyclist
//
//  Created by tunny on 15/8/10.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACHotRoutesDetailController.h"
#import "ACHotRoutesDetailTopView.h"
#import "ACSharedRouteModel.h"
#import "HCStarView.h"
#import "ACSharedRoutePhotoModel.h"
#import "UIImageView+WebCache.h"
#import "ACGlobal.h"

@interface ACHotRoutesDetailController ()

@property (weak, nonatomic) IBOutlet ACHotRoutesDetailTopView *topView;
@property (weak, nonatomic) IBOutlet UIView *difficultyView;
@property (weak, nonatomic) IBOutlet UIView *sceneryView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *routeMapView;

@end

@implementation ACHotRoutesDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    DLog(@"self.sharedRoute is %@", self.sharedRoute);
    //1. topView图片轮播
    if (self.sharedRoute.imageList.count > 0) {
        self.topView.photoArray = self.sharedRoute.imageList;
    }
    //2. 参数
    HCStarView *difficultyView = [HCStarView starViewWithLevel:self.sharedRoute.difficultyLevel.integerValue];
    difficultyView.frame = self.difficultyView.bounds;
    [self.difficultyView addSubview:difficultyView];
    
    HCStarView *sceneryView = [HCStarView starViewWithLevel:self.sharedRoute.sceneryLevel.integerValue];
    sceneryView.frame = self.sceneryView.bounds;
    [self.sceneryView addSubview:sceneryView];
    
    self.userNameLabel.text = self.sharedRoute.userName;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@ km", self.sharedRoute.distance];
    //3. 描述
    self.descriptionLabel.text = self.sharedRoute.routeDesc;
    //4. mapView
    ACSharedRoutePhotoModel *photoModel = [self.sharedRoute.imageList lastObject];
    NSURL *url = [NSURL URLWithString:photoModel.photoURL];
    [self.routeMapView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"signup_avatar_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            DLog(@"从网络上下载图片失败, error is %@", error);
        } else {
            DLog(@"从网络上下载图片成功");
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.topView stopTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
