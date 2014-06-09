//
//  NewsContentViewController.m
//  TestDemo
//
//  Created by Mealk.Lei on 14-4-30.
//  Copyright (c) 2014年 WeSoft. All rights reserved.
//

#import "NewsContentViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"

@interface NewsContentViewController ()
@property (nonatomic , strong)  NSMutableArray *newsArray;

@property (nonatomic, weak) MBProgressHUD* hud;
@property (nonatomic, weak) AFHTTPRequestOperation* op;
@property (nonatomic, weak) AFHTTPRequestOperation* op2;
@end

static int kTextTag = 347;

@implementation NewsContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self adaptednavigationBar];
    self.title = @"新闻详情";
    self.navigationItem.leftBarButtonItem = [self barButtonItemWithNormalImageName:@"navBackBtn.png"
                                                              highlightedImageName:nil
                                                                            target:self
                                                                            action:@selector(backBtn:)];
    
    self.newsArray = [NSMutableArray array];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - (IOS7Later ?164:144))];
    tableView.delegate = self;
    tableView.dataSource = self;
    //    tableView.backgroundColor = [UIColor colorWithRed:252.0f/255.0f green:252.0f/255.0f blue:252.0f/255.0f alpha:1.0f];
    tableView.backgroundColor = [UIColor clearColor];
    // tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    webHeight = 10;
    
    [self refreshData];
}
- (void)viewWillAppear:(BOOL)animated
{
    //解决底部导航隐藏不彻底的问题
    if (self.tabBarController.tabBar.hidden == YES) {
        // return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = YES;
    
    
    
    self.navigationController.navigationBarHidden = NO;
    //   [self.tabBarController.tabBar setHidden:YES];
    
}

#pragma- Button Action
- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clearWebViewBackground:(UIWebView *)_webView{
    [_webView setBackgroundColor:[UIColor clearColor]];
    [_webView setOpaque:NO];
    for (UIView *subView in [_webView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scroll = (UIScrollView *)subView;
            scroll.bounces = NO;
            scroll.showsHorizontalScrollIndicator = NO;
            scroll.showsVerticalScrollIndicator = NO;
            //((UIScrollView *)subView).scrollEnabled = NO;
            for (UIView *shadowView in [subView subviews]) {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    shadowView.hidden = YES;
                    //NSLog(@"=============hidden0");
                }
            }
        }
    }
}

-(void)refreshData{
    self.hud = [self showWorkingHUD:nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //    NSDictionary *dict = @{@"user_id": userid,
    //                           };
    //    NSError *error;
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSDictionary *params = @{@"field":jsonStr};
    //    NSLog(@"parms=======%@",params);
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"http://zhengzhou.liaoing.com/ios/info/id/%@.html",self.idStr] parameters:nil error:nil];
    self.op = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
     //   NSLog(@"JSON: %@", responseObject);
        self.infoDict = (NSDictionary *)responseObject;
        [self getRelatedNews];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        [self hidHUDMessage:self.hud animated:YES];
    }];
    [self.op start];
    
}

