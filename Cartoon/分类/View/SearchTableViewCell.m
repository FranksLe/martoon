//
//  SearchTableViewCell.m
//  Cartoon
//
//  Created by dllo on 15/10/30.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.myImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.myImageView];
        
        self.nameLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.nameLabel];
        
        self.authorLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.authorLabel];

        self.volumeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.volumeLabel];
        
       
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.nameLabel.frame = CGRectMake(110, 10, 250, 30);
    
    self.authorLabel.frame = CGRectMake(110, 50, 250, 30);
    
    self.volumeLabel.frame = CGRectMake(110, 90, 250, 30);
    
    self.myImageView.frame = CGRectMake(5, 5, 100, 140);
    self.myImageView.layer.cornerRadius = 10;
    self.myImageView.layer.masksToBounds = YES;
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
