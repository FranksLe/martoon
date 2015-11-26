//
//  LookViewController.m
//  Cartoon
//
//  Created by dllo on 15/10/31.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//
#define Screen_Width self.view.bounds.size.width
#define Screen_Height self.view.bounds.size.height
#define WEAKSELF(weakSelf) __weak typeof(&*self) weakSelf = self

#import "LookViewController.h"
#import "MyCell.h"
#import "CartoonModel.h"
#import "ListCollectionViewCell.h"
#import "AnimationModel.h"
#import "FMDBHandler.h"
#import "RecordModel.h"
#import "KindModel.h"
#import<ShareSDK/ShareSDK.h>
#import<ShareSDKUI/ShareSDKUI.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"

@interface LookViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSString *netStr;//网络接口
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) BOOL topBool;//上下view
@property (nonatomic, assign) BOOL dirBool;//滚动方向
@property (nonatomic, assign) BOOL listBool;//选集列表
@property (nonatomic, assign) BOOL lightBool;//亮度
@property (nonatomic, assign) BOOL screenBool;//横竖屏
@property (nonatomic, strong) UIImageView *promptImageView;//提示图
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIButton *directionButton;
@property (nonatomic, strong) UIButton *lightButton;
@property (nonatomic, strong) UIButton *screenButton;

@property (nonatomic, strong) UIView *lightView;
@property (nonatomic, strong) UICollectionView *listCollectionView;
@property (nonatomic, strong) UIImageView *partImageView;
@property (nonatomic, strong) NSMutableArray *scrollArr;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UISlider *lightSlider;//亮度条
@property (nonatomic, strong) UICollectionViewFlowLayout *listFlowLayout;//选集列表
@property (nonatomic, strong) UIButton *listButton;//列表按钮
@property (nonatomic, strong) UIImageView *rightImageView;//亮度右侧图片

@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) NSString *string;//剧集
@property (nonatomic, strong) NSString *networkStr;
@property (nonatomic, strong) Reachability *reach;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *shareImageView;

@end

