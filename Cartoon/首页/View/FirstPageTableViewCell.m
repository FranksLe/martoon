//
//  FirstPageTableViewCell.m
//  Cartoon
//
//  Created by dllo on 15/10/28.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//
#import "FirstPageTableViewCell.h"
#import "FirstPageCollectionViewCell.h"
#import "FirstPageModel.h"
#import "MoreBooksViewController.h"

@implementation FirstPageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
                
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(self.contentView.bounds.size.width*100/375, self.contentView.bounds.size.width*140/375);
        flowLayout.sectionInset = UIEdgeInsetsMake(-5, 10, 10, 10);
        flowLayout.minimumLineSpacing = 20;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:self.contentView.bounds collectionViewLayout:flowLayout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.collectionView registerClass:[FirstPageCollectionViewCell class] forCellWithReuseIdentifier:@"firstPageReuse"];
        
        [self.contentView addSubview:self.collectionView];
        
        
    }
    
    return self;
}

- (void)setAllBooksArray:(NSMutableArray *)allBooksArray
{
    if (_allBooksArray != allBooksArray) {
        
        _allBooksArray = allBooksArray;
        
    }
    [self.collectionView reloadData];
}

- (void)setallTitleArray:(NSMutableArray *)allTitleArray
{
    if (_allTitleArray != allTitleArray) {
        
        _allTitleArray = allTitleArray;
        
    }
    [self.collectionView reloadData];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allBooksArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    FirstPageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"firstPageReuse" forIndexPath:indexPath];
    
    cell.titleLabel.text = [[self.allBooksArray objectAtIndex:indexPath.row]objectForKey:@"name"];
    
    NSString *url = [[self.allBooksArray objectAtIndex:indexPath.row]objectForKey:@"cover"];
    
    NSString *picUrl = [NSString stringWithFormat:@"http:%@",url];
    
    [cell.titlePic sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"placeholder_comicCover.png"]];
    
    CATransition *ani4 = [CATransition animation];
    ani4.duration = 0.3;
    ani4.subtype = kCATransitionFade;
    
    [cell.layer addAnimation:ani4 forKey:nil];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *booksId = [[self.allBooksArray objectAtIndex:indexPath.row]objectForKey:@"id"];
    NSString *name = [[self.allBooksArray objectAtIndex:indexPath.row]objectForKey:@"name"];
    [self.delegate PathValue:booksId name:name];
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height - 10);
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
