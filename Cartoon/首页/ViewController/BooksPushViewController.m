//
//  BooksPushViewController.m
//  Cartoon
//
//  Created by dllo on 15/10/28.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//
#define Screen_Width self.view.bounds.size.width
#define Screen_Height self.view.bounds.size.height
#import "BooksPushViewController.h"
#import "AnimationCollectionViewCell.h"
#import "AnimationModel.h"
#import "DetailModel.h"
#import "LookViewController.h"
#import "FMDBHandler.h"
#import "RecordModel.h"

@interface BooksPushViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIView *backView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *detailLabel;

@property (nonatomic,strong) UIButton *button;

@property (nonatomic,strong) UIButton *startButton;

@property (nonatomic,strong) UIButton *saveButton;

@property (nonatomic, strong) UIButton *popButton;
@property (nonatomic, assign) NSInteger bigPage;
@property (nonatomic, assign) NSInteger smallPage;
@property (nonatomic, assign) BOOL mark; // 收藏状态
@property (nonatomic, strong) UIImageView *upBackView;
@property (nonatomic, strong) UIVisualEffectView *mohu;
@property (nonatomic, strong) MBProgressHUD *hud;


@end

@implementation BooksPushViewController

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"视图将要出现");
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.translucent = YES;
    
    CATransition *ani4 = [CATransition animation];
    ani4.duration = 0.2;
    ani4.subtype = kCATransitionFade;
    
    [self.navigationController.navigationBar.layer addAnimation:ani4 forKey:nil];
    [self.tabBarController.tabBar.layer addAnimation:ani4 forKey:nil];
    FMDBHandler *db = [FMDBHandler shareInstance];
    [db createTableRead];
    NSArray *array = [db selectAllRead];
    for (NSInteger i = 0; i <array.count; i++) {
        RecordModel *readModel = [array objectAtIndex:i];
        if ([readModel.name isEqualToString:self.name]) {
            self.bigPage = [readModel.bigPage integerValue];
            self.smallPage = [readModel.smallPage integerValue];
            [self.startButton setTitle:@"继续观看" forState:normal];
            [self.collectionView reloadData];
        }
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"视图已经出现");
    self.mark = NO;

    [self getValuesForInternet];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"漫画的ID是:%@",self.booksId);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((Screen_Width-20-40)/4, Screen_Width*30/375);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.minimumLineSpacing = 20;
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, Screen_Width*(220+85)/375+Screen_Width*105/375, Screen_Width, self.view.bounds.size.height -(Screen_Width*(220+85)/375+Screen_Width*110/375)) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[AnimationCollectionViewCell class] forCellWithReuseIdentifier:@"InsidePageReuse"];
    [self.view addSubview:self.collectionView];
    
    
    self.upBackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Width*180/375)];
    
    [self.view addSubview:_upBackView];
    
    
    self.mohu =[[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _mohu.frame = CGRectMake(0, 0, Screen_Width, Screen_Width*180/375);
    _mohu.alpha = 1;
    [self.upBackView addSubview:_mohu];
    
    self.popButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.popButton.frame = CGRectMake(10, 25, 30, 30);
    [self.popButton setImage:[UIImage imageNamed:@"iconfont-jiantouzuo.png"] forState:UIControlStateNormal];
    self.popButton.tintColor = [UIColor whiteColor];
    self.popButton.backgroundColor = [UIColor colorWithRed:153/255.0 green:203/255.0 blue:75/255.0 alpha:1];
    self.popButton.layer.masksToBounds = YES;
    self.popButton.layer.cornerRadius = 15;
    [self.popButton addTarget:self action:@selector(popButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_popButton];

    
}


- (void)getValuesForInternet
{
    
    UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-40,180, 80, 80)];
    NSMutableArray *imageArr = [NSMutableArray array];
    for (NSInteger i = 0; i < 8; i ++) {
        NSString *picStr = [NSString stringWithFormat:@"refresh_lu_run%ld.png",(long)i];
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
    

    NSString *str = [NSString stringWithFormat:@"http://api.dmgezi.com/comic/books/%@.json",self.booksId];
    
    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[ NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    self.pageDic = [NSMutableDictionary dictionary];
    self.detailArray = [NSMutableArray array];
    self.booksArray = [NSMutableArray array];
    
    [NetHandler dataWithUrl:str complant:^(NSData *data) {
        
        self.pageDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        self.detailArray = [NSMutableArray array];
                            
        self.detailArray = [self.pageDic objectForKey:@"properties"];
        

        NSMutableArray *array = [self.pageDic objectForKey:@"chapters"];
        
        for (NSMutableDictionary *dic in array) {
            
            AnimationModel *AnimaModel = [[AnimationModel alloc]init];
            
            [AnimaModel setValuesForKeysWithDictionary:dic];
            
            [self.booksArray addObject:AnimaModel];
            
        }
        
        [_upBackView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[self.pageDic objectForKey:@"cover"]]]];
        
        
        UIView *blackLine = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_Width*(220+80)/375, self.view.bounds.size.width, 0.5)];
        blackLine.alpha = 0.6;
        blackLine.backgroundColor = [UIColor grayColor];
        [_mohu addSubview:blackLine];
        
        
        UIImageView *leftPic = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_Width/2-Screen_Width*60/375, Screen_Width*60/375, Screen_Width*120/375, Screen_Width*160/375)];
        leftPic.clipsToBounds = YES;
        leftPic.layer.cornerRadius = 15;
        leftPic.layer.borderWidth = 2;
        leftPic.layer.borderColor = [[UIColor whiteColor]CGColor];
        [leftPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[self.pageDic objectForKey:@"cover"]]]];
        [self.view addSubview:leftPic];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Screen_Width*220/375, self.view.bounds.size.width, Screen_Width*30/375)];
        _titleLabel.text = [self.pageDic objectForKey:@"name"];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_titleLabel];
        

        
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_Width*(220+85)/375, self.view.bounds.size.width, Screen_Width*105/375)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.backView];
        
        self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.view.bounds.size.width - 15, Screen_Width*166/375)];
        
        self.detailLabel.numberOfLines = 4;
        self.detailLabel.font = [UIFont systemFontOfSize:14];
        self.detailLabel.textColor = [UIColor blackColor];
        self.detailLabel.text = [self.pageDic objectForKey:@"description"];
        [self.detailLabel sizeToFit];
        [self.backView addSubview:self.detailLabel];
        
        
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.button setTitle:@"展开∨" forState:normal];
        self.button.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.button setTitleColor:[UIColor colorWithRed:149/255.0 green:198/255.0 blue:64/255.0 alpha:1] forState:normal];
        self.button.frame = CGRectMake(Screen_Width*327/375, 75, 40, 20);
        [self.backView  addSubview:self.button];
        self.button.tag = 99;
        
        [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.startButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.startButton setTitle:@"开始阅读" forState:normal];
        FMDBHandler *db = [FMDBHandler shareInstance];
        [db createTableRead];
        NSArray *arr = [db selectAllRead];
        for (NSInteger i = 0; i <arr.count; i++) {
            RecordModel *readModel = [arr objectAtIndex:i];
            if ([readModel.name isEqualToString:self.name]) {
                [self.startButton setTitle:@"继续观看" forState:normal];
            }
        }

        self.startButton.titleLabel.font = [UIFont systemFontOfSize: 18];
        self.startButton.backgroundColor = [UIColor colorWithRed:149/255.0 green:198/255.0 blue:64/255.0 alpha:1];
        self.startButton.layer.cornerRadius = 4;
        self.startButton.frame = CGRectMake(10, Screen_Width*(220+35)/375, (self.view.bounds.size.width-30)/2, Screen_Width*40/375);
        [self.startButton setTitleColor:[UIColor whiteColor] forState:normal];
        [self.startButton addTarget:self action:@selector(startButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.startButton];
        
        
        self.saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.saveButton setTitle:@"收藏" forState:normal];
        self.saveButton.layer.cornerRadius = 4;
        [self.saveButton setTitleColor:[UIColor whiteColor] forState:normal];
        self.saveButton.titleLabel.font = [UIFont systemFontOfSize:18];
        self.saveButton.backgroundColor = [UIColor colorWithRed:288/255.0 green:85/255.0 blue:33/255.0 alpha:1];
        self.saveButton.frame = CGRectMake((self.view.bounds.size.width-30)/2+10+10, Screen_Width*(220+35)/375, (self.view.bounds.size.width-30)/2, Screen_Width*40/375);
        [self.view addSubview:self.saveButton];
        [self.saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        //判断是否收藏
        [db createTable];
        NSArray *collectArr = [db query];

        NSString *str = [NSString stringWithFormat:@"%@",self.booksId];
        NSLog(@"-----%@",self.booksId);
        for (NSInteger i = 0; i < collectArr.count; i++) {
            KindModel *model = [collectArr objectAtIndex:i];
            if ([model.classify_id isEqualToString:str]) {
                [self.saveButton setTitle:@"已收藏" forState:normal];
                self.mark = !_mark;
            }
        }
        if (self.booksArray.count != 0) {
            self.hud.hidden = YES;
            //移除遮罩

        }
          [self.collectionView reloadData];
    }];
}

