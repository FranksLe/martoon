//
//  PicObject.m
//  Cartoon
//
//  Created by dllo on 15/10/30.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "PicObject.h"

@implementation PicObject
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"theme_info"]) {
        
        self.cover = [value objectForKey:@"cover"];
        
    }
    
    if ([key isEqualToString:@"theme_info"]) {
        
        self.url = [value objectForKey:@"url"];
        
    }
    
}
@end