- (void)getRelatedNews
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:@"http://zhengzhou.liaoing.com/ios/list/num/5.html" parameters:nil error:nil];
    self.op = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
     //   NSLog(@"JSON: %@", responseObject);
        [self hidHUDMessage:self.hud animated:YES];
        NSArray *array = [NSArray arrayWithArray:responseObject];
        [self.newsArray removeAllObjects];
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *dic = (NSDictionary *)obj;
            [self.newsArray addObject:dic];
            
        }];
        
        [self reloadTable];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        [self hidHUDMessage:self.hud animated:YES];
    }];
    [self.op start];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int count = self.infoDict == nil?0:2;
    int count2 = self.newsArray.count == 0?0:(self.newsArray.count+1);
	return count2 + count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.row == 0) {
        height = 80;
    }else if(indexPath.row == 1){
        height = webHeight;
    }else{
         height = 44;
    }
    
    //NSLog(@"height=%f",height);
	return height;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"CellIdentifier1";
        static int kTitleTag = 346;
        
        static int kSourceTag = 348;
        static int kTimeTag = 349;
        
        UITableViewCell *cell = (UITableViewCell*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 8, 292, 34)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont boldSystemFontOfSize:17];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.tag = kTitleTag;
            [cell.contentView addSubview:titleLabel];
            
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLabel.frame.origin.y, 120, 34)] ;
            timeLabel.backgroundColor = [UIColor clearColor];
            timeLabel.font = [UIFont systemFontOfSize:11];
            timeLabel.textAlignment = NSTextAlignmentLeft;
            timeLabel.textColor = [UIColor grayColor];
            timeLabel.tag = kTimeTag;
            [cell.contentView addSubview:timeLabel];
            
            UILabel *sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, titleLabel.frame.origin.y, 150, 26)];
            sourceLabel.backgroundColor = [UIColor clearColor];
            sourceLabel.font = [UIFont systemFontOfSize:13];
            sourceLabel.textAlignment = NSTextAlignmentLeft;
            sourceLabel.textColor = [UIColor grayColor];
            sourceLabel.tag = kSourceTag;
            [cell.contentView addSubview:sourceLabel];
            
            
        }
        //    [NSDictionary dictionaryWithObjectsAndKeys:[created_at stringValue], @"created_at", [topicid stringValue], @"topicid", [title stringValue], @"title", [text stringValue], @"text", [source stringValue], @"source", [detail stringValue], @"detail", nil]
        
        NSDictionary *dict = self.infoDict;
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:kTitleTag];
    
        UILabel *sourceLabel = (UILabel *)[cell viewWithTag:kSourceTag];
        UILabel *timeLabel = (UILabel *)[cell viewWithTag:kTimeTag];
        
        
        //sourceLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"organname"]];
        timeLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"updatetime"]];
        CGSize aSize;
        CGRect frame;
        
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [titleLabel setNumberOfLines:2];
        titleLabel.text = [dict objectForKey:@"title"];
        aSize = [titleLabel sizeThatFits:CGSizeMake(292, 0)];
        if (aSize.height > 35) {
            frame = CGRectMake(14, 5, 292, aSize.height);
        }else{
            frame = CGRectMake(14, 13, 292, aSize.height);
        }
        [titleLabel setFrame:frame];
        
        sourceLabel.font = [UIFont systemFontOfSize:13];
        sourceLabel.frame = CGRectMake(15, 50, 120, 26);
   
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.frame = CGRectMake(15, 50, 150, 20);
        return cell;
        
    }else if(indexPath.row == 1)
    {
       
        static NSString *CellIdentifier = @"CellIdentifier2";
        
        UITableViewCell *cell = (UITableViewCell*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //            UIImageView *bgView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, topHeight)] autorelease];
            //            bgView.backgroundColor = [UIColor clearColor];
            //            cell.backgroundView = bgView;
           
            
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 10, 300, webHeight)] ;
            webView.delegate = self;
            webView.tag = kTextTag;
            webView.dataDetectorTypes = UIDataDetectorTypeNone;
            //webView.userInteractionEnabled = NO;
            [cell.contentView addSubview:webView];
            [self clearWebViewBackground:webView];
            
        }
 
        
        NSDictionary *dict = self.infoDict;
        
        UIWebView *webView = (UIWebView *)[cell viewWithTag:kTextTag];
       
        
        [webView loadHTMLString:[dict objectForKey:@"content"] baseURL:nil];
        
        //sourceLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"organname"]];
     
        
      webView.frame = CGRectMake(10, 10, 300, webHeight);

        return cell;
    }else if(indexPath.row == 2){
        
         static NSString *CellIdentifier = @"CellIdentifier3";
        UITableViewCell *cell = (UITableViewCell*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        cell.textLabel.text = @"相关新闻";
        cell.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_01_lan"]];
        return cell;
    }else{
        static NSString *CellIdentifier = @"NewsCellIdentifier4";
        UITableViewCell *cell = (UITableViewCell*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.text = [self.newsArray[indexPath.row - 3] objectForKey:@"title"];
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row >=3){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NewsContentViewController *contentViewCtr = [[NewsContentViewController alloc] init];
        contentViewCtr.idStr = [self.newsArray[indexPath.row-3] objectForKey:@"news_id"];
        [self.navigationController pushViewController:contentViewCtr animated:YES];
        
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView{
    NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
    
    NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
    "if (mySheet.addRule) {"
    "mySheet.addRule(selector, newRule);"								// For Internet Explorer
    "} else {"
    "ruleIndex = mySheet.cssRules.length;"
    "mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
    "}"
    "}";
    
    NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: 0px; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", _webView.frame.size.width];
    NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')", 105];
    
    [_webView stringByEvaluatingJavaScriptFromString:varMySheet];
    
    [_webView stringByEvaluatingJavaScriptFromString:addCSSRule];
    
    [_webView stringByEvaluatingJavaScriptFromString:insertRule1];
    
    setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')", 105];
    [_webView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
    //int totalHeight = [[_webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] intValue];
    int totalHeight = [[_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] intValue];
    if (webHeight != totalHeight) {
        webHeight = totalHeight;
        NSLog(@"webheight=%d",webHeight);
        //[tableView reloadData];
        [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:NO];
    }
}

-(void)reloadTable
{
    [self hidHUDMessage:self.hud animated:YES];
    [tableView reloadData];
}

@end
