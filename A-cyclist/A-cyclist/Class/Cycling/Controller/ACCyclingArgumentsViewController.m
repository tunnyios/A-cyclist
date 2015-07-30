//
//  ACCyclingArgumentsViewController.m
//  A-cyclist
//
//  Created by tunny on 15/7/25.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACCyclingArgumentsViewController.h"
#import "ACNavigationViewController.h"

@interface ACCyclingArgumentsViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleViewLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightViewLeading;

@end

@implementation ACCyclingArgumentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"######route %@", self.route);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancle:(id)sender
{
    NSLog(@"########%@", [self.navigationController class]);
    if ([self.navigationController isKindOfClass:[ACNavigationViewController class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 约束
- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    //动态修改约束
    //设置scrollView的contentView的宽度为两个屏的宽度
    self.contentViewWidth.constant = CGRectGetWidth([UIScreen mainScreen].bounds) * 3;
    self.middleViewLeading.constant = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.rightViewLeading.constant = CGRectGetWidth([UIScreen mainScreen].bounds) * 2;
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
