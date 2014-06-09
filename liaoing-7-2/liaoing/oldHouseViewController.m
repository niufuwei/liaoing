//
//  oldHouseViewController.m
//  liaoing
//
//  Created by laoniu on 14-6-3.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "oldHouseViewController.h"
#import "oldHouseInforViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "httpRequest.h"

@interface oldHouseViewController ()
{
    NSMutableArray * dataArray;
    MBProgressHUD * hud;
    NSInteger currentPage;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    menu * myMenu;
}

@end

@implementation oldHouseViewController

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
    
    self.title = _strTitle;
    
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // self.hidesBottomBarWhenPushed=YES;
    // self.view.backgroundColor = [UIColor redColor];

    dic = [[NSDictionary alloc] init];
    
    ArrayArea_id = [[NSArray alloc] init];
    ArrayPrice = [[NSArray alloc] init];
    ArrayRoom = [[NSArray alloc] init];
    ArraySort = [[NSArray alloc] init];
    
    self.navigationItem.leftBarButtonItem = [self barButtonItemWithNormalImageName:@"navBackBtn.png"
                                                              highlightedImageName:nil
                                                                            target:self
                                                                            action:@selector(backBtn:)];
    self.navigationItem.rightBarButtonItem = [self barButtonItemWithNormalImageName:@"x2.png"
                                                               highlightedImageName:nil
                                                                             target:self
                                                                             action:nil];

    
    dataArray  = [[NSMutableArray alloc] init];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, 320, self.view.frame.size.height-64-30)];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
    myMenu = [[menu alloc] initWithFrame:CGRectMake(0, 0, 320, 30) view:self];
    myMenu.delegate =self;
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"区域",@"售价",@"户型",@"排序", nil] forKey:@"menuArray"];
    
    [self.view addSubview:myMenu];
    
    currentPage = 1;

    [self refreshData];
    [self addFooter];
    [self addHeader];
        // Do any additional setup after loading the view.
}


#pragma mark - Public Method
-(void)refreshData{
 
    //    NSDictionary *dict = @{@"user_id": userid,
    //                           };
    //    NSError *error;
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSDictionary *params = @{@"field":jsonStr};
    //    NSLog(@"parms=======%@",params);
    NSString * strHttp = [NSString stringWithFormat:@"http://zhengzhou.liaoing.com/ios/esflist/city/1041/page/%d.html",currentPage];
    
    httpRequest * http = [[httpRequest alloc] init];
    http.httpDelegate = self;
    hud = [self showWorkingHUD:NSLocalizedString(@"加载数据中...", nil)];
    [http httpRequestSend:strHttp parameter:nil backBlock:(^(NSDictionary *tempdic)
                                                          {
                                                              ArrayArea_id = [tempdic objectForKey:@"area"];

                                                              dic = [tempdic objectForKey:@"allarea"];
                                                              
                                                              for(int i=0;i< [[tempdic objectForKey:@"info"] count];i++)
                                                              {
                                                                  [dataArray addObject:[[tempdic objectForKey:@"info"] objectAtIndex:i]];
                                                              }
                                                              [self hidHUDMessage:hud animated:YES];
                                                              [_table reloadData];

                                                          })];
    
}

-(void)httpRequestError:(NSString *)str
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器请求失败." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [self hidHUDMessage:hud animated:YES];
}
- (void)addFooter
{
    __unsafe_unretained oldHouseViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _table;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        currentPage++;
        [self refreshData];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:0.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footer = footer;
    
}
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

- (void)addHeader
{
    __unsafe_unretained oldHouseViewController *vc = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _table;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        currentPage =1;
        [dataArray removeAllObjects];
        [self refreshData];
        
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:0.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    _header = header;
    
}



-(void)didClickMenuCallBack:(NSInteger)buttonIndex
{
    [_table setHidden:YES];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dataArray"];
 
    NSArray * arr = [[NSArray alloc] init];
    if(buttonIndex==1)
    {
        arr=[[NSUserDefaults standardUserDefaults] objectForKey:@"dataArray"];
    }
    else if(buttonIndex ==2)
    {
        arr = [NSArray arrayWithObjects:@"30万以下",@"30-40万",@"40-50万",@"50-60万",@"60-80万",@"80-100万",@"100-150万",@"150-200万",@"200万以上", nil];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"dataArray"];

    }
    else if(buttonIndex == 3)
    {
        arr = [NSArray arrayWithObjects:@"不限",@"一室",@"二室",@"三室",@"四室",@"五室", nil];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"dataArray"];
    }
    else{
        arr = [NSArray arrayWithObjects:@"价格降序",@"价格升序",@"均价降序",@"均价升序",@"发布时间升序",@"发布时间降序", nil];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"dataArray"];
    }
    
    [myMenu setReloadDate:arr];

}

-(void)didClickTableCallBack:(NSString *)indexName
{
    [_table setHidden:NO];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    //    [self.tabBarController.tabBar setHidden:YES];
}
#pragma- Button Action
- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"====>%@",dataArray);
    return [dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID = @"cell";
    Old_RentingCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if(cell ==nil)
    {
        cell = [[Old_RentingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    
    if([[[dataArray objectAtIndex:indexPath.row] objectForKey:@"defaultpic"] length]==0)
    {
        [cell.image setImage:[UIImage imageNamed:@"difault.png"]];
    }
    else
    {
        [cell.image setImageWithURL:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"defaultpic"] placeholderImage:[UIImage imageNamed:@"isongktv_logo.png"]];

    }
    cell.title.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.short_address.text =[dic objectForKey:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"area_id"]];
    cell.money.text = [[[dataArray objectAtIndex:indexPath.row] objectForKey:@"price"] intValue] ==0?@"面议":[NSString stringWithFormat:@"￥:%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"price"]];
    
    cell.address.text =[NSString stringWithFormat:@"%@ %@室%@厅",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"inhabitarea"],[[dataArray objectAtIndex:indexPath.row] objectForKey:@"room"],[[dataArray objectAtIndex:indexPath.row] objectForKey:@"paror"]] ;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    oldHouseInforViewController * old = [[oldHouseInforViewController alloc] init];
    old.strTitle = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    old.ID = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"sh_id"];
    [self.navigationController pushViewController:old animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return 60;
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
