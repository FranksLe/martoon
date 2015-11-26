//
//  TotalDetailsCollectionViewCell.m
//  Cartoon
//
//  Created by dllo on 15/10/31.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "TotalDetailsCollectionViewCell.h"

@implementation TotalDetailsCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {       
        

        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.layer.cornerRadius = 5;
        //self.titleLabel.layer.masksToBounds = YES;
        self.titleLabel.layer.borderWidth = 0.7;
        self.titleLabel.layer.borderColor = [[UIColor colorWithRed:149/255.0 green:198/255.0 blue:64/255.0 alpha:1]CGColor];
        self.titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titleLabel];
        
    }
    
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{

    
    self.titleLabel.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
}

@end
