//
//  NetHandler.h
//  Gift
//
//  Created by dllo on 15/9/16.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetHandler : NSObject

+ (void)dataWithUrl:(NSString *)str complant:(void (^)(NSData *data))block;

// 清除缓存
+ (BOOL)deleteCaches;
@end
