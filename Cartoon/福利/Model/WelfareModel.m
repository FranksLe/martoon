//
//  WelfareModel.m
//  Cartoon
//
//  Created by dllo on 15/10/28.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "WelfareModel.h"

@implementation WelfareModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

    if ([key isEqualToString:@"user_info"] ) {
        self.name = [value objectForKey:@"name"];
        self.avatar = [value objectForKey:@"avatar"];
        
    }
    if ([key isEqualToString:@"img"]) {
        self.image = [value objectForKey:@"u"];
        self.width = [[value objectForKey:@"w"]floatValue];
        self.height = [[value objectForKey:@"h"]floatValue];
    }
}

@end
