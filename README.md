# UI层级 
UIScrollView     

UIPageViewController

UITableView   

##### 下面所讨论的一切基础是手势作用在底部tableView上面的而时候;

# step1:   
正常情况下,多个手势重叠的时候,只会响应最上层的那个手势,这里的话就只会响应最上层tableView的手势;    


# step2:         
允许手势向下传递并响应多个手势:  这样一来,在滚动tableView的时候,scrollView会跟随响应滚动事件;
	
	
	@implementation ZXMutipleGestureTableView
	/*
	 * Simultaneously:同时地;
	 * 是否允许多个手势识别器共同识别，一个控件的手势识别后是否阻断手势识别继续向下传播，默认返回NO；如果为YES，响应者链上层对象触发手势识别后，如果下层对象也添加了手势并成功识别也会继续执行，否则上层对象识别后则不再继续传播
	 */
	- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
	{
	    return YES;
	}
	@end



## step3:状态分析
`顶点状态`:规定的scrollView能向上滚动的最大位置;这里以绿色view顶部接触导航栏的时候为顶点;   
`顶点状态判断`:      

	CGRect rec = [self.titleView convertRect:self.titleView.bounds toView:self.view];   

rec.origin.y==0的时候代表顶点状态到达;

## 状态1:初始状态    
![img](https://github.com/czhen09/ZXMultipleGestureSolution/blob/master/RESOURCE/zt1.png)

在这个状态下:      

* 向下拉的时候:需限制bounces效果;   
* 向上滑动的时候:这个时候scrollView是没有到达目的顶点的,tableView和scrollView会同时向上滚动;那么我不能允许tableView向上滚动,即设置tableView始终在CGPointZero位置;    


## 状态2:顶点状态   

![img](https://github.com/czhen09/ZXMultipleGestureSolution/blob/master/RESOURCE/zt2.png)    


即时紧接着状态1;向上滚动到达顶点状态;那么这个时候,scrollView肯定不能再继续滚动,将其位置固定在顶点状态位置,只能tableView能继续向上滑动;   


## 状态3:中间状态   
![img](https://github.com/czhen09/ZXMultipleGestureSolution/blob/master/RESOURCE/zt3.png)    
这个时候,只有是tableView没有到顶,但是scrollView到顶,那么都是限制scrollView在顶点状态位置,而tableView可以滚动的


# step4:核心代码       
	#pragma mark - UIScrollViewDelegate
	- (void)scrollViewDidScroll:(UIScrollView *)scrollView
	{
	    BOOL canScroll = [self getCanScroll];
	    //如果自己不能滚动,那么就固定在固定位置
	    if (!canScroll) {
	    //对应状态2:顶点状态
	    //200指的是rec.origin.y==0的时候的偏移位置
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
	        
	        if (canScroll&&rec.origin.y>0) {
	        //父视图没有到头的时候;子视图将设置CGPointZero;和父视图一起滚动;
	        //对应状态1:初始状态;正常情况下向上滚动的时候,父scrollView和tableView都会向上滚动;
	            [scrollView setContentOffset:CGPointZero];
	            [self setCanScroll:YES];
	        }else{
	            //父视图到头:那么设置父视图不再滚动
	            //对应状态2:顶点状态,scrollView不能再滚动;
	            [self setCanScroll:NO];
	        }
	    }
	}
	
	
# step5:总结  
为了解决手势冲突,需要让控件都能响应手势,但是同时响应的时候,又需要在适当时机限制偏移;scrollView和tableView无论如何只能一个滚动;用CGPointZero限制tableView的偏移;用CGPointMake(0, 200)(200指的是顶点状态scrollView的偏移)来限制scrollView的偏移;    

如有不明,demo见;    

超链:   
*   Json转模型Mac版[ESJsonFormatForMac](https://github.com/czhen09/ESJsonFormatForMac)    
* 股票k线三方库[ZXKline](https://github.com/czhen09/ZXKline)