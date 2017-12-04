//
//  ThirdViewController.h
//  ZXMultipleGestureSolutionDemo
//
//  Created by 郑旭 on 2017/12/4.
//  Copyright © 2017年 郑旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXMultipleGestureHeader.h"
@interface ThirdViewController : UIViewController
@property (nonatomic,weak) id<ChildScrollViewDidScrollDelegate> delegate;
/*
 * canScroll指的是父视图scrollView能滚动而不是自己的tableView
 */
@property (nonatomic, assign) BOOL canScroll;
@end
