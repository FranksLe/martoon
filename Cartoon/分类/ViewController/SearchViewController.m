//
//  SearchViewController.m
//  Cartoon
//
//  Created by dllo on 15/10/30.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "KindModel.h"
#import "TotalDetailsViewController.h"
#import "GifHeader.h"
#import "GifFooter.h"
@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *arr;
@property(nonatomic, strong)NSMutableDictionary *dic;
@property (nonatomic,strong)UIImageView *picImageView;
@property (nonatomic, assign) NSInteger Page;
@end

@implementation SearchViewController
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
    
    [self.tableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:@"search"];
    
    
    self.picImageView =[[UIImageView alloc]initWithFrame:self.view.bounds];
    self.picImageView.image = [UIImage imageNamed:@"search.png"];
    self.picImageView.hidden =YES;
    self.picImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.picImageView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    [self.tableView addSubview:self.picImageView];
    
    [self bestRefreshingFooter];
    [self createCollectionView];

    [self json];
}
- (void)createCollectionView
{
    self.tableView.header = [GifHeader headerWithRefreshingTarget:self refreshingAction:@selector(json)];
    self.tableView.footer = [GifFooter footerWithRefreshingTarget:self refreshingAction:@selector(bestRefreshingFooter)];
    
}
- (void)bestRefreshingFooter
{
    NSString *pageStr = [NSString stringWithFormat:@"%ld",_Page];
    
    NSString *str = [NSString stringWithFormat:@"http://mobilev3.ac.qq.com/Search/comicSearchListForIos/uin/0/local_version/3.1.0/channel/1001/guest_id/943AAD67-2C90-414B-A21F-D9BE0A1E80F6/key_word/%@/page/%@/listcnt/20",self.text,pageStr];
    
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
        if (self.arr.count == 0) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }
        else{
        [self.tableView.footer endRefreshing];
        }
    }];
}

-(void)json
{
    
    NSString *str =[NSString stringWithFormat:@"http://mobilev3.ac.qq.com/Search/comicSearchListForIos/uin/0/local_version/3.1.0/channel/1001/guest_id/943AAD67-2C90-414B-A21F-D9BE0A1E80F6/key_word/%@/page/1/listcnt/20",self.text];
    [NetHandler dataWithUrl:str complant:^(NSData *data) {
        self.dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = [self.dic objectForKey:@"data"];
        self.arr = [NSMutableArray array];
        for (NSDictionary *dict in arr) {
            KindModel *kind = [[KindModel alloc]init];
            [kind setValuesForKeysWithDictionary:dict];
            [self.arr addObject:kind];
        }
        if (self.arr.count ==0) {
            self.picImageView.hidden =NO;

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
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"search" forIndexPath:indexPath];
    cell.nameLabel.text = kind.title;
    cell.nameLabel.font = [UIFont boldSystemFontOfSize:16];
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:kind.cover_url]placeholderImage:[UIImage imageNamed:@"placeholder_comicCover.png"]];
    cell.authorLabel.text =[NSString stringWithFormat:@"作者:%@",kind.artist_name];
    cell.authorLabel.font = [UIFont systemFontOfSize:14];
    
    cell.volumeLabel.text = [NSString stringWithFormat:@"更新至%@",kind.lastup];
    cell.volumeLabel.font = [UIFont systemFontOfSize:14];
    
//    // 关键字高亮
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:[kind.title stringByRemovingPercentEncoding]];
    NSRange range = [[kind.title stringByRemovingPercentEncoding] rangeOfString:[self.text stringByRemovingPercentEncoding]];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:range];
    cell.nameLabel.attributedText = string;
    
    NSMutableAttributedString *stringAuthor = [[NSMutableAttributedString alloc]initWithString:[[NSString stringWithFormat:@"作者:%@",kind.artist_name] stringByRemovingPercentEncoding]];
    NSRange rangeAuthor = [[[NSString stringWithFormat:@"作者:%@",kind.artist_name] stringByRemovingPercentEncoding] rangeOfString:[self.text stringByRemovingPercentEncoding]];
    [stringAuthor addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rangeAuthor];
    [stringAuthor addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:rangeAuthor];
    cell.authorLabel.attributedText = stringAuthor;
        return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TotalDetailsViewController *searchDetailsV = [[TotalDetailsViewController alloc]init];
    [self.navigationController pushViewController:searchDetailsV animated:YES];
    KindModel *kind = [self.arr objectAtIndex:indexPath.row];
    searchDetailsV.comicId = kind.comic_id;
    searchDetailsV.name = kind.title;
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
