//
//  MyCell.m
//  UI_豆瓣解析
//
//  Created by dllo on 15/9/12.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.scrollView = [[CustomScrollView alloc]init];
        self.scrollView.minimumZoomScale = 1;
        self.scrollView.maximumZoomScale = 2.f;
        self.scrollView.delegate = self;
        self.scrollView.bounces = NO;
        
        [self.contentView addSubview:_scrollView];
        
        
        self.bigPage = [[UILabel alloc]init];
        self.bigPage.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1];
        self.bigPage.textColor = [UIColor whiteColor];
        self.bigPage.textAlignment = NSTextAlignmentCenter;
        self.bigPage.font = [UIFont boldSystemFontOfSize:30];
        self.bigPage.layer.cornerRadius = 50;
        self.bigPage.layer.masksToBounds = YES;
        self.bigPage.userInteractionEnabled = YES;
        [self.scrollView addSubview:_bigPage];
        
        self.myImageView = [[UIImageView alloc]init];
        self.myImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:_myImageView];
        
        
        
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    self.scrollView.frame = CGRectMake(0, 0, layoutAttributes.size.width, layoutAttributes.size.height);
    self.myImageView.frame = CGRectMake(0, 0, layoutAttributes.size.width, layoutAttributes.size.height);
    self.bigPage.frame = CGRectMake(self.contentView.bounds.size.width/2-50, self.contentView.bounds.size.height/2-50, 100, 100);

}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView){
        // 只有小scrollView才允许缩放
        //return [scrollView.subviews objectAtIndex:1];
        return _myImageView;
    }else{
        return nil;
    }
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    //当捏或移动时，需要对center重新定义以达到正确显示未知
    CGFloat xcenter = scrollView.center.x,ycenter = scrollView.center.y;
    NSLog(@"adjust position,x:%f,y:%f",xcenter,ycenter);
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width?scrollView.contentSize.width/2 :xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : ycenter;
    [_myImageView setCenter:CGPointMake(xcenter, ycenter)];
    [_bigPage setCenter:CGPointMake(xcenter, ycenter)];
}
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale
//{
//    NSLog(@"%f",self.myImageView.frame.size.width);
//    NSLog(@"%f",self.myImageView.frame.size.height);
//    self.scrollView.contentSize = CGSizeMake(self.myImageView.frame.size.width, self.myImageView.frame.size.height);
//    //self.scrollView.zoomScale = 1.0;
//    //    NSLog(@"结束缩放 - %f", scale);
//}
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView
//{
//    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
//    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
//    
//    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
//    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
//    _myImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
//                            scrollView.contentSize.height * 0.5 + offsetY);
//}


@end
