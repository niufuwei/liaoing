//
//  NewsListViewController.h
//  TestDemo
//
//  Created by Mealk.Lei on 14-4-30.
//  Copyright (c) 2014年 WeSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreNewsViewController.h"

@interface NewsListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * tagArray;
}
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;

@property (weak, nonatomic) UIButton *button;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

-(void)refreshData;
- (IBAction)BtnPressed:(id)sender;
@end
