//
//  ViewController.m
//  ZXMultipleGestureSolutionDemo
//
//  Created by 郑旭 on 2017/12/4.
//  Copyright © 2017年 郑旭. All rights reserved.
//
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#import "ViewController.h"
#import "Masonry.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
@interface ViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate,ChildScrollViewDidScrollDelegate>
@property (nonatomic,strong) UIScrollView  *scrollView;
@property (nonatomic,strong) UIView  *scrollContentView;
@property (nonatomic,strong) UIImageView  *headImageView;
@property (nonatomic,strong) UIView  *titleView;
@property (nonatomic,strong) UIPageViewController * pageViewVC;
@property (nonatomic,strong) NSMutableArray * childVCArray;
@property (nonatomic,assign) NSInteger currentChildVCIndex;
@end

@implementation ViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubViews];
    [self addConstrains];
    [self initData];
}
#pragma mark - Private Methods
- (void)initData
{
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, 0,80, 30)];
    title.font = [UIFont boldSystemFontOfSize:17];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"首页";
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.titleView = title;
    self.navigationController.navigationBar.translucent = NO;
    UIViewController *initVC = self.childVCArray[0];
    self.currentChildVCIndex = 0;
    [self.pageViewVC setViewControllers:@[initVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}
- (void)addSubViews
{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollContentView];
    [self.scrollContentView addSubview:self.headImageView];
    [self.scrollContentView addSubview:self.titleView];
    [self addChildViewController:self.pageViewVC];
    [self.scrollContentView addSubview:self.pageViewVC.view];
}
- (void)addConstrains
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(SCREEN_HEIGHT-64+200);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView);
        make.right.left.mas_equalTo(self.scrollContentView);
        make.height.mas_equalTo(200);
    }];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImageView.mas_bottom);
        make.left.right.mas_equalTo(self.scrollContentView);
        make.height.mas_equalTo(49);
    }];
    [self.pageViewVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
 
        make.top.mas_equalTo(self.titleView.mas_bottom);
        make.right.left.mas_equalTo(self.scrollContentView);
        make.bottom.mas_equalTo(self.view);
    }];
}
- (BOOL)getCanScroll
{
    if (self.currentChildVCIndex==0) {
        FirstViewController *vc = self.childVCArray[self.currentChildVCIndex];
        return  vc.canScroll;
    }else if (self.currentChildVCIndex==1)
    {
        SecondViewController *vc = self.childVCArray[self.currentChildVCIndex];
        return vc.canScroll;
    }else if (self.currentChildVCIndex==2)
    {
        ThirdViewController *vc =self.childVCArray[self.currentChildVCIndex];
        return vc.canScroll;
    }
    return NO;
}
- (void)setCanScroll:(BOOL)canScroll
{
    if (self.currentChildVCIndex==0) {
        FirstViewController *vc = self.childVCArray[self.currentChildVCIndex];
        vc.canScroll = canScroll;
    }else if (self.currentChildVCIndex==1)
    {
        SecondViewController *vc = self.childVCArray[self.currentChildVCIndex];
        vc.canScroll = canScroll;
    }else if (self.currentChildVCIndex==2)
    {
        ThirdViewController *vc =self.childVCArray[self.currentChildVCIndex];
        vc.canScroll = canScroll;
    }
}
#pragma mark - UIPageViewControllerDelegate
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSUInteger index = [self.childVCArray indexOfObject:viewController];
    if (index <= 0) {
        
        return nil;
    }
    self.currentChildVCIndex = index-1;
    
    return self.childVCArray[index-1];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = [self.childVCArray indexOfObject:viewController];
    if (index >= self.childVCArray.count -1) {
        
        return nil;
    }
    self.currentChildVCIndex = index+1;
    return self.childVCArray[index+1];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    BOOL canScroll = [self getCanScroll];
    //如果自己不能滚动,那么就固定在固定位置
    if (!canScroll) {
        [scrollView setContentOffset:CGPointMake(0, 200)];
    }
}
#pragma mark - ChildScrollViewDidScrollDelegate
- (void)childScrollViewDidScroll:(UIScrollView *)scrollView
{
    BOOL canScroll = [self getCanScroll];
    //下拉的时候:scrollView.contentOffset.y<=0说明子视图的滚动已经到头了;父视图即将开始滚动
    if (scrollView.contentOffset.y<=0) {
        [self setCanScroll:YES];
        [scrollView setContentOffset:CGPointZero];
    }else{
//      CGRect rec = [self.titleView convertRect:self.titleView.bounds toView:[UIApplication sharedApplication].keyWindow];
        CGRect rec = [self.titleView convertRect:self.titleView.bounds toView:self.view];
        //父视图没有到头的时候;子视图将设置CGPointZero;和父视图一起滚动;
        if (canScroll&&rec.origin.y>0) {
            [scrollView setContentOffset:CGPointZero];
            [self setCanScroll:YES];
        }else{
            //父视图到头:那么设置父视图不再滚动
            [self setCanScroll:NO];
        }
    }
}

#pragma mark - Getters & Setters
- (UIPageViewController *)pageViewVC{
    
    if (!_pageViewVC) {
        
        _pageViewVC             = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewVC.dataSource  = self;
        _pageViewVC.delegate    = self;
        
    }
    return _pageViewVC;
}
- (NSMutableArray *)childVCArray
{
    if (!_childVCArray) {
        //
        _childVCArray = [NSMutableArray array];
        FirstViewController *firstVC = [FirstViewController new];
        firstVC.delegate = self;
        //
        SecondViewController *secondVC = [SecondViewController new];
        secondVC.delegate = self;
        //
        ThirdViewController *thirdVC = [ThirdViewController new];
        thirdVC.delegate = self;
        [_childVCArray addObject:firstVC];
        [_childVCArray addObject:secondVC];
        [_childVCArray addObject:thirdVC];
    }
    return _childVCArray;
}
- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timg"]];
    }
    return _headImageView;
}
- (UIView *)scrollContentView
{
    if (!_scrollContentView) {
        _scrollContentView = [[UIView alloc] init];
    }
    return _scrollContentView;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.delegate = self;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.tag = 666;
    }
    return _scrollView;
}
- (UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor cyanColor];
    }
    return _titleView;
}
@end
