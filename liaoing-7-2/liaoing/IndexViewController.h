//
//  IndexViewController.h
//  liaoing
//
//  Created by liaoing on 14-5-20.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCTopic.h"


@interface IndexViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UITextFieldDelegate,UISearchBarDelegate>
{
    UITableView *tableView;
    NSArray *_imageArray;
    UIImageView * firstIMG;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) JCTopic * Topic;

@end
