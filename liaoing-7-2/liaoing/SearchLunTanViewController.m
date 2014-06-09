//
//  SearchLunTanViewController.m
//  liaoing
//
//  Created by shanchen on 14-6-7.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "SearchLunTanViewController.h"
#import "DetailQuViewController.h"



@interface SearchLunTanViewController ()

@end

@implementation SearchLunTanViewController

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
    // Do any additional setup after loading the view.
    
    _array = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.title = @"论坛目录";

    self.navigationItem.leftBarButtonItem = [self barButtonItemWithNormalImageName:@"navBackBtn.png"
                                                              highlightedImageName:nil
                                                                            target:self
                                                                            action:@selector(backBtn:)];
    
    //添加搜索框
    UISearchBar *searchBar=[[UISearchBar alloc ] initWithFrame:CGRectMake(10, 0, 300, 40)];
    searchBar.placeholder=@"请输入您要搜索内容的关键字";
    [self.view addSubview:searchBar];
    //添加表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, self.view.frame.size.height)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    
    //获取数据
    self.hud = [self showWorkingHUD:NSLocalizedString(@"加载数据中...", nil)];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:@"http://zhengzhou.liaoing.com/ios/bbslistareaall/city/1041.html" parameters:nil error:nil];
    self.op = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        [self hidHUDMessage:self.hud animated:YES];
        
        NSArray *arr = [NSArray arrayWithArray:[(NSDictionary*)responseObject objectForKey:@"info"]];
        
        for (int i=0; i<arr.count; i++) {
            NSDictionary *dic=[arr objectAtIndex:i];
            NSString *key=[dic objectForKey:@"key"];
            NSString *name=[dic objectForKey:@"name"];
            [_array addObject:name];
        }
        
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        [self hidHUDMessage:self.hud animated:YES];
        
    }];
    [self.op start];


}


#pragma- Button Action
- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - UITableViewDelegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
    }
    if (_array.count==0) {
        cell.textLabel.text = @"";
    }
    else
    {
        NSString *name=[_array objectAtIndex:indexPath.row];
        
        cell.textLabel.text = name;
    }
    
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = [[UIView alloc] init];
    [headView setBackgroundColor:[UIColor grayColor]];
    UILabel * tishi = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 310, 20)];
    tishi.backgroundColor = [UIColor clearColor];
    tishi.text = [NSString stringWithFormat:@"城市区域"];
    [headView addSubview:tishi];
    
    
    return headView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击进入相呼应的界面
        DetailQuViewController *detailVC=[[DetailQuViewController alloc] init];
    
        detailVC.quName=[_array objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
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
