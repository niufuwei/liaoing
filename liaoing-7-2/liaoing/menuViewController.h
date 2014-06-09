//
//  menuViewController.h
//  liaoing
//
//  Created by liaoing on 14-5-26.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLDropDownView.h"
@protocol menuprotorl <NSObject>
- (void)drowDown:(XLDropDownView *)view didSelectedItemAtIndex:(NSInteger) index subIndex:(NSInteger)subIndex;

@end
@interface menuViewController : UIView<XLDropDownViewDelegate>
@property (nonatomic, assign)id <menuprotorl> menudelegate;
@end
