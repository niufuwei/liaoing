//
//  PAQueryMorePromptView.m
//  QueryMore
//
//  Created by FreeDo on 11-7-20.
//  Copyright 2011 Alive. All rights reserved.
//

#import "PAQueryMorePromptView.h"

//箭头转上转下的动画时间
#define FLIP_ANIMATION_DURATION 0.18f
//触发加载更多数据 向下拖动距离
#define DRAG_TRIGGER_HEIGHT       50.0f

@interface PAQueryMorePromptView()

- (void)indicatorStartAnimating;
- (void)indicatorStopAnimating;

@end


@implementation PAQueryMorePromptView
@synthesize delegate;

- (void)setCurrentState:(QueryMorePromptState)_state{
	switch (_state) {
		case kQueryMorePromptCanLoad:
			
			stateLabel.text = @"释放获取更多数据";
			
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			arrowImage.transform = CATransform3DMakeRotation(3.1415f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case kQueryMorePromptNormal:
			
			if (state == kQueryMorePromptCanLoad) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			stateLabel.text = @"上拉获取更多数据";
			
			[self indicatorStopAnimating];
			
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			arrowImage.hidden = NO;
			arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			break;
		case kQueryMorePromptLoading:
			
			stateLabel.text = @"正在加载";
			
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
		if (state == kQueryMorePromptLoading) {
			[self setCurrentState:kQueryMorePromptNormal];
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.2];
			tableView_ref.contentInset = UIEdgeInsetsZero;
			[UIView commitAnimations];
		}
	}
	
	if (isRefreshed) {
		[refreshDataPromptView setIsLoading:_isLoading];
	}
}

- (void)setActive:(BOOL)_isActive{
	isActive = _isActive;
	self.hidden = !isActive;
	
	[self setIsLoading:NO];
	
	if (isRefreshed) {
		[refreshDataPromptView setActive:YES];
	}
}

#pragma mark -
#pragma mark initialization

- (id)initWithTableView:(UITableView *)_tableView delegate:(id<PAQueryMorePromptViewDelegate>)_delegate isRefreshed:(BOOL)_refreshFlag
{
    
    self = [super initWithFrame:CGRectMake(0, 0, 320, 60)];
    if (self) {
        //把实例加载到tableview 的 tableFooterView	上
		if (!_tableView.tableFooterView) {
			//NSLog(@"tableFooterView is nil!~");
			_tableView.tableFooterView = [[[UIView alloc] init] autorelease];
		}
		[_tableView.tableFooterView addSubview:self];
		
		self.delegate = _delegate;
		tableView_ref = _tableView;
		
		isRefreshed = _refreshFlag;
		if (isRefreshed) {
			refreshDataPromptView = [[PARefreshDataPromptView alloc] initWithTableView:_tableView delegate:_delegate];
		}
		
		UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_bg_small.png"]];
		imgView.frame = CGRectMake(40, 0, 11, 27);
		[self addSubview:imgView];
		[imgView release];
		
		stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(113, 0, 200, 50)];
		stateLabel.text = @"上拉获取更多数据";
        //stateLabel.textAlignment = UITextAlignmentCenter;
		stateLabel.font = [UIFont boldSystemFontOfSize:12];
		stateLabel.textColor = [UIColor colorWithRed:132/255.0 green:143/255.0 blue:162/255.0 alpha:1.0];
		[stateLabel setBackgroundColor:[UIColor clearColor]];
		[self addSubview:stateLabel];
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(75.0f, 10, 11.0f, 27.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"sys_blueArrow.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		arrowImage=layer;
		
		activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(75, 15, 20, 20)];
		activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		[self indicatorStopAnimating];
		[self addSubview:activityIndicatorView];
		
		state = kQueryMorePromptNormal;
    }
    return self;
}

- (id)initWithTableView:(UITableView *)_tableView delegate:(id<PAQueryMorePromptViewDelegate>)_delegate{
    
	return [self initWithTableView:_tableView delegate:_delegate isRefreshed:NO];
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
	if (isActive&&!isLoading) {
		if (scrollView.tracking) {
			if (state == kQueryMorePromptNormal) {
				if (tableView_ref.bounds.size.height+scrollView.contentOffset.y-scrollView.contentSize.height >= DRAG_TRIGGER_HEIGHT) {
					[self setCurrentState:kQueryMorePromptCanLoad];
				}
			}else if (state == kQueryMorePromptCanLoad) {
				if (tableView_ref.bounds.size.height+scrollView.contentOffset.y-scrollView.contentSize.height < DRAG_TRIGGER_HEIGHT) {
					[self setCurrentState:kQueryMorePromptNormal];
				}
			}
			
		}
	}
	
	if (isRefreshed) {
		[refreshDataPromptView handleDidScroll:scrollView];
	}
	
}
- (void)handleDidEndDragging:(UIScrollView *)scrollView{
	//NSLog(@"handleDidEndDragging");
	if (isActive&&!isLoading) {
		if (state == kQueryMorePromptCanLoad) {
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.2];
			scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 75.0f, 0.0f);
			[UIView commitAnimations];
			
			[self setCurrentState:kQueryMorePromptPreLoad];
		}
	}
	
	if (isRefreshed) {
		[refreshDataPromptView handleDidEndDragging:scrollView];
	}
}
- (void)handleDidEndDecelerating:(UIScrollView *)scrollView{
	//NSLog(@"handleDidEndDecelerating");
	if (isActive&&!isLoading) {
		if (state == kQueryMorePromptPreLoad) {
			[self setCurrentState:kQueryMorePromptLoading];
			if ([delegate respondsToSelector:@selector(loadingForMoreData)]) {
				[delegate loadingForMoreData];
			}
			//[self performSelector:@selector(setIsLoading:) withObject:NO afterDelay:3];
		}
	}
	
	if (isRefreshed) {
		[refreshDataPromptView handleDidEndDecelerating:scrollView];
	}
}

#pragma mark -
#pragma mark deal with locate
- (void)dealloc {
	[activityIndicatorView release];
	[stateLabel release];
	//[tableView_ref release];
	if (isRefreshed) {
		[refreshDataPromptView release];
	}
    [super dealloc];
}


@end
