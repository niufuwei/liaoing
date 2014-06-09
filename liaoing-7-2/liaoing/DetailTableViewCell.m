//
//  DetailTableViewCell.m
//  liaoing
//
//  Created by shanchen on 14-6-7.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell
@synthesize fans;
@synthesize logo;
@synthesize post;
@synthesize name;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //添加左边图片
        logo=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 40)];
        
        [self addSubview:logo];
        //添加名字
        name=[[UILabel alloc] initWithFrame:CGRectMake(80, 0, 100, 30)];
        
        [self addSubview:name];
        //添加关注
        fans=[[UILabel alloc] initWithFrame:CGRectMake(80, 30, 100, 30)];
      
        fans.font=[UIFont systemFontOfSize:15];
        fans.textColor=[UIColor grayColor];
        [self addSubview:fans];
        //添加tiez
        post=[[UILabel alloc] initWithFrame:CGRectMake(180, 30, 100, 30)];
        
        post.font=[UIFont systemFontOfSize:15];
        post.textColor=[UIColor grayColor];
        [self addSubview:post];
        
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
