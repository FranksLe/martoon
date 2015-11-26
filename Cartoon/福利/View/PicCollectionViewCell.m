//
//  PicCollectionViewCell.m
//  Cartoon
//
//  Created by dllo on 15/10/29.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//
#define Width self.contentView.bounds.size.width
#define Height self.contentView.bounds.size.height
#import "PicCollectionViewCell.h"

@implementation PicCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.picImageView = [[UIImageView alloc]init];
        self.picImageView.backgroundColor = [UIColor colorWithRed:235/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        self.picImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_picImageView];
        
        self.photoImageView = [[UIImageView alloc]init];
        _photoImageView.layer.masksToBounds = YES;
        _photoImageView.layer.cornerRadius = 15;
        [self.contentView addSubview:_photoImageView];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_nameLabel];
        
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.font = [UIFont systemFontOfSize:12];
        self.contentLabel.numberOfLines = 0;
        [self.contentLabel sizeToFit];
        [self.contentView addSubview:_contentLabel];
        
        self.reportButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_reportButton setBackgroundImage:[UIImage imageNamed:@"jubao.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_reportButton];
        
        self.lineImageView = [[UIImageView alloc]init];
        self.lineImageView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        [self.contentView addSubview:_lineImageView];
        
        self.stateLabel = [[UILabel alloc]init];
        self.stateLabel.textColor = [UIColor whiteColor];
        self.stateLabel.font = [UIFont systemFontOfSize:11];
        self.stateLabel.textAlignment = NSTextAlignmentCenter;
        self.stateLabel.layer.cornerRadius = 4;
        self.stateLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_stateLabel];
        
        self.likeImageView = [[UIImageView alloc]init];
        self.likeImageView.image = [UIImage imageNamed:@"iconfont-zan.png"];
        [self.contentView addSubview:_likeImageView];
        
        self.likeCountLabel = [[UILabel alloc]init];
        self.likeCountLabel.textAlignment = NSTextAlignmentCenter;
        self.likeCountLabel.font = [UIFont systemFontOfSize:11];
        self.likeCountLabel.numberOfLines = 0;
        [self.likeCountLabel sizeToFit];
        [self.contentView addSubview:_likeCountLabel];
        
    }
    return self;
}
- (void)setResult:(CGFloat)result
{
    if (_result!=result) {
        _result = result;
       
    }
    NSLog(@"%f",result);
//        self.picImageView.frame = CGRectMake(0, 0, Width, Width*self.result);
//        self.photoImageView.frame = CGRectMake(5, Width*self.result+5, 30, 30);
//        self.nameLabel.frame = CGRectMake(45, Width*self.result+5, Width-55, 20);
//        self.contentLabel.frame = CGRectMake(5, Width*self.result+40, Width-10, 30);
//        self.reportButton.frame = CGRectMake(Width-40, Width*self.result+15, 30, 25);
//        self.lineImageView.frame = CGRectMake(10, Height- 30, Width-20, 1);
//        self.stateLabel.frame = CGRectMake(10, Height-25, 40, 20);
//        self.likeCountLabel.frame = CGRectMake(Width-35 , Height-25, 25 , 20);
//        self.likeImageView.frame = CGRectMake(Width-self.likeCountLabel.frame.size.width-30, Height-25, 20, 20);
    
    
}

//- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
//{
//
//  
////    self.picImageView.frame = CGRectMake(0, 0, layoutAttributes.size.width, layoutAttributes.size.width*self.height/self.width);
//    
//    self.photoImageView.frame = CGRectMake(5, layoutAttributes.size.height*3/4+10, 40, 40);
//    self.nameLabel.frame = CGRectMake(55, layoutAttributes.size.height*3/4+10, layoutAttributes.size.width-55, 20);
//    self.contentLabel.frame = CGRectMake(5, layoutAttributes.size.height*3/4+50, self.contentView.bounds.size.width-10, 30);
//
//}

@end
