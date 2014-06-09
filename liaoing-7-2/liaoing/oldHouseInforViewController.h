//
//  oldHouseInforViewController.h
//  liaoing
//
//  Created by eliuyan_mac on 14-6-7.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface oldHouseInforViewController : UIViewController
{
    UIPageControl *pageControl;
    UIScrollView * backGroundScrollview;
}
@property (nonatomic,strong) UIScrollView * scrollview;
@property (nonatomic,strong) NSString * strTitle;
@property (nonatomic,strong) NSString * ID;
@end
