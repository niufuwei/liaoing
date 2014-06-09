//
//  pushSearchViewController.m
//  liaoing
//
//  Created by eliuyan_mac on 14-6-7.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "pushSearchViewController.h"
#import "SectionTableViewController.h"
#import "tempTable.h"
@interface pushSearchViewController ()
{
    UIView *mytextFiledView;
    UIView * ContrntView;
    UIView * imageview;
}

@end

@implementation pushSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self addSearchBar];
    
    [self addContent];
    
    NSArray * arr =[NSArray arrayWithObjects:@"区域",@"均价",@"类型", nil];
    [self setContent:arr];
    // Do any additional setup after loading the view.
}

//搜索框
- (void)addSearchBar
{
    UIView* searchView = [[UIView alloc]init];
    searchView.userInteractionEnabled = YES;
    
    searchView.frame = CGRectMake(0, 20, 320, 44);
    searchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBG"]];
    [self.view addSubview:searchView];
  
    UIButton *liaoingImage = [[UIButton alloc]init];
    
    [liaoingImage setBackgroundImage:[UIImage imageNamed:@"navBackBtn.png"] forState:UIControlStateNormal];
    liaoingImage.frame = CGRectMake(20, 12, 9.5, 18.5);
    [liaoingImage addTarget:self action:@selector(backGround) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:liaoingImage];

    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 40)];
    label.text  = @"新房搜索";
    label.textAlignment = NSTextAlignmentCenter;
    [searchView addSubview:label];
    
    UIButton *searchBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBarButton.frame = CGRectMake(240, 5, 60, 34);
    [searchBarButton setTitle:@"郑州 " forState:UIControlStateNormal];
    // searchBarButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tb_a_1"]];
    [searchBarButton setImage:[UIImage imageNamed:@"tb_a_1"]  forState:UIControlStateNormal];
    [searchBarButton setImageEdgeInsets:UIEdgeInsetsMake(20, 12, 21, -80)];
    
    
    searchBarButton.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dochangecity:)];
    [searchBarButton addGestureRecognizer:tap];
    [searchView addSubview:searchBarButton];
    
    [self.view addSubview:searchView];
    
    mytextFiledView = [[UIView alloc] initWithFrame:CGRectMake(0, 104, 320, 45)];
    [mytextFiledView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, 300, 35)];
    _textField.placeholder = @"请输入您要搜索的关键字";
    [_textField setBackgroundColor:[UIColor whiteColor]];
    [_textField addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    _textField.returnKeyType = UIReturnKeySearch;
    
    [mytextFiledView addSubview:_textField];
    [self.view addSubview:mytextFiledView];
}

-(void)backGround
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)hideKeyboard
{
    [self.view endEditing:YES];
}

-(void)addContent
{
    NSInteger myXX=0;
    NSArray * arr = [NSArray arrayWithObjects:@"新房",@"资讯",@"二手房",@"租房",@"论坛", nil];
    for(int i=0;i<5;i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(myXX*i, 64, 64, 40);
        button.tag = i+1;
        if(i==0)
        {
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.origin.x+button.frame.size.width, 70, 1, 28)];
        [image setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:button];
        [self.view addSubview:image];
        
        myXX = button.frame.size.width;
    }
}

