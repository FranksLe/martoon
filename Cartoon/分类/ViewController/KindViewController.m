//
//  KindViewController.m
//  Cartoon
//
//  Created by dllo on 15/10/28.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//
#define WIDTH self.view.bounds.size.width
#define HEIGHT self.view.bounds.size.height
#import "KindViewController.h"
#import "KindCollectionViewCell.h"
#import "KindModel.h"
#import "SearchViewController.h"
#import "DetailsViewController.h"
#import "HistoryCollectionViewCell.h"
#import "FMDBHandler.h"
@interface KindViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate>

@property(nonatomic, strong)NSMutableArray *arr;
@property(nonatomic, strong)NSMutableDictionary *dic;
@property(nonatomic, strong)UISearchBar *searchBar;// 搜索
@property(nonatomic,retain)UICollectionView *collectionView;
@property(nonatomic, strong)UIView *myView;
@property (nonatomic, retain) UILabel *recordOneLabel;//暂无历史记录
@property (nonatomic, retain) UIButton *clearRecordButton;// 清楚搜索记录按钮
@property (nonatomic, retain) NSMutableArray *historyArr;// 搜索记录数组
@property (nonatomic, retain) UICollectionView *historyCV;// 搜索模块

@end

@implementation KindViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.arr = [NSMutableArray array];
    
    self.myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width ,self.view.bounds.size.height)];
    [self.view addSubview:self.myView];
    //self.myView.hidden = YES;
    
    //历史记录
    UILabel *historyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 100, 20)];
    historyLabel.text = @"历史记录";
    historyLabel.font = [UIFont systemFontOfSize:14];
    [self.myView addSubview:historyLabel];
    
    //清除历史记录
    self.clearRecordButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _clearRecordButton.frame = CGRectMake(self.view.bounds.size.width-120, 20,100, 20);
    [_clearRecordButton setTitle:@"清除搜索记录" forState:UIControlStateNormal];
    _clearRecordButton.tintColor = [UIColor grayColor];
    [_clearRecordButton addTarget:self action:@selector(clearRecordButton:) forControlEvents:UIControlEventTouchUpInside];
    _clearRecordButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.myView addSubview:_clearRecordButton];
    
    //暂无搜索历史
    self.recordOneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 30)];
    self.recordOneLabel.text = @"暂无搜索历史";
    self.recordOneLabel.textAlignment = NSTextAlignmentCenter;
    self.recordOneLabel.font = [UIFont systemFontOfSize:15];
    self.recordOneLabel.textColor = [UIColor grayColor];
    [self.myView addSubview:self.recordOneLabel];
    
    
    UICollectionViewFlowLayout *historyFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    historyFlowLayout.itemSize = CGSizeMake((WIDTH-40)/4-10, 30);
    historyFlowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 30);
    historyFlowLayout.minimumLineSpacing = 20;
    historyFlowLayout.minimumInteritemSpacing = 5;
    
    self.historyCV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:historyFlowLayout];
    _historyCV.backgroundColor = [UIColor whiteColor];
    _historyCV.dataSource = self;
    _historyCV.delegate = self;
    [self.myView addSubview:_historyCV];
    [self.historyCV registerClass:[HistoryCollectionViewCell class] forCellWithReuseIdentifier:@"history"];
    //从数据库取历史
    FMDBHandler *db = [FMDBHandler shareInstance];
    [db createTableHistory];
    NSArray *array = [db selectAllHistory];
    self.historyArr = [NSMutableArray arrayWithArray:array];
    NSLog(@"历史数据:%@",self.historyArr);
    
    if (self.historyArr.count == 0) {
        self.clearRecordButton.hidden = YES;
        self.recordOneLabel.hidden = NO;

    }
    else{
        self.clearRecordButton.hidden = NO;
        self.recordOneLabel.hidden = YES;
        self.historyCV.hidden = NO;
    }
  
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 一个section距离边缘上下左右的距离
    flowLayout.minimumInteritemSpacing = 12;
    flowLayout.minimumLineSpacing = 12;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    flowLayout.itemSize = CGSizeMake((self.view.bounds.size.width-78)/3, WIDTH*150/375);
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width, self.view.bounds.size.height - 64 - 49 ) collectionViewLayout:flowLayout];
    [self.view addSubview:self.collectionView];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.hidden = NO;
    [self.collectionView registerClass:[KindCollectionViewCell class] forCellWithReuseIdentifier:@"kind"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
#pragma mark 创建搜索
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 25, self.view.bounds.size.width, 40)];
    self.searchBar.placeholder = @"输入漫画名或作者名";
    [self.searchBar setKeyboardType: UIKeyboardTypeNamePhonePad];// 键盘类型
    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor blueColor];
    self.navigationItem.titleView = self.searchBar;
    
    // 自定义返回按钮的标题
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"返回";
    
    self.navigationItem.backBarButtonItem=backItem;
      [self json];
}
#pragma mark 键盘确认搜索按钮方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
   FMDBHandler *db = [FMDBHandler shareInstance];
    [db createTableHistory];
  [db insertHistory:_searchBar.text];
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    searchVC.title = searchBar.text;
    searchBar.text = [searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[ NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@",searchBar.text);
    searchVC.text = searchBar.text;
    
   
    [searchBar resignFirstResponder];
    
    self.myView.hidden = NO;
    self.collectionView.hidden = YES;
    _clearRecordButton.hidden = NO;
    self.recordOneLabel.hidden = NO;
    
    NSArray *array = [db selectAllHistory];
    self.historyArr = [NSMutableArray arrayWithArray:array];
    [_historyCV reloadData];
     self.searchBar.text = nil;
   [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark 清除历史记录
- (void)clearRecordButton:(UIButton *)btn
{
    FMDBHandler *db = [FMDBHandler shareInstance];
    [db createTableHistory];
    NSInteger num = _historyArr.count;
    for (NSInteger i = 0; i < num; i ++) {
        NSString *str = [_historyArr objectAtIndex:i];
        [db deleteHistory:str];
    }
    [_historyArr removeAllObjects];
    [_historyCV reloadData];
    btn.hidden = YES;
    self.recordOneLabel.hidden = NO;
    self.historyCV.hidden = YES;
}

#pragma mark 开始搜索时 创建取消按钮
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    self.myView.hidden = NO;
    self.recordOneLabel.hidden = NO;
    self.collectionView.hidden = YES;
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"返回"  forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }

       return YES;
}

#pragma mark 取消按钮时执行的方法
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.myView.hidden = YES;
    self.collectionView.hidden = NO;
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
      self.searchBar.text = nil;
    
}


