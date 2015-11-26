//
//  AnimationCollectionViewCell.m
//  Cartoon
//
//  Created by dllo on 15/10/29.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "AnimationCollectionViewCell.h"

@implementation AnimationCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        

        
        self.numberLabel = [[UILabel alloc]init];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.font = [UIFont systemFontOfSize:14];
        self.numberLabel.layer.cornerRadius = 5;
        //self.titleLabel.layer.masksToBounds = YES;
        self.numberLabel.layer.borderWidth = 0.7;
        self.numberLabel.layer.borderColor = [[UIColor colorWithRed:149/255.0 green:198/255.0 blue:64/255.0 alpha:1]CGColor];
        self.numberLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.numberLabel];
        
        
    }
    
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    
    self.numberLabel.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
}





@end
