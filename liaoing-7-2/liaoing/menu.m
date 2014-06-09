//
//  menu.m
//  liaoing
//
//  Created by eliuyan_mac on 14-6-7.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "menu.h"

@implementation menu
@synthesize tag;

- (id)initWithFrame:(CGRect)frame view:(UIViewController *)view
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      
        self.backgroundColor =[UIColor whiteColor];
        NSInteger xx = 0;
        _array = [[NSArray alloc] init];
        _array= [[NSUserDefaults standardUserDefaults] objectForKey:@"menuArray"];
        for(int i= 0;i<_array.count;i++)
        {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button setTitle:[_array objectAtIndex:i] forState:UIControlStateNormal];
            button.frame = CGRectMake(xx, 0, 320/_array.count,30);
            button.tag = i+1;
            [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            xx += 320/_array.count;
            
        }
        
        dataArray = [[NSArray alloc] init];
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, 320, 300)];
        _table.delegate = self;
        _table.dataSource = self;
        _table.hidden = YES;
        [view.view addSubview:_table];
        
    }
    return self;
}

-(void)settableYY:(float)yy
{
    if(yy<0)
    {
        yy=0;
    }
    CGRect myYY = _table.frame;
    myYY.origin.y = yy+40;
    _table.frame = myYY;
}
-(void)onClick:(id)sender
{
    UIButton * btn = (UIButton*)sender;
    [_delegate didClickMenuCallBack:btn.tag];
    
}

-(void)setReloadDate:(NSArray *)arr
{
    _table.hidden =NO;
    dataArray = [NSArray arrayWithArray:arr];
    [_table reloadData];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate didClickTableCallBack:[NSString stringWithFormat:@"选中的第%ld行",indexPath.row]];
    [_table setHidden:YES];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    cell.textLabel.text =[dataArray objectAtIndex:indexPath.row];
    return cell;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
