//
//  NewsContentViewController.h
//  TestDemo
//
//  Created by Mealk.Lei on 14-4-30.
//  Copyright (c) 2014年 WeSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsContentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    UITableView *tableView;
    int webHeight;
}

@property (nonatomic,strong) NSDictionary *infoDict;
@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, copy) NSString *titleStr;

@end
