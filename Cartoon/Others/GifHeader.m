//
//  GifHeader.m
//  Gift
//
//  Created by dllo on 15/9/17.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import "GifHeader.h"

@implementation GifHeader

- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];

        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_lu_jump0.png"]];
        [idleImages addObject:image];

    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *pullImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_lu_f%ld.png", i]];
        [pullImages addObject:image];
    }
    [self setImages:pullImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片

    [self setImages:pullImages forState:MJRefreshStateRefreshing];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
