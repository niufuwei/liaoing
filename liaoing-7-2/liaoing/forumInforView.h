//
//  forumInforView.h
//  liaoing
//
//  Created by laoniu on 14-6-8.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface forumInforView : UIViewController
{
    UIScrollView * myScrollview;
}

@property(nonatomic,strong)NSString *bar_post;//帖子
@property(nonatomic,strong)NSString *bar_name;//名字
@property(nonatomic,strong)NSString *bbs_fans;//关注
@property(nonatomic,strong)NSString *bbs_logo;//图片



@end
