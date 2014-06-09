//
//  NewHouseViewController.m
//  liaoing
//
//  Created by haonan.wang on 14-5-7.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "NewHouseViewController.h"
#import "NewHouseinfoViewController.h"
#import "NewHouseListCell.h"
#import "MJRefresh.h"
#import "menuViewController.h"
#import "newHouseInformationViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"

//网络加载指示器
// #import "MBProgressHUD.h"

@interface NewHouseViewController (){
    //数据加载条数
    int dataCount;
    
    //自定义加载列表
    UIImageView *imageView_cell;
    menu * myMenu;
    UILabel *lable_cell;
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
}
@property (nonatomic, weak) MBProgressHUD* hud;
@property (nonatomic, weak) AFHTTPRequestOperation* op;
@end

@implementation NewHouseViewController


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
    self.title = @"郑州-新房";
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
   // self.hidesBottomBarWhenPushed=YES;
   // self.view.backgroundColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = [self barButtonItemWithNormalImageName:@"navBackBtn.png"
                                                              highlightedImageName:nil
                                                                            target:self
                                                                            action:@selector(backBtn:)];
    self.navigationItem.rightBarButtonItem = [self barButtonItemWithNormalImageName:@"x2.png"
                                                              highlightedImageName:nil
                                                                            target:self
                                                                            action:nil];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-10)];
    tableView.delegate = self;
    tableView.dataSource = self;
    //    tableView.backgroundColor = [UIColor colorWithRed:252.0f/255.0f green:252.0f/255.0f blue:252.0f/255.0f alpha:1.0f];
    tableView.backgroundColor = [UIColor clearColor];
  //  tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    //一次加载的条数
    dataCount = 10;
    [self addHeader];
    [self addFooter];
    listData = [NSMutableArray array];
    [self refreshData];

    [super viewDidLoad];

}
/*
 * 开始请求Web Service
 */
#pragma mark - Public Method
-(void)refreshData{
    
    self.hud = [self showWorkingHUD:NSLocalizedString(@"加载数据中...", nil)];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //    NSDictionary *dict = @{@"user_id": userid,
    //                           };
    //    NSError *error;
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSDictionary *params = @{@"field":jsonStr};
    //    NSLog(@"parms=======%@",params);
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:@"http://zhengzhou.liaoing.com/ios/list.html" parameters:nil error:nil];
    self.op = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //   NSLog(@"JSON: %@", responseObject);
        [self hidHUDMessage:self.hud animated:YES];
        
        NSArray *array = [NSArray arrayWithArray:responseObject];
        [listData removeAllObjects];
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *dic = (NSDictionary *)obj;
            [listData addObject:dic];
        }];
        
        [tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        [self hidHUDMessage:self.hud animated:YES];
        
    }];
    [self.op start];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
//    [self.tabBarController.tabBar setHidden:YES];
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

