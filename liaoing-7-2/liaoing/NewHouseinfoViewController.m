//
//  NewHouseinfoViewController.m
//  liaoing
//
//  Created by liaoing on 14-5-14.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "NewHouseinfoViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"

@interface NewHouseinfoViewController ()
{
    UIButton * telButton;
    NSArray *_imageArray;
    BOOL isEnd;//scrollView是否需要从头重新播放
}
@property (nonatomic , strong)  NSMutableArray *newhouseArray;

@property (nonatomic, weak) MBProgressHUD* hud;
@property (nonatomic, weak) AFHTTPRequestOperation* op;
@property (nonatomic, weak) AFHTTPRequestOperation* op2;
@end

@implementation NewHouseinfoViewController

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
    self.title = _houseName;
    self.navigationItem.leftBarButtonItem = [self barButtonItemWithNormalImageName:@"navBackBtn.png"
                                                              highlightedImageName:nil
                                                                            target:self
                                                                            action:@selector(backBtn:)];
    
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
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(handleSchedule) userInfo:nil repeats:YES];
    
    
  //  [self refreshData];

    self.backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-64-44-44)];
    self.backScrollView.backgroundColor = [UIColor clearColor];
    self.backScrollView.contentSize = CGSizeMake(320, 705);
    
    [self.backScrollView addSubview:self.scrollView];
    [self.backScrollView addSubview:self.pageControl];
    [self.view addSubview:self.backScrollView];
    
    //初始化内容页面
    [self InitContentView];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64-60-44-44, 320, 60)];
    [view setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:223.0/255.0  blue:222.0/255.0  alpha:1]];
    telButton = [UIButton buttonWithType:UIButtonTypeCustom];
    telButton.frame = CGRectMake(30, 10, 260, 40);
    
    [telButton setTitle:@"18600135086" forState:UIControlStateNormal];
    [telButton.layer setCornerRadius:10.0];
    
    [telButton setBackgroundColor:[UIColor colorWithRed:71.0/255.0 green:178.0/255.0 blue:26.0/255.0 alpha:1]];
    [view addSubview:telButton];
    [self.view addSubview:view];


}

