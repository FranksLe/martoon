//
//  FirstPageTableViewCell.h
//  Cartoon
//
//  Created by dllo on 15/10/28.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PathValue <NSObject>

- (void)PathValue:(NSString *)booksId name:(NSString *)name;

@end


@interface FirstPageTableViewCell : UITableViewCell <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) NSMutableArray *allBooksArray;

@property (nonatomic,strong) NSMutableArray *allTitleArray;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,assign) id<PathValue>delegate;

@property (nonatomic,strong) NSString *kindStr;

@property (nonatomic,assign) NSInteger *indexPath;

@end
