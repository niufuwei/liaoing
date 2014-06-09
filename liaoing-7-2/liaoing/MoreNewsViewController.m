//
//  MoreNewsViewController.m
//  ;
//
//  Created by laoniu on 14-6-7.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "MoreNewsViewController.h"
#import "tempTableCell.h"

@interface MoreNewsViewController ()
{
    NSMutableDictionary * MutableDictionary;
}
@end

@implementation MoreNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"更多资讯";
    self.navigationItem.leftBarButtonItem = [self barButtonItemWithNormalImageName:@"navBackBtn.png"
                                                              highlightedImageName:nil
                                                                            target:self
                                                                            action:@selector(backBtn:)];
    
    MutableDictionary= [[NSMutableDictionary alloc] init];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44)];
    table.delegate = self;
    table.dataSource  =self;
    [self.view addSubview:table];
    
    
    array = [NSArray arrayWithObjects:@"本地资讯",@"全国资讯",@"楼盘动态",@"楼盘优惠",@"楼市情报",@"楼市评测",@"服务机构",@"商业地产",@"土地市场",@"地产智库",@"现场直播",@"嘉宾访谈",@"团购动态",@"专题新闻",@"便民服务",@"本地民生",@"二手房动态",@"招聘信息",@"二手房人物专访",@"会员公司新闻",@"租赁指南",@"租房故事",@"家居资讯",nil];
    // Do any additional setup after loading the view.
}

-(void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [array count];
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
    
    cell.name.text = [array objectAtIndex:indexPath.row];
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
-(void)callback:(void(^)(NSString*))callback
{
    if(self)
    {
        _CallBack = callback;
    }
}
-(IBAction)onClick:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    tempTableCell * AddressCell = (tempTableCell*)[[btn superview] superview];
    if(![[MutableDictionary objectForKey:[NSString stringWithFormat:@"%d",btn.tag]] isEqualToString:@"isChoose"])
    {
        
        NSIndexPath * index = [NSIndexPath indexPathForRow:btn.tag-1 inSection:0];
        tempTableCell * cell = (tempTableCell*)[table cellForRowAtIndexPath:index];
        
        [cell.choose setBackgroundImage:[UIImage imageNamed:@"曾用地址_未选.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"曾用地址_选中.png"] forState:UIControlStateNormal];
        [MutableDictionary setObject:@"isChoose" forKey:[NSString stringWithFormat:@"%d",btn.tag]];
    }
    else
    {
        NSLog(@"你已经选中");
    }
    _CallBack([NSString stringWithFormat:@"%@",AddressCell.name.text]);

    [self.navigationController popViewControllerAnimated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
