//
//  MyCell.h
//  UI_豆瓣解析
//
//  Created by dllo on 15/9/12.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomScrollView.h"
@interface MyCell : UICollectionViewCell<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) CustomScrollView *scrollView;
@property (nonatomic, strong) UILabel *bigPage;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, strong) NSMutableArray *scrollArr;
@end
