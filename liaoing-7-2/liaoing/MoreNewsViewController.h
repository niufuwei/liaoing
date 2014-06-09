//
//  MoreNewsViewController.h
//  liaoing
//
//  Created by laoniu on 14-6-7.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^callBack)(NSString*);

@interface MoreNewsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * table;
    NSArray * array;
}

@property (nonatomic,strong) callBack CallBack;

-(void)callback:(void(^)(NSString*))callback;

@end
