//
//  DetailQuViewController.h
//  liaoing
//
//  Created by shanchen on 14-6-7.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailQuViewController : UIViewController

<UITableViewDataSource,UITableViewDelegate>

{
    UITableView *_tableView;
    
    NSMutableArray *_array;
}

@property (nonatomic,strong)NSString * quName;


@end
