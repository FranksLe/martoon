//
//  LeadViewController.m
//  Cartoon
//
//  Created by dllo on 15/11/5.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "LeadViewController.h"
#import "LeadCollectionViewCell.h"

@interface LeadViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *leadCollectionView;

@property (nonatomic,strong) NSMutableArray *leadPicArray;

@end

@implementation LeadViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.leadPicArray = [NSMutableArray arrayWithObjects:@"yindao-1.png",@"yindao-2.png",@"yindao-3.png", nil];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UICollectionViewFlowLayout *leadFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    leadFlowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    leadFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    leadFlowLayout.minimumLineSpacing = 0;
    
    self.leadCollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:leadFlowLayout];
    _leadCollectionView.delegate = self;
    _leadCollectionView.dataSource = self;
    _leadCollectionView.pagingEnabled = YES;
    _leadCollectionView.backgroundColor = [UIColor colorWithRed:149/255.0 green:198/255.0 blue:64/255.0 alpha:1];
    [_leadCollectionView registerClass:[LeadCollectionViewCell class] forCellWithReuseIdentifier:@"leadReuse"];
    [self.view addSubview:_leadCollectionView];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.leadPicArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        LeadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"leadReuse" forIndexPath:indexPath];
        
        cell.myImage.image = [UIImage imageNamed:[self.leadPicArray objectAtIndex:indexPath.item]];
        
        return cell;
        
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.leadCollectionView.alpha = 0;
        } completion:^(BOOL finished) {
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:@"enter" object:nil userInfo:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
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
