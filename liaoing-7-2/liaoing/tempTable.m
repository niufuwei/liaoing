//
//  tempTable.m
//  liaoing
//
//  Created by laoniu on 14-6-7.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "tempTable.h"
#import "tempTableCell.h"

@implementation tempTable


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    
}
-(void)callback:(void(^)(NSString*))callback
{
    if(self)
    {
        _CallBack = callback;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    MutableDictionary = [[NSMutableDictionary alloc] init];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 22, 320, self.view.frame.size.height-22)];
    _table.delegate =self;
    _table.dataSource = self;
    
    [self.view addSubview:_table];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arr count]-1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID = @"cell";
    tempTableCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if(cell ==nil)
    {
        cell = [[tempTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    
    cell.name.text = [_arr objectAtIndex:indexPath.row+1];
    cell.choose.tag = indexPath.row+1;
    [cell.choose addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row==0)
    {
        [MutableDictionary setObject:@"isChoose" forKey:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
    }
    
    if([[MutableDictionary objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row+1]] isEqualToString:@"isChoose"])
    {
        [cell.choose setBackgroundImage:[UIImage imageNamed:@"曾用地址_选中.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [cell.choose setBackgroundImage:[UIImage imageNamed:@"曾用地址_未选.png"] forState:UIControlStateNormal];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * label = [[UILabel alloc] init];
    label.text = [_arr objectAtIndex:0];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:23];
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor blackColor];
    return label;
}
// custom view for header. will be adjusted to default or specified header height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}
-(IBAction)onClick:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    
    if(![[MutableDictionary objectForKey:[NSString stringWithFormat:@"%d",btn.tag]] isEqualToString:@"isChoose"])
    {
        
        NSIndexPath * index = [NSIndexPath indexPathForRow:btn.tag-1 inSection:0];
        tempTableCell * cell = (tempTableCell*)[_table cellForRowAtIndexPath:index];
        
        [cell.choose setBackgroundImage:[UIImage imageNamed:@"曾用地址_未选.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"曾用地址_选中.png"] forState:UIControlStateNormal];
        [MutableDictionary setObject:@"isChoose" forKey:[NSString stringWithFormat:@"%d",btn.tag]];
        
        tempTableCell * AddressCell = (tempTableCell*)[[btn superview] superview];
        
        _CallBack([NSString stringWithFormat:@"%@",AddressCell.name.text]);
        
    }
    else
    {
        NSLog(@"你已经选中");
        _CallBack(@"");
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
