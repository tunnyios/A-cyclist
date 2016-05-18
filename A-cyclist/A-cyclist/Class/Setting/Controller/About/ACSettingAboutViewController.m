//
//  ACSettingAboutViewController.m
//  A-cyclist
//
//  Created by tunny on 16/5/17.
//  Copyright © 2016年 tunny. All rights reserved.
//

#import "ACSettingAboutViewController.h"
#import "ACNavUtility.h"

@interface ACSettingAboutViewController ()

@end

@implementation ACSettingAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ACNavUtility setNav:self.navigationController setNavItem:self.navigationItem setTitle:@"关于Acyclist"];
    self.navigationItem.leftBarButtonItem = [ACNavUtility setNavButtonWithImage:@"back_icon.png" target:self action:@selector(goBack) frame:CGRectMake(0, 0, 20, 20)];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
