//
//  NewHouseinfoViewController.h
//  liaoing
//
//  Created by liaoing on 14-5-14.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewHouseinfoViewController : UIViewController<UIScrollViewDelegate>
{
}

@property (nonatomic, copy) NSString *idStr;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong,nonatomic) NSString * houseName;
@property (strong, nonatomic) UIScrollView *backScrollView;
@end
