//
//  ReportViewController.m
//  Cartoon
//
//  Created by dllo on 15/11/2.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//
#define Screen_Width self.view.bounds.size.width
#define Screen_Height self.view.bounds.size.height
#import "ReportViewController.h"
#import "AnimationCollectionViewCell.h"

@interface ReportViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UILabel *reportLabel;

@property (nonatomic,strong) UIView *reportView;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我要举报";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%@",self.url);
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 56, Screen_Width, Screen_Height / 5 * 3)];
    backView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:backView];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(56, 30, Screen_Width - 56 * 2, Screen_Height / 5 * 3 - 56 * 2 )];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.url]];
    imageView.layer.borderWidth = 15;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backView addSubview:imageView];
    
    self.reportArray = @[@"淫秽色情",@"广告营销",@"人身攻击",@"骚扰他人",@"刷屏灌水",@"内容抄袭"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(150, 30);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(25, 20, 10, 20);
    flowLayout.minimumLineSpacing = 30;
    
    UICollectionView *reportCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, Screen_Height / 5 * 3 + 5, Screen_Width, Screen_Height / 5 * 2 - 5) collectionViewLayout:flowLayout];
    reportCollection.backgroundColor = [UIColor whiteColor];
    reportCollection.delegate = self;
    reportCollection.dataSource = self;
    [self.view addSubview:reportCollection];
    [reportCollection registerClass:[AnimationCollectionViewCell class] forCellWithReuseIdentifier:@"reportReuse"];
    
    self.reportView = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width / 2 - 80, Screen_Height / 2 - 50, 160, 100)];
    self.reportView.backgroundColor = [UIColor blackColor];
    self.reportView.clipsToBounds = YES;
    self.reportView.layer.cornerRadius = 25;
    self.reportView.alpha = 0;
    [self.view addSubview:self.reportView];
    
    self.reportLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_Width / 2 - 40, Screen_Height / 2 - 40, 80, 80)];
    self.reportLabel.textColor = [UIColor whiteColor];
    self.reportLabel.alpha = 0;
    self.reportLabel.textAlignment = NSTextAlignmentCenter;
    self.reportLabel.text = @"举报成功";
    [self.view addSubview:self.reportLabel];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.reportArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AnimationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reportReuse" forIndexPath:indexPath];
    
    cell.numberLabel.text = [self.reportArray objectAtIndex:indexPath.item];
    cell.numberLabel.textColor = [UIColor redColor];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.reportView.alpha = 0.5;
        self.reportLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            [UIView setAnimationDelay:1];
            self.reportView.alpha = 0;
            self.reportLabel.alpha = 0;
            
        }];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];    });

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
