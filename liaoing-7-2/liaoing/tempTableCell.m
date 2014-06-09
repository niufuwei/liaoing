//
//  tempTableCell.m
//  liaoing
//
//  Created by laoniu on 14-6-7.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "tempTableCell.h"

@implementation tempTableCell
@synthesize name;
@synthesize choose;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        name =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 290-50, 77)];
        name.textColor = [UIColor blackColor];
        name.font = [UIFont systemFontOfSize:19];
        [name setBackgroundColor:[UIColor clearColor]];
        [self addSubview:name];
        
        choose = [UIButton buttonWithType:UIButtonTypeCustom];
        choose.frame = CGRectMake(320- 15-28, 77/2-14, 28, 28);
        [self addSubview:choose];
        
    }
    return self;
}

@end
