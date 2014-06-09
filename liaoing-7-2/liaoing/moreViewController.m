//
//  moreViewController.m
//  liaoing
//
//  Created by eliuyan_mac on 14-6-7.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "moreViewController.h"
#import "newVersion.h"
#import "MBProgressHUD.h"

@interface moreViewController ()
{
    newVersion * NVersion;
    MBProgressHUD * hud;
}

@end

@implementation moreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage *image = [UIImage imageNamed:@"x5"];
        UITabBarItem *homeItem = [[UITabBarItem alloc]
                                  initWithTitle:@"更多" image:image selectedImage:image];
        self.tabBarItem = homeItem;    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title= @"更多";
    _table= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-64)];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];

    arr = [NSArray arrayWithObjects:@"检查更新",@"关于我们",@"意见反馈", nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID = @"cell";
    UITableViewCell * cell = [_table dequeueReusableCellWithIdentifier:strID];
    if(cell ==nil)
    {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        hud = [self showWorkingHUD:NSLocalizedString(@"正在检查...", nil)];

        NVersion = [[newVersion alloc] init];
        [NVersion begin:@"http://itunes.apple.com/lookup?id=768005105" boolBegin:NO mycallback:(^(NSString *str) {
                if([str isEqualToString:@"ok"])
                {
                    [hud hide:YES afterDelay:0];
                }
        })];
    }
    else if(indexPath.row==1)
    {
        hud = [self showWorkingHUD:NSLocalizedString(@"正在打开...", nil)];

        //关于我们
    }
    else
    {
        hud = [self showWorkingHUD:NSLocalizedString(@"正在打开...", nil)];

        //意见反馈
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
