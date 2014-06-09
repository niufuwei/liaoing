//
//  WDHomeViewController.m
//  liaoing
//
//  Created by haonan.wang on 14-5-6.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "WDHomeViewController.h"
#import "NewHouseViewController.h"
#import "NewslistViewController.h"
#import "IndexViewController.h"
#import "SectionTableViewController.h"


@interface WDHomeViewController ()
{
    UIView *searchView;
    UIImageView *backgroudView;
    UIImageView *advertisingImageview;
    UIView *moreView;
    UITableView *tabview;
}
@end

@implementation WDHomeViewController

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
    // Do any additional setup after loading the view.
    
    [self addSearchBar];
    [self addSixgrid];
    [self addAdvertising];
    [self addMoreView];
    [self addTabview];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    //    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.tabBarController.tabBar setHidden:NO];
    
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
    liaoingImage.frame = CGRectMake(10, 5, 57, 38);
    liaoingImage.image = [UIImage imageNamed:@"logo"];
    [searchView addSubview:liaoingImage];
    
    UISearchBar *searchbar = [[UISearchBar alloc]init];
    searchbar.frame = CGRectMake(liaoingImage.frame.origin.x*2+liaoingImage.frame.size.width, 5, 160, 34);
    searchbar.barStyle = UISearchBarStyleDefault;
    searchbar.backgroundImage=[UIImage imageNamed:@"navBG"];
  //  [[searchbar layer] setShadowOpacity:0];
    searchbar.placeholder = @"楼盘名/开发商等";
    [searchView addSubview:searchbar];
    
    UIButton *searchBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBarButton.frame = CGRectMake(searchbar.frame.origin.x+searchbar.frame.size.width+10, 5, 60, 34);
    [searchBarButton setTitle:@"郑州 " forState:UIControlStateNormal];
    searchBarButton.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dochangecity:)];
    [searchBarButton addGestureRecognizer:tap];
    [searchView addSubview:searchBarButton];
}

//六宫格
- (void)addSixgrid
{
    backgroudView = [[UIImageView alloc]init];
    backgroudView.userInteractionEnabled = YES;
    backgroudView.frame = CGRectMake(0, searchView.frame.origin.y+searchView.frame.size.height, 320, 190);
    backgroudView.image = [UIImage imageNamed:@"bgindex"];
    [self.view addSubview:backgroudView];
    
    NSArray *imageArr1 = [NSArray arrayWithObjects:[UIImage imageNamed:@"01"],[UIImage imageNamed:@"01"],[UIImage imageNamed:@"01"], nil];
    NSArray *textArr1 = [NSArray arrayWithObjects:@"新房",@"二手房",@"租房", nil];
    
    NSArray *imageArr2 = [NSArray arrayWithObjects:[UIImage imageNamed:@"01"],[UIImage imageNamed:@"01"],[UIImage imageNamed:@"01"], nil];
    NSArray *textArr2 = [NSArray arrayWithObjects:@"看房团",@"房产资讯",@"小区论坛", nil];
    
    for (int i=0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        
        imageView.image = [imageArr1 objectAtIndex:i];
        imageView.frame = CGRectMake(28+320/3*i, 10, imageView.image.size.width, imageView.image.size.height);
        imageView.tag = 10086+i;
        imageView.userInteractionEnabled = YES;
        [backgroudView addSubview:imageView];
        
        NSLog(@"%f",imageView.image.size.width);
        NSLog(@"%f",imageView.image.size.height);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doImageView:)];
        [imageView addGestureRecognizer:tap];
        
        UILabel *lable = [[UILabel alloc]init];
        lable.frame = CGRectMake(320/3*i, imageView.frame.origin.y+imageView.frame.size.height+4, 320/3, 25);
        lable.text = [textArr1 objectAtIndex:i];
        lable.textAlignment = NSTextAlignmentCenter;
        [backgroudView addSubview:lable];
    }
    
    for (int i=0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(28+320/3*i, 190/2+10, 57, 57);
        imageView.image = [imageArr2 objectAtIndex:i];
        imageView.tag = 10089+i;
        imageView.userInteractionEnabled = YES;
        [backgroudView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doImageView:)];
        [imageView addGestureRecognizer:tap];
        
        UILabel *lable = [[UILabel alloc]init];
        lable.frame = CGRectMake(320/3*i, imageView.frame.origin.y+imageView.frame.size.height+4, 320/3, 25);
        lable.text = [textArr2 objectAtIndex:i];
        lable.textAlignment = NSTextAlignmentCenter;
        [backgroudView addSubview:lable];
    }
}

//广告条
- (void)addAdvertising
{
    advertisingImageview = [[UIImageView alloc]init];
    advertisingImageview.frame = CGRectMake(0, backgroudView.frame.origin.y+backgroudView.frame.size.height, 320, 90);
    advertisingImageview.backgroundColor = [UIColor blueColor];
    [self.view addSubview:advertisingImageview];
}

//tabview
- (void)addTabview
{
    tabview = [[UITableView alloc]initWithFrame:CGRectMake(0, advertisingImageview.frame.origin.y+advertisingImageview.frame.size.height, 320, moreView.frame.origin.y-advertisingImageview.frame.origin.y-advertisingImageview.frame.size.height) style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    [self.view addSubview:tabview];
    
    NSLog(@"%f",advertisingImageview.frame.origin.y);
    NSLog(@"%f",advertisingImageview.frame.size.height);
    NSLog(@"%f",tabview.frame.origin.y);
}

//查看更多
- (void)addMoreView
{
    moreView = [[UIView alloc]init];
    moreView.frame = CGRectMake(0, self.view.frame.size.height-44-40, 320, 40);
//    moreView.backgroundColor = [UIColor redColor];
    [self.view addSubview:moreView];
    
    UILabel *moreLable = [[UILabel alloc]init];
    moreLable.frame = CGRectMake(0, 0, 320, moreView.frame.size.height);
    moreLable.text = @"查看更多  >";
    moreLable.textAlignment = NSTextAlignmentCenter;
    [moreView addSubview:moreLable];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 20;
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
            IndexViewController *index = [[IndexViewController alloc]init];
            //            [self presentViewController:newhouse animated:YES completion:nil];
            [self.navigationController pushViewController:index animated:YES];
        }
            break;
        case 10088:
            //租房
            break;
        case 10089:
            //看房团
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
- (void)dochangecity:(UITapGestureRecognizer *)tap{
    SectionTableViewController *cc = [[SectionTableViewController alloc]init];
   [self.navigationController pushViewController:cc animated:YES];

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
