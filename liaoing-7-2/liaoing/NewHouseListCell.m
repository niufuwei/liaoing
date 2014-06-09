//
//  CAVdSongInfoCell.m
//  CAVA
//
//  Created by Mealk.Lei on 14-2-27.
//  Copyright (c) 2014年 WeSoft. All rights reserved.
//

#import "NewHouseListCell.h"
#import "UIImageView+WebCache.h"


@implementation NewHouseListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.thumnailImageView.backgroundColor = [UIColor clearColor];
    self.songNameLabel.backgroundColor = [UIColor clearColor];
    self.lengthLabel.backgroundColor = [UIColor clearColor];
    self.jiage.backgroundColor = [UIColor clearColor];
    self.dizhi.backgroundColor = [UIColor clearColor];
    self.leixing.backgroundColor = [UIColor clearColor];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSDictionary*)infoDic
{
    return _infoDic;
}
- (void)setInfoDic:(NSDictionary *)dict
{
    _infoDic = dict;
    
    
    [self.thumnailImageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"defaultpic"]] placeholderImage:[UIImage imageNamed:@"isongktv_logo.png"]];
    self.songNameLabel.text = [dict objectForKey:@"title"];
    self.lengthLabel.text = [dict objectForKey:@"summary"];
    self.leixing.text = [dict objectForKey:@"summary"];
    
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *cachedImage = [manager imageWithURL:[NSURL URLWithString:[dict objectForKey:@"defaultpic"]]]; // 将需要缓存的图片加载进来
    if (cachedImage) {
        // 如果Cache命中，则直接利用缓存的图片进行有关操作
        // Use the cached image immediatly
        imageView_cell.image=cachedImage;
    } else {
        // 如果Cache没有命中，则去下载指定网络位置的图片，并且给出一个委托方法
        // Start an async download
        [manager downloadWithURL:[NSURL URLWithString:[dict objectForKey:@"defaultpic"]] delegate:self];
    }
    
}

@end
