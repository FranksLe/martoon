//
//  WelfareViewController.m
//  Cartoon
//
//  Created by dllo on 15/10/28.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//
#define Screen_Width self.view.bounds.size.width
#define Screen_Height self.view.bounds.size.height
#import "WelfareViewController.h"
#import "WelfareCollectionViewCell.h"
#import "PhotoDetailViewController.h"
#import "ReportViewController.h"
@interface WelfareViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,pushPhotoViewController>
@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation WelfareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //最新按钮
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeSystem];
    newButton.frame = CGRectMake(0, 64, Screen_Width/2, 40);
    [newButton setTitle:@"最新" forState:UIControlStateNormal];
    newButton.tintColor = [UIColor colorWithRed:153/255.0 green:203/255.0 blue:75/255.0 alpha:1];
    [newButton addTarget:self action:@selector(newButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newButton];
    
    //最热按钮
    UIButton *hotButton = [UIButton buttonWithType:UIButtonTypeSystem];
    hotButton.frame = CGRectMake(Screen_Width/2, 64, Screen_Width/2, 40);
    [hotButton setTitle:@"最热" forState:UIControlStateNormal];
    hotButton.tintColor = [UIColor colorWithRed:153/255.0 green:203/255.0 blue:75/255.0 alpha:1];
    [hotButton addTarget:self action:@selector(hotButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hotButton];
    
    //按钮下端彩线
    self.colorView = [[UIView alloc]initWithFrame:CGRectMake(0, newButton.bounds.size.height-2+64, Screen_Width/2, 2)];
    self.colorView.backgroundColor = [UIColor colorWithRed:153/255.0 green:203/255.0 blue:75/255.0 alpha:1];
    [self.view addSubview:_colorView];
    
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(Screen_Width, Screen_Height-64-49-40);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, newButton.bounds.size.height+64, Screen_Width, Screen_Height-64-49-40) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.view addSubview:_collectionView];
    
    [self.collectionView registerClass:[WelfareCollectionViewCell class] forCellWithReuseIdentifier:@"first"];
    
    NSNotificationCenter *PushView = [NSNotificationCenter defaultCenter];
    
    [PushView addObserver:self selector:@selector(receiveNotification:) name:@"PushView" object:nil];

    
}

- (void)receiveNotification:(NSNotification *)noti
{
    ReportViewController *reportVC = [[ReportViewController alloc]init];
    reportVC.url = noti.object;
    [self.navigationController pushViewController:reportVC animated:YES];
}


- (void)newButtonAction:(UIButton *)btn
{
    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)hotButtonAction:(UIButton *)btn
{
    [self.collectionView setContentOffset:CGPointMake(Screen_Width, 0) animated:YES];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WelfareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
    cell.photoDelegate = self;
    if (indexPath.item == 0) {

        [cell createCollectionView];
    }
    if (indexPath.item == 1) {

        [cell createHotCollectionView];
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _collectionView) {
       
            self.colorView.frame = CGRectMake(_collectionView.contentOffset.x/2, 40-2+64, Screen_Width/2, 2);
        
    }
}
- (void)passPhotoArr:(NSMutableArray *)photoArr index:(NSInteger)indexpath
{
    PhotoDetailViewController *photoVC = [[PhotoDetailViewController alloc]init];
    photoVC.indexPath = indexpath;
    photoVC.photoArr= photoArr;
    [self.navigationController presentViewController:photoVC animated:YES completion:nil];
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