-(void)InitContentView
{
    
    //标题
    UILabel * headTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, self.scrollView.frame.size.height+self.scrollView.frame.origin.y+5, 320, 15)];
    headTitle.backgroundColor = [UIColor clearColor];
    headTitle.text = @"万科没景龙塘";
    headTitle.textColor = [UIColor blackColor];
    headTitle.font = [UIFont systemFontOfSize:14];
    [self.backScrollView addSubview:headTitle];
    
    //均价
    UILabel * money = [[UILabel alloc] initWithFrame:CGRectMake(10, headTitle.frame.size.height+headTitle.frame.origin.y+5, 40, 15)];
    money.backgroundColor = [UIColor clearColor];
    money.text = @"均价:";
    money.textColor = [UIColor blackColor];
    money.font = [UIFont systemFontOfSize:12];
    [self.backScrollView addSubview:money];
    
    UILabel * AllocMoney = [[UILabel alloc] initWithFrame:CGRectMake(50,headTitle.frame.size.height+headTitle.frame.origin.y+5, 100, 15)];
    AllocMoney.backgroundColor = [UIColor clearColor];
    AllocMoney.text = @"12000元/平";
    AllocMoney.textColor = [UIColor redColor];
    AllocMoney.font = [UIFont systemFontOfSize:14];
    [self.backScrollView addSubview:AllocMoney];
    
    
    //房贷计算器
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"房贷计算器" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(200, headTitle.frame.size.height+headTitle.frame.origin.y+5,100, 30);
    [self.backScrollView addSubview:btn];
    
    //开盘
    UILabel * kaipan = [[UILabel alloc] initWithFrame:CGRectMake(10, money.frame.size.height+money.frame.origin.y+5, 40, 15)];
    kaipan.backgroundColor = [UIColor clearColor];
    kaipan.text = @"开盘";
    kaipan.textColor = [UIColor blackColor];
    kaipan.font = [UIFont systemFontOfSize:12];
    [self.backScrollView addSubview:kaipan];
    
    UILabel * Allockaipan = [[UILabel alloc] initWithFrame:CGRectMake(50,money.frame.size.height+money.frame.origin.y+5, 100, 15)];
    Allockaipan.backgroundColor = [UIColor clearColor];
    Allockaipan.text = @"2013年下半年";
    Allockaipan.textColor = [UIColor blackColor];
    Allockaipan.font = [UIFont systemFontOfSize:14];
    [self.backScrollView addSubview:Allockaipan];
    
    //地址
    UILabel * address = [[UILabel alloc] initWithFrame:CGRectMake(10, kaipan.frame.size.height+kaipan.frame.origin.y+5, 40, 15)];
    address.backgroundColor = [UIColor clearColor];
    address.text = @"地址";
    address.textColor = [UIColor blackColor];
    address.font = [UIFont systemFontOfSize:12];
    [self.backScrollView addSubview:address];
    
    UILabel * allocaddress = [[UILabel alloc] initWithFrame:CGRectMake(40, kaipan.frame.size.height+kaipan.frame.origin.y+5, 320, 15)];
    allocaddress.backgroundColor = [UIColor clearColor];
    allocaddress.text = @"【管城区】中州大道以东、航海路以北";
    allocaddress.textColor = [UIColor blackColor];
    allocaddress.font = [UIFont systemFontOfSize:14];
    [self.backScrollView addSubview:allocaddress];
    
    UIButton * HouseType;
    for(int i=0;i<3;i++)
    {
        HouseType = [UIButton buttonWithType:UIButtonTypeCustom];
        HouseType.frame= CGRectMake(10+(i*80), address.frame.size.height+address.frame.origin.y+10, 70, 25);
        [HouseType setTitle:@"双气楼盘" forState:UIControlStateNormal];
        [HouseType setBackgroundColor:[UIColor orangeColor]];
        [HouseType setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        HouseType.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.backScrollView addSubview:HouseType];

    }
    
    //购房优惠
    
    UILabel * buyHouse = [[UILabel alloc] initWithFrame:CGRectMake(10, HouseType.frame.size.height+HouseType.frame.origin.y+5, 300, 30)];
    buyHouse.backgroundColor = [UIColor clearColor];
    buyHouse.text = @"  购房优惠";
    buyHouse.textColor = [UIColor blackColor];
    buyHouse.font = [UIFont systemFontOfSize:17];
    [buyHouse setBackgroundColor:[UIColor grayColor]];
    [self.backScrollView addSubview:buyHouse];
    
    UILabel * ex;
    for(int i=0;i<2;i++)
    {
        ex = [[UILabel alloc] init];
        ex.frame = CGRectMake(10, buyHouse.frame.size.height+buyHouse.frame.origin.y+5+i*40, 220, 30);
        ex.font = [UIFont systemFontOfSize:10];
        [ex setText:@"聊斋网购房优惠卷为您再省500元" ];
        [ex setTextColor:[UIColor grayColor]];
        ex.textAlignment = NSTextAlignmentLeft;
        [self.backScrollView addSubview:ex];
        
        
        UIImageView * imageHeng = [[UIImageView alloc] initWithFrame:CGRectMake(10, ex.frame.size.height+ex.frame.origin.y+5, 300, 1)];
        [imageHeng setBackgroundColor:[UIColor grayColor]];
        [self.backScrollView addSubview:imageHeng];
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame= CGRectMake(230, buyHouse.frame.size.height+buyHouse.frame.origin.y+5+i*40, 80, 30);
        [button setTitle:@"立即报名" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.backScrollView addSubview:button];
    }

    //楼盘信息
    
    UILabel * infor = [[UILabel alloc] initWithFrame:CGRectMake(10, ex.frame.size.height+ex.frame.origin.y+5, 300, 30)];
    infor.backgroundColor = [UIColor clearColor];
    infor.text = @"  楼盘信息";
    infor.textColor = [UIColor blackColor];
    infor.font = [UIFont systemFontOfSize:17];
    [infor setBackgroundColor:[UIColor grayColor]];
    [self.backScrollView addSubview:infor];
    
    //开盘时间
    UILabel * startTime = [[UILabel alloc] initWithFrame:CGRectMake(10, infor.frame.size.height+infor.frame.origin.y+10, 300, 15)];
    startTime.backgroundColor = [UIColor clearColor];
    startTime.text = [NSString stringWithFormat:@"开盘时间: %@",@"2013年下半年"];
    startTime.textColor = [UIColor blackColor];
    startTime.font = [UIFont systemFontOfSize:12];
    [self.backScrollView addSubview:startTime];
  

    //交房时间
    UILabel * commitTime = [[UILabel alloc] initWithFrame:CGRectMake(10, startTime.frame.size.height+startTime.frame.origin.y+5, 300, 15)];
    commitTime.backgroundColor = [UIColor clearColor];
    commitTime.text = [NSString stringWithFormat:@"交盘时间: %@",@"2013年下半年"];
    commitTime.textColor = [UIColor blackColor];
    commitTime.font = [UIFont systemFontOfSize:12];
    [self.backScrollView addSubview:commitTime];

    
    //物业类型
    UILabel * type = [[UILabel alloc] initWithFrame:CGRectMake(10, commitTime.frame.size.height+commitTime.frame.origin.y+5, 300, 15)];
    type.backgroundColor = [UIColor clearColor];
    type.text = [NSString stringWithFormat:@"物业类型: %@",@"高层商铺"];
    type.textColor = [UIColor blackColor];
    type.font = [UIFont systemFontOfSize:12];
    [self.backScrollView addSubview:type];
    
    UIImageView * imageHeng2= [[UIImageView alloc] initWithFrame:CGRectMake(10, type.frame.size.height+type.frame.origin.y+5, 300, 1)];
    imageHeng2.backgroundColor = [UIColor grayColor];
    [self.backScrollView addSubview:imageHeng2];
    
    //开发商
    UILabel * shop = [[UILabel alloc] initWithFrame:CGRectMake(10, type.frame.size.height+type.frame.origin.y+15, 300, 15)];
    shop.backgroundColor = [UIColor clearColor];
    shop.text = [NSString stringWithFormat:@"开发商: %@",@"河南美景红城置业有限公司"];
    shop.textColor = [UIColor blackColor];
    shop.font = [UIFont systemFontOfSize:12];
    [self.backScrollView addSubview:shop];

    
    
    //投资商
    UILabel * touzishang = [[UILabel alloc] initWithFrame:CGRectMake(10, shop.frame.size.height+shop.frame.origin.y+5, 300, 15)];
    touzishang.backgroundColor = [UIColor clearColor];
    touzishang.text = [NSString stringWithFormat:@"投资商: %@",@"郑州万科美景房地产开发有限公司"];
    touzishang.textColor = [UIColor blackColor];
    touzishang.font = [UIFont systemFontOfSize:12];
    [self.backScrollView addSubview:touzishang];
    
    //售楼处
    UILabel * shoulouchu = [[UILabel alloc] initWithFrame:CGRectMake(10, touzishang.frame.size.height+touzishang.frame.origin.y+5, 300, 15)];
    shoulouchu.backgroundColor = [UIColor clearColor];
    shoulouchu.text = [NSString stringWithFormat:@"售楼处: %@",@"中州大道航海路向东200米路北"];
    shoulouchu.textColor = [UIColor blackColor];
    shoulouchu.font = [UIFont systemFontOfSize:12];
    [self.backScrollView addSubview:shoulouchu];
    
    //物业公司
    UILabel * wuye = [[UILabel alloc] initWithFrame:CGRectMake(10, shoulouchu.frame.size.height+shoulouchu.frame.origin.y+5, 300, 15)];
    wuye.backgroundColor = [UIColor clearColor];
    wuye.text = [NSString stringWithFormat:@"物业公司: %@",@"万科物业"];
    wuye.textColor = [UIColor blackColor];
    wuye.font = [UIFont systemFontOfSize:12];
    [self.backScrollView addSubview:wuye];
    
    //物业费
    UILabel * wuyemoney = [[UILabel alloc] initWithFrame:CGRectMake(10, wuye.frame.size.height+wuye.frame.origin.y+5, 300, 15)];
    wuyemoney.backgroundColor = [UIColor clearColor];
    wuyemoney.text =[NSString stringWithFormat:@"物业费: %@",@"2.48元/平方米·月"];
    wuyemoney.textColor = [UIColor blackColor];
    wuyemoney.font = [UIFont systemFontOfSize:12];
    [self.backScrollView addSubview:wuyemoney];
    
    UIImageView * imageHeng3= [[UIImageView alloc] initWithFrame:CGRectMake(10, wuyemoney.frame.size.height+wuyemoney.frame.origin.y+5, 300, 1)];
    imageHeng3.backgroundColor = [UIColor grayColor];
    [self.backScrollView addSubview:imageHeng3];

    //规划面积
    UILabel * guiahuamianji = [[UILabel alloc] initWithFrame:CGRectMake(10, wuyemoney.frame.size.height+wuyemoney.frame.origin.y+15, 300, 15)];
    guiahuamianji.backgroundColor = [UIColor clearColor];
    guiahuamianji.text = [NSString stringWithFormat:@"规划面积: %@",@"651233平米"];
    guiahuamianji.textColor = [UIColor blackColor];
    guiahuamianji.font = [UIFont systemFontOfSize:12];
    [self.backScrollView addSubview:guiahuamianji];
    
    
    //建筑面积
    UILabel * jianzhumianji = [[UILabel alloc] initWithFrame:CGRectMake(10, guiahuamianji.frame.size.height+guiahuamianji.frame.origin.y+5, 300, 15)];
    jianzhumianji.backgroundColor = [UIColor clearColor];
    jianzhumianji.text = [NSString stringWithFormat:@"建筑面积: %@",@"223232平米"];
    jianzhumianji.textColor = [UIColor blackColor];
    jianzhumianji.font = [UIFont systemFontOfSize:12];
    [self.backScrollView addSubview:jianzhumianji];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma- Button Action
- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
