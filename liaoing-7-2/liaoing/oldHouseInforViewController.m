//
//  oldHouseInforViewController.m
//  liaoing
//
//  Created by eliuyan_mac on 14-6-7.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "oldHouseInforViewController.h"
#import "httpRequest.h"

@interface oldHouseInforViewController ()<httpRequestDelegate>
{
    BOOL isEnd;
    UIButton * telButton;
    
    NSMutableArray * dataArray;
    MBProgressHUD * hud;
}

@end

@implementation oldHouseInforViewController
@synthesize scrollview;
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
    self.title = _strTitle;
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64-60-44, 320, 60)];
    [view setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:223.0/255.0  blue:222.0/255.0  alpha:1]];
    telButton = [UIButton buttonWithType:UIButtonTypeCustom];
    telButton.frame = CGRectMake(30, 10, 260, 40);
    
    UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 40)];
    name.text = @"张作奎";
    name.backgroundColor = [UIColor clearColor];
    name.textColor = [UIColor whiteColor];
    [telButton addSubview:name];
    
    UIImageView * tel = [[UIImageView alloc] initWithFrame:CGRectMake(name.frame.size.width+name.frame.origin.x, 5, 30, 30)];
    tel.backgroundColor = [UIColor redColor];
    [telButton addSubview:tel];
    
    UILabel * telPhone = [[UILabel alloc] initWithFrame:CGRectMake(tel.frame.size.width+tel.frame.origin.x+5, 0, 170, 40)];
    telPhone.text = @"18600135086";
    telPhone.backgroundColor = [UIColor clearColor];
    telPhone.textColor = [UIColor whiteColor];
    [telButton addSubview:telPhone];
    [telButton.layer setCornerRadius:10.0];
    
    [telButton setBackgroundColor:[UIColor colorWithRed:71.0/255.0 green:178.0/255.0 blue:26.0/255.0 alpha:1]];
    [view addSubview:telButton];
    
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // self.hidesBottomBarWhenPushed=YES;
    // self.view.backgroundColor = [UIColor redColor];
    backGroundScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    self.navigationItem.leftBarButtonItem = [self barButtonItemWithNormalImageName:@"navBackBtn.png"
                                                              highlightedImageName:nil
                                                                            target:self
                                                                            action:@selector(backBtn)];
    self.navigationItem.rightBarButtonItem = [self barButtonItemWithNormalImageName:@"x2.png"
                                                               highlightedImageName:nil
                                                                             target:self
                                                                             action:nil];
    NSArray *_imageArray = @[@"caScrollImg1.png",@"caScrollImg2.png",@"caScrollImg3.png"];
    
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    scrollview.backgroundColor = [UIColor clearColor];
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.pagingEnabled = YES;
    scrollview.contentSize = CGSizeMake(320*3, 130);
    [backGroundScrollview addSubview:scrollview];
    
    for(int i=0;i<_imageArray.count;i++){
        
        UIImageView * firstImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[_imageArray objectAtIndex:i]]];
        
        firstImg.frame=CGRectMake(320*i, 0, 320, 130);
        
        [scrollview addSubview:firstImg];
        
    }
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(141, 110, 38, 36)];
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    [backGroundScrollview addSubview:pageControl];
    
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(handleSchedule) userInfo:nil repeats:YES];
    
    [self.view addSubview:backGroundScrollview];
    [self.view addSubview:view];
    // Do any additional setup after loading the view.
}


#pragma mark - Public Method
-(void)refreshData{
    
    //    NSDictionary *dict = @{@"user_id": userid,
    //                           };
    //    NSError *error;
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSDictionary *params = @{@"field":jsonStr};
    //    NSLog(@"parms=======%@",params);
    NSString * strHttp = [NSString stringWithFormat:@"http://zhengzhou.liaoing.com/ios/esfinfo/id/%@.html",_ID];
    NSLog(@"%@",strHttp);
    
    httpRequest * http = [[httpRequest alloc] init];
    http.httpDelegate = self;
    hud = [self showWorkingHUD:NSLocalizedString(@"加载数据中...", nil)];
    [http httpRequestSend:strHttp parameter:nil backBlock:(^(NSDictionary *tempdic)
                                                           {
                                                              
                                                               [self hidHUDMessage:hud animated:YES];
                                                               [self addContent:tempdic];
                                                               
                                                           })];
    
}

-(void)httpRequestError:(NSString *)str
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器请求失败." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [self hidHUDMessage:hud animated:YES];
}

