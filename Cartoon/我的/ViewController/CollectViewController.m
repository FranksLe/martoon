//
//  CollectViewController.m
//  Cartoon
//
//  Created by dllo on 15/11/5.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "CollectViewController.h"
#import "BooksPushViewController.h"
#import "CollectCollectionViewCell.h"
#import "FMDBHandler.h"
#import "TotalDetailsViewController.h"
#import "BooksPushViewController.h"
@interface CollectViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *collectArray;

@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic, strong) UIImageView *backImage;

@end

@implementation CollectViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.tabBarController.tabBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    
    CATransition *ani4 = [CATransition animation];
    ani4.duration = 0.5;
    ani4.subtype = kCATransitionFade;
    
    [self.navigationController.navigationBar.layer addAnimation:ani4 forKey:nil];
    [self.tabBarController.tabBar.layer addAnimation:ani4 forKey:nil];
    
    
    FMDBHandler *db = [FMDBHandler shareInstance];
    [db createTable];
    self.collectArray = (NSMutableArray *)[db query];
    NSLog(@"数组:%@",self.collectArray);
    [self.collectionView reloadData];
    
    if (self.collectArray.count == 0) {
        self.backImage.hidden = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"我的收藏";
    
    UIImage *imagee = [UIImage imageNamed:@"shanchu.png"];
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [self.rightButton setBackgroundImage:imagee forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(barButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.tag = 99;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    
    FMDBHandler *db = [FMDBHandler shareInstance];
    [db createTable];
    self.collectArray = (NSMutableArray *)[db query];
    NSLog(@"数组:%@",self.collectArray);

    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((self.view.bounds.size.width-60)/3, self.view.bounds.size.width*140/375);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 56+56+10, 15);
    flowLayout.minimumLineSpacing = 20;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[CollectCollectionViewCell class] forCellWithReuseIdentifier:@"collectPageReuse"];
    [self.view addSubview:self.collectionView];

    
    self.backImage = [[UIImageView alloc]init];
    _backImage.frame = self.view.bounds;
    _backImage.image = [UIImage imageNamed:@"empty_no_favorite.png"];
    _backImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_backImage];
    self.backImage.hidden = YES;

    if (self.collectArray.count == 0) {
        self.backImage.hidden = NO;
    }
    else {
        self.backImage.hidden = YES;
    }

    

  }

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CollectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectPageReuse" forIndexPath:indexPath];
    
    KindModel *kind = [self.collectArray objectAtIndex:indexPath.item];
   
    cell.titleLabel.text = kind.classify_title;
    [cell.titlePic sd_setImageWithURL:[NSURL URLWithString:kind.classify_url]];
    [cell.rightButton addTarget:self action:@selector(deleteOneBook:) forControlEvents:UIControlEventTouchUpInside];
    cell.rightButton.userInteractionEnabled = YES;
    cell.rightButton.tag = indexPath.item;
   
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KindModel *kind = [self.collectArray objectAtIndex:indexPath.item];
    
    BooksPushViewController *bookV = [[BooksPushViewController alloc]init];
    TotalDetailsViewController *bookVC = [[TotalDetailsViewController alloc]init];
    if ([kind.only isEqualToString:@"b"]) {
     
        bookVC.comicId = kind.classify_id;
        bookVC.name = kind.classify_title;
        [self.navigationController pushViewController:bookVC animated:YES];
        NSLog(@"aaaaaa%@",kind.classify_title);
   
    }else{
    // 要传的id
        bookV.booksId = kind.classify_id;
        bookV.name = kind.classify_title;
        NSLog(@"aaaaaa%@",kind.classify_title);
    [self.navigationController pushViewController:bookV animated:YES];
    }
}

- (void)barButtonAction:(UIButton *)button
{
    if (self.rightButton.tag == 100) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"layoutMiss" object:nil userInfo:nil];
        
            [self.rightButton setTitle:nil forState:normal];
            [self.rightButton setBackgroundImage:[UIImage imageNamed:@"shanchu.png"] forState:normal];

        
        self.rightButton.tag = 99;
    }else
    
    if (self.rightButton.tag == 99) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"layout" object:nil userInfo:nil];
        
            [self.rightButton setTitle:@"完成" forState:normal];
            [self.rightButton setBackgroundImage:nil forState:normal];
            self.rightButton.titleLabel.font = [UIFont systemFontOfSize:13];

        [self.collectionView reloadData];
        self.rightButton.tag = 100;
    }
    
}

- (void)deleteOneBook:(UIButton *)button
{
    
    KindModel *kind = [self.collectArray objectAtIndex:button.tag];
    FMDBHandler *db = [FMDBHandler shareInstance];
    [db createTable];
    [db deleteData:kind];
    [self.collectArray removeObjectAtIndex:button.tag];
    [self.collectionView reloadData];
    NSLog(@"删除一条收藏");
    
    if (self.collectArray.count == 0) {
        self.backImage.hidden = NO;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
