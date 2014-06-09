//
//  oldHouseViewController.h
//  liaoing
//
//  Created by laoniu on 14-6-3.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Old+RentingCell.h"
#import "menu.h"
#import "httpRequest.h"

@interface oldHouseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,menuDelegate,httpRequestDelegate>
{
    NSArray * ArrayArea_id;
    NSArray * ArrayPrice;
    NSArray * ArrayRoom;
    NSArray * ArraySort;
    NSDictionary * dic;
}

@property (nonatomic,strong) UITableView * table;
@property (nonatomic,strong) NSString * strTitle;
@property (nonatomic,strong) NSMutableArray * dataArray;
@end