@implementation LookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.listBool= YES;
    self.lightBool = YES;
    self.scrollArr = [NSMutableArray array];
    self.shareImageView = [[UIImageView alloc]init];
    NSLog(@"视图出现");

    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout.itemSize = CGSizeMake(Screen_Width-20, Screen_Height-20);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.flowLayout.minimumLineSpacing = 20;
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1];
    [self.view addSubview:_collectionView];

    //隐藏状态栏
    [self prefersStatusBarHidden];
    
    self.listFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    _listFlowLayout.itemSize = CGSizeMake((Screen_Width-60)/2, 30);
    _listFlowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    _listFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _listFlowLayout.minimumLineSpacing = 5;
    self.listCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(20, 64, Screen_Width-40, Screen_Height-120-64) collectionViewLayout:_listFlowLayout];
    self.listCollectionView.delegate = self;
    self.listCollectionView.dataSource = self;
    self.listCollectionView.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1];
    [self.view addSubview:_listCollectionView];
    self.listCollectionView.hidden = YES;

    
    NSLog(@"first%ld",self.page);
    //创建UIActivityIndicatorView背底半透明View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,64, Screen_Width, Screen_Height+49)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.4];
    [self.view addSubview:view];
    //加载动画
    UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_Width/2-50,170, 100, 100)];
    NSMutableArray *imageArr = [NSMutableArray array];
    for (NSInteger i = 1; i < 31; i ++) {
        NSString *picStr = [NSString stringWithFormat:@"l100%ld.gif",i];
        UIImage *image = [UIImage imageNamed:picStr];
        [imageArr addObject:image];
    }
    animatedImageView.animationImages = imageArr;
    animatedImageView.animationDuration = 2.5f;
    animatedImageView.animationRepeatCount = 0;
    [self.view addSubview: animatedImageView];
    [animatedImageView startAnimating];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.color=[UIColor whiteColor];
    _hud.mode = MBProgressHUDModeCustomView;
    //    _hud.labelText = @"加载中...";
    _hud.customView= animatedImageView;
    
    //状态条
    self.stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width-150, Screen_Height-15, 150, 15)];
    self.stateLabel.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0.9];
    self.stateLabel.textColor = [UIColor whiteColor];
    self.stateLabel.font = [UIFont systemFontOfSize:10];
    self.stateLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_stateLabel];
    
    // 创建Reachability
    self.reach = [Reachability reachabilityForInternetConnection];
    // 开始监控网络(一旦网络状态发生改变, 就会发出通知kReachabilityChangedNotification)
    [self.reach startNotifier];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFunc) userInfo:nil repeats:YES];
    

    
    //顶部View
    self.topView = [[UIView alloc]init];
    self.topView.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0.9];
   [self.view addSubview:_topView];


    self.listButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_listButton addTarget:self action:@selector(partButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:_listButton];
    
    //标题
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = self.name;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.titleLabel sizeToFit];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:_titleLabel];
    
    //箭头
    self.partImageView = [[UIImageView alloc]init ];
    _partImageView.image = [UIImage imageNamed:@"bookread_downpartlist_img.png"];
    [self.topView addSubview:_partImageView];
    
    
    //退出按钮
    UIButton *popButton = [UIButton buttonWithType:UIButtonTypeSystem];
    popButton.frame = CGRectMake(10, 20, 30, 30);
    [popButton setBackgroundImage:[UIImage imageNamed:@"iconfont-jiantouzuo.png"] forState:UIControlStateNormal];
    [popButton addTarget:self action:@selector(popButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:popButton];
    
    //提示图;
    self.promptImageView = [[UIImageView alloc]init ];
    self.promptImageView.hidden = YES;
    self.promptImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_promptImageView];
    
    //调节亮度View
    self.lightView = [[UIView alloc]init];
    self.lightView.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0.9];
    self.lightView.hidden = YES;
    [self.view addSubview:_lightView];
    
    //亮度调节slider
    self.lightSlider = [[UISlider alloc]init];
    [_lightSlider addTarget:self action:@selector(lightSliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.lightSlider setMinimumTrackImage:[UIImage imageNamed:@"welfare_segmentedArrow.png"] forState:UIControlStateNormal];
    [_lightSlider setThumbImage:[UIImage imageNamed:@"iconfont-slider.png"] forState:UIControlStateNormal];
    [self.lightView addSubview:_lightSlider];
    
    //亮度图片
    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    leftImageView.image = [UIImage imageNamed:@"read_change_brightness_nor.png"];
    [self.lightView addSubview:leftImageView];
    
    self.rightImageView = [[UIImageView alloc]init];
    _rightImageView.image = [UIImage imageNamed:@"read_brightness_nor.png"];
    [self.lightView addSubview:_rightImageView];
    
    //底部View
    
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0.9];
    [self.view addSubview:_bottomView];
    
    //进度条
    self.slider = [[UISlider alloc]init];
    [self.slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.slider setThumbImage:[UIImage imageNamed:@"iconfont-slider.png"] forState:UIControlStateNormal];
    [self.slider setMinimumTrackImage:[UIImage imageNamed:@"welfare_segmentedArrow.png"] forState:UIControlStateNormal];
    [self.bottomView addSubview:_slider];
    
    //纵向滑动按钮
    self.directionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _directionButton.tintColor = [UIColor whiteColor];
    [_directionButton setImage:[UIImage imageNamed:@"bookRead_vertical_scroll.png"] forState:UIControlStateNormal];
    [_directionButton addTarget:self action:@selector(directionAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:_directionButton];
    
    //页码
    self.pageLabel = [[UILabel alloc]init];
    self.pageLabel.textColor = [UIColor whiteColor];
    self.pageLabel.font = [UIFont systemFontOfSize:14];
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomView addSubview:_pageLabel];
    
    //分享按钮
    self.shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.shareButton setImage:[UIImage imageNamed:@"read_share_nor.png"] forState:UIControlStateNormal];
    self.shareButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.shareButton.tintColor = [UIColor whiteColor];
    [self.shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:_shareButton];
    
    //存图
    self.saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.saveButton setImage:[UIImage imageNamed:@"read_savepic_nor.png"] forState:UIControlStateNormal];
    self.saveButton.tintColor = [UIColor whiteColor];
    [self.saveButton addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:_saveButton];
    
    //亮度按钮
    self.lightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.lightButton setImage:[UIImage imageNamed:@"read_brightness_nor.png"] forState:UIControlStateNormal];
    self.lightButton.tintColor = [UIColor whiteColor];
    [self.lightButton addTarget:self action:@selector(lightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:_lightButton];
    
    //横竖屏
    self.screenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.screenButton setImage:[UIImage imageNamed:@"read_landscape_mode_nor.png"] forState:UIControlStateNormal];
    self.screenButton.tintColor = [UIColor whiteColor];
    [self.screenButton addTarget:self action:@selector(screenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:_screenButton];

    
    [self viewFrame];
    //点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.collectionView addGestureRecognizer:tap];
    
    
    [self.collectionView registerClass:[MyCell class] forCellWithReuseIdentifier:@"look"];
    [self.listCollectionView registerClass:[ListCollectionViewCell class] forCellWithReuseIdentifier:@"list"];
     [self cartoonData];
    
}
- (void)timerFunc
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable)
    { // 有wifi
        self.networkStr = @"WiFi";
    }
    else if ([conn currentReachabilityStatus] != NotReachable)
    { // 没有使用wifi, 使用手机自带网络进行上网
        self.networkStr = @"蜂窝";
    }
    else {
        self.networkStr = @"无网络链接";
    }
    if ([self.mark isEqualToString:@"second"]) {
        self.string = self.everyname;
    }
    else{
        self.string = [self.dataDic objectForKey:@"name"];
    }
   
    self.stateLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",_string,self.pageLabel.text,timestamp,self.networkStr];
}
- (void)cartoonData
{
    if ([self.mark isEqualToString:@"second"]) {
        NSString *str1 = [NSString stringWithFormat:@"http://mobilev3.ac.qq.com/Comic/chapterPictureListForIos/uin/0/local_version/3.1.0/channel/1001/guest_id/943AAD67-2C90-414B-A21F-D9BE0A1E80F6/comic_id/%@/cid/%@/uin/0/local_version/3.1.0/channel/1001/guest_id/943AAD67-2C90-414B-A21F-D9BE0A1E80F6",self.bookId,self.carId];
        self.count = _indexPath;
        [NetHandler dataWithUrl:str1 complant:^(NSData *data) {
            NSLog(@"的二个页码c%ld",_page);
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

            NSArray *array = [[dataDic objectForKey:@"data"] objectForKey:@"img_infos"];
            self.cartoonArr = [CartoonModel baseModelByArr:array];
            
            self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",self.name,self.everyname];
            
            [self networkDataParameter];

        }];
    }
    else{
    
    NSString *str = [NSString stringWithFormat:@"http://api.dmgezi.com/comic/chapters/%@.json",_cartoonId];
    NSLog(@"%@",_cartoonId);
    self.netStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [NetHandler dataWithUrl:_netStr complant:^(NSData *data) {
        self.dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = [_dataDic objectForKey:@"pages"];
        
        self.cartoonArr = [CartoonModel baseModelByArr:arr];
    
        self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",[[self.dataDic objectForKey:@"book"]objectForKey:@"name"],[self.dataDic objectForKey:@"name"]];
        [self networkDataParameter];
        }];
    }
}