- (void)buttonAction:(UIButton *)but
{
    if (self.button.tag == 99) {
        [UIView animateWithDuration:0.5 animations:^{
            self.backView.frame = CGRectMake(0, Screen_Width*(220+85)/375, self.view.bounds.size.width, self.view.bounds.size.height);
            self.detailLabel.numberOfLines = 0;
            self.button.frame = CGRectMake(Screen_Width*327/375, 75+self.view.bounds.size.height -(Screen_Width*(220+85)/375+Screen_Width*110/375), 40, 20);
            [self.button setTitle:@"合起∧" forState:normal];
            [self.detailLabel sizeToFit];
        }];
        self.button.tag = 100;
    }else if (self.button.tag == 100){
        
        [UIView animateWithDuration:0.5 animations:^{
        self.button.tag = 99;
        [self.button setTitle:@"展开∨" forState:normal];
        self.button.frame = CGRectMake(Screen_Width*327/375, 75, 40, 20);
        self.detailLabel.numberOfLines = 4;
        [self.detailLabel sizeToFit];
        self.backView.frame = CGRectMake(0, Screen_Width*(220+85)/375, self.view.bounds.size.width, Screen_Width*105/375);
         }];
    }
    
    
}
//收藏的方法实现
- (void)saveButtonAction:(UIButton *)btn
{
    FMDBHandler *db = [FMDBHandler shareInstance];
    
    [db createTable];
    
    KindModel *kind = [[KindModel alloc]init];

    kind.classify_id=[self.pageDic objectForKey:@"id"];
    kind.classify_url = [NSString stringWithFormat:@"http://%@",[self.pageDic objectForKey:@"cover"]];
    kind.classify_title = [self.pageDic objectForKey:@"name"];
    kind.only = @"a";
    NSLog(@"--%d",self.mark);
    if (_mark == NO) {
        [self.saveButton setTitle:@"已收藏" forState:normal];
        
        [db insertData:kind];
        NSString *str = [NSString stringWithFormat:@"该漫画已经收藏在您的收藏夹中"];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        
        [alertView show];
        NSLog(@"插入%d",_mark);
        NSLog(@"收藏");
        
    }
    else
    {
        [self.saveButton setTitle:@"收藏" forState:normal];
        [db deleteData:kind];
        NSString *str = [NSString stringWithFormat:@"该漫画已经在您的收藏夹中删除"];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alertView show];
        NSLog(@"删除%d",_mark);
        NSLog(@"删除");
        
    }
    self.mark = !_mark;
    NSLog(@"最后%d",_mark);
    NSNotificationCenter *collectCenter = [NSNotificationCenter defaultCenter];
    [collectCenter postNotificationName:@"changeName" object:self userInfo:@{@"key":@"value"}];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"漫画共有:%ld卷",self.booksArray.count);
    
    return self.booksArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AnimationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InsidePageReuse" forIndexPath:indexPath];
    
    AnimationModel *model = [self.booksArray objectAtIndex:indexPath.item];
    
    cell.numberLabel.text = model.name;
    if (indexPath.item == _bigPage) {
        cell.numberLabel.layer.borderWidth = 1;
        cell.numberLabel.layer.borderColor = [[UIColor colorWithRed:288/255.0 green:85/255.0 blue:33/255.0 alpha:1]CGColor];
    }
    else{
        cell.numberLabel.layer.borderWidth = 0.5;
         cell.numberLabel.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    }
    
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LookViewController *lookVC = [[LookViewController alloc]init];
    AnimationModel *model = [self.booksArray objectAtIndex:indexPath.item];
    lookVC.name = [NSString stringWithFormat:@"%@ %@",_titleLabel.text,model.name];
    lookVC.cartoonId = model.cartoonId;
    lookVC.listArr = _booksArray;
    lookVC.indexPath = indexPath.item;
    lookVC.part = _bigPage;
    lookVC.page = _smallPage;
    lookVC.only = @"a";
    [self presentViewController:lookVC animated:YES completion:nil];
}
- (void)startButtonAction:(UIButton *)btn
{
    LookViewController *lookVC = [[LookViewController alloc]init];
    
    AnimationModel *model = [self.booksArray objectAtIndex:_bigPage];
    lookVC.name = [NSString stringWithFormat:@"%@ %@",_titleLabel.text,model.name];
    lookVC.cartoonId = model.cartoonId;
    lookVC.listArr = _booksArray;
    lookVC.part = _bigPage;
    lookVC.indexPath = _bigPage;
    lookVC.page = _smallPage;
    lookVC.only = @"a";
    
    [self presentViewController:lookVC animated:YES completion:nil];
    
}
- (void)popButtonAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
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
