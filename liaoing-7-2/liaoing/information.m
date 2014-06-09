//
//  information.m
//  liaoing
//
//  Created by laoniu on 14-6-8.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "information.h"

@implementation information
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
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor blackColor];
    [title setFont:[UIFont systemFontOfSize:16]];
    [title setLineBreakMode:NSLineBreakByCharWrapping];
    [title setNumberOfLines:0];
    
    NSString *str = @"那些年错过的大雨 那些年错过的爱情 好想拥抱你 拥抱错过的勇气 曾经想征服全世界 到最后回首才发现 这世界滴滴点点全部都是你 那些年错过的大雨 那些年错过的爱情 好想告诉你 告诉你我没有忘记 那天晚上满天星星 平行时空下的约定 再一次相遇我会紧紧抱着你 紧紧抱着你";
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(300,500) lineBreakMode:NSLineBreakByCharWrapping];
    [title setText:str];
    [title setFrame:CGRectMake(10.0f, 10, 300, size.height)];

    [self.view addSubview:title];
    
    //时间
    UILabel * time = [[UILabel alloc] initWithFrame:CGRectMake(160, title.frame.origin.y+title.frame.size.height+3,100, 20)];
    time.backgroundColor = [UIColor clearColor];
    time.textColor = [UIColor grayColor];
    time.text= @"2013-10-1";
    time.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:time];
    
    UIImageView * imageHeng = [[UIImageView alloc] initWithFrame:CGRectMake(0, time.frame.size.height+time.frame.origin.y+5, 320, 1)];
    [imageHeng setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]];
    [self.view addSubview:imageHeng];
    
    UILabel * content = [[UILabel alloc] initWithFrame:CGRectMake(10, imageHeng.frame.origin.y+imageHeng.frame.size.height+10, 300, 20)];
    content.backgroundColor = [UIColor clearColor];
    content.textColor = [UIColor blackColor];
    [content setFont:[UIFont systemFontOfSize:16]];
    [content setLineBreakMode:NSLineBreakByCharWrapping];
    [content setNumberOfLines:0];
    
    NSString *str2 = @"111111111111111111111111111111111111111111111111111111111111111111111111113";
    CGSize size2 = [str2 sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(300,500) lineBreakMode:NSLineBreakByCharWrapping];
    [content setText:str2];
    [content setFrame:CGRectMake(10, imageHeng.frame.origin.y+imageHeng.frame.size.height+10, 300, size2.height)];
    
    [self.view addSubview:content];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