- (void)networkDataParameter
{
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(Screen_Width/2, (self.topView.bounds.size.height+20)/2);
    self.partImageView.frame =  CGRectMake(Screen_Width/2+self.titleLabel.bounds.size.width/2, (self.topView.bounds.size.height+20)/2-self.titleLabel.bounds.size.height/2+3, 12, 12);
    //页码label赋值
    if (self.part == _indexPath) {
        NSLog(@"第二个页码%ld",_page);
        if (_page == 0) {
            self.pageLabel.text = [NSString stringWithFormat:@"1/%ld",self.cartoonArr.count];
        }
        else{
            self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.page,self.cartoonArr.count];
        }
        self.slider.value = _page;
    }
    else{
        self.pageLabel.text = [NSString stringWithFormat:@"1/%ld",self.cartoonArr.count];
        self.slider.value = 0;
    }
    self.slider.maximumValue = self.cartoonArr.count-1;
    if (self.cartoonArr.count != 0) {
        //加载数据隐藏
        self.hud.hidden = YES;
        //移除遮罩
        UIView *view = (UIView*)[self.view viewWithTag:108];
        [view removeFromSuperview];
    }
    [self.collectionView reloadData];
    if (_part == _indexPath) {
        self.collectionView.contentOffset = CGPointMake(_page*Screen_Width, _page*Screen_Height);
    }
    else{
        self.collectionView.contentOffset = CGPointMake(0*Screen_Width, 0*Screen_Height);
    }

}

