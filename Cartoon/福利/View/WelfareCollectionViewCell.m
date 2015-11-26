//
//  WelfareCollectionViewCell.m
//  Cartoon
//
//  Created by dllo on 15/10/28.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//
#define Width cell.bounds.size.width
#define Height cell.bounds.size.height
#import "WelfareCollectionViewCell.h"
#import "WelfareModel.h"
#import "GifFooter.h"
#import "GifHeader.h"

@implementation WelfareCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.portDic = @{@"2":@[@"8322dfd0306209f08dedaabecc1eb5eb",@"1446811514"],@"3":@[@"5085cea952389b52d439504048db8eea",@"1446811517"],@"4":@[@"c6da8c6e27aa6876a7d91169b423abf5",@"1446811520"],@"5":@[@"de37d1eb47abe3093ef45d6abe316586",@"1446811522"],@"6":@[@"983417703ad632ef67b13d66cd53b319",@"1446811525"],@"7":@[@"b60586ac4b06b12f5c9bca4e7e4afb30",@"1446811527"]};
        
        self.hotPortDic = @{@"2":@[@"3ad41d8b7f1e5f8390f9962149aaf9ae",@"1446192082"],@"3":@[@"5110cae6965a7a7d28c14d45b9b0d74d",@"1446192108"],@"4":@[@"9cb8fcd69562fe652704f3c6d852f2be",@"1446192129"],@"5":@[@"227a29fa9bc0647316bfcfd10c83bf4f",@"1446192161"],@"6":@[@"5838e0452e8700f3e1325c5157f31e13",@"1446192182"],@"7":@[@"c2406a4032f2dced00d34fa1d77d8be8",@"1446192202"]};
   
        
        /*  layout布局初始化    */
        
        HMWaterflowLayout *layout = [[HMWaterflowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 20, 10);
        layout.columnsCount = 2;
        layout.delegate = self;
        
        self.picCollectionView = [[UICollectionView alloc]initWithFrame:self.contentView.bounds collectionViewLayout:layout];
        self.picCollectionView.backgroundColor = [UIColor whiteColor];
        _picCollectionView.delegate = self;
        _picCollectionView.dataSource = self;
        _picCollectionView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
        [self.contentView addSubview:_picCollectionView];
        [self.picCollectionView registerClass:[PicCollectionViewCell class] forCellWithReuseIdentifier:@"picture"];
        
        [self dataHandler];
       
    }
    return self;
}
- (void)createCollectionView
{
    self.picCollectionView.header = [GifHeader headerWithRefreshingTarget:self refreshingAction:@selector(dataHandler)];
    self.picCollectionView.footer = [GifFooter footerWithRefreshingTarget:self refreshingAction:@selector(bestRefreshingFooter)];
    
}
- (void)createHotCollectionView
{
    [self hotData];
    self.picCollectionView.header = [GifHeader headerWithRefreshingTarget:self refreshingAction:@selector(hotData)];
    
    self.picCollectionView.footer = [GifFooter footerWithRefreshingTarget:self refreshingAction:@selector(hotRefreshingFooter)];
}
- (void)dataHandler
{
    
    NSString *str = @"http://api.zhuizhuiyoyo.com/request.php?method=welfare%2Flist&param=%7B%22count%22%3A20%2C%22o%22%3A%22t%22%2C%22page%22%3A1%7D&sig=bad337f580b47a69e23cf802733f95e2&timestamp=1445923309";
    
    [NetHandler dataWithUrl:str complant:^(NSData *data) {
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *arr = [dataDic objectForKey:@"welfares"];
        self.dataArr = [WelfareModel baseModelByArr:arr];
        [self.picCollectionView reloadData];
        self.bestPage = 2;
        [self.picCollectionView.header endRefreshing];
    }];
}
- (void)bestRefreshingFooter
{
    NSString *pageStr = [NSString stringWithFormat:@"%ld",_bestPage];
    NSString *sig = [[_portDic objectForKey:pageStr]objectAtIndex:0];
    NSString *time = [[_portDic objectForKey:pageStr]objectAtIndex:1];
    
    
    NSString *str = [NSString stringWithFormat:@"http://api.zhuizhuiyoyo.com/request.php?method=welfare/list&param={\"count\":20,\"o\":\"t\",\"page\":%@}&sig=%@&timestamp=%@",pageStr,sig,time];
      str = [str stringByAddingPercentEncodingWithAllowedCharacters:[ NSCharacterSet URLFragmentAllowedCharacterSet]];

    [NetHandler dataWithUrl:str complant:^(NSData *data) {
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *arr = [dataDic objectForKey:@"welfares"];
        for (NSDictionary *dic in arr) {
            WelfareModel *welfareModel = [[WelfareModel alloc]init];
            [welfareModel setValuesForKeysWithDictionary:dic];
            [self.dataArr addObject:welfareModel];
        }
        self.bestPage = _bestPage + 1;
        [self.picCollectionView reloadData];
        [self.picCollectionView.footer endRefreshing];
    }];
}
- (void)hotData
{
    NSString *str = @"http://api.zhuizhuiyoyo.com/request.php?method=welfare%2Flist&param=%7B%22count%22%3A20%2C%22o%22%3A%22h%22%2C%22page%22%3A1%7D&sig=4db6fb947b7ca0bd1bbc96cb3aafdcdd&timestamp=1445924662";
    [NetHandler dataWithUrl:str complant:^(NSData *data) {
        
        NSDictionary *hotDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *arr = [hotDic objectForKey:@"welfares"];
        self.dataArr = [WelfareModel baseModelByArr:arr];
        [self.picCollectionView reloadData];
        self.hotPage = 2;
        [self.picCollectionView.header endRefreshing];
    }];
    
}
- (void)hotRefreshingFooter
{
    NSString *pageStr = [NSString stringWithFormat:@"%ld",_hotPage];
    NSString *sig = [[_hotPortDic objectForKey:pageStr]objectAtIndex:0];
    NSString *time = [[_hotPortDic objectForKey:pageStr]objectAtIndex:1];
    

    NSString *str = [NSString stringWithFormat:@"http://api.zhuizhuiyoyo.com/request.php?method=welfare/list&param={\"count\":20,\"o\":\"h\",\"page\":%@}&sig=%@&timestamp=%@",pageStr,sig,time];
    NSLog(@"%@",str);
    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[ NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"aa%@",str);
    [NetHandler dataWithUrl:str complant:^(NSData *data) {
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *arr = [dataDic objectForKey:@"welfares"];
        for (NSDictionary *dic in arr) {
            WelfareModel *welfareModel = [[WelfareModel alloc]init];
            [welfareModel setValuesForKeysWithDictionary:dic];
            [self.dataArr addObject:welfareModel];
        }
        self.hotPage = _hotPage + 1;
        [self.picCollectionView reloadData];
        [self.picCollectionView.footer endRefreshing];
    }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picture" forIndexPath:indexPath];
    WelfareModel *welfareModel = [self.dataArr objectAtIndex:indexPath.item];
    cell.result = welfareModel.height/welfareModel.width;
    
    [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:welfareModel.image]placeholderImage:[UIImage imageNamed:@"placeholder_comicCover.png"]];
    cell.nameLabel.text = welfareModel.name;
    [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:welfareModel.avatar]];
    cell.contentLabel.text = welfareModel.introduce;
    cell.likeCountLabel.text = welfareModel.up_count;
    cell.reportButton.tag = indexPath.item;
    [cell.reportButton addTarget:self action:@selector(reportButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([welfareModel.type isEqualToString:@"1" ]) {
        cell.stateLabel.text = @"原创";
        cell.stateLabel.backgroundColor = [UIColor colorWithRed:153/255.0 green:203/255.0 blue:75/255.0 alpha:1];
    }
    else if([welfareModel.type isEqualToString:@"2"]){
        cell.stateLabel.text = @"搬运";
        cell.stateLabel.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    }
    
    cell.picImageView.frame = CGRectMake(0, 0, Width, Width*cell.result);
    cell.photoImageView.frame = CGRectMake(5, Width*cell.result+5, 30, 30);
    cell.nameLabel.frame = CGRectMake(45, Width*cell.result+5, Width-55, 20);
    cell.contentLabel.frame = CGRectMake(5, Width*cell.result+40, Width-10, 30);
    cell.reportButton.frame = CGRectMake(Width-30, Width*cell.result+22, 20, 20);
    cell.lineImageView.frame = CGRectMake(10, Height- 30, Width-20, 1);
    cell.stateLabel.frame = CGRectMake(10, Height-25, 40, 20);
    cell.likeCountLabel.frame = CGRectMake(Width-35 , Height-25, 25 , 20);
    cell.likeImageView.frame = CGRectMake(Width-cell.likeCountLabel.frame.size.width-30, Height-25, 20, 20);

    
    
    cell.backgroundColor = [ UIColor whiteColor];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    return cell;
}

- (void)reportButtonAction:(UIButton *)but
{
    WelfareModel *welfareModel = [self.dataArr objectAtIndex:but.tag];
    
    NSNotificationCenter *PushView = [NSNotificationCenter defaultCenter];
    
    [PushView postNotificationName:@"PushView" object:welfareModel.image userInfo:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *photoArr = [NSMutableArray array];
    for (WelfareModel *model in _dataArr) {
        [photoArr addObject:model.image];
    }
    [self.photoDelegate passPhotoArr:photoArr index:indexPath.item];
    
}
- (CGFloat)waterflowLayout:(HMWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    WelfareModel *welfareModel = [self.dataArr objectAtIndex:indexPath.item];
    
    CGFloat hei = (self.contentView.bounds.size.width/2-10)*welfareModel.height/welfareModel.width;
    
    
    NSString *str = welfareModel.introduce;
//    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(self.contentView.bounds.size.width/2-10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];

    return  hei+rect.size.height+50+30;
}



@end
