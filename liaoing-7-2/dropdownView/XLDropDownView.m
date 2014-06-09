//
//  XLDropDownView.m
//  martTour
//
//  Created by lty on 14-5-20.
//  Copyright (c) 2014年 东南助力. All rights reserved.
//

#import "XLDropDownView.h"

#define SELECTED_BACKGROUND_COLOR ColorWithHexValue(0xe7e7e7, 1)
#define NORMAL_BACKGROUND_COLOR ColorWithHexValue(0xf7f7f7, 1)
#define BUTTON_SELECTED_COLOR ColorWithHexValue(0x4fc2d4, 1)
#define BUTTON_NORMAL_COLOR [UIColor blackColor]
#define TEXT_COLOR ColorWithHexValue(0x696969, 1)
#define CELL_HEIGHT 60.0f
#define TITLE_BTN_HEIGHT 40.0f
#define PARTINGLINE_TAG 456
//下拉菜单

#define WindowWidth             ( [UIScreen mainScreen].applicationFrame.size.width )
//应用程序窗口高度
#define WindowHeight            ( [UIScreen mainScreen].applicationFrame.size.height )
#define TITLE_BAR_HEIGHT 40.0f
#import "menuViewController.h"

#define ColorWithHexValue(hexValue, a) [UIColor colorWithRed:((hexValue >> 16) & 0x000000FF)/255.0f \
green:((hexValue >> 8) & 0x000000FF)/255.0f \
blue:((hexValue) & 0x000000FF)/255.0f \
alpha:a]

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@interface XLDropDownView ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_contentTable;
    
    NSInteger currentButtonSelectedIndex;
    
    UIImageView *_bottomImageView;
    
    CGRect spreadRect;
    
    UIView *_mask;
    
    UIView *_indicator;
}

@property (nonatomic, strong)NSArray *showTitles;
@property (nonatomic, strong)NSMutableArray *stateArr;
@property (nonatomic, strong)NSMutableArray *btns;

// 黑色背景遮盖
- (void)initMask;

// 初始化选择框
- (void)initTable;

// 初始化选择框底部图片
- (void)initBottomImage;

//  收起
- (void)packup;

// 展开
- (void)spread;

@end


@implementation XLDropDownView

