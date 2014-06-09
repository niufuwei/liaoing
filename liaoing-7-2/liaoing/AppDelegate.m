//
//  AppDelegate.m
//  liaoing
//
//  Created by haonan.wang on 14-5-6.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchViewController.h"
#import "IndexViewController.h"
#import "moreViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    [self customizeAppearance];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
//    WDHomeViewController *homeVC = [[WDHomeViewController alloc]init];
//   WDHomeViewController *homeVC1 = [[WDHomeViewController alloc]init];
//    WDHomeViewController *homeVC2 = [[WDHomeViewController alloc]init];
//    WDHomeViewController *homeVC3 = [[WDHomeViewController alloc]init];
//   WDHomeViewController *homeVC4 = [[WDHomeViewController alloc]init];
    
    IndexViewController *homeVC = [[IndexViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    SearchViewController *homeVC1 = [[SearchViewController alloc]init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:homeVC1];
    moreViewController *homeVC2 = [[moreViewController alloc]init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:homeVC2];

    
    UITabBarController *tabbar = [[UITabBarController alloc]init];
//    tabbar.viewControllers = [NSArray arrayWithObjects:homeVC,homeVC1,homeVC2,homeVC3,homeVC4, nil];
    tabbar.viewControllers = [NSArray arrayWithObjects:nav,nav1,nav2, nil];
    self.window.rootViewController = tabbar;
    
    [self.window makeKeyAndVisible];
    return YES;
    
//    if ([self.navigationController.visibleViewController isEqual:[self.navigationController.viewControllers objectAtIndex:0]])
//    {
//       self.navigationController.navigationBarHidden = YES;
//       self.hidesBottomBarWhenPushed = NO;
//    }
//    else
//   {
//        self.navigationController.navigationBarHidden = NO;
//        self.hidesBottomBarWhenPushed = YES;
//   }

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)customizeAppearance
{
    //Setting Navigation Bar appearance.
    UIImage *bgImg = [IOS7Later?[UIImage imageNamed:@"navBG.png"]:[UIImage imageNamed:@"navBG.png"]
                      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [[UINavigationBar appearance] setBackgroundImage:bgImg
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      UITextAttributeTextColor,
      nil]];
    
}

@end
