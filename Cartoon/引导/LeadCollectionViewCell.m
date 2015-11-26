//
//  LeadCollectionViewCell.m
//  Cartoon
//
//  Created by dllo on 15/11/5.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "LeadCollectionViewCell.h"

@implementation LeadCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.myImage = [[UIImageView alloc]init];
        [self.contentView addSubview:_myImage];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    self.myImage.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
}

@end