- (id)initWithTitles:(NSArray *)titles
{
    self = [super init];
    
    if (self)
    {
        // 模拟数据
        self.showTitles = titles;
        self.contents = @[@[@"五星酒店", @"四星酒店", @"三星酒店", @"其他"], @[@"鼓楼区", @"台江区", @"仓山区", @"晋安区", @"马尾区"], @[@"热度从高到低", @"热度从低到高", @"评价从高到低", @"评价从低到高", @"价格从高到低", @"价格从低到高"], @[@"xxxx", @"yyyyy", @"仓山区", @"晋安区"]];
        [self setUserInteractionEnabled:YES];
        self.clipsToBounds = YES;
        self.btns = [[NSMutableArray alloc] init];
        
        
        [self setFrame:CGRectMake(0, 0, WindowWidth, TITLE_BTN_HEIGHT)];
        [self setBackgroundColor:[UIColor clearColor]];
        
        spreadRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, CGRectGetWidth(self.frame), WindowHeight - TITLE_BTN_HEIGHT);
        self.stateArr = [[NSMutableArray alloc] initWithArray:@[@"-1", @"-1", @"-1", @"-1"]];
        
        NSInteger titleCount = [titles count];
        
        CGFloat width = WindowWidth/titleCount;
        for (int index = 0; index < titleCount; index++)
        {
            UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [topBtn setFrame:CGRectMake(index * width, 0, width, TITLE_BTN_HEIGHT)];
            
            NSString *title = titles[index];
            topBtn.tag = 1000 + index;
            [topBtn addTarget:self action:@selector(topBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            [topBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [topBtn setTitle:title forState:UIControlStateNormal];
            [topBtn setTitleColor:BUTTON_NORMAL_COLOR forState:UIControlStateNormal];
            [topBtn setImage:[UIImage imageNamed:@"arrow_down_normal.png"] forState:UIControlStateNormal];
            [topBtn setImage:[UIImage imageNamed:@"arrow_down_selected.png"] forState:UIControlStateHighlighted];
            [self addSubview:topBtn];
            [topBtn setBackgroundColor:NORMAL_BACKGROUND_COLOR];
            [topBtn setImageEdgeInsets:UIEdgeInsetsMake(16, width - 15 - 2, 16, 2)];
            [topBtn setTitleEdgeInsets:UIEdgeInsetsMake(20, -10, 20, 17)];
            [self.btns addObject:topBtn];
        }
        
        [self initTable];
        [self initMask];
        [self initBottomImage];
        
        NSInteger lineCount = titleCount - 1;
        for (int index = 1; index <= lineCount; index++)
        {
            UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_detail_line.png"]];
            [line setBounds:CGRectMake(0, 0, 1, 24)];
            [line setCenter:CGPointMake(width * index, TITLE_BTN_HEIGHT/2)];
            [self addSubview:line];
            [self bringSubviewToFront:line];
        }
        
        UIView *btnBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, TITLE_BTN_HEIGHT - 1, CGRectGetWidth(self.frame), 1)];
        [btnBottomLine setBackgroundColor:ColorWithHexValue(0xb8b8b8, 1)];
        [self addSubview:btnBottomLine];
        [self bringSubviewToFront:btnBottomLine];
        
        UIView *indicator = [[UIView alloc] initWithFrame:CGRectMake(0, TITLE_BTN_HEIGHT - 1, width - 4, 1)];
        [indicator setBackgroundColor:ColorWithHexValue(0x49c0d6, 1)];
        [indicator setCenter:CGPointMake(width/2, TITLE_BTN_HEIGHT - 0.5)];
        [indicator setHidden:YES];
        _indicator = indicator;
        [self addSubview:indicator];
        [self bringSubviewToFront:indicator];
    }
    
    return self;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectedCell" forIndexPath:indexPath];
    
    NSArray *arr = [_contents objectAtIndex:currentButtonSelectedIndex];
    
    NSString *content = [arr objectAtIndex:indexPath.row];
    
    cell.textLabel.text = content;
    cell.textLabel.textColor = TEXT_COLOR;
    cell.backgroundColor = [UIColor clearColor];
    
    if ([cell viewWithTag:PARTINGLINE_TAG])
    {
        [[cell viewWithTag:PARTINGLINE_TAG] removeFromSuperview];
    }
    
    UIImageView *partingLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(cell.frame), CGRectGetWidth(cell.frame), 1.0f)];
    partingLine.tag = PARTINGLINE_TAG;
    [partingLine setImage:[UIImage imageNamed:@"partingLine.png"]];
    [cell addSubview:partingLine];
    
    NSInteger state = [[self.stateArr objectAtIndex:currentButtonSelectedIndex] integerValue];
    if (state == indexPath.row)
    {
        [cell setBackgroundColor:SELECTED_BACKGROUND_COLOR];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *listContent = [_contents objectAtIndex:currentButtonSelectedIndex];
    return [listContent count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger deselectedIndex = [[self.stateArr objectAtIndex:currentButtonSelectedIndex] integerValue];
    
    UITableViewCell *deselectedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:deselectedIndex inSection:0]];
    [deselectedCell setBackgroundColor:[UIColor clearColor]];
    
    NSString *stateString = [NSString stringWithFormat:@"%d", indexPath.row];
    [self.stateArr replaceObjectAtIndex:currentButtonSelectedIndex withObject:stateString];
    
    
    NSArray *arr = [_contents objectAtIndex:currentButtonSelectedIndex];
    NSString *string = [arr objectAtIndex:indexPath.row];
    UIButton *button = (UIButton *)[self viewWithTag:(1000 + currentButtonSelectedIndex)];
    [button setTitle:string forState:UIControlStateNormal];
    
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    [selectedCell setBackgroundColor:SELECTED_BACKGROUND_COLOR];
    [self packup];
    
    if ([self.delegate respondsToSelector:@selector(drowDownView:didSelectedItemAtIndex:subIndex:)])
    {
        [self.delegate drowDownView:self didSelectedItemAtIndex:currentButtonSelectedIndex subIndex:indexPath.row];
    }
}


