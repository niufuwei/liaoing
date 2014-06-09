//
//  forumViewController.m
//  liaoing
//
//  Created by eliuyan_mac on 14-6-7.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "forumViewController.h"
#import "SearchLunTanViewController.h"




@interface forumViewController ()

@end

@implementation forumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    //获取数据
    self.hud = [self showWorkingHUD:NSLocalizedString(@"加载数据中...", nil)];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:@"http://zhengzhou.liaoing.com/ios/bbs/city/1041.html" parameters:nil error:nil];
    self.op = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        [self hidHUDMessage:self.hud animated:YES];
        
        _array = [NSArray arrayWithArray:[(NSDictionary*)responseObject objectForKey:@"posttop"]];
        NSArray *arr = [NSArray arrayWithArray:[(NSDictionary*)responseObject objectForKey:@"toppic"]];
        NSDictionary *dic=[arr objectAtIndex:0];
        _imageUrl=[dic objectForKey:@"pic"];
        
        
        [self addContent: _array];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        [self hidHUDMessage:self.hud animated:YES];
        
    }];
    [self.op start];

    
    
    
    self.title = @"论坛";
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
                                                                             action:@selector(rightBtn)];

    
    


    
	// Do any additional setup after loading the view, typically from a nib.
}
//导航栏右边点击事件

-(void)addContent:(NSArray*)arr
{
    
    UIScrollView * backGroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, 320, self.view.frame.size.height)];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [backView setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1]];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
    _textField.placeholder = @"请输入您要搜索的内容";
    _textField.delegate = self;
    _textField.returnKeyType =UIReturnKeySearch;
    [_textField setBackgroundColor:[UIColor whiteColor]];
    [_textField addTarget:self action:@selector(onClick) forControlEvents:UIControlEventEditingDidEndOnExit];
    [backView addSubview:_textField];
    
    [backGroundScrollView addSubview:backView];
    
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10, backView.frame.size.height+backView.frame.origin.y+5, 300, 100)];
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]];
    image.image=[[UIImage alloc] initWithData:data];
    [backGroundScrollView addSubview:image];
    //得到的数据
    
     NSInteger m_count = 0;

    NSInteger yy = image.frame.size.height+image.frame.origin.y;
    for(int i =0;i<10;i++)
    {
        UIButton * left = [UIButton buttonWithType:UIButtonTypeCustom];
        [left setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1]];
        left.frame = CGRectMake(10,5+yy, 150, 30);
        left.layer.borderColor = [UIColor grayColor].CGColor;
        left.layer.borderWidth = 1;
        
        _dic=[arr objectAtIndex:m_count];
        [left setTitle:[_dic objectForKey:@"name"] forState:UIControlStateNormal];
        left.titleLabel.font=[UIFont systemFontOfSize:11];
        m_count++;
        
        [left setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backGroundScrollView addSubview:left];
        
        UIButton * right = [UIButton buttonWithType:UIButtonTypeCustom];
        [right setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1]];
        right.frame = CGRectMake(left.frame.size.width+left.frame.origin.x, 5+yy, 150, 30);
        right.layer.borderWidth = 1;
        right.layer.borderColor = [UIColor grayColor].CGColor;
        _dic=[arr objectAtIndex:m_count];
        [right setTitle:[_dic objectForKey:@"name"] forState:UIControlStateNormal];
        right.titleLabel.font=[UIFont systemFontOfSize:11];
        m_count ++;
        
        [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backGroundScrollView addSubview:right];
        
        yy = right.frame.origin.y + right.frame.size.height;
    }
    
    UILabel * tuijian = [[UILabel alloc] initWithFrame:CGRectMake(0, yy+10, 320, 30)];
    [tuijian setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1]];
    tuijian.text = @"推荐论坛";
    tuijian.textColor = [UIColor blackColor];
    tuijian.textAlignment = NSTextAlignmentLeft;
    [backGroundScrollView addSubview:tuijian];
    
    NSInteger my_yy = tuijian.frame.origin.y+tuijian.frame.size.height;
    for(int i=0;i<2;i++)
    {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, my_yy, 320, 40);
        
        [button addTarget:self action:@selector(oneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 35, 35)];
        [icon setBackgroundColor:[UIColor redColor]];
        [button addSubview:icon];
        
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.size.width+icon.frame.origin.x+10, 5, 200, 20)];
        title.backgroundColor = [UIColor clearColor];
        title.textAlignment = NSTextAlignmentLeft;
        title.text = @"吃喝玩乐";
        title.textColor = [UIColor blackColor];
        
        UILabel * content = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.size.width+icon.frame.origin.x+10, title.frame.size.height+title.frame.origin.y, 200, 20)];
        content.backgroundColor = [UIColor clearColor];
        content.textAlignment = NSTextAlignmentLeft;
        content.text = @"吃喝玩乐,生活本该如此";
        content.font = [UIFont systemFontOfSize:13];
        content.textColor = [UIColor grayColor];
        
        UIImageView * jiantou = [[UIImageView alloc] initWithFrame:CGRectMake(320-30, 0, 20, 40)];
        [jiantou setBackgroundColor: [UIColor grayColor]];
        
        [button addSubview:title];
        [button addSubview:content];
        [button addSubview:jiantou];
        [backGroundScrollView addSubview:button];
        my_yy = button.frame.size.height+button.frame.origin.y;
    }
    
    backGroundScrollView.contentSize = CGSizeMake(320,my_yy+40);
    
    [self.view addSubview:backGroundScrollView];
    
  
}


-(void)rightBtn
{
    //进入搜索界面
    
    SearchLunTanViewController *searchLt=[[SearchLunTanViewController alloc] init];
    [self.navigationController pushViewController:searchLt animated:YES];
    
}



-(void)oneBtnClick:(UIButton *)sender
{
    NSLog(@"被点击了、、、");
}

- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onClick
{
    [self.view endEditing:YES];
    if([_textField.text length] != 0)
    {
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
