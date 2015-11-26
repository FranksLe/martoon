//
//  MyMainTableViewCell.m
//  Cartoon
//
//  Created by dllo on 15/11/3.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "MyMainTableViewCell.h"

@implementation MyMainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.myLabel = [[UILabel alloc]init];
        self.myLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.myLabel];
        
        self.rightLabel = [[UILabel alloc]init];
        self.rightLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.rightLabel];
        
        self.leftImage = [[UIImageView alloc]init];
        [self.contentView addSubview:self.leftImage];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.leftImage.frame =  CGRectMake(5, 10, 20, 20);
    
    self.myLabel.frame = CGRectMake(30, 0, self.contentView.bounds.size.width / 10 * 3 , self.contentView.bounds.size.height);
    
    self.rightLabel.frame = CGRectMake(self.contentView.bounds.size.width-15, 0, self.contentView.bounds.size.width / 10 * 1 - 10, self.contentView.bounds.size.height);
}






- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
