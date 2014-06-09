//
//  forumViewController.h
//  liaoing
//
//  Created by eliuyan_mac on 14-6-7.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"




@interface forumViewController : UIViewController<UITextFieldDelegate>

{
    NSArray *_array;
    NSMutableDictionary *_dic;
    NSString *_imageUrl;
}


@property (nonatomic, strong) AFHTTPRequestOperation* op;
@property (nonatomic, strong) MBProgressHUD* hud;
@property (strong,nonatomic) UITextField * textField;
@property(nonatomic,strong) UIButton* doneButton;

@end
