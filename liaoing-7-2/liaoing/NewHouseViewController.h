//
//  NewHouseViewController.h
//  liaoing
//
//  Created by haonan.wang on 14-5-7.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "NSString+URLEncoding.h"
#import "lookHouseViewController.h"
#import "menu.h"

@interface NewHouseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,menuDelegate>
{
    UITableView *tableView;
    NSMutableArray *listData;
    UITableView * headTable;
    
}
@end
