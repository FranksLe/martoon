//
//  LunBoCollectionViewCell.m
//  Cartoon
//
//  Created by dllo on 15/10/31.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "LunBoCollectionViewCell.h"

@implementation LunBoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.picImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_picImageView];
        
        self.underTextView = [[UIView alloc]init];
        self.underTextView.backgroundColor = [UIColor blackColor];
        self.underTextView.alpha = 0.6;
        [self.contentView addSubview:_underTextView];
        
        self.underTextLabel = [[UILabel alloc]init];
        self.underTextLabel.textColor = [UIColor whiteColor];
        self.underTextLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_underTextLabel];
        
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    self.picImageView.frame = CGRectMake(0, 0, layoutAttributes.size.width, layoutAttributes.size.height);
    
    self.underTextLabel.frame = CGRectMake(0, layoutAttributes.size.height / 7 * 6, layoutAttributes.size.width, layoutAttributes.size.height / 7);
    
    self.underTextView.frame = CGRectMake(0, layoutAttributes.size.height / 7 * 6, layoutAttributes.size.width, layoutAttributes.size.height / 7);
    
}

@end
