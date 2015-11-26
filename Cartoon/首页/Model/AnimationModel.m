//
//  AnimationModel.m
//  Cartoon
//
//  Created by dllo on 15/10/29.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "AnimationModel.h"

@implementation AnimationModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.cartoonId = value;
    }
    if ([key isEqualToString:@"cid"]) {
        self.cartoonId = value;
    }
    if ([key isEqualToString:@"btn_str"]) {
        self.name = value;
    }
    
}
@end
