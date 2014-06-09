//
//  PAQueryMorePromptView.h
//  QueryMore
//
//  Created by FreeDo on 11-7-20.
//  Copyright 2011 Alive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PARefreshDataPromptView.h"

/**		
 使用实例
 
 1 初始化：
 注意：PAQueryMorePromptView的初始化一定要在tableView的tableFooterView 实例化 之后
 
 tableFooter = [[UIView alloc] init];
 [tableFooter addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MyAccountBook_BottomTable_Class_img.png"]]];
 tableFooter.frame = CGRectMake(0, 0, 320, 22.5);
 self.myTableView.tableFooterView = tableFooter;
 
 queryMorePromptView = [[PAQueryMorePromptView alloc] initWithTableView:self.myTableView delegate:self];
 
 2 状态设置：
 一般情况下，viewController都有2个标志变量，如 isCanQueryMore，是否还可以请求更多数据；isLoadingMore，是否正在请求更多数据。
 在网络请求解析结束后回调时，设置queryMorePromptView的状态
 
 if (self.viewController.isCanQueryMore) {
 [queryMorePromptView setActive:YES];
 [queryMorePromptView setIsLoading:self.viewController.isLoadingMore];
 }else {
 [queryMorePromptView setActive:NO];
 }
 
 3 scrollView 代理方法里面调用对应调用三个成员方法
 
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
 {
 [queryMorePromptView handleDidScroll:scrollView];
 }
 
 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
 {
 [queryMorePromptView handleDidEndDragging:scrollView];
 }
 
 - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
 {
 [queryMorePromptView handleDidEndDecelerating:scrollView];
 }
 
 4 协议方法使用 注意：用延迟发送请求更多数据，才不会出现scrollview滑动的时候卡
 
 - (void)loadingForMoreData{
 [self.viewController performSelector:@selector(requestForMoreData) withObject:nil afterDelay:.3];
 }
 
 */

/* 
 设置四种状态:
 */
typedef enum{
	kQueryMorePromptNormal = 0,	//正常状态
	kQueryMorePromptCanLoad,	//松手就可以加载
	kQueryMorePromptPreLoad,	//松手后准备加载
	kQueryMorePromptLoading,	//正在加载状态
} QueryMorePromptState;

@protocol PAQueryMorePromptViewDelegate<PARefreshDataPromptViewDelegate>

//发送加载更多数据请求，最好用延迟发送
- (void)loadingForMoreData;

@end


@interface PAQueryMorePromptView : UIView {
	UIActivityIndicatorView *activityIndicatorView;	//活动图标
	CALayer *arrowImage;	//箭头
	UILabel *stateLabel;	//文字提示
	
	id delegate;
	UITableView *tableView_ref;
	
	BOOL isActive;		//是否激活标志
	BOOL isLoading;		//是否还在加载中
	
	QueryMorePromptState state;		//活动状态
	
	BOOL isRefreshed;	//是否带下拉刷新功能
	PARefreshDataPromptView *refreshDataPromptView;	
}

@property (nonatomic, assign) id<PAQueryMorePromptViewDelegate> delegate;

/**
 * 功能：初始化
 * 参数：
 *		_tableView		显示数据的表视图
 *		_delegate		发送加载更多数据的代理
 *		_refreshFlag	是否带下拉刷新功能
 */
- (id)initWithTableView:(UITableView *)_tableView delegate:(id<PAQueryMorePromptViewDelegate>)_delegate;
- (id)initWithTableView:(UITableView *)_tableView delegate:(id<PAQueryMorePromptViewDelegate>)_delegate isRefreshed:(BOOL)_refreshFlag;

- (void)setActive:(BOOL)_isActive;		//是否激活设置
- (void)setIsLoading:(BOOL)_isLoading;	//是否正在加载设置

- (void)handleDidScroll:(UIScrollView *)scrollView;			//scrollViewDidScroll中调用
- (void)handleDidEndDragging:(UIScrollView *)scrollView;	//scrollViewDidEndDragging中调用
- (void)handleDidEndDecelerating:(UIScrollView *)scrollView;//scrollViewDidEndDecelerating中调用

@end
