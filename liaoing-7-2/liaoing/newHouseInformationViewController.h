//
//  newHouseInformationViewController.h
//  liaoing
//
//  Created by laoniu on 14-6-2.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newHouseInformationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *listData;
}
@property (nonatomic,strong) UITableView * table;
@property (nonatomic,strong) NSString * strtitle;
@end
