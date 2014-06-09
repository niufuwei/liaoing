//
//  PARefreshDataPromptView.h
//  QueryMore
//
//  Created by FreeDo on 11-7-20.
//  Copyright 2011 Alive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/* 
 设置四种状态:
 */
typedef enum{
	kRefreshDataPromptNormal = 0,	//正常状态
	kRefreshDataPromptCanLoad,	//松手就可以加载
	kRefreshDataPromptPreLoad,	//松手后准备加载
	kRefreshDataPromptLoading,	//正在加载状态
} RefreshDataPromptState;

@protocol PARefreshDataPromptViewDelegate
@optional
- (void)refreshData;

@end


@interface PARefreshDataPromptView : UIView {
	UIActivityIndicatorView *activityIndicatorView;	//活动图标
	CALayer *arrowImage;	//箭头
	UILabel *stateLabel;	//文字提示
	
	id delegate;
	UITableView *tableView_ref;
	
	BOOL isActive;		//是否激活标志
	BOOL isLoading;		//是否还在加载中
	
	RefreshDataPromptState state;		//活动状态
	
}

@property (nonatomic, assign) id<PARefreshDataPromptViewDelegate> delegate;

/**
 * 功能：初始化
 * 参数：
 *		_tableView		显示数据的表视图
 *		_delegate		发送加载更多数据的代理
 */
- (id)initWithTableView:(UITableView *)_tableView delegate:(id<PARefreshDataPromptViewDelegate>)_delegate;

- (void)setActive:(BOOL)_isActive;		//是否激活设置
- (void)setIsLoading:(BOOL)_isLoading;	//是否正在加载设置

- (void)handleDidScroll:(UIScrollView *)scrollView;			//scrollViewDidScroll中调用
- (void)handleDidEndDragging:(UIScrollView *)scrollView;	//scrollViewDidEndDragging中调用
- (void)handleDidEndDecelerating:(UIScrollView *)scrollView;//scrollViewDidEndDecelerating中调用

@end
