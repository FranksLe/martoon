//
//  DetailsViewController.m
//  Cartoon
//
//  Created by dllo on 15/10/29.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "DetailsViewController.h"
#import "DetailsTableViewCell.h"
#import "KindModel.h"
#import "TotalDetailsViewController.h"
#import "GifFooter.h"
#import "GifHeader.h"
#define Screen_Width self.view.bounds.size.width
#define Screen_Height self.view.bounds.size.height
@interface DetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *arr;
@property(nonatomic, strong)NSMutableDictionary *dic;
@property (nonatomic, assign) NSInteger Page;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation DetailsViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.tabBarController.tabBar.translucent = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-20) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[DetailsTableViewCell class] forCellReuseIdentifier:@"details"];
    
    UIBarButtonItem*backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"返回";
    self.navigationItem.backBarButtonItem=backItem;

    [self json];
    
    
    [self createCollectionView];
}
- (void)createCollectionView
{
    self.tableView.header = [GifHeader headerWithRefreshingTarget:self refreshingAction:@selector(json)];
    self.tableView.footer = [GifFooter footerWithRefreshingTarget:self refreshingAction:@selector(bestRefreshingFooter)];
    
}
- (void)bestRefreshingFooter
{
    NSString *pageStr = [NSString stringWithFormat:@"%ld",_Page];
   
    NSString *str = [NSString stringWithFormat:@"http://mobilev3.ac.qq.com/Classify/comicClassifyDetailForIos/uin/0/local_version/3.1.0/channel/1001/guest_id/943AAD67-2C90-414B-A21F-D9BE0A1E80F6/classify_id/%@/page/%@/listcnt/20",self.listId,pageStr];
    
    [NetHandler dataWithUrl:str complant:^(NSData *data) {
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *arr = [dataDic objectForKey:@"data"];
        for (NSDictionary *dict in arr) {
            KindModel *kind = [[KindModel alloc]init];
            [kind setValuesForKeysWithDictionary:dict];
            [self.arr addObject:kind];
        }
        self.Page = _Page + 1;
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    }];
}
-(void)json
{
//    //创建UIActivityIndicatorView背底半透明View
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height+49)];
//    [view setTag:108];
//    [view setBackgroundColor:[UIColor blackColor]];
//    [view setAlpha:0.4];
//    [self.view addSubview:view];
//    UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-40,180, 80, 80)];
//    NSMutableArray *imageArr = [NSMutableArray array];
//    for (NSInteger i = 0; i < 8; i ++) {
//        NSString *picStr = [NSString stringWithFormat:@"refresh_lu_run%ld",i];
//        UIImage *image = [UIImage imageNamed:picStr];
//        [imageArr addObject:image];
//    }
//    animatedImageView.animationImages = imageArr;
//    animatedImageView.animationDuration = 1.5f;
//    animatedImageView.animationRepeatCount = 0;
//    [self.view addSubview: animatedImageView];
//    [animatedImageView startAnimating];
//    
//    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    _hud.color=[UIColor whiteColor];
//    _hud.mode = MBProgressHUDModeCustomView;
//    //    _hud.labelText = @"加载中...";
//    _hud.customView= animatedImageView;
//
    NSString *str =[NSString stringWithFormat:@"http://mobilev3.ac.qq.com/Classify/comicClassifyDetailForIos/uin/0/local_version/3.1.0/channel/1001/guest_id/943AAD67-2C90-414B-A21F-D9BE0A1E80F6/classify_id/%@/page/1/listcnt/20",self.listId];
        str = [str stringByAddingPercentEncodingWithAllowedCharacters:[ NSCharacterSet URLFragmentAllowedCharacterSet]];

    [NetHandler dataWithUrl:str complant:^(NSData *data) {
        
        self.dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"%@",self.dic);
        NSArray *tempArr = [self.dic objectForKey:@"data"];
        self.arr = [NSMutableArray array];
        for (NSDictionary *dict in tempArr) {
            KindModel *kind = [[KindModel alloc]init];
            [kind setValuesForKeysWithDictionary:dict];
            [self.arr addObject:kind];
        }
//        NSLog(@"%@",_arr);
//        if (self.arr.count != 0) {
//            //加载数据隐藏
//            self.hud.hidden = YES;
//            //移除遮罩
//            UIView *view = (UIView*)[self.view viewWithTag:108];
//            [view removeFromSuperview];
//        }
        

        self.title = self.myTitle;
        if ([self.title isEqualToString:@"VIP"]) {
            self.title = @"精选";
        }
         self.Page = 2;
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   KindModel *kind = [self.arr objectAtIndex:indexPath.row];
    DetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"details" forIndexPath:indexPath];
    
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:kind.cover_url]placeholderImage:[UIImage imageNamed:@"placeholder_comicCover.png"]];
    cell.nameLabel.text = kind.title;
    cell.nameLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.authorLabel.text = [NSString stringWithFormat:@"作者:%@",kind.artist_name];
    cell.authorLabel.font = [UIFont systemFontOfSize:14];
    cell.categoryLabel.text = [NSString stringWithFormat:@"类型:%@", kind.type];
    cell.categoryLabel.font = [UIFont systemFontOfSize:14];
    cell.volumeLabel.text = [NSString stringWithFormat:@"更新至%@",kind.lastup];
    cell.volumeLabel.font = [UIFont systemFontOfSize:14];

    cell.timeLabel.text = [NSString stringWithFormat:@"更新:%@",kind.update_date];
    cell.timeLabel.font = [UIFont systemFontOfSize:14];
    cell.gradeLabel.text = [NSString stringWithFormat:@"评分:%@",kind.grade_ave];;
    cell.gradeLabel.font = [UIFont systemFontOfSize:14];
    cell.gradeLabel.textColor = [UIColor redColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TotalDetailsViewController *totalDetailsV = [[TotalDetailsViewController alloc]init];
    [self.navigationController pushViewController:totalDetailsV animated:YES];
    KindModel *kind = [self.arr objectAtIndex:indexPath.row];
    totalDetailsV.comicId = kind.comic_id;
    totalDetailsV.name = kind.title;
    NSLog(@"******id是:%@",kind.comic_id);
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
