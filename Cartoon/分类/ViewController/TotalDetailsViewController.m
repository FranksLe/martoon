//
//  TotalDetailsViewController.m
//  Cartoon
//
//  Created by dllo on 15/10/30.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "TotalDetailsViewController.h"
#import "KindModel.h"
#import "TotalDetailsCollectionViewCell.h"
#import "FMDBHandler.h"
#import "LookViewController.h"
#import "AnimationModel.h"

#define HEIGHT [UIScreen mainScreen].bounds.size.height/667

@interface TotalDetailsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong) UILabel *detailLabel;

@property (nonatomic,strong) UIButton *button;

@property (nonatomic,strong) UIButton *startButton;

@property (nonatomic,strong) UIButton *saveButton;

@property (nonatomic,strong ) NSMutableDictionary *pageDic;

@property (nonatomic,strong ) NSMutableArray *booksArray;

@property (nonatomic,strong ) NSMutableDictionary *dic;

@property (nonatomic, strong) UIButton *popButton;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) KindModel *kind;
@property (nonatomic, assign) BOOL mark; // 收藏状态
@property (nonatomic, strong)NSString *classify_id;
@property (nonatomic, strong)NSString *classify_url;
@property (nonatomic, strong)NSString *classify_title;
@property (nonatomic, assign) NSInteger bigPage;
@property (nonatomic, assign) NSInteger smallPage;
@property (nonatomic, strong) UIImageView *upBackView;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIVisualEffectView *mohu;

@end

