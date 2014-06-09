//
//  PARefreshDataPromptView.m
//  QueryMore
//
//  Created by FreeDo on 11-7-20.
//  Copyright 2011 Alive. All rights reserved.
//

#import "PARefreshDataPromptView.h"

//箭头转上转下的动画时间
#define FLIP_ANIMATION_DURATION 0.18f
//触发加载更多数据 向下拖动距离
#define DRAG_TRIGGER_HEIGHT       50.0f

@interface PARefreshDataPromptView()

- (void)indicatorStartAnimating;
- (void)indicatorStopAnimating;

@end


@implementation PARefreshDataPromptView
@synthesize delegate;

- (void)setCurrentState:(RefreshDataPromptState)_state{
	switch (_state) {
		case kRefreshDataPromptCanLoad:
			
			stateLabel.text = @"释放立即刷新";
			
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			//[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			break;
		case kRefreshDataPromptNormal:
			
			//			if (state == kRefreshDataPromptCanLoad) {
			//				[CATransaction begin];
			//				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			//				arrowImage.transform = CATransform3DMakeRotation(3.1415f, 0.0f, 0.0f, 1.0f);
			//				[CATransaction commit];
			//			}
			
			stateLabel.text = @"下拉刷新";
			
			[self indicatorStopAnimating];
			
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			arrowImage.transform = CATransform3DMakeRotation(3.1415f, 0.0f, 0.0f, 1.0f);
			arrowImage.hidden = NO;
			[CATransaction commit];
			
			break;
		case kRefreshDataPromptLoading:
			
			stateLabel.text = @"正在刷新";
			
			[self indicatorStartAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	state = _state;
}

- (void)setIsLoading:(BOOL)_isLoading{
	isLoading = _isLoading;
	if (!isLoading) {
		if (state == kRefreshDataPromptLoading) {
			[self setCurrentState:kRefreshDataPromptNormal];
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.2];
			tableView_ref.contentInset = UIEdgeInsetsZero;
			[UIView commitAnimations];
		}
	}
}

- (void)setActive:(BOOL)_isActive{
	isActive = _isActive;
	self.hidden = !isActive;
	
	[self setIsLoading:NO];
}

#pragma mark -
#pragma mark initialization

- (id)initWithTableView:(UITableView *)_tableView delegate:(id<PARefreshDataPromptViewDelegate>)_delegate{
    
    self = [super initWithFrame:CGRectMake(0, -100, 320, 100)];
    if (self) {
		
		//		if (!_tableView.tableHeaderView) {
		//			_tableView.tableHeaderView = [[[UIView alloc] init] autorelease];
		//		}
		[_tableView addSubview:self];
		
		self.delegate = _delegate;
		tableView_ref = _tableView;
		
		UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_bg_small.png"]];
		imgView.frame = CGRectMake(40, 0, 11,27);
		[self addSubview:imgView];
		[imgView release];
		
		stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(133, 45, 200, 50)];
		stateLabel.text = @"下拉刷新";
		stateLabel.font = [UIFont boldSystemFontOfSize:12];
		stateLabel.textColor = [UIColor colorWithRed:132/255.0 green:143/255.0 blue:162/255.0 alpha:1.0];
		[stateLabel setBackgroundColor:[UIColor clearColor]];
		[self addSubview:stateLabel];
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(95.0f, 60.0f, 11.0f, 27.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"sys_blueArrow.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		arrowImage=layer;
		arrowImage.transform = CATransform3DMakeRotation(3.1415f, 40.0f, 0.0f, 1.0f);
		
		activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(110, 60, 20, 20)];
		activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		[self indicatorStopAnimating];
		[self addSubview:activityIndicatorView];
		
		state = kRefreshDataPromptNormal;
    }
    return self;
}

- (void)indicatorStartAnimating{	
	[activityIndicatorView startAnimating];
    activityIndicatorView.hidden = NO;
    tableView_ref.scrollEnabled = NO;
}

- (void)indicatorStopAnimating{
    tableView_ref.scrollEnabled = YES;
	if (activityIndicatorView) {
		activityIndicatorView.hidden = YES;
		[activityIndicatorView stopAnimating];
	}
}

#pragma mark -
#pragma mark scrollView delegate matheds
- (void)handleDidScroll:(UIScrollView *)scrollView{
	//NSLog(@"handleDidScroll：%f",scrollView.contentOffset.y);
	
	if (scrollView.contentOffset.y <= 0) {
		tableView_ref.clipsToBounds = NO;
	}else {
		tableView_ref.clipsToBounds = YES;
	}
	
	if (isActive&&!isLoading) {
		if (scrollView.tracking) {
			if (state == kRefreshDataPromptNormal) {
				if (scrollView.contentOffset.y <= -DRAG_TRIGGER_HEIGHT) {
					[self setCurrentState:kRefreshDataPromptCanLoad];
				}
			}else if (state == kRefreshDataPromptCanLoad) {
				if (scrollView.contentOffset.y > -DRAG_TRIGGER_HEIGHT) {
					[self setCurrentState:kRefreshDataPromptNormal];
				}
			}
			
		}
	}
	
}
- (void)handleDidEndDragging:(UIScrollView *)scrollView{
	//NSLog(@"handleDidEndDragging");
	if (isActive&&!isLoading) {
		if (state == kRefreshDataPromptCanLoad) {
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.2];
			scrollView.contentInset = UIEdgeInsetsMake(75.0f, 0.0f, 0.0f, 0.0f);
			[UIView commitAnimations];
			
			[self setCurrentState:kRefreshDataPromptPreLoad];
		}
	}
}
- (void)handleDidEndDecelerating:(UIScrollView *)scrollView{
	//NSLog(@"handleDidEndDecelerating");
	if (isActive&&!isLoading) {
		if (state == kRefreshDataPromptPreLoad) {
			[self setCurrentState:kRefreshDataPromptLoading];
			if ([delegate respondsToSelector:@selector(refreshData)]) {
				[delegate refreshData];
			}
			//[self performSelector:@selector(setIsLoading:) withObject:NO afterDelay:3];
		}
	}
}

#pragma mark -
#pragma mark deal with locate
- (void)dealloc {
    NSLog(@"pARefreshDataPromptView dealloc");
	[activityIndicatorView release];
	[stateLabel release];
    //[tableView_ref release];
    [super dealloc];
}


@end