//图片保存到本地
- (void)saveClick:(UIButton *)btn
{
    NSLog(@"%ld",_page);
    CartoonModel *cartoonModel = [self.cartoonArr objectAtIndex:_page];
    UIImageView *imageview = [[UIImageView alloc]init];
    [imageview sd_setImageWithURL:[NSURL URLWithString:cartoonModel.cartoonImage]];
    UIImageWriteToSavedPhotosAlbum(imageview.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

//imageSavedToPhotosAlbum 保存到本地的状态

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = [NSString string];
    if (!error) {
        message = @"保存成功";
    }else
    {
        message = @"保存失败";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertController animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _collectionView) {
        return self.cartoonArr.count;
    }
    if (collectionView == _listCollectionView) {
        return self.listArr.count;
    }
    else{
        return 0;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _collectionView) {
        MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"look" forIndexPath:indexPath];
        
        CartoonModel *cartoonModel = [self.cartoonArr objectAtIndex:indexPath.item];
        if (indexPath.item <self.cartoonArr.count-1 ) {
            CartoonModel *model = [self.cartoonArr objectAtIndex:indexPath.item+1];
            [self.shareImageView sd_setImageWithURL:[NSURL URLWithString:model.cartoonImage]];
        }
        
        cell.bigPage.text = [NSString stringWithFormat:@"%ld",indexPath.item+1];
        [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:cartoonModel.cartoonImage]];
        
        cell.scrollView.zoomScale = 1.0;

        cell.index = indexPath.item;
        if (cell.myImageView.image != nil) {
            cell.bigPage.hidden = YES;
        }
        else {
            cell.bigPage.hidden = NO;
        }
        return cell;
    }
    if (collectionView == _listCollectionView) {
        ListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"list" forIndexPath:indexPath];
        AnimationModel *animationModel = [self.listArr objectAtIndex:indexPath.item];
        cell.nameLabel.text = animationModel.name;
        
        return cell;
    }
    else{
        return nil;
    }

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _listCollectionView) {
        AnimationModel *animationModel = [self.listArr objectAtIndex:indexPath.item];
        if ([self.mark isEqualToString:@"second"]) {
            self.carId = animationModel.cartoonId;
            self.everyname = [NSString stringWithFormat:@"%ld",indexPath.item+1];
            self.titleLabel.text = [NSString stringWithFormat:@"%@ %@ ",self.name,self.everyname];
            self.listCollectionView.hidden = YES;
            self.indexPath = indexPath.item;
            self.page = 0;
            self.listBool = YES;
            [self cartoonData];
        }
        else{
        self.cartoonId = animationModel.cartoonId;
        self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",[[self.dataDic objectForKey:@"book"]objectForKey:@"name"],animationModel.name];
            self.listCollectionView.hidden = YES;
            self.indexPath = indexPath.item;
            self.page = 0;
            self.listBool = YES;
        [self cartoonData];
        }
     
        }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _collectionView) {
    int halfX = Screen_Width / 2;
    int halfY = Screen_Height / 2;
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        self.page = (_collectionView.contentOffset.x  - halfX) / Screen_Width +1;
    }
    else{
        self.page = (_collectionView.contentOffset.y  - halfY) / Screen_Height +1;
        }
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",_page+1,self.cartoonArr.count];
    self.slider.value = _page;

    //滑动到最后自动下一话
    if (_collectionView.contentOffset.x > (self.cartoonArr.count-1)*Screen_Width+30 || _collectionView.contentOffset.y> (self.cartoonArr.count-1)*Screen_Height+30) {
        AnimationModel *model = [self.listArr lastObject];
        if ([self.mark isEqualToString:@"second"]) {
            if ([self.everyname isEqualToString:model.name]) {
                [self lastPageprompt];
            }
            else {
                self.count = _count +1;
                AnimationModel *animationModel = [self.listArr objectAtIndex:_count];
                self.carId = animationModel.cartoonId;

                NSInteger num = [self.everyname integerValue];
                num = num+1;
        
                self.everyname = [NSString stringWithFormat:@"%ld",num];
                self.indexPath = _indexPath+1;
                [self cartoonData];
            }

        }
        else{
        if ([[self.dataDic objectForKey:@"name"] isEqualToString:model.name]) {
            [self lastPageprompt];
        }
        else {
        self.cartoonId = [NSString stringWithFormat:@"%@",[[self.dataDic objectForKey:@"next"]objectForKey:@"id"]];
            self.indexPath = _indexPath+1;
        [self cartoonData];
        }
        }
    }
}
    
}
//最后一话提示
- (void)lastPageprompt
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经是最后一话了" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });

}