@implementation TotalDetailsViewController
-(void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    FMDBHandler *db = [FMDBHandler shareInstance];
    [db createTableRead];
    NSArray *array = [db selectAllRead];
    for (NSInteger i = 0; i <array.count; i++) {
        RecordModel *readModel = [array objectAtIndex:i];
        if ([readModel.name isEqualToString:self.name]) {
            self.bigPage = [readModel.bigPage integerValue];
            self.smallPage = [readModel.smallPage integerValue];
            NSLog(@"yyyyy%ld",self.smallPage);
            [self.startButton setTitle:@"继续观看" forState:normal];
            [self.collectionView reloadData];
        }
    }
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.mark = NO;
    self.view.backgroundColor = [UIColor whiteColor];

    self.pageDic = [NSMutableDictionary dictionary];
    self.booksArray = [NSMutableArray array];
    self.dic = [NSMutableDictionary dictionary];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/2-40*HEIGHT),180*HEIGHT, 80*HEIGHT, 80*HEIGHT)];
    NSMutableArray *imageArr = [NSMutableArray array];
    for (NSInteger i = 0; i < 8; i ++) {
        NSString *picStr = [NSString stringWithFormat:@"refresh_lu_run%ld.png",i];
        UIImage *image = [UIImage imageNamed:picStr];
        NSLog(@"%@",image);
        [imageArr addObject:image];
    }
    animatedImageView.animationImages = imageArr;
    animatedImageView.animationDuration = 1.5f;
    animatedImageView.animationRepeatCount = 0;
    [self.view addSubview: animatedImageView];
    [animatedImageView startAnimating];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.color=[UIColor whiteColor];
    _hud.mode = MBProgressHUDModeCustomView;
    //    hud.labelText = @"加载中...";
    _hud.customView= animatedImageView;

    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(((self.view.bounds.size.width-(20+50)*HEIGHT)/4), 30*HEIGHT);
    flowLayout.sectionInset = UIEdgeInsetsMake(25*HEIGHT, 10*HEIGHT, 10*HEIGHT, 10*HEIGHT);
    flowLayout.minimumLineSpacing = 20*HEIGHT;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, (self.view.bounds.size.height / 2 + (55+30)*HEIGHT), self.view.bounds.size.width, (self.view.bounds.size.height -self.view.bounds.size.height / 2 - (55+50 - 20)*HEIGHT)) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[TotalDetailsCollectionViewCell class] forCellWithReuseIdentifier:@"InsidePageReuse"];
    [self.view addSubview:self.collectionView];
    
    
    
    
    self.upBackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180*HEIGHT)];
    [self.view addSubview:_upBackView];
    
    self.mohu =[[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _mohu.frame = CGRectMake(0, 0, self.view.bounds.size.width, 180*HEIGHT);
    _mohu.alpha = 1;
    [_upBackView addSubview:_mohu];
    
    self.popButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.popButton.frame = CGRectMake(10*HEIGHT, 25*HEIGHT, 30*HEIGHT, 30*HEIGHT);
    [self.popButton setImage:[UIImage imageNamed:@"iconfont-jiantouzuo.png"] forState:UIControlStateNormal];
    [self.popButton addTarget:self action:@selector(popButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.popButton.tintColor = [UIColor whiteColor];
    self.popButton.backgroundColor = [UIColor colorWithRed:153/255.0 green:203/255.0 blue:75/255.0 alpha:1];
    self.popButton.layer.masksToBounds = YES;
    self.popButton.layer.cornerRadius = 15*HEIGHT;
    [self.view addSubview:_popButton];

    
    [self getValuesForInternet];

}

- (void)getValuesForInternet
{
    
    NSString *str = [NSString stringWithFormat:@"http://mobilev3.ac.qq.com/Comic/comicChapterListForIosV2/uin/0/local_version/3.1.0/channel/1001/guest_id/943AAD67-2C90-414B-A21F-D9BE0A1E80F6/comic_id/%@",self.comicId];
    
        [NetHandler dataWithUrl:str complant:^(NSData *data) {
        
        self.pageDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *array = [self.pageDic objectForKey:@"data"];
        
        for (NSMutableDictionary *dic in array) {
            
            AnimationModel *animationModel = [[AnimationModel alloc]init];
            
            [animationModel setValuesForKeysWithDictionary:dic];
            
            [self.booksArray insertObject:animationModel atIndex:0];
            
            
        }
            if (self.booksArray.count != 0) {
                self.hud.hidden = YES;
            }

            [self.collectionView reloadData];
        }];
    NSString *str1 = [NSString stringWithFormat:@"http://mobilev3.ac.qq.com/Comic/comicDetailForIosV2/uin/0/local_version/3.1.0/channel/1001/guest_id/943AAD67-2C90-414B-A21F-D9BE0A1E80F6/comic_id/%@",self.comicId];

    [NetHandler dataWithUrl:str1 complant:^(NSData *data) {
        
        self.dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dict = [[self.dic objectForKey:@"data"] objectForKey:@"comic"];
        self.title = [dict objectForKey:@"title"];
        
        self.classify_id =[dict objectForKey:@"comic_id"];
        self.classify_url =[dict objectForKey:@"cover_url"];
        self.classify_title =[dict objectForKey:@"title"];
        
        
        NSLog(@"777777%@---%@---%@",self.classify_id,self.classify_title,self.classify_url);
        
        [_upBackView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"cover_url"]]placeholderImage:[UIImage imageNamed:@"placeholder_comicCover.png"]];
        
       
        
        UIView *blackLine = [[UIView alloc]initWithFrame:CGRectMake(0, (self.view.bounds.size.height / 2.8 + (30+50)*HEIGHT), self.view.bounds.size.width, 0.5*HEIGHT)];
        blackLine.alpha = 0.6;
        blackLine.backgroundColor = [UIColor grayColor];
        [_mohu addSubview:blackLine];
        
        
        UIImageView *leftPic = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width/2-60*HEIGHT), 60*HEIGHT, 120*HEIGHT, 160*HEIGHT)];
        leftPic.clipsToBounds = YES;
        leftPic.layer.cornerRadius = 15*HEIGHT;
        leftPic.layer.borderWidth = 2;
        [leftPic sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"cover_url"]]placeholderImage:[UIImage imageNamed:@"placeholder_comicCover.png"]];
        leftPic.layer.borderColor = [[UIColor whiteColor]CGColor];
        [self.view addSubview:leftPic];
      
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 220*HEIGHT, self.view.bounds.size.width, 30*HEIGHT)];
        _titleLabel.text = [dict objectForKey:@"title"];
        _titleLabel.font = [UIFont systemFontOfSize:18*HEIGHT];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_titleLabel];

        
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, (self.view.bounds.size.height / 2.8 + (10 + 28+50)*HEIGHT), self.view.bounds.size.width, (self.view.bounds.size.height / 7 + 10*HEIGHT))];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.backView];
        
        self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*HEIGHT, 5*HEIGHT, (self.view.bounds.size.width - 15*HEIGHT), self.view.bounds.size.height / 4 )];
        self.detailLabel.numberOfLines = 4;
        self.detailLabel.font = [UIFont systemFontOfSize:15*HEIGHT];
        self.detailLabel.textColor = [UIColor blackColor];
        self.detailLabel.text = [dict objectForKey:@"brief_intrd"];
        [self.detailLabel sizeToFit];
        [self.backView  addSubview:self.detailLabel];
        
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.button setTitle:@"展开∨" forState:normal];
        self.button.titleLabel.font = [UIFont systemFontOfSize:13*HEIGHT];
        [self.button setTitleColor:[UIColor colorWithRed:149/255.0 green:198/255.0 blue:64/255.0 alpha:1] forState:normal];
        self.button.frame = CGRectMake((self.view.bounds.size.width / 10 * 9 - 10*HEIGHT), 75*HEIGHT, 40*HEIGHT, 20*HEIGHT);
        [self.backView  addSubview:self.button];
        self.button.tag = 99;
        
        [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        // 阅读按钮
        self.startButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.startButton setTitle:@"开始阅读" forState:normal];
        FMDBHandler *db = [FMDBHandler shareInstance];
        [db createTableRead];
        NSArray *readArr = [db selectAllRead];
        for (NSInteger i = 0; i <readArr.count; i++) {
            RecordModel *readModel = [readArr objectAtIndex:i];
            if ([readModel.name isEqualToString:self.name]) {
                self.bigPage = [readModel.bigPage integerValue];
                self.smallPage = [readModel.smallPage integerValue];
                [self.startButton setTitle:@"继续观看" forState:normal];
            }
        }

        self.startButton.titleLabel.font = [UIFont systemFontOfSize: 18];
        self.startButton.backgroundColor = [UIColor colorWithRed:149/255.0 green:198/255.0 blue:64/255.0 alpha:1];
        self.startButton.layer.cornerRadius = 4;
        self.startButton.frame = CGRectMake(10*HEIGHT, (self.view.bounds.size.height / 4 + (30+70)*HEIGHT), (self.view.bounds.size.width-30*HEIGHT)/2, 40*HEIGHT);
        [self.startButton setTitleColor:[UIColor whiteColor] forState:normal];
        [self.startButton addTarget:self action:@selector(startButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.startButton];
        
        // 收藏按钮
        self.saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
      
        self.saveButton.layer.cornerRadius = 4;
        [self.saveButton setTitleColor:[UIColor whiteColor] forState:normal];
        self.saveButton.titleLabel.font = [UIFont systemFontOfSize:18];
        self.saveButton.backgroundColor = [UIColor colorWithRed:288/255.0 green:85/255.0 blue:33/255.0 alpha:1];
        self.saveButton.frame = CGRectMake(((self.view.bounds.size.width-30*HEIGHT)/2+(10+10)*HEIGHT), (self.view.bounds.size.height / 4 + (30+70)*HEIGHT), (self.view.bounds.size.width-30*HEIGHT)/2, 40*HEIGHT);
        [self.saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.saveButton];
        
        [self.saveButton setTitle:@"收藏" forState:normal];
         //判断是否收藏
        
        [db createTable];
        NSArray *collectArr = [db query];
        NSLog(@"%@",collectArr);
        NSString *str = [NSString stringWithFormat:@"%@",self.comicId];
        for (NSInteger i = 0; i < collectArr.count; i++) {
            KindModel *kind = [collectArr objectAtIndex:i];
            if ([kind.classify_id isEqualToString:str]) {
                [self.saveButton setTitle:@"已收藏" forState:normal];
                self.mark = !_mark;
            }
        }
      
                [self.collectionView reloadData];
        
    }];
    
}

