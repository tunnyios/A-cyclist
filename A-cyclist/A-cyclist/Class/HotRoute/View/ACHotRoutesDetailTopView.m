//
//  HCTgHeaderView.m
//  01-day07-团购
//
//  Created by suhongcheng on 15/5/14.
//  Copyright (c) 2015年 suhongcheng. All rights reserved.
//

#import "ACHotRoutesDetailTopView.h"
#import "ACGlobal.h"
#import "ACSharedRoutePhotoModel.h"
#import "UIImageView+WebCache.h"

#define kpageNumbers    ((_photoArray.count) - 1)
#define kimageWidth     ACScreenBounds.size.width

@interface ACHotRoutesDetailTopView() <UIScrollViewDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
//图片索引
@property (nonatomic, assign) NSInteger index;

@end

@implementation ACHotRoutesDetailTopView

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kimageWidth, 160)];
        
        //设置scrollView的内容大小
        _scrollView.contentSize = CGSizeMake(kimageWidth * kpageNumbers, 0);
        //取消弹簧
        _scrollView.bounces = NO;
        //取消水平滚动条
        _scrollView.showsHorizontalScrollIndicator = NO;
        //分页滚动
        _scrollView.pagingEnabled = YES;
        
        //设置代理
        _scrollView.delegate = self;
        
        [self addSubview:_scrollView];
    }
    
    return _scrollView;
}

- (void)setPhotoArray:(NSArray *)photoArray
{
    _photoArray = photoArray;
    
    //1. 设置图像
    for (int i = 0; i < kpageNumbers; i++) {
        CGFloat x = kimageWidth * i;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, kimageWidth, 160)];
        ACSharedRoutePhotoModel *photoModel = self.photoArray[i];
        NSURL *url = [NSURL URLWithString:photoModel.photoURL];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"route_cell_default_icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                DLog(@"从网络下载图片失败, error is %@", error);
            } else {
                DLog(@"从网络下载图片成功");
            }
        }];
        [self.scrollView addSubview:imageView];
    }
    
    //2. 设置分页标志
    [self pageControl];
    
    //3. 设置时钟
    [self startTimer];
}

#pragma mark - NSTimer部分
/** 启动时钟 */
- (void)startTimer
{
//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    //添加到common的当前运行循环中,此种情况在滚动滑块儿，也不影响计时器的行为
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    /**
     因此，需要监听scorllView的拖拽事件，
     开始拖拽的时候，停止时钟
     结束拖拽的时候，启动时钟
     */
}

/** 每2s执行一次 */
- (void)updateTimer:(NSTimer *)timer
{
    self.index = ++self.index % kpageNumbers;
    
    //根据图片的索引，设置scrollView的contentOffset
    [self.scrollView setContentOffset:CGPointMake(kimageWidth * self.index, 0) animated:YES];
    //设置当前的pageNumber
    self.pageControl.currentPage = self.index;
}

/** 停止时钟 */
- (void)stopTimer
{
    /**
     唯一停止时钟的方法，会删除时钟，
     想要启动，需要再次创建时钟
     */
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - pageControl部分
- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = kpageNumbers;
        
        //设置pageControl的位置
        CGSize size = [_pageControl sizeForNumberOfPages:kpageNumbers];
        _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
        _pageControl.center = CGPointMake(kimageWidth * 0.5, 150);
        
        //绑定pageControl监听事件
        [_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
        
        //添加到headerView上
        [self addSubview:_pageControl];
    }
    
    return _pageControl;
}


/** pageControl 的监听事件*/
- (void)pageChanged:(UIPageControl *)pageControl
{
    // pageControl 在当前值的左边点，值减1， 右边点值加1
    // 根据当前值来设置scrollView的contentOffset
    CGFloat x = pageControl.currentPage * kimageWidth;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

#pragma mark - 实现scrollView的代理方法

/** scrollView滚动停止监听事件 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //根据contentOffset的值来进行判断，当前是第几张图
    DLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    
    self.index = scrollView.contentOffset.x / kimageWidth;
    //根据当前值设置pageControl
    self.pageControl.currentPage = self.index;
}

/** scrollView的拖拽事件 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    DLog(@"开始拖拽...%@", NSStringFromCGPoint(scrollView.contentOffset));
    //停止时钟
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    DLog(@"结束拖拽...");
    //启动时钟
    [self startTimer];
}

@end