//点击手势
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    self.promptImageView.hidden = YES;
    self.lightView.hidden = YES;
    self.lightBool = YES;
    self.listCollectionView.hidden = YES;
    self.listBool = YES;
    
    CGPoint point = [tap locationInView:self.collectionView];
    NSLog(@"%f,%f",point.x,point.y);
//
//    //  获取UIImageView的范围,四个顶点坐标(左上,左下,右下,右上,左上),围成一个圈
//    CGMutablePathRef pathRef=CGPathCreateMutable();
//    CGPathMoveToPoint(pathRef, NULL, widthScreen * 25 / 375,  heightScreen * 176 / 667);
//    CGPathAddLineToPoint(pathRef, NULL, widthScreen * 25 / 375, heightScreen * 176 / 667 + heightScreen * 325 / 667);
//    CGPathAddLineToPoint(pathRef, NULL, widthScreen * 25 / 375 +  widthScreen * 325 / 375, heightScreen * 176 / 667 + heightScreen * 325 / 667);
//    CGPathAddLineToPoint(pathRef, NULL, widthScreen * 25 / 375 + widthScreen * 325 / 375, heightScreen * 176 / 667);
//    CGPathAddLineToPoint(pathRef, NULL, widthScreen * 25 / 375, heightScreen * 176 / 667);
//    CGPathCloseSubpath(pathRef);
//    
//    //  如果在范围内
//    if (CGPathContainsPoint(pathRef, NULL, touchPoint, NO))
//    {
//        NSLog(@"point in path!");
//    }
//    //  如果不在范围内
//    if (!CGPathContainsPoint(pathRef, NULL, touchPoint, NO))
//    {
//        NSLog(@"outPoint out path!");
//        self.hidden = YES;
//    }
    
    
    if (self.topBool) {
    [UIView animateWithDuration:0.4 animations:^{
        self.topView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 64);
        self.bottomView.frame = CGRectMake(0, self.view.bounds.size.height-100, self.view.bounds.size.width, 100);

    } completion:^(BOOL finished) {
        
    }];
        self.topBool = NO;
        
}else
{
    [UIView animateWithDuration:0.4 animations:^{
        self.topView.frame = CGRectMake(0, -64, self.view.bounds.size.width, 65);
        self.bottomView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 100);
    } completion:^(BOOL finished) {
        
    }];
    self.topBool = YES;
}
    NSLog(@"%d",_topBool);
    
}

