//
//  FirstPageHeaderView.m
//  Cartoon
//
//  Created by dllo on 15/10/29.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "FirstPageHeaderView.h"
#import "MoreBooksViewController.h"

@implementation FirstPageHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = [UIColor colorWithRed:135/255.0 green:213/255.0 blue:50/255.0 alpha:1];
        [self.contentView addSubview:self.titleLabel];
        
        self.moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.moreButton setTitle:@"更多 >" forState:normal];
        [self.moreButton setTintColor:[UIColor lightGrayColor]];
        self.moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.moreButton];
        
        self.upView = [[UIView alloc]init];
        self.upView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.upView];
        
        self.leftView = [[UIView alloc]init];
        self.leftView.backgroundColor = [UIColor colorWithRed:135/255.0 green:213/255.0 blue:27/255.0 alpha:1];
        [self.contentView addSubview:self.leftView];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(11, 0, self.contentView.bounds.size.width / 10 * 3 , self.contentView.bounds.size.height);
    
    self.moreButton.frame = CGRectMake(self.contentView.bounds.size.width-65, 0, self.contentView.bounds.size.width / 10 * 2, self.contentView.bounds.size.height);
    
    self.leftView.frame = CGRectMake(0, 6, 3 , self.contentView.bounds.size.height - 12);
    
    self.upView.frame = CGRectMake(0, -1, self.contentView.bounds.size.width, 1);
    
}


- (void)moreButtonAction:(UIButton *)but
{
    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
