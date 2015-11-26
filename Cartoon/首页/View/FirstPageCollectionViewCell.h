//
//  FirstPageCollectionViewCell.h
//  Cartoon
//
//  Created by dllo on 15/10/28.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstPageCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) NSMutableArray *allBooksArray;

@property (nonatomic,strong) NSMutableArray *allTitleArray;

@property (nonatomic,strong ) UIImageView *titlePic;

@property (nonatomic,strong ) UILabel *titleLabel;

@property (nonatomic,strong ) UIImageView *backImage;

@property (nonatomic,strong ) NSMutableArray *array;

@property (nonatomic,strong ) UIImageView *backPic;
@end
