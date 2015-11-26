//
//  FirstPageCollectionViewCell.m
//  Cartoon
//
//  Created by dllo on 15/10/28.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "FirstPageCollectionViewCell.h"
#import "FirstPageModel.h"

@implementation FirstPageCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.titlePic = [[UIImageView alloc]init];
        [self.contentView addSubview:self.titlePic];
        self.titlePic.layer.borderWidth = 1.5;
        self.titlePic.layer.borderColor = [[UIColor blackColor]CGColor];
        
        self.backImage = [[UIImageView alloc]init];
        self.backImage.layer.masksToBounds = YES;
        self.backImage.image = [UIImage imageNamed:@"underBackPic.png"];
        [self.contentView addSubview:self.backImage];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        
    }
    
    return self;
}


- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    
    
    self.titlePic.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    
    self.titleLabel.frame = CGRectMake(0, self.contentView.bounds.size.height / 5 * 4 + 2, self.contentView.bounds.size.width, self.contentView.bounds.size.height / 5);
    
    self.backImage.frame = CGRectMake(0, self.contentView.bounds.size.height / 5 * 3, self.contentView.bounds.size.width, self.contentView.bounds.size.height / 5 * 2);
    
}




@end