#pragma- Button Action
- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 3;
    }
    else
    {
        return [listData count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if(indexPath.section==1)
    {
        height = 83;
    }
    else{
        height = 50;
    }
    
    //NSLog(@"height=%f",height);
	return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return 0;
    }
    else
    {
        return 40;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(section==1)
    {
        myMenu = [[menu alloc] initWithFrame:CGRectMake(0, 0, 320, 40) view:self];
        myMenu.delegate =self;
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"区域",@"售价",@"户型",@"排序", nil] forKey:@"menuArray"];
    }
    return myMenu;

}
// custom view for header. will be adjusted to default or specified header height

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
//        NSString * nsname;
//        nsname=[NSString stringWithFormat:@"cell%d",indexPath.row];
//        static NSString *CellIdentifier = nsname;
        static NSString *CellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //图片
            imageView_cell = [[UIImageView alloc]init];
            imageView_cell.frame = CGRectMake(10, 5, 50, cell.frame.size.height);
            [cell.contentView addSubview:imageView_cell];
            //lable
            lable_cell = [[UILabel alloc]init];
            lable_cell.frame = CGRectMake(imageView_cell.frame.size.width+20, 5, 220, cell.frame.size.height);
            [cell.contentView addSubview:lable_cell];
            if (indexPath.row == 0) {
                //            cell.textLabel.text=@"特价房";
                //            //   cell.textLabel.font=[UIFont fontWithName:@"Courier-BoldOblique" size:17 ];
                //            cell.imageView.image=[UIImage imageNamed:@"08.png"];
                //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                //            cell.detailTextLabel.text=@"111";
                lable_cell.text = @"特价房";
                imageView_cell.image=[UIImage imageNamed:@"08.png"];
                
            }
            if (indexPath.row == 1) {
                lable_cell.text = @"热销楼盘";
                imageView_cell.image=[UIImage imageNamed:@"08.png"];
                
            }
            if (indexPath.row == 2) {
                lable_cell.text = @"看房团";
                imageView_cell.image=[UIImage imageNamed:@"08.png"];
            }

            
        }
        
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"NewHouseListCell";
        NewHouseListCell *cell = (NewHouseListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NewHouseListCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        cell.infoDic = listData[indexPath.row];
        
       
        return cell;
    }
    
    return nil;

}
-(void)didClickMenuCallBack
{
    CGRect rectInTableView = [tableView rectForHeaderInSection:1];
    CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
    
    NSLog(@"%f",rect.origin.y);
    [myMenu settableYY:rect.origin.y];
}

-(void)didClickTableCallBack:(NSString *)indexName
{
    NSLog(@"%@",indexName);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    NSInteger row = [indexPath row];
    if(row==0){
         newHouseInformationViewController *newhouseinfo = [[newHouseInformationViewController alloc]init];
        newhouseinfo.strtitle= @"特价房";
        [self.navigationController pushViewController:newhouseinfo animated:YES];
    }else if(row==1)
    {
        newHouseInformationViewController *newhouseinfo = [[newHouseInformationViewController alloc]init];
        newhouseinfo.strtitle= @"热销楼盘";
        [self.navigationController pushViewController:newhouseinfo animated:YES];
    }
    else if(row ==2)
    {
        lookHouseViewController *newhouseinfo = [[lookHouseViewController alloc]init];
        [self.navigationController pushViewController:newhouseinfo animated:YES];
    }
    else
        if(row>=4){
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            NewHouseinfoViewController *contentViewCtr = [[NewHouseinfoViewController alloc] init];
            contentViewCtr.idStr = [listData[indexPath.row] objectForKey:@"news_id"];
            contentViewCtr.houseName =[listData[indexPath.row] objectForKey:@"title"];
            [self.navigationController pushViewController:contentViewCtr animated:YES];
    
    }
    
}
- (void)addFooter
{
    __unsafe_unretained NewHouseViewController *vc = self;
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = tableView;
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
        [vc refreshFooter:refreshView];
    };
    
}

- (void)addHeader
{
    __unsafe_unretained NewHouseViewController *vc = self;
    
    _header = [MJRefreshHeaderView header];
    _header.scrollView = tableView;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
        [vc refreshHeader:refreshView];
    };
    _header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    _header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
}

//下拉刷新
-(void)refreshHeader:(MJRefreshBaseView *)view
{
    NSTimer *endTimer;
    endTimer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(refreshtimeoutHeadrt:) userInfo:nil repeats:NO];
}

//下拉刷新超时
-(void)refreshtimeoutHeadrt:(NSTimer *)timer
{
    NSLog(@"下拉刷新超时");
    [_header endRefreshing];
}

//上拉更多
-(void)refreshFooter:(MJRefreshBaseView *)view
{
    //刷新一次加载两条
    dataCount = dataCount + 10;
    [tableView reloadData];
    
    [_footer endRefreshing];
    NSTimer *endTimer;
    endTimer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(refreshtimeoutFooter:) userInfo:nil repeats:NO];
}

//上拉更多超时
-(void)refreshtimeoutFooter:(MJRefreshBaseView *)view
{
    NSLog(@"上拉更多超时");
    [_footer endRefreshing];
}


@end
