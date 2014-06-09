//
//  menu.h
//  liaoing
//
//  Created by eliuyan_mac on 14-6-7.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol menuDelegate <NSObject>

-(void)didClickMenuCallBack:(NSInteger)buttonIndex;
-(void)didClickTableCallBack:(NSString*)indexName;

@end
@interface menu : UIView<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * dataArray;
}

@property (nonatomic,strong) NSArray * array ;
@property (nonatomic,strong) UITableView * table;
@property (nonatomic,strong) id<menuDelegate>delegate;

-(id)initWithFrame:(CGRect)frame view:(UIViewController*)view;
-(void)settableYY:(float)yy;
-(void)setReloadDate:(NSArray*)arr;
@end
