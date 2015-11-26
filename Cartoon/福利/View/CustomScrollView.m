//
//  CustomScrollView.m
//  Cartoon
//
//  Created by dllo on 15/11/2.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "CustomScrollView.h"

@implementation CustomScrollView


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //  获取点击点的坐标
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    NSLog(@" x = %f ,y =%f",touchPoint.x,touchPoint.y);
    int stringFloat = (int)(touchPoint.x);
    int stringFloat1 = (int)(touchPoint.y);
    NSLog(@"%i%i",stringFloat,stringFloat1);
    //touchPoint.x ，touchPoint.y 就是触点的坐标。
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
