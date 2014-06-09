//
//  define.h
//  liaoing
//
//  Created by laoniu on 14-5-27.
//  Copyright (c) 2014年 haonan.wang. All rights reserved.
//

#ifndef liaoing_define_h
#define liaoing_define_h

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#endif
