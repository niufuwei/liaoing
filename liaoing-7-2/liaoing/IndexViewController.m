//
//  IndexViewController.m
//  liaoing
//
//  Created by liaoing on 14-5-20.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "IndexViewController.h"
#import "SectionTableViewController.h"
#import "NewsListCell.h"
#import "NewHouseViewController.h"
#import "NewslistViewController.h"
#import "NewsContentViewController.h"
#import "menuViewController.h"
#import "oldHouseViewController.h"
#import "MBProgressHUD.h"
#import "lookHouseViewController.h"
#import "pushSearchViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "forumViewController.h"

@interface IndexViewController ()
{
    UIPageControl * pageControl;
    UIScrollView * scrollview;
    UIView *searchView;
    UIImageView *advertisingImageview;
    BOOL isEnd;//scrollView是否需要从头重新播放

}
@property (nonatomic , strong)  NSMutableArray *listDate;

@property (nonatomic, weak) MBProgressHUD* hud;
@property (nonatomic, weak) AFHTTPRequestOperation* op;
@end

@implementation IndexViewController
{
//    UIView *searchView;
//    UIImageView *backgroudView;
//    UIImageView *advertisingImageview;
//    UIView *moreView;
//    UITableView *tabview;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage *image = [UIImage imageNamed:@"x1"];
        UITabBarItem *homeItem = [[UITabBarItem alloc]
                                  initWithTitle:@"首页" image:image selectedImage:image];
        self.tabBarItem = homeItem;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _imageArray= [[NSArray alloc] init];
    if(iPhone5)
    {
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height- (IOS7Later ?204:184)+86)];

    }
    else
    {
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height- (IOS7Later ?204:184))];

    }
    tableView.delegate = self;
    tableView.dataSource = self;
    //    tableView.backgroundColor = [UIColor colorWithRed:252.0f/255.0f green:252.0f/255.0f blue:252.0f/255.0f alpha:1.0f];
    tableView.backgroundColor = [UIColor clearColor];
    //  tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSearchBar];
    [self.view addSubview:tableView];
    self.listDate = [NSMutableArray array];
    [self refreshData];
    
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
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:@"http://zhengzhou.liaoing.com/ios/index/city/1041.html" parameters:nil error:nil];
    self.op = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
      //   NSLog(@"JSON: %@", responseObject);
        [self hidHUDMessage:self.hud animated:YES];
        
        NSArray *array = [NSArray arrayWithArray:[(NSDictionary*)responseObject objectForKey:@"news"]];
        _imageArray  =[NSArray arrayWithArray:[(NSDictionary*)responseObject objectForKey:@"ad"]];
      //  NSLog(@"==1111=%@",array);
        [self.listDate removeAllObjects];
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *dic = (NSDictionary *)obj;
           
            [self.listDate addObject:dic];
            
        }];
        
        [tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器请求失败." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self hidHUDMessage:self.hud animated:YES];
        
    }];
    [self.op start];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = YES;

}
#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	

    return self.listDate.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.row ==0) {
        height = 250;
    }else if(indexPath.row ==1){
      height = 83;
    }else if(indexPath.row >=2){
        height = 44;
    }
    
    //NSLog(@"height=%f",height);
	return height;
}
//搜索框
- (void)addSearchBar
{
    searchView = [[UIView alloc]init];
    searchView.userInteractionEnabled = YES;
    
    searchView.frame = CGRectMake(0, 20, 320, 44);
    searchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBG"]];
    [self.view addSubview:searchView];
    
    UIImageView *liaoingImage = [[UIImageView alloc]init];
    liaoingImage.image = [UIImage imageNamed:@"logo"];
    liaoingImage.frame = CGRectMake(10, 8, liaoingImage.image.size.width, liaoingImage.image.size.height);
    [searchView addSubview:liaoingImage];
    
    UISearchBar *searchbar = [[UISearchBar alloc]init];
    searchbar.frame = CGRectMake(liaoingImage.frame.origin.x*2+liaoingImage.frame.size.width, 5, 170, 34);
    searchbar.barStyle = UISearchBarStyleDefault;
    searchbar.backgroundImage=[UIImage imageNamed:@"navBG"];
    searchbar.delegate = self;
    //  [[searchbar layer] setShadowOpacity:0];
    searchbar.placeholder = @"楼盘名/开发商等";
    [searchView addSubview:searchbar];
    
    UIButton *searchBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBarButton.frame = CGRectMake(searchbar.frame.origin.x+searchbar.frame.size.width+10, 5, 60, 34);
    [searchBarButton setTitle:@"郑州 " forState:UIControlStateNormal];
   // searchBarButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tb_a_1"]];
    [searchBarButton setImage:[UIImage imageNamed:@"tb_a_1"]  forState:UIControlStateNormal];
    [searchBarButton setImageEdgeInsets:UIEdgeInsetsMake(20, 12, 21, -80)];
    
    
    searchBarButton.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dochangecity:)];
    [searchBarButton addGestureRecognizer:tap];
    [searchView addSubview:searchBarButton];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    pushSearchViewController * search = [[pushSearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
       if (indexPath.row == 0){
           static NSString *CellIdentifier = @"CellIdentifier1";
           UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
           if (cell == nil) {
               cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
               cell.selectionStyle = UITableViewCellSelectionStyleNone;
               cell.accessoryType = UITableViewCellAccessoryNone;
               
               NSArray *imageArr1 = [NSArray arrayWithObjects:[UIImage imageNamed:@"01"],[UIImage imageNamed:@"02"],[UIImage imageNamed:@"03"], nil];
               NSArray *textArr1 = [NSArray arrayWithObjects:@"新房",@"二手房",@"租房", nil];
               
               NSArray *imageArr2 = [NSArray arrayWithObjects:[UIImage imageNamed:@"05"],[UIImage imageNamed:@"06"],[UIImage imageNamed:@"07"], nil];
               NSArray *textArr2 = [NSArray arrayWithObjects:@"看房团",@"房产资讯",@"小区论坛", nil];
               
               for (int i=0; i<3; i++) {
                   UIImageView *imageView = [[UIImageView alloc]init];
                   
                   imageView.image = [imageArr1 objectAtIndex:i];
                   imageView.frame = CGRectMake(32+320/3*i, 10, imageView.image.size.width, imageView.image.size.height);
                   imageView.tag = 10086+i;
                   imageView.userInteractionEnabled = YES;
                   [cell.contentView addSubview:imageView];
                   
                   NSLog(@"%f",imageView.image.size.width);
                   NSLog(@"%f",imageView.image.size.height);
                   
                   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doImageView:)];
                   [imageView addGestureRecognizer:tap];
                   
                   UILabel *lable = [[UILabel alloc]init];
                   lable.frame = CGRectMake(320/3*i, imageView.frame.origin.y+imageView.frame.size.height+4, 320/3, 25);
                   lable.text = [textArr1 objectAtIndex:i];
                   lable.textAlignment = NSTextAlignmentCenter;
                   [cell.contentView addSubview:lable];
               }
               
               for (int i=0; i<3; i++) {
                   UIImageView *imageView = [[UIImageView alloc]init];
                   imageView.image = [imageArr2 objectAtIndex:i];
                   imageView.frame = CGRectMake(32+320/3*i, 160/2+10, imageView.image.size.width, imageView.image.size.height);
                   imageView.tag = 10089+i;
                   imageView.userInteractionEnabled = YES;
                   [cell.contentView addSubview:imageView];
                   
                   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doImageView:)];
                   [imageView addGestureRecognizer:tap];
                   
                   UILabel *lable = [[UILabel alloc]init];
                   lable.frame = CGRectMake(320/3*i, imageView.frame.origin.y+imageView.frame.size.height+4, 320/3, 25);
                   lable.text = [textArr2 objectAtIndex:i];
                   lable.textAlignment = NSTextAlignmentCenter;
                   [cell.contentView addSubview:lable];
               }
             
               scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 170, 300, 70)];
               scrollview.backgroundColor = [UIColor clearColor];
               scrollview.showsHorizontalScrollIndicator = NO;
               scrollview.showsVerticalScrollIndicator = NO;
               scrollview.pagingEnabled = YES;
              
               [cell.contentView addSubview:scrollview];
               firstIMG = [[UIImageView alloc] init];

               
               pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(141, 210, 38, 36)];
               pageControl.currentPage = 0;
               [cell.contentView addSubview:pageControl];
               
               [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(handleSchedule) userInfo:nil repeats:YES];
               
           }
           scrollview.contentSize = CGSizeMake(320*_imageArray.count, 130);

           for(int i=0;i<_imageArray.count;i++){
               
               NSLog(@"%@",[[_imageArray objectAtIndex:i] objectForKey:@"pic"]);
               [firstIMG setImageWithURL:[[_imageArray objectAtIndex:i] objectForKey:@"pic"] placeholderImage:[UIImage imageNamed:@"isongktv_logo.png"]];
               firstIMG.frame=CGRectMake(320*i, 0, 320, 130);
               
               [scrollview addSubview:firstIMG];
               
           }
           pageControl.numberOfPages = _imageArray.count;

           
           return cell;

       }else if (indexPath.row == 1){
           static NSString *CellIdentifier = @"NewsListCell";
           NewsListCell *cell = (NewsListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
           if (cell == nil) {
               cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsListCell" owner:self options:nil] lastObject];
               cell.selectionStyle = UITableViewCellSelectionStyleGray;
               cell.accessoryType = UITableViewCellAccessoryNone;
           }
           
           cell.infoDic = self.listDate[indexPath.row-1];
           return cell;
       }else if(indexPath.row >=2 && indexPath.row <=5){
           static NSString *CellIdentifier = @"NewsCellIdentifier3";
           UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
           if (cell == nil) {
               cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
               cell.selectionStyle = UITableViewCellSelectionStyleGray;
               cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
           }
           cell.textLabel.text = [self.listDate[indexPath.row - 1] objectForKey:@"title"];
           
           return cell;
       }else {
           static NSString *CellIdentifier = @"CellIdentifier4";
           UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
           if (cell == nil) {
               cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
               cell.selectionStyle = UITableViewCellSelectionStyleNone;
               cell.accessoryType = UITableViewCellAccessoryNone;
               
           }
           cell.textLabel.text = @"更多 >>";
           cell.textLabel.textAlignment=NSTextAlignmentCenter;
           return cell;

       
       
       }

       
        
    return nil;
    
}

