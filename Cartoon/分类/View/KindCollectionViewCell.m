//
//  KindCollectionViewCell.m
//  Cartoon
//
//  Created by dllo on 15/10/28.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "KindCollectionViewCell.h"
#import "PrefixHeader.pch"
@implementation KindCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] init];
//        self.imageView.layer.cornerRadius = self.contentView.bounds.size.width/2;
//        self.imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageView];
        
        self.label = [[UILabel alloc]init];
        [self.contentView addSubview:self.label];
        self.label.textAlignment = NSTextAlignmentCenter;

        
        
    }
    return self;
}
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    self.imageView.frame = CGRectMake(0, 5 + 20, layoutAttributes.size.width, layoutAttributes.size.width);
    self.label.frame = CGRectMake(0, layoutAttributes.size.width+30, layoutAttributes.size.width, 30);
}


@end
