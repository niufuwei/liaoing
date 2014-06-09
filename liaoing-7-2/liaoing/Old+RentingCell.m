//
//  Old+RentingCell.m
//  liaoing
//
//  Created by laoniu on 14-6-4.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "Old+RentingCell.h"

@implementation Old_RentingCell
@synthesize image;
@synthesize short_address;
@synthesize title;
@synthesize address;
@synthesize money;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 50)];
        [self addSubview:image];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(image.frame.size.width+image.frame.origin.x+3, 10, 240, 15)];
        title.font = [UIFont systemFontOfSize:15];
        title.textColor = [UIColor blackColor];
        title.backgroundColor = [UIColor clearColor];
        [self addSubview:title];
        
        short_address = [[UILabel alloc] initWithFrame:CGRectMake(image.frame.size.width+image.frame.origin.x+3, title.frame.origin.y+title.frame.size.height+2, 70, 15)];
        short_address.font = [UIFont systemFontOfSize:12];
        short_address.textColor = [UIColor grayColor];
        short_address.backgroundColor = [UIColor clearColor];
        [self addSubview:short_address];
        
        money = [[UILabel alloc] initWithFrame:CGRectMake(short_address.frame.size.width+short_address.frame.origin.x+80, title.frame.origin.y+title.frame.size.height+2, 150, 15)];
        money.font = [UIFont systemFontOfSize:14];
        money.textColor = [UIColor orangeColor];
        money.backgroundColor = [UIColor clearColor];
        [self addSubview:money];
        
        address = [[UILabel alloc] initWithFrame:CGRectMake(image.frame.size.width+image.frame.origin.x+3, short_address.frame.origin.y+short_address.frame.size.height+2, 250, 15)];
        address.font = [UIFont systemFontOfSize:12];
        address.textColor = [UIColor grayColor];
        address.backgroundColor = [UIColor clearColor];
        [self addSubview:address];

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
