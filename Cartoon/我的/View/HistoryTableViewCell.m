//
//  HistoryTableViewCell.m
//  Cartoon
//
//  Created by dllo on 15/11/4.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // 漫画标题
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:self.titleLabel];
        
        // 已经看到第几话
        self.didWatchLabel = [[UILabel alloc]init];
        self.didWatchLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.didWatchLabel];
        
        // 左侧漫画图片
        self.leftPic = [[UIImageView alloc]init];
        
        self.leftPic.layer.cornerRadius = 10;
        self.leftPic.layer.masksToBounds = YES;
        [self.contentView addSubview:self.leftPic];
        
        // 继续观看按钮
        self.goOnButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.goOnButton setTitle:@"继续观看" forState:normal];
        [self.goOnButton setTitleColor:[UIColor whiteColor] forState:normal];
        self.goOnButton.titleLabel.font = [UIFont systemFontOfSize: 18];
        self.goOnButton.layer.cornerRadius = 4;
        self.goOnButton.backgroundColor = [UIColor colorWithRed:288/255.0 green:85/255.0 blue:33/255.0 alpha:1];
        [self.contentView addSubview:self.goOnButton];

        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.leftPic.frame = CGRectMake(5, 10, self.contentView.bounds.size.width /10*3, self.contentView.bounds.size.height - 20);
    
    self.titleLabel.frame = CGRectMake(self.contentView.bounds.size.width / 10*3 + 5 + 10, 15, 240, 30);
    
    self.didWatchLabel.frame = CGRectMake(self.contentView.bounds.size.width / 10*3 + 5 + 54, 55, 240, 30);
    
    self.goOnButton.frame = CGRectMake(self.contentView.bounds.size.width / 3 *2, self.contentView.bounds.size.height-45, 80, 30);
    
    
}






- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
