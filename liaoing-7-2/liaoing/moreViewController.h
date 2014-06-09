//
//  moreViewController.h
//  liaoing
//
//  Created by eliuyan_mac on 14-6-7.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface moreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * arr;
}

@property (nonatomic,strong) UITableView * table;

@end
