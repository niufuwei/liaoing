//
//  UIViewController+Utilities.h
//  CAVA
//
//  Created by Mealk.Lei on 14-2-21.
//  Copyright (c) 2014年 WeSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (Utilities)

- (void)setDefaultAppearance;
- (void)adaptednavigationBar;
- (void)setDefaultBackground;
- (id)barButtonItemWithNormalImageName:(NSString*)normalImageName
                  highlightedImageName:(NSString*)highlightedImageName
                                target:(id)target
                                action:(SEL)action;
- (id)barButtonItemWithNormalImage:(UIImage*)normalImage
                  highlightedImage:(UIImage*)highlightedImage
                            target:(id)target
                            action:(SEL)action;
- (id)barButtonItemWithNormalImageName:(NSString*)normalImageName
                  highlightedImageName:(NSString*)highlightedImageName
                                 title:(NSString*)titleStr
                                target:(id)target
                                action:(SEL)action;
//HUD
- (MBProgressHUD*)showWorkingHUD:(NSString*)message inView:(UIView*)view;
- (MBProgressHUD*)showWorkingHUDAutoHiden:(NSString*)message inView:(UIView*)view;
- (MBProgressHUD*)showWorkingHUD:(NSString*)message;
- (void)changeHUD:(MBProgressHUD*)hud message:(NSString*)message;
- (void)changeHUDAutoHiden:(MBProgressHUD*)hud message:(NSString*)message;
- (void)hidHUDMessage:(MBProgressHUD*)hud animated:(BOOL)animated;
- (MBProgressHUD*)showToastAutoHiden:(NSString*)message inView:(UIView*)view;

@end
