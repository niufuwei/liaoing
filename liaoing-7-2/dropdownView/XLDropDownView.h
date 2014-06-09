//
//  XLDropDownView.h
//  martTour
//
//  Created by lty on 14-5-20.
//  Copyright (c) 2014年 东南助力. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLDropDownView;

@protocol XLDropDownViewDelegate <NSObject>

- (void)drowDownView:(XLDropDownView *)view didSelectedItemAtIndex:(NSInteger) index subIndex:(NSInteger)subIndex;

@end

@interface XLDropDownView : UIView

@property (nonatomic, strong)NSArray *contents;
@property (nonatomic, assign)id <XLDropDownViewDelegate> delegate;

- (id)initWithTitles:(NSArray *)titles;

@end
