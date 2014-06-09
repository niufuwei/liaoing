//
//  SearchLunTanViewController.h
//  liaoing
//
//  Created by shanchen on 14-6-7.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"



@interface SearchLunTanViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>

{
    UITableView *_tableView;
    
    NSMutableArray *_array;
}

@property (nonatomic, strong) AFHTTPRequestOperation* op;
@property (nonatomic, strong) MBProgressHUD* hud;


@end
