//
//  forumInforView.m
//  liaoing
//
//  Created by laoniu on 14-6-8.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "forumInforView.h"
#import "information.h"

@implementation forumInforView
{
    information * inforMatioin;
}
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

    self.title = @"论坛";
   
    self.navigationItem.leftBarButtonItem = [self barButtonItemWithNormalImageName:@"navBackBtn.png"
                                                              highlightedImageName:nil
                                                                            target:self
                                                                            action:@selector(backBtn:)];
    
    myScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    inforMatioin = [[information alloc] init];
    [self.view addSubview:myScrollview];
    [self addContent];
    
}

-(void)addContent
{
    UIImageView * image= [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 60, 60)];
    [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.bbs_logo]] placeholderImage:[UIImage imageNamed:@"isongktv_logo.png"]];
    [myScrollview addSubview:image];
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(image.frame.size.width+image.frame.origin.x+3, 3, 200, 20)];
    title.text = self.bar_name;
    title.backgroundColor = [UIColor clearColor];
    title.textColor  = [UIColor blackColor];
    [myScrollview addSubview:title];
    
    //关注
    UILabel * guanzhu = [[UILabel alloc] initWithFrame:CGRectMake(image.frame.size.width+image.frame.origin.x+3, title.frame.origin.y+title.frame.size.height+10, 30, 15)];
    guanzhu.text = @"关注:";
    guanzhu.backgroundColor = [UIColor clearColor];
    guanzhu.textColor = [UIColor colorWithRed:122.0/255.0 green:122.0/255.0 blue:122.0/255.0 alpha:1];
    guanzhu.font = [UIFont systemFontOfSize:11];
    [myScrollview addSubview:guanzhu];
    
    UILabel * guanzhu2 = [[UILabel alloc] initWithFrame:CGRectMake(guanzhu.frame.size.width+guanzhu.frame.origin.x, title.frame.origin.y+title.frame.size.height+10, 100, 15)];
    guanzhu2.text = self.bbs_fans;
    guanzhu2.backgroundColor = [UIColor clearColor];
    guanzhu2.font = [UIFont systemFontOfSize:11];
    guanzhu2.textColor = [UIColor redColor];
    [myScrollview addSubview:guanzhu2];
    
    //帖子
    UILabel * tiezi = [[UILabel alloc] initWithFrame:CGRectMake(guanzhu2.frame.size.width+guanzhu2.frame.origin.x+5, title.frame.origin.y+title.frame.size.height+10, 30, 15)];
    tiezi.text = @"帖子:";
    tiezi.backgroundColor = [UIColor clearColor];
    tiezi.textColor = [UIColor colorWithRed:122.0/255.0 green:122.0/255.0 blue:122.0/255.0 alpha:1];
    tiezi.font = [UIFont systemFontOfSize:11];
    [myScrollview addSubview:tiezi];
    
    UILabel * tiezi2 = [[UILabel alloc] initWithFrame:CGRectMake(tiezi.frame.size.width+tiezi.frame.origin.x, title.frame.origin.y+title.frame.size.height+10, 100, 15)];
    tiezi2.text = [NSString stringWithFormat:@"%@",self.bar_post];
    tiezi2.backgroundColor = [UIColor clearColor];
    tiezi2.font = [UIFont systemFontOfSize:11];
    tiezi2.textColor = [UIColor redColor];
    [myScrollview addSubview:tiezi2];

    NSInteger myYY =0;
    UIImageView * imageBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, image.frame.origin.y+image.frame.size.height, 320, 20)];
    [imageBack setBackgroundColor:[UIColor blackColor]];
    
    for(int i=0;i<2;i++)
    {
        
        UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(3,myYY+5 , 35, 20)];
        [icon setBackgroundColor:[UIColor redColor]];
        [imageBack addSubview:icon];
        
        //置顶
        UIButton * zhiding = [[UIButton alloc] initWithFrame:CGRectMake(50, myYY+5, 260, 15)];
        [zhiding setTitle:@"团购就是力量" forState:UIControlStateNormal];
        zhiding.backgroundColor = [UIColor clearColor];
        [zhiding setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        zhiding.titleLabel.font = [UIFont systemFontOfSize:11];
        zhiding.tag = i+1;
        [zhiding addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [imageBack addSubview:zhiding];
        
        myYY = zhiding.frame.origin.y+zhiding.frame.size.height+5;
    }
    CGRect height = imageBack.frame;
    height.size.height = myYY+10;
    imageBack.frame= height;
    
    [myScrollview addSubview:imageBack];
    
    NSInteger yy = imageBack.frame.size.height+imageBack.frame.origin.y+5;
    
    NSInteger temp_yy = 0;
    for(int i =0;i<10;i++)
    {
        
        UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.tag = (i+1)*100;
        [backBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        backBtn.frame= CGRectMake(0,  yy *(i+1)+10, 320, 30);
        
        UILabel * titleName = [[UILabel alloc] initWithFrame:CGRectMake(10,5, 300, 20)];
        titleName.text = @"请各位安琥小雨，请勿捕捉";
        titleName.backgroundColor = [UIColor clearColor];
        
        [titleName setFont:[UIFont systemFontOfSize:14]];
        [titleName setLineBreakMode:NSLineBreakByCharWrapping];
        [titleName setNumberOfLines:0];
        
        NSString *str = @"那些年错过的大雨 那些年错过的爱情 好想拥抱你 拥抱错过的勇气 曾经想征服全世界 到最后回首才发现 这世界滴滴点点全部都是你 那些年错过的大雨 那些年错过的爱情 好想告诉你 告诉你我没有忘记 那天晚上满天星星 平行时空下的约定 再一次相遇我会紧紧抱着你 紧紧抱着你";
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300,500) lineBreakMode:NSLineBreakByCharWrapping];
        [titleName setText:str];
        [titleName setFrame:CGRectMake(10.0f, 5, 300, size.height)];
        [backBtn addSubview:titleName];
        
        UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(10, size.height+titleName.frame.origin.y+10, 300, 20)];
        name.text = [NSString stringWithFormat:@"%@%@",@"蓝颜",@"04-14"];
        name.backgroundColor = [UIColor clearColor];
        name.textColor = [UIColor blackColor];
        name.font = [UIFont systemFontOfSize:12];
        [backBtn addSubview:name];
        
        UIImageView * heng = [[UIImageView alloc] initWithFrame:CGRectMake(0, name.frame.size.height+name.frame.origin.y+5, 320, 1)];
        heng.backgroundColor =[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
        [backBtn addSubview:heng];
        
        CGRect height = backBtn.frame;
        height.size.height = heng.frame.size.height+heng.frame.origin.y+5;
        backBtn.frame= height;
        
        yy =heng.frame.size.height+heng.frame.origin.y;
        temp_yy = yy *(i+2)+10;
        [myScrollview addSubview:backBtn];

    }
    
    myScrollview.contentSize= CGSizeMake(320, temp_yy+64);
}

-(void)onClick:(id)sender
{
    [self.navigationController pushViewController:inforMatioin animated:YES];
}
- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
