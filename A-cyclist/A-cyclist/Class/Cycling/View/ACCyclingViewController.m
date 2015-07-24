//
//  ACCyclingViewController.m
//  A-cyclist
//
//  Created by tunny on 15/7/24.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACCyclingViewController.h"

@interface ACCyclingViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapViewLeading;

@end

@implementation ACCyclingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 更新约束

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    /** 在这里更新约束 */
    //设置scrollView的contentView的宽度为两个屏的宽度
    self.contentViewWidth.constant = CGRectGetWidth([UIScreen mainScreen].bounds) * 2;
    self.mapViewLeading.constant = CGRectGetWidth([UIScreen mainScreen].bounds);
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
