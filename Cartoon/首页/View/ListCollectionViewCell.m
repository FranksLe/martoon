//
//  ListCollectionViewCell.m
//  Cartoon
//
//  Created by dllo on 15/11/3.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "ListCollectionViewCell.h"

@implementation ListCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.backgroundColor = [UIColor blackColor];
        self.nameLabel.layer.borderWidth =1;
        self.nameLabel.layer.borderColor = [[UIColor whiteColor]CGColor];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.nameLabel];
        
        
    }
    
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    
    self.nameLabel.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
}

@end