-(void)addContent:(NSDictionary *)dic
{
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(10, scrollview.frame.size.height+scrollview.frame.origin.y+5, 300, 20)];
    title.text =_strTitle;
    title.backgroundColor = [UIColor clearColor];
    [backGroundScrollview addSubview:title];
    
    //时间
    UILabel * time = [[UILabel alloc] initWithFrame:CGRectMake(10, title.frame.size.height+title.frame.origin.y+5, 300, 20)];
    time.text = [[dic objectForKey:@"sellhouse"] objectForKey:@"time1"];
    time.backgroundColor = [UIColor clearColor];
    [backGroundScrollview addSubview:time];
    
    //售价
    UILabel * shoujia = [[UILabel alloc] initWithFrame:CGRectMake(10, time.frame.size.height+time.frame.origin.y+5, 80, 20)];
    shoujia.text = @"售      价:";
    shoujia.backgroundColor = [UIColor clearColor];
    shoujia.textColor = [UIColor grayColor];
    [backGroundScrollview addSubview:shoujia];
    
    UILabel * shoujiaalloc = [[UILabel alloc] initWithFrame:CGRectMake(shoujia.frame.size.width+shoujia.frame.origin.x+5, time.frame.size.height+time.frame.origin.y+5, 200, 20)];
    shoujiaalloc.text = [NSString stringWithFormat:@"%@万",[[dic objectForKey:@"sellhouse"] objectForKey:@"price"]];
    shoujiaalloc.backgroundColor = [UIColor clearColor];
    shoujiaalloc.textColor = [UIColor redColor];
    [backGroundScrollview addSubview:shoujiaalloc];

    //户型面积
    UILabel * huxing = [[UILabel alloc] initWithFrame:CGRectMake(10, shoujia.frame.size.height+shoujia.frame.origin.y+5, 80, 20)];
    huxing.text = @"户型面积:";
    huxing.backgroundColor = [UIColor clearColor];
    huxing.textColor = [UIColor grayColor];
    [backGroundScrollview addSubview:huxing];
    
    
    UILabel * huxing_alloc = [[UILabel alloc] initWithFrame:CGRectMake(huxing.frame.size.width+huxing.frame.origin.x+5, shoujia.frame.size.height+shoujia.frame.origin.y+5, 200, 20)];
    huxing_alloc.text = [[dic objectForKey:@"sellhouse"] objectForKey:@"size"];
    huxing_alloc.backgroundColor = [UIColor clearColor];
    huxing_alloc.textColor = [UIColor blackColor];
    [backGroundScrollview addSubview:huxing_alloc];
    //楼层朝向
    UILabel * chaoxiang = [[UILabel alloc] initWithFrame:CGRectMake(10, huxing.frame.size.height+huxing.frame.origin.y+5, 80, 20)];
    chaoxiang.text = @"楼层朝向:";
    chaoxiang.backgroundColor = [UIColor clearColor];
    chaoxiang.textColor = [UIColor grayColor];
    [backGroundScrollview addSubview:chaoxiang];
    
    UILabel * chaoxiang_alloc = [[UILabel alloc] initWithFrame:CGRectMake(chaoxiang.frame.size.width+chaoxiang.frame.origin.x+5, huxing.frame.size.height+huxing.frame.origin.y+5, 200, 20)];
    chaoxiang_alloc.text = [[dic objectForKey:@"sellhouse"] objectForKey:@"chaoxiang"];
    chaoxiang_alloc.backgroundColor = [UIColor clearColor];
    chaoxiang_alloc.textColor = [UIColor blackColor];
    [backGroundScrollview addSubview:chaoxiang_alloc];

    
    //房屋情况
    UILabel * qingkuang = [[UILabel alloc] initWithFrame:CGRectMake(10, chaoxiang.frame.size.height+chaoxiang.frame.origin.y+5, 80, 20)];
    qingkuang.text = @"房屋情况:";
    qingkuang.backgroundColor = [UIColor clearColor];
    qingkuang.textColor = [UIColor grayColor];
    [backGroundScrollview addSubview:qingkuang];
    
    UILabel * qingkuang_alloc = [[UILabel alloc] initWithFrame:CGRectMake(qingkuang.frame.size.width+qingkuang.frame.origin.x+5, chaoxiang.frame.size.height+chaoxiang.frame.origin.y+5, 200, 20)];
    qingkuang_alloc.text = [[dic objectForKey:@"sellhouse"] objectForKey:@"leixing"];
    qingkuang_alloc.backgroundColor = [UIColor clearColor];
    qingkuang_alloc.textColor = [UIColor blackColor];
    [backGroundScrollview addSubview:qingkuang_alloc];
    
    //房源描述
    UILabel * fangyuan = [[UILabel alloc] initWithFrame:CGRectMake(10, qingkuang.frame.size.height+qingkuang.frame.origin.y+10, 300, 20)];
    fangyuan.text = @"房源描述";
    fangyuan.backgroundColor = [UIColor clearColor];
    [backGroundScrollview addSubview:fangyuan];

    UILabel * infor = [[UILabel alloc] initWithFrame:CGRectMake(10, fangyuan.frame.size.height+fangyuan.frame.origin.y+5, 300, 20)];
    infor.backgroundColor = [UIColor clearColor];
    infor.textColor = [UIColor grayColor];
    [infor setFont:[UIFont systemFontOfSize:14]];
    [infor setLineBreakMode:NSLineBreakByCharWrapping];
    [infor setNumberOfLines:0];
    
    NSString *str =[[dic objectForKey:@"sellhouse"] objectForKey:@"remark"];
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300,500) lineBreakMode:NSLineBreakByCharWrapping];
    [infor setText:str];
    [infor setFrame:CGRectMake(10.0f, fangyuan.frame.size.height+fangyuan.frame.origin.y+5, size.width, size.height)];
    [backGroundScrollview addSubview:infor];
    
    //小区信息
    UILabel * xiaoquxinxi = [[UILabel alloc] initWithFrame:CGRectMake(10, infor.frame.size.height+infor.frame.origin.y+10, 300, 20)];
    xiaoquxinxi.text = @"小区信息";
    xiaoquxinxi.backgroundColor = [UIColor clearColor];
    [backGroundScrollview addSubview:xiaoquxinxi];
    
    UIImageView * imageHeng =[[UIImageView alloc] initWithFrame:CGRectMake(0, xiaoquxinxi.frame.origin.y+xiaoquxinxi.frame.size.height, 320, 1)];
    [imageHeng setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1]];
    [backGroundScrollview addSubview:imageHeng];
    
    //小区
    UILabel * xiaoqu = [[UILabel alloc] initWithFrame:CGRectMake(10, imageHeng.frame.size.height+imageHeng.frame.origin.y+5, 80, 20)];
    xiaoqu.text = @"小       区:";
    xiaoqu.backgroundColor = [UIColor clearColor];
    xiaoqu.textColor = [UIColor grayColor];
    [backGroundScrollview addSubview:xiaoqu];
    
    UILabel *xiaoqu_alloc = [[UILabel alloc] initWithFrame:CGRectMake(xiaoqu.frame.size.width+xiaoqu.frame.origin.x+5, imageHeng.frame.size.height+imageHeng.frame.origin.y+5, 200, 20)];
    xiaoqu_alloc.text = [[[[dic objectForKey:@"sellhouse"] objectForKey:@"iha"] objectAtIndex:0] objectForKey:@"name"];
    xiaoqu_alloc.backgroundColor = [UIColor clearColor];
    xiaoqu_alloc.textColor = [UIColor blackColor];
    [backGroundScrollview addSubview:xiaoqu_alloc];

    
    //区域
    UILabel * quyu = [[UILabel alloc] initWithFrame:CGRectMake(10, xiaoqu.frame.size.height+xiaoqu.frame.origin.y+5, 80, 20)];
    quyu.text = @"区       域:";
    quyu.backgroundColor = [UIColor clearColor];
    quyu.textColor = [UIColor grayColor];
    [backGroundScrollview addSubview:quyu];
    
    UILabel * quyu_alloc = [[UILabel alloc] initWithFrame:CGRectMake(quyu.frame.size.width+quyu.frame.origin.x+5, xiaoqu.frame.size.height+xiaoqu.frame.origin.y+5, 200, 20)];
    quyu_alloc.text = [[[[dic objectForKey:@"sellhouse"] objectForKey:@"iha"] objectAtIndex:0] objectForKey:@"area"];
    quyu_alloc.backgroundColor = [UIColor clearColor];
    quyu_alloc.textColor = [UIColor blackColor];
    [backGroundScrollview addSubview:quyu_alloc];
    
    //地址
    UILabel * address = [[UILabel alloc] initWithFrame:CGRectMake(10, quyu.frame.size.height+quyu.frame.origin.y+5, 300, 20)];
    address.text = [[[[dic objectForKey:@"sellhouse"] objectForKey:@"iha"] objectAtIndex:0] objectForKey:@"address"];
    address.backgroundColor = [UIColor clearColor];
    address.textColor = [UIColor blackColor];
    address.textAlignment = NSTextAlignmentLeft;
    [backGroundScrollview addSubview:address];
    
    //联系人

    UILabel * people = [[UILabel alloc] initWithFrame:CGRectMake(10, address.frame.size.height+address.frame.origin.y+10, 300, 20)];
    people.text = @"联系人";
    people.backgroundColor = [UIColor clearColor];
    [backGroundScrollview addSubview:people];
    
    UIImageView * imageHeng2 =[[UIImageView alloc] initWithFrame:CGRectMake(0, people.frame.origin.y+people.frame.size.height, 320, 1)];
    [imageHeng2 setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1]];
    [backGroundScrollview addSubview:imageHeng2];

    
    //头像
    UIImageView * touxiang = [[UIImageView alloc] initWithFrame:CGRectMake(5, imageHeng2.frame.size.height+imageHeng2.frame.origin.y+10, 85, 110)];
    [touxiang setBackgroundColor:[UIColor redColor]];
    [backGroundScrollview addSubview:touxiang];
    
    //姓名
    UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(touxiang.frame.size.width+touxiang.frame.origin.x+3, imageHeng2.frame.size.height+imageHeng2.frame.origin.y+10, 300, 20)];
    name.text = @"张作奎";
    name.backgroundColor = [UIColor clearColor];
    [backGroundScrollview addSubview:name];

    //联系方式
    UILabel * telphone = [[UILabel alloc] initWithFrame:CGRectMake(touxiang.frame.size.width+touxiang.frame.origin.x+3, name.frame.size.height+name.frame.origin.y+10, 80, 20)];
    telphone.text = @"联系方式:";
    telphone.backgroundColor = [UIColor clearColor];
    [telphone setTextColor:[UIColor grayColor]];
    [backGroundScrollview addSubview:telphone];
    
    UILabel * telphone2 = [[UILabel alloc] initWithFrame:CGRectMake(telphone.frame.size.width+telphone.frame.origin.x, name.frame.size.height+name.frame.origin.y+10, 170, 20)];
    telphone2.text = @"18600135086";
    telphone2.backgroundColor = [UIColor clearColor];
    [telphone2 setTextColor:[UIColor redColor]];
    [backGroundScrollview addSubview:telphone2];
    
    //所属公司
    UILabel * gongsi = [[UILabel alloc] initWithFrame:CGRectMake(touxiang.frame.size.width+touxiang.frame.origin.x+3, telphone.frame.size.height+telphone.frame.origin.y+10, 80, 20)];
    gongsi.text = @"所属公司:";
    gongsi.backgroundColor = [UIColor clearColor];
    [gongsi setTextColor:[UIColor grayColor]];
    [backGroundScrollview addSubview:gongsi];
    
    UILabel * gongsi2 = [[UILabel alloc] initWithFrame:CGRectMake(gongsi.frame.size.width+gongsi.frame.origin.x, telphone.frame.size.height+telphone.frame.origin.y+10, 170, 20)];
    gongsi2.text = @"郑州世行房地产";
    gongsi2.backgroundColor = [UIColor clearColor];
    [gongsi2 setTextColor:[UIColor blackColor]];
    [backGroundScrollview addSubview:gongsi2];
    
    //所属门店
    UILabel * mendian = [[UILabel alloc] initWithFrame:CGRectMake(touxiang.frame.size.width+touxiang.frame.origin.x+3, gongsi.frame.size.height+gongsi.frame.origin.y+10, 80, 20)];
    mendian.text = @"所属门店:";
    mendian.backgroundColor = [UIColor clearColor];
    [mendian setTextColor:[UIColor grayColor]];
    [backGroundScrollview addSubview:mendian];
    
    UILabel * mendian2 = [[UILabel alloc] initWithFrame:CGRectMake(mendian.frame.size.width+mendian.frame.origin.x, gongsi.frame.size.height+gongsi.frame.origin.y+10, 170, 20)];
    mendian2.text = @"中央店";
    mendian2.backgroundColor = [UIColor clearColor];
    [mendian2 setTextColor:[UIColor blackColor]];
    [backGroundScrollview addSubview:mendian2];
    
    //备注
    UILabel * beizhu = [[UILabel alloc] initWithFrame:CGRectMake(10, mendian2.frame.size.height+mendian2.frame.origin.y+10, 300, 20)];
    beizhu.text = @"房源信息由张作奎提供，详情请致电.";
    beizhu.backgroundColor = [UIColor clearColor];
    [beizhu setTextColor:[UIColor grayColor]];
    [backGroundScrollview addSubview:beizhu];

    
    backGroundScrollview.contentSize=  CGSizeMake(320, beizhu.frame.size.height+beizhu.frame.origin.y+70+60);

}


-(void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)handleSchedule
{
    pageControl.currentPage = pageControl.currentPage + 1;
    
    if(isEnd){
        
        [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
        
        pageControl.currentPage=0;
        
    }else{
        
        [scrollview setContentOffset:CGPointMake(pageControl.currentPage*scrollview.frame.size.width, 0) animated:YES];
        
    }
    
    if (pageControl.currentPage==pageControl.numberOfPages-1) {
        
        isEnd=YES;
        
    }else{
        
        isEnd=NO;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