- (void)handleSchedule
{
    pageControl.currentPage = pageControl.currentPage + 1;
    
    if(isEnd){
        
        [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
        
        pageControl.currentPage=0;
        
    }else{
        
        [scrollview setContentOffset:CGPointMake(pageControl.currentPage*scrollview.frame.size.width, 0) animated:YES];
        
    }
    
    if (pageControl.currentPage==pageControl.numberOfPages-1) {
        
        isEnd=YES;
        
    }else{
        
        isEnd=NO;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row >=1 && indexPath.row<=5){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NewsContentViewController *contentViewCtr = [[NewsContentViewController alloc] init];
        contentViewCtr.idStr = [self.listDate[indexPath.row-1] objectForKey:@"news_id"];
        [self.navigationController pushViewController:contentViewCtr animated:YES];
    }else if(indexPath.row ==6){
           NewsListViewController *newslist = [[NewsListViewController alloc]init];
          [self.navigationController pushViewController:newslist animated:YES];
      }
    
}
- (void)dochangecity:(UITapGestureRecognizer *)tap{
    SectionTableViewController *cc = [[SectionTableViewController alloc]init];
    [self.navigationController pushViewController:cc animated:YES];
    
}
- (void)doImageView:(UITapGestureRecognizer *)tap
{
    switch (tap.view.tag) {
        case 10086:
        {
            NSLog(@"新房");
            NewHouseViewController *newhouse = [[NewHouseViewController alloc]init];
            //            [self presentViewController:newhouse animated:YES completion:nil];
            [self.navigationController pushViewController:newhouse animated:YES];
        }
            break;
        case 10087:
            //二手房
        {
            oldHouseViewController *menu = [[oldHouseViewController alloc]init];
            //            [self presentViewController:newhouse animated:YES completion:nil];
            menu.strTitle = @"二手房";
            [self.navigationController pushViewController:menu animated:YES];
        }
            break;
        case 10088:
            //租房
        {
            oldHouseViewController *menu = [[oldHouseViewController alloc]init];
            //            [self presentViewController:newhouse animated:YES completion:nil];
            menu.strTitle = @"租房网";
            [self.navigationController pushViewController:menu animated:YES];

        }
            break;
        case 10089:
            //看房团
        {
            lookHouseViewController * look = [[lookHouseViewController alloc] init];
            [self.navigationController pushViewController:look animated:YES];
            
        }
            break;
        case 10090:{
            //房产资讯
            NSLog(@"房产资讯");
            NewsListViewController *news = [[NewsListViewController alloc]init];
            //            [self presentViewController:newhouse animated:YES completion:nil];
            [self.navigationController pushViewController:news animated:YES];
        }
            break;
        case 10091:
            //小区论坛
        {
            forumViewController * forum = [[forumViewController alloc] init];
            [self.navigationController pushViewController:forum animated:YES];
        }
            break;
            
        default:
            NSLog(@"swich-error");
            break;
    }
    
    //    if (tap.view.tag == 10086) {
    //        NSLog(@"新房");
    //        NewHouseViewController *newhouse = [[NewHouseViewController alloc]init];
    //        [self presentViewController:newhouse animated:YES completion:nil];
    //    }
}

@end
