//
//  HistoryCollectionViewCell.m
//  Cartoon
//
//  Created by dllo on 15/11/3.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "HistoryCollectionViewCell.h"

@implementation HistoryCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
    if (self) {
        self.recordLabel = [[UILabel alloc]init];
        self.recordLabel.textAlignment = NSTextAlignmentCenter;
        self.recordLabel.layer.cornerRadius = 5;
        self.recordLabel.layer.masksToBounds = YES;
        self.recordLabel.layer.borderWidth = 1;
        self.recordLabel.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        self.recordLabel.font = [UIFont systemFontOfSize:15];
        self.recordLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_recordLabel];
        
    }
    return self;
}
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    self.recordLabel.frame = CGRectMake(0, 0, layoutAttributes.size.width, layoutAttributes.size.height);
}

@end
