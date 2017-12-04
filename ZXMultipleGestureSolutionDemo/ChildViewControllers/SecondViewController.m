//
//  SecondViewController.m
//  ZXMultipleGestureSolutionDemo
//
//  Created by 郑旭 on 2017/12/4.
//  Copyright © 2017年 郑旭. All rights reserved.
//
#import "Masonry.h"
#import "SecondViewController.h"
#import "ZXMutipleGestureTableView.h"
@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) ZXMutipleGestureTableView  *tableView;
@end

@implementation SecondViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubViews];
    [self addConstrains];
}
#pragma mark - Private Methods
- (void)initData
{
    self.canScroll = YES;
}
- (void)addSubViews
{
    [self.view addSubview:self.tableView];
    
}
- (void)addConstrains
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.
        bottom.mas_equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 25;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(childScrollViewDidScroll:)]) {
        [self.delegate childScrollViewDidScroll:scrollView];
    }
}

#pragma mark - Getters & Setters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[ZXMutipleGestureTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
@end
