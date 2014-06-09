//
//  tempTable.h
//  liaoing
//
//  Created by laoniu on 14-6-7.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^callBack)(NSString*);
@interface tempTable : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary * MutableDictionary;
}

@property (nonatomic,strong) UITableView * table;
@property (nonatomic,strong) NSArray * arr;
@property (nonatomic,strong) callBack CallBack;

-(void)callback:(void(^)(NSString*))callback;

@end