-(void)json
{
    NSString *str = @"http://mobilev3.ac.qq.com/Classify/comicClassifyListV2ForIos/uin/0/local_version/3.1.0/channel/1001/guest_id/943AAD67-2C90-414B-A21F-D9BE0A1E80F6";
    [NetHandler dataWithUrl:str complant:^(NSData *data) {
        
        self.dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = [self.dic objectForKey:@"data"];
        for (NSDictionary *dict in arr) {
            KindModel *kind = [[KindModel alloc]init];
            [kind setValuesForKeysWithDictionary:dict];
            [self.arr addObject:kind];
        }
        [self.collectionView reloadData];
    }];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _collectionView) {
        return self.arr.count -1;
    }
    if (collectionView == _historyCV) {
        NSLog(@"历史记录数量:%ld",self.historyArr.count);
        return self.historyArr.count  ;
    }
    else {
        return 0;
        
    }
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _collectionView) {
        KindModel *kind = [self.arr objectAtIndex:indexPath.item];

        KindCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kind" forIndexPath:indexPath];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:kind.classify_url]placeholderImage:[UIImage imageNamed:@"avatar.png"]];
        cell.label.text = kind.classify_title;
        if ([cell.label.text  isEqualToString: @"VIP"] ) {
            cell.label.text = @"精选";
        }
        return cell;
    }
    if (collectionView == _historyCV) {
        HistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"history" forIndexPath:indexPath];
        cell.recordLabel.text = [self.historyArr objectAtIndex:indexPath.item];
        if (self.historyArr.count !=0) {
            self.historyCV.hidden = NO;
           self.recordOneLabel.hidden = YES;
        }else{
            self.historyCV.hidden = YES;
            self.recordOneLabel.hidden = NO;

        }
        return cell;
    }
    else {
        return nil;
    }


}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _collectionView) {

    DetailsViewController *detailsV = [[DetailsViewController alloc]init];
    [self.navigationController pushViewController:detailsV animated:YES];
    KindModel *kind = [self.arr objectAtIndex:indexPath.row];
    detailsV.listId = kind.classify_id;
    detailsV.myTitle = kind.classify_title;
    NSLog(@"%@",kind.classify_id);
    }
    if (collectionView == _historyCV) {
        self.myView.hidden = NO;
        self.searchBar.text = [self.historyArr objectAtIndex:indexPath.item];
 
        self.collectionView.hidden = YES;
        SearchViewController *searchVC = [[SearchViewController alloc]init];
        NSString *str = [_searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[ NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSLog(@"%@",_searchBar.text);
        searchVC.text = str ;
        searchVC.title = self.searchBar.text;
        [self.navigationController pushViewController:searchVC animated:YES];

    
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
