//
//  menuViewController.m
//  liaoing
//
//  Created by liaoing on 14-5-26.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import "menuViewController.h"

@interface menuViewController (){
    
    NSMutableDictionary *array;
    
}

@end

@implementation menuViewController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    XLDropDownView *dropDownView = [[XLDropDownView alloc] initWithTitles:@[@"区域", @"房屋类型", @"评价",@"排序"]];
    dropDownView.delegate = self;
    [self addSubview:dropDownView];
    
    return self;
}

- (void)drowDownView:(XLDropDownView *)view didSelectedItemAtIndex:(NSInteger)index subIndex:(NSInteger)subIndex
{
//    NSLog(@"index === %d, subIndex ===== %d", index,subIndex);
//    switch (index) {
//        case 0:
//        {
//            switch (subIndex) {
//                case 0:
//                    NSLog(@"array ===== %@",array);
//                    [array setObject:@"1111" forKey:@"ida"];
//                    NSLog(@"%@",[array objectForKey: @"ida"]);
//                    
//                    break;
//                    
//                default:
//                    break;
//            }
//        }
//            break;
//            
//        default:
//            break;
//    }
    
    [_menudelegate drowDown:view didSelectedItemAtIndex:index subIndex:subIndex];
}


@end
