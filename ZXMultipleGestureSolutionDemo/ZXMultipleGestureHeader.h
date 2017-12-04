//
//  ZXMultipleGestureHeader.h
//  ZXMultipleGestureSolutionDemo
//
//  Created by 郑旭 on 2017/12/4.
//  Copyright © 2017年 郑旭. All rights reserved.
//
#ifndef ZXMultipleGestureHeader_h
#define ZXMultipleGestureHeader_h
@protocol ChildScrollViewDidScrollDelegate<NSObject>
@optional
- (void)childScrollViewDidScroll:(UIScrollView *)scrollView;
@end
#endif /* ZXMultipleGestureHeader_h */