//滑动条方法
- (void)sliderAction:(UISlider *)sl
{   NSInteger num = sl.value;
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        [self.collectionView setContentOffset:CGPointMake(num*self.view.bounds.size.width, 0) animated:NO];
    }
    else{
        [self.collectionView setContentOffset:CGPointMake(0, num*self.view.bounds.size.height) animated:NO];
    }
    
}
//滚动方向切换
- (void)directionAction:(UIButton *)btn
{
    if(!self.dirBool){
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat offect_y = _collectionView.contentOffset.x / Screen_Width * Screen_Height;
    self.collectionView.contentOffset = CGPointMake(0, offect_y);
    [_directionButton setImage:[UIImage imageNamed:@"bookRead_horizontal_scroll.png"] forState:UIControlStateNormal];
        self.promptImageView.image = [UIImage imageNamed:@"tip_bar_ver.png"];
        self.promptImageView.hidden = NO;
        
    }
    else{
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat offect_x = _collectionView.contentOffset.y / Screen_Height * Screen_Width;
        self.collectionView.contentOffset = CGPointMake(offect_x, 0);
        [_directionButton setImage:[UIImage imageNamed:@"bookRead_vertical_scroll.png"] forState:UIControlStateNormal];
        self.promptImageView.image = [UIImage imageNamed:@"tip_bar_hori.png"];
        self.promptImageView.hidden = NO;
    }
    self.dirBool = !_dirBool;
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         self.promptImageView.hidden = YES;
     });
    
}
//亮度按钮
- (void)lightButtonAction:(UIButton *)btn
{
    float value = [UIScreen mainScreen].brightness;
    self.lightSlider.value = value;
    if (self.lightBool == YES) {
        self.lightView.hidden = NO;
    }
    else{
        self.lightView.hidden = YES;
    }
    self.lightBool = !_lightBool;
}
//亮度slider
- (void)lightSliderAction:(UISlider *)sl
{
    [[UIScreen mainScreen] setBrightness:sl.value];
    
}
//退出按钮
- (void)popButtonAction:(UIButton *)btn
{
    RecordModel *model = [[RecordModel alloc]init];
    if ([self.mark isEqualToString:@"second"]) {
        
        model.name = self.name;
        model.pageId = [NSString stringWithFormat:@"%@/%@",self.bookId,self.carId];
        model.imageStr = self.imageStr;
    }
    else{
    model.pageId = [NSString stringWithFormat:@"%@",[[self.dataDic objectForKey:@"book"]objectForKey:@"id"]];
    model.imageStr = [[self.dataDic objectForKey:@"book"]objectForKey:@"cover"];
    model.name = [[self.dataDic objectForKey:@"book"]objectForKey:@"name"];
    }
    model.bigPage = [NSString stringWithFormat:@"%ld",_indexPath];
    model.smallPage = [NSString stringWithFormat:@"%ld",_page];
    NSLog(@"页码%@",model.smallPage);
    model.only = self.only;
    
    
    FMDBHandler *db = [FMDBHandler shareInstance];
    [db createTableRead];
    NSArray *array = [db selectAllRead];
    NSLog(@"数据库数组%@",array);
    if(array.count == 0){
        [db insertRecord:model];
    }
    else{
        for (NSInteger i = 0; i <array.count; i++) {
            RecordModel *readModel = [array objectAtIndex:i];
            if ([readModel.name isEqualToString:model.name]) {
                [db updateRecord:model];
                
            }
            else{
                [db insertRecord:model];
            }
        }
    }
    [self.timer invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];

}
//列表按钮
- (void)partButtonAction:(UIButton *)btn
{
    if (self.listBool == YES) {
        [self.listCollectionView reloadData];
        self.listCollectionView.hidden = NO;
    }
    else{
        self.listCollectionView.hidden = YES;
    }
    self.listBool = !_listBool;
    
    
}
//分享
- (void)shareButtonAction:(UIButton *)button
{
    //创建分享参数
    NSLog(@"%ld",_page);
    CartoonModel *cartoonModel = [self.cartoonArr objectAtIndex:_page];
    
    NSURL *url = [NSURL URLWithString:cartoonModel.cartoonImage];
    [_shareImageView sd_setImageWithURL:url];
    NSData *imageData = UIImageJPEGRepresentation(self.shareImageView.image, 0.5);
    UIImage *image = [UIImage imageWithData: imageData];
    NSLog(@"%@",image);

    NSMutableDictionary *shareParms = [NSMutableDictionary dictionary];
    [shareParms SSDKSetupShareParamsByText:self.titleLabel.text
                                    images:image
                                       url:nil
                                     title:@"分享标题"
                                      type:SSDKContentTypeAuto];

    //进行分享
    [ShareSDK showShareActionSheet:button
                             items:nil
                       shareParams:shareParms
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   switch (state) {
                       case SSDKResponseStateBegin:
                       {
                           NSLog(@"开始分享");
                       }
                           break;
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                       }
                           break;
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                       }
                           break;
                       case SSDKResponseStateCancel:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享取消"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                       }
                           break;
                       default:
                           break;
                   }
               }];

}
//横竖屏切换
- (void)screenButtonAction:(UIButton *)btn
{
//    if ([UIDevice currentDevice].orientation != UIDeviceOrientationPortrait) {
//        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
//        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
//    }else{
//        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
//    }
    
    if (!self.screenBool) {
        [self.screenButton setImage:[UIImage imageNamed:@"read_portrait_mode_nor.png"] forState:UIControlStateNormal];
        
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
        self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
        CGRect frame = [UIScreen mainScreen].bounds;
        NSLog(@"%f",frame.size.height);
        self.view.bounds = CGRectMake(0, 0, frame.size.height, frame.size.width);
        self.flowLayout.itemSize = CGSizeMake(Screen_Width-20, Screen_Width-20);
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.flowLayout.minimumLineSpacing = 20;
        self.collectionView.frame = self.view.bounds;
        self.collectionView.pagingEnabled = NO;
        
        _listFlowLayout.itemSize = CGSizeMake((Screen_Width-60)/2, 30);
        _listFlowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _listFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _listFlowLayout.minimumLineSpacing = 5;
        self.listCollectionView.frame = CGRectMake(20, 64, Screen_Width-40, Screen_Height-120-64);
        
        self.directionButton.enabled = NO;

    }
    else{
        [self.screenButton setImage:[UIImage imageNamed:@"read_landscape_mode_nor.png"] forState:UIControlStateNormal];

        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        self.view.transform = CGAffineTransformMakeRotation(0);
        CGRect frame = [UIScreen mainScreen].bounds;
        NSLog(@"%f",frame.size.height);
        self.view.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.flowLayout.itemSize = CGSizeMake(Screen_Width-20, Screen_Height-20);
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.flowLayout.minimumLineSpacing = 20;
        self.collectionView.frame = self.view.bounds;
        self.collectionView.pagingEnabled = YES;

        
        _listFlowLayout.itemSize = CGSizeMake((Screen_Width-60)/2, 30);
        _listFlowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _listFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _listFlowLayout.minimumLineSpacing = 5;
        self.listCollectionView.frame = CGRectMake(20, 64, Screen_Width-40, Screen_Height-120-64);
        self.directionButton.enabled = YES;
    
    }
    self.screenBool = !_screenBool;
    
    CGFloat offect_y = Screen_Width*_page / Screen_Width * Screen_Height;
    CGFloat offect_x = Screen_Height*_page / Screen_Height * Screen_Width;

    self.collectionView.contentOffset = CGPointMake(offect_x, offect_y);
    self.listCollectionView.hidden = YES;
    self.listBool = YES;
    [self viewFrame];
    
}
//- (void)swipeAction:(UISwipeGestureRecognizer *)swipe
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)viewFrame
{
    self.stateLabel.frame = CGRectMake(Screen_Width-150, Screen_Height-15, 150, 15);
    self.topView.frame = CGRectMake(0, 0, Screen_Width, 64);
    
    _listButton.frame = CGRectMake(40, 20, Screen_Width-70, 30);
    self.titleLabel.center = CGPointMake(Screen_Width/2, (self.topView.bounds.size.height+20)/2);
    self.partImageView.frame = CGRectMake(Screen_Width/2+self.titleLabel.bounds.size.width/2, (self.topView.bounds.size.height+20)/2-self.titleLabel.bounds.size.height/2+3, 12, 12);
    self.promptImageView.frame = CGRectMake(Screen_Width/2-60, Screen_Height/2-60, 120, 120);
    self.lightView.frame = CGRectMake(50, Screen_Height/2-20, Screen_Width-100, 40);
    self.lightSlider.frame = CGRectMake(40,10 , self.lightView.bounds.size.width-80, 20);
    self.rightImageView.frame = CGRectMake( self.lightView.bounds.size.width-40, 0, 40, 40);
    self.bottomView.frame = CGRectMake(0,Screen_Height-100, Screen_Width, 100);
    self.slider.frame = CGRectMake(60,10 , Screen_Width-80, 20);
    self.directionButton.frame = CGRectMake(10, 40, (Screen_Width-60)/5, 40);
    self.pageLabel.frame = CGRectMake(5, 10, 55, 20);
    self.shareButton.frame = CGRectMake(20+(Screen_Width-60)/5, 40, (Screen_Width-60)/5, 40);
    self.saveButton.frame = CGRectMake(30+(Screen_Width-60)/5*2, 40, (Screen_Width-60)/5, 40);
    self.lightButton.frame = CGRectMake(40+(Screen_Width-60)/5*3, 40, (Screen_Width-60)/5, 40);
    self.screenButton.frame = CGRectMake(50+(Screen_Width-60)/5*4, 40, (Screen_Width-60)/5, 40);
}
- (BOOL)prefersStatusBarHidden
{
//    if (self.screenBool == 0) {
//        return YES;
//    }
//    else{
//        return NO;
//    }
    return YES;
    
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
