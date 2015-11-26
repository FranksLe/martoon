//
//  DetailsTableViewCell.m
//  Cartoon
//
//  Created by dllo on 15/10/29.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "DetailsTableViewCell.h"

@implementation DetailsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.ImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.ImageView];
        self.myImageView = [[UIImageView alloc]init];
        [self.ImageView addSubview:self.myImageView];
        
        self.nameLabel = [[UILabel alloc]init];
        [self.ImageView addSubview:self.nameLabel];
        
        self.authorLabel = [[UILabel alloc]init];
        [self.ImageView addSubview:self.authorLabel];
        
        self.categoryLabel = [[UILabel alloc]init];
        [self.ImageView addSubview:self.categoryLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        [self.ImageView addSubview:self.timeLabel];
        
        self.volumeLabel = [[UILabel alloc]init];
        [self.ImageView addSubview:self.volumeLabel];
        
        self.gradeLabel = [[UILabel alloc]init];
        [self.ImageView addSubview:self.gradeLabel];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.ImageView.frame = CGRectMake(5, 5, 360, 140);
    self.ImageView.layer.cornerRadius = 10;
    
    self.myImageView.frame = CGRectMake(1, 0, 100, 140);
    self.myImageView.layer.cornerRadius = 10;
    self.myImageView.layer.masksToBounds = YES;
    
    self.nameLabel.frame = CGRectMake(110, 10, 250, 30);
    
    self.authorLabel.frame = CGRectMake(110, 30, 250, 30)
    ;
    self.categoryLabel.frame = CGRectMake(110, 50, 250, 30);
    
    self.timeLabel.frame = CGRectMake(110, 70, 250, 30);
    
    self.volumeLabel.frame = CGRectMake(110, 90, 250, 30);
    
    self.gradeLabel.frame = CGRectMake(110, 110, 250, 30);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
