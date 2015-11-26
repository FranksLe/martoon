//
//  PicCollectionViewCell.h
//  Cartoon
//
//  Created by dllo on 15/10/29.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UIButton *reportButton;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *likeCountLabel;
@property (nonatomic, assign) CGFloat result;


@end
