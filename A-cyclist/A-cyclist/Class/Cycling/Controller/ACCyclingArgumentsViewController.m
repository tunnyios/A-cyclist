//
//  ACCyclingArgumentsViewController.m
//  A-cyclist
//
//  Created by tunny on 15/7/25.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "ACCyclingArgumentsViewController.h"
#import "ACNavigationViewController.h"
#import "ACCyclingArgumentScrollView.h"
#import "ACGlobal.h"

@interface ACCyclingArgumentsViewController () <UIScrollViewDelegate>
/** 约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleViewLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightViewLeading;

/** storyboard中的属性 */
@property (weak, nonatomic) IBOutlet UIButton *trailBtn;
@property (weak, nonatomic) IBOutlet UIButton *graphicBtn;
@property (weak, nonatomic) IBOutlet UIButton *dataBtn;

/** scrollView */
@property (weak, nonatomic) IBOutlet ACCyclingArgumentScrollView *cyclingArgumentScrollView;


@end

@implementation ACCyclingArgumentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //1. 最先展示轨迹
    [self trailBtnClick];
    
    DLog(@"######route %@", self.route);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - storyboard中的按钮监听点击事件
/**
 *  点击返回按钮
 */
- (IBAction)cancle:(id)sender
{
    if ([self.navigationController isKindOfClass:[ACNavigationViewController class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 *  轨迹按钮点击
 */
- (IBAction)trailBtnClick
{
    //1. 设置选中状态
    self.trailBtn.selected = YES;
    self.graphicBtn.selected = NO;
    self.dataBtn.selected = NO;
    
    //2. 切换scrollView的View
    self.cyclingArgumentScrollView.contentOffset = CGPointMake(0, 0);
}

/**
 *  图表按钮点击
 */
- (IBAction)graphicBtnClick
{
    //1. 设置选中状态
    self.trailBtn.selected = NO;
    self.graphicBtn.selected = YES;
    self.dataBtn.selected = NO;
    
    //2. 切换scrollView的View
    CGFloat offsetX = self.view.bounds.size.width;
    self.cyclingArgumentScrollView.contentOffset = CGPointMake(offsetX, 0);
}

/**
 *  数据按钮点击
 */
- (IBAction)dataBtnClick
{
    //1. 设置选中状态
    self.trailBtn.selected = NO;
    self.graphicBtn.selected = NO;
    self.dataBtn.selected = YES;
    
    //2. 切换scrollView的View
    CGFloat offsetX = self.view.bounds.size.width * 2;
    self.cyclingArgumentScrollView.contentOffset = CGPointMake(offsetX, 0);
}

#pragma mark - scrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint currentPoint = scrollView.contentOffset;
    //根据偏移量计算出是第几个view
    //加上0.5进行四舍五入
    NSInteger page =  currentPoint.x / self.view.bounds.size.width + 0.5;
    
    //根据page切换button
    switch (page) {
        case 0:{
            self.trailBtn.selected = YES;
            self.graphicBtn.selected = NO;
            self.dataBtn.selected = NO;
            break;
        }
        case 1:{
            self.trailBtn.selected = NO;
            self.graphicBtn.selected = YES;
            self.dataBtn.selected = NO;
            break;
        }
        case 2:{
            self.trailBtn.selected = NO;
            self.graphicBtn.selected = NO;
            self.dataBtn.selected = YES;
            break;
        }
        default:
            break;
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
