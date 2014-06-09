//
//  CAVdSongInfoCell.h
//  CAVA
//
//  Created by Mealk.Lei on 14-2-27.
//  Copyright (c) 2014年 WeSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewHouseListCell : UITableViewCell
{
    NSDictionary *_infoDic;
    UIImageView *imageView_cell;
}

@property (weak, nonatomic) IBOutlet UIImageView *thumnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
//@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UILabel *jiage;
@property (weak, nonatomic) IBOutlet UILabel *dizhi;
@property (weak, nonatomic) IBOutlet UILabel *leixing;

@property(nonatomic, strong) NSDictionary* infoDic;

@end
