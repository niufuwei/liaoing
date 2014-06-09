//
//  lookHouseViewController.m
//  liaoing
//
//  Created by laoniu on 14-6-3.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "lookHouseViewController.h"

@interface lookHouseViewController ()

@end

@implementation lookHouseViewController

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
    
    self.title = @"看房团";
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]];
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
    
    
    self.backGroundScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    self.backGroundScrollview.backgroundColor = [UIColor clearColor];
    self.backGroundScrollview.contentSize = CGSizeMake(320, 1000);
    
    [self.view addSubview:self.backGroundScrollview];

    NSInteger my_y=0;
    for (int i=0; i<4; i++) {

        UIView * myView = [[UIView alloc] initWithFrame:CGRectMake(10, 10+my_y*i, 300, 200)];
        [myView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280,20)];
        title.text = @"3月16日上街专场看房火爆招募中";
        title.textAlignment = NSTextAlignmentCenter;
        [myView addSubview:title];
        
        UILabel * baoming = [[UILabel alloc] initWithFrame:CGRectMake(10,title.frame.size.height+title.frame.origin.y+5, 140, 20)];
        baoming.text = @"已报名36人";
        [myView addSubview:baoming];
        
        UILabel * time = [[UILabel alloc] initWithFrame:CGRectMake(baoming.frame.size.width+baoming.frame.origin.x, title.frame.size.height+title.frame.origin.y+5, 140, 20)];
        time.text = @"截止时间";
        [myView addSubview:time];
        
        
        UIImageView * imageHeng = [[UIImageView alloc] initWithFrame:CGRectMake(0, time.frame.size.height+time.frame.origin.y+10, 300, 1)];
        [imageHeng setBackgroundColor:[UIColor grayColor]];
        [myView addSubview:imageHeng];
        
        UIImageView * mapView = [[UIImageView alloc] initWithFrame:CGRectMake(5, imageHeng.frame.origin.y+10, 290, 150)];
        [mapView setBackgroundColor:[UIColor redColor]];
        [myView addSubview:mapView];
        
        
        UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(5, mapView.frame.size.height+mapView.frame.origin.y+5, 300, 200)];
       
        NSInteger yyy = 0;
        for(int i=0;i<3;i++)
        {
            UILabel * contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5 , 5+yyy*i, 290, 20)];
            contentLabel.text = @"福田性和员";
            [contentView addSubview:contentLabel];
            
            CGRect height = contentView.frame;
            height.size.height = contentLabel.frame.size.height+contentLabel.frame.origin.y+10;
            contentView.frame = height;
            
            yyy = contentLabel.frame.size.height;

        }
        
        [myView addSubview:contentView];
        
        UIImageView * imageHeng3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height+contentView.frame.origin.y+5, 300, 1)];
        [imageHeng3 setBackgroundColor:[UIColor blackColor]];
        [myView addSubview:imageHeng3];
        
        UIButton * baomingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [baomingBtn setTitle:@"我要报名" forState:UIControlStateNormal];
        baomingBtn.frame = CGRectMake(3, imageHeng3.frame.size.height+imageHeng3.frame.origin.y+5, 140, 25);
        [baomingBtn setBackgroundColor:[UIColor greenColor]];
        [myView addSubview:baomingBtn];
        
        
        UIButton * zixunBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [zixunBtn setTitle:@"电话咨询" forState:UIControlStateNormal];
        zixunBtn.frame = CGRectMake(baomingBtn.frame.size.width+baomingBtn.frame.origin.x+4,imageHeng3.frame.size.height+imageHeng3.frame.origin.y+5, 140, 25);
        [zixunBtn setBackgroundColor:[UIColor redColor]];
        
        [myView addSubview:zixunBtn];
        
        UIImageView * imageHeng4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, zixunBtn.frame.size.height+zixunBtn.frame.origin.y+5, 300, 1)];
        [imageHeng4 setBackgroundColor:[UIColor blackColor]];
        [myView addSubview:imageHeng4];

        UIButton * contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [contentBtn setTitle:@"详情查看" forState:UIControlStateNormal];
        [contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        contentBtn.frame = CGRectMake(3,imageHeng4.frame.size.height+imageHeng4.frame.origin.y+5, 294, 25);
        contentBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
        [myView addSubview:contentBtn];
        
        CGRect height = myView.frame;
        height.size.height = contentBtn.frame.size.height+contentBtn.frame.origin.y+10;
        myView.frame = height;
        
        my_y = height.size.height;
        self.backGroundScrollview.contentSize = CGSizeMake(320, my_y*(i+1)+76);
        [self.backGroundScrollview addSubview:myView];

    }
    
        // Do any additional setup after loading the view.
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
