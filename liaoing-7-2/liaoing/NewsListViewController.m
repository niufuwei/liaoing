//
//  NewsListViewController.m
//  TestDemo
//
//  Created by Mealk.Lei on 14-4-30.
//  Copyright (c) 2014年 WeSoft. All rights reserved.
//

#import "NewsListViewController.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "NewsListCell.h"
#import "NewsContentViewController.h"

@interface NewsListViewController ()
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    NSArray *_imageArray;
    BOOL isEnd;//scrollView是否需要从头重新播放
    
    //数据加载条数
    int dataCount;
}

@property (nonatomic , strong)  NSMutableArray *newsArray;

@property (nonatomic, weak) MBProgressHUD* hud;
@property (nonatomic, weak) AFHTTPRequestOperation* op;

@end

@implementation NewsListViewController

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
    // Do any additional setup after loading the view from its nib.
    [self adaptednavigationBar];
    self.title =  @"新闻列表";
    
    //一次加载的条数
    dataCount = 10;
    
    self.navigationItem.leftBarButtonItem = [self barButtonItemWithNormalImageName:@"navBackBtn.png"
                                                              highlightedImageName:nil
                                                                            target:self
                                                                            action:@selector(backBtn:)];
    
    UIScrollView * backScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 280, 153-70)];
    NSArray * arr = [NSArray arrayWithObjects:@"头条",@"本地资讯",@"楼盘动态",@"楼市优惠",@"全国资讯",@"楼市情报",@"楼盘评测",@"嘉宾访谈", nil];
    tagArray = [[NSMutableArray alloc] init];
    NSInteger myXX=0;
    for(int i =0;i<[arr count];i++)
    {
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(5+myXX, 11, 60, 21)];
        [image setBackgroundColor:[UIColor clearColor]];
        image.tag = (i+100)*2;
        [backScrollview addSubview:image];
        
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(myXX, 0, 70, 42);
        _button.titleLabel.font = [UIFont systemFontOfSize:13];
        [_button setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        _button.tag = i+100;
        [tagArray addObject:[NSString stringWithFormat:@"%ld",_button.tag]];
        [_button addTarget:self action:@selector(BtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [backScrollview addSubview:_button];
        [_button setEnabled:YES];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if(i==0)
        {
            [image setBackgroundColor:[UIColor blueColor]];
            [_button setEnabled:NO];
            [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        myXX+=70;
    }
    backScrollview.contentSize = CGSizeMake(myXX, 153-70);
    [self.view addSubview:backScrollview];
    
    
    self.newsTableView.backgroundColor = [UIColor clearColor];
    _imageArray = @[@"caScrollImg1.png",@"caScrollImg2.png",@"caScrollImg3.png"];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 153)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*3, 130);
    for(int i=0;i<_imageArray.count;i++){
        
        UIImageView * firstImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[_imageArray objectAtIndex:i]]];
        
        firstImg.frame=CGRectMake(self.scrollView.bounds.size.width*i, 0, self.scrollView.bounds.size.width, 130);
        
        [self.scrollView addSubview:firstImg];
        
    }
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(141, 100, 38, 36)];
    [self.scrollView addSubview:self.pageControl];
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(handleSchedule) userInfo:nil repeats:YES];
    
    self.newsTableView.tableHeaderView = self.scrollView;
    self.newsArray = [NSMutableArray array];
    [self refreshData];
    
    [self addHeader];
    [self addFooter];
   
}
- (void)viewWillAppear:(BOOL)animated
{
    //解决底部导航隐藏不彻底的问题
    if (self.tabBarController.tabBar.hidden == YES) {
       // return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = YES;
    
    
    
    self.navigationController.navigationBarHidden = NO;
 //   [self.tabBarController.tabBar setHidden:YES];
    
}
- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)handleSchedule
{
    self.pageControl.currentPage = self.pageControl.currentPage + 1;
    
    if(isEnd){
        
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        self.pageControl.currentPage=0;
        
    }else{
        
        [self.scrollView setContentOffset:CGPointMake(self.pageControl.currentPage*self.scrollView.frame.size.width, 0) animated:YES];
        
    }
    
    if (self.pageControl.currentPage==self.pageControl.numberOfPages-1) {
        
        isEnd=YES;
        
    }else{
        
        isEnd=NO;
        
    }
}


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
       // NSLog(@"JSON: %@", responseObject);
        [self hidHUDMessage:self.hud animated:YES];
       
        NSArray *array = [NSArray arrayWithArray:responseObject];
        [self.newsArray removeAllObjects];
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *dic = (NSDictionary *)obj;
            NSLog(@"==33333=%@",obj);
            NSLog(@"==444=%@",dic);
            [self.newsArray addObject:dic];
            
        }];
        [self.newsTableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        [self hidHUDMessage:self.hud animated:YES];
        
    }];
    [self.op start];
    
}
- (IBAction)more:(id)sender {
    MoreNewsViewController * more = [[MoreNewsViewController alloc] init];
    [more callback:(^(NSString *str) {
        NSLog(@"选择的%@",str);
    })];
    [self.navigationController pushViewController:more animated:YES];
}

#pragma- Button Action
- (IBAction)BtnPressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    [UIView animateWithDuration:0.3 animations:^{
        UIImageView * image = (UIImageView*)[self.view viewWithTag:btn.tag*2];
        [image setBackgroundColor:[UIColor blueColor]];
    }];
    [btn setEnabled:NO];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    for(int i=0;i<[tagArray count];i++)
    {
        if([[tagArray objectAtIndex:i] intValue] ==btn.tag)
        {
            
        }
        else
        {
           UIButton * buttonTag = (UIButton*)[self.view viewWithTag:[[tagArray objectAtIndex:i] intValue]];
            UIImageView * image = (UIImageView*)[self.view viewWithTag:[[tagArray objectAtIndex:i] intValue]*2];
            [image setBackgroundColor:[UIColor clearColor]];

            [buttonTag setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [buttonTag setEnabled:YES];

        }
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	return 83;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.newsArray count] > dataCount) {
        return dataCount;
    }
    
    
	return [self.newsArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsListCell";
    NewsListCell *cell = (NewsListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsListCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.infoDic = self.newsArray[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsContentViewController *contentViewCtr = [[NewsContentViewController alloc] init];
    contentViewCtr.idStr = [self.newsArray[indexPath.row] objectForKey:@"news_id"];
    [self.navigationController pushViewController:contentViewCtr animated:YES];
    
}


//--------------   加载更多
- (void)addFooter
{
    __unsafe_unretained NewsListViewController *vc = self;
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self.newsTableView;
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
        [vc refreshFooter:refreshView];
    };
    
}

- (void)addHeader
{
    __unsafe_unretained NewsListViewController *vc = self;
    
    _header = [MJRefreshHeaderView header];
    _header.scrollView = self.newsTableView;
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
    [self.newsTableView reloadData];
    
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


#pragma mark QueryMore Delegate Methods
- (void)loadingForMoreData
{
	//TODO:
}


- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = YES;
    
}

@end
