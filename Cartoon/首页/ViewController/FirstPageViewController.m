//
//  FirstPageViewController.m
//  Cartoon
//
//  Created by dllo on 15/10/28.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//
#define Collection_Width self.collectionView.bounds.size.width
#define Collection_Height self.collectionView.bounds.size.height
#define Screen_Width self.view.bounds.size.width
#define Screen_Height self.view.bounds.size.height

#import "BooksPushViewController.h"
#import "FirstPageViewController.h"
#import "MoreBooksViewController.h"
#import "FirstPageHeaderView.h"
#import "UpPicPushViewController.h"
#import "FirstPageCollectionViewCell.h"
#import "FirstPageTableViewCell.h"
#import "FirstPageModel.h"
#import "PicObject.h"
#import "LunBoCollectionViewCell.h"

@interface FirstPageViewController ()<UITableViewDataSource,UITableViewDelegate,PathValue,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIButton *rightBarButton;

@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,assign) NSInteger count;

@end

@implementation FirstPageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    CATransition *ani4 = [CATransition animation];
    ani4.duration = 0.5;
    ani4.subtype = kCATransitionFade;
    
    [self.view.layer addAnimation:ani4 forKey:nil];
    [self.navigationController.navigationBar.layer addAnimation:ani4 forKey:nil];
    [self.tabBarController.tabBar.layer addAnimation:ani4 forKey:nil];
    [self.tableView.layer addAnimation:ani4 forKey:nil];
    [self.collectionView.layer addAnimation:ani4 forKey:nil];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.tableView.alpha = 1;
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"主页";
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:149/255.0 green:198/255.0 blue:64/255.0 alpha:1];
    
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 84) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    [self.tableView registerClass:[FirstPageTableViewCell class] forCellReuseIdentifier:@"tableViewReuse"];
    [self.view addSubview:self.tableView];
    self.tableView.alpha = 0;
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"mhzzjz.png"];
    [self.tableView setBackgroundView:imageView];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height / 7*2)];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    NSLog(@"dadada %@ %@", formatter, date);
    //创建轮播图CollectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height / 7*2);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/7*2) collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;

    [self.tableView.tableHeaderView addSubview:_collectionView];
    
    //创建pageControl
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(Collection_Width / 2 + 75, Collection_Height-20, 100, 20)];
    [self.tableView.tableHeaderView addSubview:_pageControl];

    //轮播计时器
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];

    [self.collectionView registerClass:[LunBoCollectionViewCell class] forCellWithReuseIdentifier:@"lunbo"];

    
    
    UIImage *imagee = [UIImage imageNamed:@"shuaxin.png"];
    self.rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,16,16)];
    [self.rightBarButton setBackgroundImage:imagee forState:UIControlStateNormal];
    [self.rightBarButton addTarget:self action:@selector(barButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.rightBarButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    
    [self getValuesForInternet];
    [self getPicForInternet];
    

}
- (void)timerAction:(NSTimer *)timer
{
    [self.collectionView setContentOffset:CGPointMake(Collection_Width*(_pageControl.currentPage + 2), 0) animated:YES];
    
        CATransition *ani4 = [CATransition animation];
        ani4.duration = 0.5;
        ani4.subtype = kCATransitionFade;
        [_collectionView.layer addAnimation:ani4 forKey:nil];
    
}

- (void)barButtonAction:(UIButton *)but
{
    self.tableView.contentOffset = CGPointMake( 0, 0);
    [self.tableView reloadData];
}


/*   tableView 的铺设  */


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    return Screen_Width*170/375;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FirstPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewReuse"];
    
    cell.allBooksArray = [[self.allTitleArray objectAtIndex:indexPath.section]objectForKey:@"books"];
    
    cell.delegate = self;
    
    cell.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    
    return cell;
}



/*   分区的创建   */


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allTitleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


/*    取消section上面的空白 (改变默认的footter高度)  */

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *str = @"headerReuse";
    
    FirstPageHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:str];
    
    if (!view) {
        
        view = [[FirstPageHeaderView alloc]initWithReuseIdentifier:str];
    }
    
    view.titleLabel.text = [[self.allTitleArray objectAtIndex:section]objectForKey:@"name"];
    
    view.moreButton.tag = section;
    
    [view.moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
    
}

