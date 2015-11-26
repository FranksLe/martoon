//
//  CollectCollectionViewCell.m
//  Cartoon
//
//  Created by dllo on 15/11/5.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "CollectCollectionViewCell.h"

@implementation CollectCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titlePic = [[UIImageView alloc]init];
        [self.contentView addSubview:self.titlePic];
        self.titlePic.backgroundColor = [UIColor lightGrayColor];
        self.titlePic.clipsToBounds = YES;
        self.titlePic.layer.cornerRadius = 5;
        self.titlePic.layer.borderWidth = 1;
        self.titlePic.layer.borderColor = [[UIColor blackColor]CGColor];
        
        self.backImage = [[UIImageView alloc]init];
        self.backImage.image = [UIImage imageNamed:@"underBackPic.png"];
        self.backImage.clipsToBounds = YES;
        self.backImage.layer.cornerRadius = 5;
        [self.contentView addSubview:self.backImage];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.alpha = 1;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.clipsToBounds = YES;
        self.titleLabel.layer.cornerRadius = 5;
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.rightButton.layer.cornerRadius = 10;
        [self.rightButton setBackgroundImage:[UIImage imageNamed:@"youshang.png"] forState:normal];
        [self.contentView addSubview:self.rightButton];
        self.rightButton.alpha = 0;
        
        NSNotificationCenter *layout = [NSNotificationCenter defaultCenter];
        [layout addObserver:self selector:@selector(layoutbutton:) name:@"layout" object:nil];
        
        NSNotificationCenter *layoutMiss = [NSNotificationCenter defaultCenter];
        [layoutMiss addObserver:self selector:@selector(layoutMissbutton:) name:@"layoutMiss" object:nil];

        
    }
    
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    
    self.titlePic.frame = CGRectMake(0, 10, self.contentView.bounds.size.width, self.contentView.bounds.size.height-10);
    
    self.titleLabel.frame = CGRectMake(0, self.contentView.bounds.size.height / 5 * 4 , self.contentView.bounds.size.width, self.contentView.bounds.size.height / 5);
    
    self.backImage.frame = CGRectMake(0, self.contentView.bounds.size.height / 5 * 3 + 10, self.contentView.bounds.size.width, self.contentView.bounds.size.height / 5 * 2 - 10);
    
    self.rightButton.frame = CGRectMake(self.contentView.bounds.size.width - 10, 0, 20, 20);
    
}

- (void)layoutMissbutton:(NSNotification *)noti
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.rightButton.alpha = 0;
    }];
    CATransition *ani4 = [CATransition animation];
    ani4.duration = 1.2;
    ani4.type = @"rippleEffect";
    
    [self.rightButton.layer addAnimation:ani4 forKey:nil];

    
}

- (void)layoutbutton:(NSNotification *)noti
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.rightButton.alpha = 1;
    }];
    CATransition *ani4 = [CATransition animation];
    ani4.duration = 1.2;
    ani4.type = @"rippleEffect";
    
    [self.rightButton.layer addAnimation:ani4 forKey:nil];

    
}

@end
