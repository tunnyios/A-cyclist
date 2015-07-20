//
//  ACSettingProfileInfoViewController.m
//  A-cyclist
//
//  Created by tunny on 15/7/20.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACSettingProfileInfoViewController.h"
#import "ACCacheDataTool.h"
#import "ACUserModel.h"
#import "ACGlobal.h"

@interface ACSettingProfileInfoViewController ()

@end

@implementation ACSettingProfileInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //读取本地数据库，展示数据
    ACUserModel *user = [ACCacheDataTool getUserInfo];
    DLog(@"user %@", user);
    
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
