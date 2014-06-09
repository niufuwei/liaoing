//
//  UIViewController+Utilities.m
//  CAVA
//
//  Created by Mealk.Lei on 14-2-21.
//  Copyright (c) 2014年 WeSoft. All rights reserved.
//

#import "UIViewController+Utilities.h"

@implementation UIViewController (Utilities)

- (void)setDefaultAppearance
{
    [self adaptednavigationBar];
    [self setDefaultBackground];
}
- (void)adaptednavigationBar
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
#endif
}
- (void)setDefaultBackground
{
    if([self isKindOfClass:[UITableViewController class]])
    {
        UITableViewController* tvc = (UITableViewController*)self;
        UIImageView *tableBGImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"viewBG.png"]];
        [tvc.tableView setBackgroundView:tableBGImage];
    }
    else {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBG.png"]];
    }
    
}
- (id)barButtonItemWithNormalImageName:(NSString*)normalImageName
                  highlightedImageName:(NSString*)highlightedImageName
                                target:(id)target
                                action:(SEL)action
{
    return [self barButtonItemWithNormalImage:[UIImage imageNamed:normalImageName]
                             highlightedImage:[UIImage imageNamed:highlightedImageName]
                                       target:target
                                       action:action];
}

- (id)barButtonItemWithNormalImageName:(NSString*)normalImageName
                  highlightedImageName:(NSString*)highlightedImageName
                                 title:(NSString*)titleStr
                                target:(id)target
                                action:(SEL)action
{
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    UIImage *highlightedImage = [UIImage imageNamed:highlightedImageName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithCustomView: button];
    NSLog(@"%f",normalImage.size.width);
    button.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
    barButtonItem.width = normalImage.size.width;
    
    [button setTitle:titleStr forState:UIControlStateNormal];
    
    
    // Normal state background
    UIImage *backgroundImage = normalImage;
    
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    backgroundImage = highlightedImage;
    
    [button setBackgroundImage:backgroundImage forState:UIControlStateHighlighted];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return barButtonItem;
}

- (id)barButtonItemWithNormalImage:(UIImage*)normalImage
                  highlightedImage:(UIImage*)highlightedImage
                            target:(id)target
                            action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithCustomView: button];
    NSLog(@"%f",normalImage.size.width);
    button.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
    barButtonItem.width = normalImage.size.width;
    
    [button setTitle:@"" forState:UIControlStateNormal];
    
    
    // Normal state background
    UIImage *backgroundImage = normalImage;
    
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    backgroundImage = highlightedImage;
    
    [button setBackgroundImage:backgroundImage forState:UIControlStateHighlighted];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return barButtonItem;
    
}
- (MBProgressHUD*)showWorkingHUD:(NSString*)message
{
    MBProgressHUD* messageView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    messageView.delegate = nil;
    messageView.detailsLabelText = message;
    messageView.removeFromSuperViewOnHide = YES;
    return messageView;
}
- (void)changeHUD:(MBProgressHUD*)hud message:(NSString*)message
{
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.hidden = NO;
    hud.detailsLabelText = message;
    hud.completionBlock = nil;
}

- (void)changeHUDAutoHiden:(MBProgressHUD*)hud message:(NSString*)message
{
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.hidden = NO;
    hud.detailsLabelText = message;
    hud.completionBlock = nil;
    [hud hide:YES afterDelay:1.8];
}

- (void)hidHUDMessage:(MBProgressHUD*)hud
             animated:(BOOL)animated
{
    [hud hide:animated];
}

- (MBProgressHUD*)showWorkingHUD:(NSString*)message inView:(UIView*)view
{
    MBProgressHUD* messageView = [MBProgressHUD showHUDAddedTo:view animated:YES];
    messageView.delegate = nil;
    messageView.detailsLabelText = message;
    messageView.removeFromSuperViewOnHide = YES;
    return messageView;
}

- (MBProgressHUD*)showWorkingHUDAutoHiden:(NSString*)message inView:(UIView*)view
{
    MBProgressHUD* messageView = [MBProgressHUD showHUDAddedTo:view animated:YES];
    messageView.delegate = nil;
    messageView.mode = MBProgressHUDModeText;
    messageView.detailsLabelText = message;
    messageView.removeFromSuperViewOnHide = YES;
    [messageView hide:YES afterDelay:1.8];
    return messageView;
}

- (MBProgressHUD*)showToastAutoHiden:(NSString*)message inView:(UIView*)view
{
    MBProgressHUD* messageView = [MBProgressHUD showHUDAddedTo:view animated:NO];
    messageView.delegate = nil;
    messageView.mode = MBProgressHUDModeText;
    messageView.detailsLabelText = message;
    messageView.removeFromSuperViewOnHide = YES;
    [messageView hide:YES afterDelay:1.8];
    return messageView;
}

@end
