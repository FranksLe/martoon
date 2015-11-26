//
//  CartoonModel.m
//  Cartoon
//
//  Created by dllo on 15/10/31.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "CartoonModel.h"

@implementation CartoonModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"source"]) {
        self.cartoonImage = [NSString stringWithFormat:@"http://%@",value];
    }
    if ([key isEqualToString:@"current_img_url"]) {
        self.cartoonImage = value;
    }
    

    
}

@end
