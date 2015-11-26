//
//  PhotoDetailViewController.m
//  UI_豆瓣解析
//
//  Created by dllo on 15/9/11.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "MyCell.h"
#import<ShareSDK/ShareSDK.h>
#import<ShareSDKUI/ShareSDKUI.h>

@interface PhotoDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, assign) NSInteger page;


@end

@implementation PhotoDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor blackColor];
    
    self.page = _indexPath;
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    flowlayout.itemSize = CGSizeMake(self.view.bounds.size.width-20, self.view.bounds.size.height);
    flowlayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowlayout.minimumLineSpacing = 20;
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowlayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1];
    self.collectionView.contentOffset = CGPointMake(_indexPath*self.view.bounds.size.width, 0);
    [self.view addSubview:_collectionView];

    self.pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-30, 20, 60, 25)];
    self.pageLabel.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1];
    self.pageLabel.textColor = [UIColor whiteColor];
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    self.pageLabel.layer.cornerRadius = 12.5;
    self.pageLabel.layer.masksToBounds = YES;
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",_indexPath+1,self.photoArr.count];
    [self.view addSubview:_pageLabel];
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.saveButton.frame = CGRectMake(20, self.view.bounds.size.height-40, 80, 25);
    [self.saveButton setTitle:@"保存原图" forState:UIControlStateNormal];
    self.saveButton.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1];
    self.saveButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.saveButton.tintColor = [UIColor whiteColor];
    self.saveButton.layer.cornerRadius = 12.5;
    self.saveButton.layer.masksToBounds = YES;
    [self.saveButton addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.shareButton.frame = CGRectMake(self.view.bounds.size.width- 80, self.view.bounds.size.height-40, 60, 25);
    [self.shareButton setTitle:@"分享" forState:UIControlStateNormal];
    self.shareButton.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1];
    self.shareButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.shareButton.tintColor = [UIColor whiteColor];
    self.shareButton.layer.cornerRadius = 12.5;
    self.shareButton.layer.masksToBounds = YES;
    [self.shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareButton];

    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.collectionView addGestureRecognizer:tap];
 
    [self.collectionView registerClass:[MyCell class] forCellWithReuseIdentifier:@"picture"];

}
- (void)saveClick:(UIButton *)btn
{
    NSURL *url = [self.photoArr objectAtIndex:_page];
    UIImageView *imageview = [[UIImageView alloc]init];
    [imageview sd_setImageWithURL:url];
    /**
     *       image保存到本地相册的方法
     *
     *  @param imageview.image                                               imageview.image 的相片为待保存的图片
     *  @param self
     *  @param imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo: imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo: 请求访问系统相册的权限
     *
     *  @return
     */
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
    return self.photoArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picture" forIndexPath:indexPath];
   
    NSString *photoStr = [self.photoArr objectAtIndex:indexPath.item];
    cell.bigPage.text = [NSString stringWithFormat:@"%ld",indexPath.item+1];
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:photoStr]];
    cell.scrollView.zoomScale = 1.0;
    if (cell.myImageView.image != nil) {
        cell.bigPage.hidden = YES;
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int halfX = _collectionView.frame.size.width / 2;
    self.page = (_collectionView.contentOffset.x  - halfX) / self.collectionView.bounds.size.width +1;
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",_page+1,self.photoArr.count];
    
}
//点击手势
- (void)tapAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareButtonAction:(UIButton *)btn
{
    //创建分享参数
    NSLog(@"%ld",_page);
    NSString *urlStr = [self.photoArr objectAtIndex:_page];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"%@",url);

    
    //self.name = [NSString stringWithFormat:@"%@",strUrl];
    NSMutableDictionary *shareParms = [NSMutableDictionary dictionary];
    [shareParms SSDKSetupShareParamsByText:@"#夹心漫画-带你了解二次元的世界"
                                    images:url
                                       url:nil
                                     title:@"分享标题"
                                      type:SSDKContentTypeAuto];
    //进行分享
    [ShareSDK showShareActionSheet:btn
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
