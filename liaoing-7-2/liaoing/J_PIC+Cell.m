//
//  J_PIC+Cell.m
//  liaoing
//
//  Created by laoniu on 14-6-2.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "J_PIC+Cell.h"

@implementation J_PIC_Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _Topic = [[JCTopic alloc] initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height)];
        _Topic.JCdelegate = self;
        
        [self addSubview:_Topic];

    }
    return self;
}
-(void)didClick:(id)data
{
    
}
-(void)currentPage:(int)page total:(NSUInteger)total
{
    
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
