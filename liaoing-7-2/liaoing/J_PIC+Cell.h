//
//  J_PIC+Cell.h
//  liaoing
//
//  Created by laoniu on 14-6-2.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCTopic.h"


@interface J_PIC_Cell : UITableViewCell<JCTopicDelegate>
@property (nonatomic,strong) JCTopic * Topic;

@end
