//
//  MoreBooksViewController.m
//  Cartoon
//
//  Created by dllo on 15/10/30.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "MoreBooksViewController.h"
#import "MoreCollectionViewCell.h"
#import "MoreBooksModel.h"
#import "BooksPushViewController.h"

@interface MoreBooksViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation MoreBooksViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.tabBarController.tabBar.translucent = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.kindStr;
    
    self.view.backgroundColor = [UIColor brownColor];
    
    NSLog(@"%ld",(long)self.indexNum);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((self.view.bounds.size.width-50)/3, self.view.bounds.size.width*140/375);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 56, 10);
    flowLayout.minimumLineSpacing = 20;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[MoreCollectionViewCell class] forCellWithReuseIdentifier:@"morePageReuse"];
    [self.view addSubview:self.collectionView];
    
    
    
    
    [self getValuesForInternet];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.moreBooksArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    MoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"morePageReuse" forIndexPath:indexPath];
    
    MoreBooksModel *model = [self.moreBooksArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = model.name;
    
    NSString *url = model.cover;
    
    NSString *picUrl = [NSString stringWithFormat:@"http:%@",url];
    
    [cell.titlePic sd_setImageWithURL:[NSURL URLWithString:picUrl]];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BooksPushViewController *bookVC = [[BooksPushViewController alloc]init];
    MoreBooksModel *model = [self.moreBooksArray objectAtIndex:indexPath.row];
    bookVC.booksId = model.Id;
    bookVC.name = model.name;
    [self.navigationController pushViewController:bookVC animated:YES];
}




- (void)getValuesForInternet
{
    
    
    if ((long)self.indexNum < 3) {
        
        NSString *urlStr = self.kindStr;
        
        NSString *Str = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[ NSCharacterSet URLFragmentAllowedCharacterSet]];
        
        NSLog(@"%@",Str);
        
        NSString *orUrl = @"http://api.dmgezi.com/comic/books.json?order%5Breleased_at%5D=desc&page=1&per=60%20&property%5B%E5%88%86%E7%B1%BB%5D=";
        
        NSString *url = [NSString stringWithFormat:@"%@%@",orUrl,Str];
        
        NSLog(@"%@",url);
        
        self.moreBooksArray = [NSMutableArray array];
        
        [NetHandler dataWithUrl:url complant:^(NSData *data) {
            
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            
            for (NSMutableDictionary *dic in arr) {
                
                MoreBooksModel *model = [[MoreBooksModel alloc]init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [self.moreBooksArray addObject:model];
                
            }
            
            [self.collectionView reloadData];
        }];
        
    }else if ((long)self.indexNum >= 3){
        
        NSString *urlStr = self.kindStr;
        
        NSString *Str = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[ NSCharacterSet URLFragmentAllowedCharacterSet]];
        
        NSLog(@"%@",Str);
        
        NSString *orUrl = @"http://api.dmgezi.com/comic/books.json?order%5Breadings_count%5D=desc&page=1&per=60&property%5B%E9%A2%98%E6%9D%90%5D=";
        
        NSString *url = [NSString stringWithFormat:@"%@%@",orUrl,Str];
        
        NSLog(@"%@",url);
        
        self.moreBooksArray = [NSMutableArray array];
        
        [NetHandler dataWithUrl:url complant:^(NSData *data) {
            
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            
            for (NSMutableDictionary *dic in arr) {
                
                MoreBooksModel *model = [[MoreBooksModel alloc]init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [self.moreBooksArray addObject:model];
                
            }
            
            [self.collectionView reloadData];
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