-(IBAction)onClick:(id)sender
{
    UIButton * btn = (UIButton*)sender;
    NSArray * arr;
    if(btn.tag<1000)
    {
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        arr=[NSArray arrayWithObjects:@"区域",@"均价",@"类型", nil];
    }
    switch (btn.tag) {
        case 1:
        {
            arr =[NSArray arrayWithObjects:@"区域",@"均价",@"类型", nil];
            [ContrntView removeFromSuperview];
            [imageview removeFromSuperview];
            [self setContent:arr];
            
        }
            break;
        case 2:
        {
            
            [ContrntView removeFromSuperview];
            [imageview removeFromSuperview];
            [self setContent:nil];
            
        }
            break;
        case 3:
        {
            arr =[NSArray arrayWithObjects:@"区域",@"面积",@"价格",@"户型", nil];
            [ContrntView removeFromSuperview];
            [imageview removeFromSuperview];
            [self setContent:arr];
            
        }
            break;
        case 4:
        {
            arr =[NSArray arrayWithObjects:@"区域",@"租金",@"户型", nil];
            [ContrntView removeFromSuperview];
            [imageview removeFromSuperview];
            [self setContent:arr];
        }
            break;
        case 5:
        {
            arr =[NSArray arrayWithObjects:@"帖子", nil];
            [ContrntView removeFromSuperview];
            [imageview removeFromSuperview];
            [self setContent:arr];
            
        }
            break;
        case 1000:
        {
            tempTable * temp = [[tempTable alloc] init];
            
            [temp callback:(^(NSString *str)
                            {
                                NSLog(@"选中的时谁啊  ==>%@",str);
                            })
             ];
            temp.arr = [NSArray arrayWithObjects:@"区域",@"不限",@"你好",@"哈哈", nil];
            
            [self presentViewController:temp animated:YES completion:^{
                
            }];
        }
            break;
        case 2000:
        {
            
        }
            break;
        case 3000:
        {
            
        }
            break;
        case 4000:
        {
            
        }
            break;
            
        default:
            break;
    }
    if(btn.tag<1000)
    {
        for(int i =1;i<6;i++)
        {
            if(i == btn.tag)
            {
                
            }
            else
            {
                UIButton * button = (UIButton*)[self.view viewWithTag:i];
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
        }
        
    }
}

-(void)setContent:(NSArray *)arr
{
    NSInteger myYY=0;
    ContrntView = [[UIView alloc] initWithFrame:CGRectMake(0, mytextFiledView.frame.size.height+mytextFiledView.frame.origin.y, 320, 0)];
    for(int i=0;i<arr.count;i++)
    {
        UIButton * myView = [[UIButton alloc] initWithFrame:CGRectMake(0, myYY, 320, 40)];
        myView.tag = (i+1)*1000;
        [myView addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [myView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,80 , 40)];
        name.text = [arr objectAtIndex:i];
        [name setBackgroundColor:[UIColor clearColor]];
        [name setTextColor:[UIColor blackColor]];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(230, 0, 50,40 )];
        label.text = @"不限";
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor grayColor]];
        
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(290, 10, 20, 20)];
        [image setBackgroundColor:[UIColor redColor]];
        
        UIImageView * imageheng = [[UIImageView alloc] initWithFrame:CGRectMake(0, myView.frame.size.height-1, 320 , 1)];
        [imageheng setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0  blue:239.0/255.0  alpha:1]];
        
        [myView addSubview:name];
        [myView addSubview:label];
        [myView addSubview:image];
        [myView addSubview:imageheng];
        [ContrntView addSubview:myView];
        
        myYY += 40;
        
    }
    
    CGRect hh = ContrntView.frame;
    hh.size.height = myYY;
    ContrntView.frame = hh;
    [self.view addSubview:ContrntView];
    
    imageview = [[UIView alloc] initWithFrame:CGRectMake(0, ContrntView.frame.size.height+ContrntView.frame.origin.y, 320, 70)];
    [imageview setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]];
    
    UIButton * chongzhi = [UIButton buttonWithType:UIButtonTypeCustom];
    [chongzhi setBackgroundColor:[UIColor whiteColor]];
    chongzhi.frame = CGRectMake(15, 10, 140, 50);
    [chongzhi setTitle:@"重置" forState:UIControlStateNormal];
    [chongzhi setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [imageview addSubview:chongzhi];
    
    UIButton * search = [UIButton buttonWithType:UIButtonTypeCustom];
    [search setBackgroundColor:[UIColor greenColor]];
    search.frame = CGRectMake(165, 10, 140, 50);
    [search setTitle:@"搜索" forState:UIControlStateNormal];
    [search setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [imageview addSubview:search];
    
    [self.view addSubview:imageview];
    
    
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