- (void)initTable
{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, TITLE_BTN_HEIGHT, CGRectGetWidth(self.frame), 280)];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"selectedCell"];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = NORMAL_BACKGROUND_COLOR;
    _contentTable = table;
    [table setUserInteractionEnabled:YES];
    [self addSubview:table];
}

- (void)initMask
{
    UIView *mask = [[UIView alloc] initWithFrame:CGRectMake(0, TITLE_BTN_HEIGHT + CGRectGetHeight(_contentTable.frame), CGRectGetWidth(self.frame), WindowHeight - TITLE_BAR_HEIGHT - TITLE_BTN_HEIGHT - CGRectGetHeight(_contentTable.frame))];
    [mask setBackgroundColor:RGBA(0, 0, 0, 0.4)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(packup)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [mask addGestureRecognizer:tap];
    [self addSubview:mask];
    _mask = mask;
}

- (void)initBottomImage
{
    UIImage *bottomImage = [UIImage imageNamed:@"dropdowmMenu_bottom.png"];
    UIImageView *bottomImageView = [[UIImageView alloc] init];
    [bottomImageView setImage:bottomImage];
    [bottomImageView setFrame:CGRectMake(0, TITLE_BTN_HEIGHT + CGRectGetHeight(_contentTable.frame), bottomImage.size.width, bottomImage.size.height)];
    [self addSubview:bottomImageView];
}

- (void)packup
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4f];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, CGRectGetWidth(self.frame), TITLE_BTN_HEIGHT)];
    [UIView commitAnimations];
    
    [_indicator setHidden:YES];
    
    
    // 收起的时候 修改箭头方向
    for (UIButton *topBtn in self.btns)
    {
        [topBtn setImage:[UIImage imageNamed:@"arrow_down_normal.png"] forState:UIControlStateNormal];
        [topBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
}

- (void)spread
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4f];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, CGRectGetWidth(self.frame), WindowHeight - TITLE_BAR_HEIGHT)];
    [UIView commitAnimations];
}

- (void)topBtnPress:(id)sender
{
    // 改变箭头的图标
    UIButton *btn = (UIButton *)sender;
    [btn setTitleColor:ColorWithHexValue(0x49c0d6, 1) forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"arrow_down_selected.png"] forState:UIControlStateNormal];
    for (UIButton *topBtn in self.btns)
    {
        if (![topBtn isEqual:btn])
        {
            [topBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [topBtn setImage:[UIImage imageNamed:@"arrow_down_normal.png"] forState:UIControlStateNormal];
        }
    }
    
    
    
    currentButtonSelectedIndex = btn.tag % 10;
    
    if (!CGRectEqualToRect(self.frame , spreadRect))
    {
        [self spread];
    }
    
    [_contentTable reloadData];
    
    // 重置指示器
    [self resetIndicator];
}

- (void)tap:(id) sender
{
    
}

- (void)resetIndicator
{
    NSInteger titleCount = [_showTitles count];
    CGFloat width = WindowWidth/titleCount;
    
    if (_indicator.hidden)
    {
        _indicator.hidden = NO;
        [_indicator setCenter:CGPointMake(width * currentButtonSelectedIndex + width/2, TITLE_BTN_HEIGHT - 0.5)];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.2f];
        [_indicator setCenter:CGPointMake(width * currentButtonSelectedIndex + width/2, TITLE_BTN_HEIGHT - 0.5)];
        [UIView commitAnimations];
    }
}

@end
