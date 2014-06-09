//
//  newHouseInformationViewController.m
//  liaoing
//
//  Created by laoniu on 14-6-2.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "newHouseInformationViewController.h"
#import "NewHouseListCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "NewHouseinfoViewController.h"


@interface newHouseInformationViewController ()
{
    //数据加载条数
    int dataCount;
    
    //自定义加载列表
    UIImageView *imageView_cell;
    UILabel *lable_cell;
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
}
@property (nonatomic, weak) MBProgressHUD* hud;
@property (nonatomic, weak) AFHTTPRequestOperation* op;
@end

@implementation newHouseInformationViewController


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
    [self.view setBackgroundColor:[UIColor whiteColor]];

    self.title = _strtitle;
    // Do any additional setup after loading the view.
    
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
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-10)];
    _table.delegate = self;
    _table.dataSource = self;
    //    tableView.backgroundColor = [UIColor colorWithRed:252.0f/255.0f green:252.0f/255.0f blue:252.0f/255.0f alpha:1.0f];
    _table.backgroundColor = [UIColor clearColor];
    //  tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    //一次加载的条数
    dataCount = 10;
    [self addHeader];
    [self addFooter];
    listData = [NSMutableArray array];
    [self refreshData];

    // Do any additional setup after loading the view.
}

#pragma- Button Action
- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
        
        [_table reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        [self hidHUDMessage:self.hud animated:YES];
        
    }];
    [self.op start];
    
}

- (void)addFooter
{
    __unsafe_unretained newHouseInformationViewController *vc = self;
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _table;
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
        [vc refreshFooter:refreshView];
    };
    
}

- (void)addHeader
{
    __unsafe_unretained newHouseInformationViewController *vc = self;
    
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _table;
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
    [_table reloadData];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid = @"cell";
    NewHouseListCell * cell = (NewHouseListCell*)[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewHouseListCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.infoDic = listData[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewHouseinfoViewController *contentViewCtr = [[NewHouseinfoViewController alloc] init];
    contentViewCtr.idStr = [listData[indexPath.row] objectForKey:@"news_id"];
    contentViewCtr.houseName =[listData[indexPath.row] objectForKey:@"title"];
    [self.navigationController pushViewController:contentViewCtr animated:YES];
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