/*取消选中状态*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)moreButtonAction:(UIButton *)but
{
    MoreBooksViewController *moreVC = [[MoreBooksViewController alloc]init];
    
    if (but.tag < 3) {
        moreVC.kindStr = [[[[self.allTitleArray objectAtIndex:but.tag]objectForKey:@"parameters"]objectForKey:@"property"]objectForKey:@"分类"];
        moreVC.indexNum = (long *)but.tag;
    }else if (but.tag >= 3){
        moreVC.kindStr = [[[[self.allTitleArray objectAtIndex:but.tag]objectForKey:@"parameters"]objectForKey:@"property"]objectForKey:@"题材"];
        moreVC.indexNum = (long *)but.tag;
    }
    
    
    
    [self.navigationController pushViewController:moreVC animated:YES];
}


/*    协议方法    */

- (void)PathValue:(NSString *)booksId name:(NSString *)name;
{
    BooksPushViewController *booksVC = [[BooksPushViewController alloc]init];
    [self.navigationController pushViewController:booksVC animated:YES];
    booksVC.booksId = booksId;
    booksVC.name = name;
    
}
//轮播图数据
- (void)getPicForInternet
{
    self.picArray = [NSMutableArray array];
    
    NSString *str = @"http://api.zhuizhuiyoyo.com/request.php?method=page%2Fhome&param=%7B%22v%22%3A1%7D&sig=a2b76b937658e10d455fa50234bac564&timestamp=1446202394";
    
    [NetHandler dataWithUrl:str complant:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *arr = [NSArray array];
        
        arr = [dic objectForKey:@"banners"];
        
        for (NSDictionary *dicc in arr) {
            
            PicObject *model = [[PicObject alloc]init];
            
            [model setValuesForKeysWithDictionary:dicc];
            
            [self.picArray addObject:model];
            
        }
        [self handleImages];
        //给定collecttionView一个偏移量
        _collectionView.contentOffset = CGPointMake(Collection_Width, 0);
        //page的点数
        self.pageControl.numberOfPages = self.picArray.count-2;
        [self.collectionView reloadData];
        
    }];
}
- (void)handleImages
{
    PicObject *picModelFirst = [self.picArray firstObject];
    PicObject *picModelLast = [self.picArray lastObject];
    
    [self.picArray insertObject:picModelLast atIndex:0];
    [self.picArray addObject:picModelFirst];
}


/*   获取网络数据   */

- (void)getValuesForInternet
{
    
    self.allBooksArray = [NSMutableArray array];
    
    self.allTitleArray = [NSMutableArray array];
    
    NSString *str = @"http://api.dmgezi.com/comic/books/featured.json";
    
    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[ NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [NetHandler dataWithUrl:str complant:^(NSData *data) {
        
        self.allTitleArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        for (NSMutableDictionary *dic in self.allTitleArray) {
            
            FirstPageModel *model = [[FirstPageModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dic];
            
            [self.allBooksArray addObject:model];
            
        }
        
        [self.allTitleArray removeObjectAtIndex:0];
        
        [self.tableView reloadData];
        
        NSLog(@"网络数据请求成功,已刷新View");
        
    }];
    
    
}

//使页面上点的变化与视图的变化一致
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int halfX = _collectionView.frame.size.width / 2;
    _pageControl.currentPage = (_collectionView.contentOffset.x - Collection_Width - halfX) / (Collection_Width) + 1;
    if (_collectionView.contentOffset.x >=Collection_Width*(self.picArray.count-1)) {
        _collectionView.contentOffset = CGPointMake(Collection_Width, 0);
        // _pageControl.currentPage =0;
    }
    if (_collectionView.contentOffset.x <= 0) {
        _collectionView.contentOffset = CGPointMake(Collection_Width * (self.picArray.count-2),0);
    }
    
}
#pragma collectionView协议方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return self.picArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        LunBoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"lunbo" forIndexPath:indexPath];
        PicObject *picModel = [self.picArray objectAtIndex:indexPath.item];
        
        [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:picModel.cover]];
    
        cell.underTextLabel.text = picModel.content;
        return cell;
   
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PicObject *picObject = [self.picArray objectAtIndex:indexPath.item];
    UpPicPushViewController *upPicVC = [[UpPicPushViewController alloc]init];
    [self.navigationController pushViewController:upPicVC animated:YES];
    upPicVC.url = picObject.url;
    
    
    
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
