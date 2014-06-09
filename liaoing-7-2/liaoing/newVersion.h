//
//  newVersion.h
//  KBwap
//
//  Created by niufuwei on 14-1-16.
//  Copyright (c) 2014年 niufuwei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^callback)(NSString*);
@interface newVersion : NSObject<UITextFieldDelegate>
@property (nonatomic,strong) callback callBack;

-(void)begin:(NSString * )urlStr boolBegin:(BOOL)NoVersion mycallback:(void(^)(NSString*))mycallback;
@end
