//
//  ACCyclingViewController.m
//  A-cyclist
//
//  Created by tunny on 15/7/24.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACCyclingViewController.h"
#import <BaiduMapAPI/BMapKit.h>

@interface ACCyclingViewController ()

/** contentView的width的约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
/** mapView的leading约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapViewLeading;
/** 开始按钮 */
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
/** 暂停按钮 */
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
/** 结束按钮 */
@property (weak, nonatomic) IBOutlet UIButton *endBtn;

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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"控制器touch");
}

#pragma mark - 按钮的监听事件

/**
 *  开始骑行
 */
- (IBAction)startCycling
{
    [UIView animateWithDuration:1.0f animations:^{
        //1. 隐藏开始骑行按钮
        self.startBtn.alpha = 0;
        //2. 显示暂停和完成按钮
        self.pauseBtn.alpha = 1;
        self.endBtn.alpha = 1;
        
    } completion:^(BOOL finished) {
        //3. 开始骑行功能
        
    }];
    
    
}

/**
 *  启动或暂停
 */
- (IBAction)beginOrPause
{
    self.pauseBtn.selected = !self.pauseBtn.isSelected;
    if (self.pauseBtn.isSelected) {
        //暂停
    } else {
        //启动
    }
}

/**
 *  完成、结束骑行
 */
- (IBAction)endCycling
{
    //1. 弹框提醒是否结束
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"xxxxx" message:@"确定结束本次骑行吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //2. 结束，隐藏暂停和结束按钮，显示开始按钮
        //3. 执行结束功能，分析此次骑行状态
        //跳转控制器
        
    }];
    
    [alertVc addAction:cancleAction];
    [alertVc addAction:sureAction];
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