- (void)popButtonAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonAction:(UIButton *)but
{
    if (self.button.tag == 99) {
        [UIView animateWithDuration:0.5 animations:^{
        self.backView.frame = CGRectMake(0, (self.view.bounds.size.height / 2.8 + (10 + 28+50)*HEIGHT), self.view.bounds.size.width, self.view.bounds.size.height);
        self.detailLabel.numberOfLines = 0;
        self.button.frame = CGRectMake((self.view.bounds.size.width / 10 * 9 - 10*HEIGHT), 280*HEIGHT, 40*HEIGHT, 20*HEIGHT);
        [self.button setTitle:@"合起∧" forState:normal];
        [self.detailLabel sizeToFit];
        }];
        self.button.tag = 100;
    }else if (self.button.tag == 100){
        
        [UIView animateWithDuration:0.5 animations:^{
            self.button.tag = 99;
            [self.button setTitle:@"展开∨" forState:normal];
            [self.button setTitle:@"展开∨" forState:normal];
            self.button.frame = CGRectMake((self.view.bounds.size.width / 10 * 9 - 10*HEIGHT), 75*HEIGHT, 40*HEIGHT, 20*HEIGHT);
            self.detailLabel.numberOfLines = 4;
            [self.detailLabel sizeToFit];
            self.backView.frame = CGRectMake(0, (self.view.bounds.size.height / 2.8 + (10 + 28+50)*HEIGHT), self.view.bounds.size.width, (self.view.bounds.size.height / 7 + 10*HEIGHT));

        }];
    }
    
    
}
//收藏的方法实现
- (void)saveButtonAction:(UIButton *)btn
{
    FMDBHandler *db = [FMDBHandler shareInstance];
    
    [db createTable];
    
    KindModel *kind = [[KindModel alloc]init];
    
    kind.classify_id=self.classify_id;
    kind.classify_url = self.classify_url;
    kind.classify_title = self.classify_title;
    kind.only = @"b";
    NSLog(@"//%@",kind);
    if (_mark == NO) {
        [self.saveButton setTitle:@"已收藏" forState:normal];
        
        [db insertData:kind];
        NSString *str = [NSString stringWithFormat:@"该漫画已经收藏在您的收藏夹中"];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alertView show];
    }
    else
    {
        [self.saveButton setTitle:@"收藏" forState:normal];
        [db deleteData:kind];
        NSString *str = [NSString stringWithFormat:@"该漫画已经在您的收藏夹中删除"];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alertView show];

    }
 self.mark = !_mark;
    NSNotificationCenter *collectCenter = [NSNotificationCenter defaultCenter];
    [collectCenter postNotificationName:@"changeName" object:self userInfo:@{@"key":@"value"}];

    NSLog(@"000000000%@",db.query);
    
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"漫画共有:%ld卷",self.booksArray.count);
    
    return self.booksArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TotalDetailsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InsidePageReuse" forIndexPath:indexPath];
    
    AnimationModel *animationModel = [self.booksArray objectAtIndex:indexPath.item];
    
    cell.titleLabel.text = animationModel.name;
    if (indexPath.item == _bigPage) {
        cell.titleLabel.layer.borderWidth = 1;
        cell.titleLabel.layer.borderColor = [[UIColor colorWithRed:288/255.0 green:85/255.0 blue:33/255.0 alpha:1]CGColor];
    }
    else{
        cell.titleLabel.layer.borderWidth = 0.5;
        cell.titleLabel.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    }

    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击");
    LookViewController *lookVC = [[LookViewController alloc]init];
    lookVC.mark = @"second";
    AnimationModel *anmitionModel = [self.booksArray objectAtIndex:indexPath.item];
    NSLog(@"id%@",anmitionModel.cartoonId);
    lookVC.carId = anmitionModel.cartoonId;
    lookVC.bookId = self.comicId;
    lookVC.name = self.name;
    lookVC.everyname = anmitionModel.name;
    lookVC.listArr = _booksArray;
    lookVC.indexPath = indexPath.item;
    lookVC.part = _bigPage;
    lookVC.page = _smallPage;
    NSLog(@"last%ld",_smallPage);
    lookVC.only = @"b";
    lookVC.imageStr = self.classify_url;
    [self presentViewController:lookVC animated:YES completion:nil];
    
    
}
- (void)startButtonAction:(UIButton *)btn
{
    LookViewController *lookVC = [[LookViewController alloc]init];
    lookVC.mark = @"second";
    AnimationModel *model = [self.booksArray objectAtIndex:_bigPage];
    lookVC.name = self.name;
    lookVC.everyname = model.name;
    lookVC.carId = model.cartoonId;
    lookVC.bookId = self.comicId;
    lookVC.listArr = _booksArray;
    lookVC.part = _bigPage;
    lookVC.indexPath = _bigPage;
    lookVC.page = _smallPage;
    lookVC.only = @"b";
    lookVC.imageStr = self.classify_url;
    [self presentViewController:lookVC animated:YES completion:nil];
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
