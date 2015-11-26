//
//  MyViewController.m
//  Cartoon
//
//  Created by dllo on 15/10/28.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "MyViewController.h"
#import "HistoryViewController.h"
#import "CollectViewController.h"
#import "MyMainTableViewCell.h"
#import "SettingViewController.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height


@interface MyViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,strong) NSMutableArray *picArray;

@end

@implementation MyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    
    
    CATransition *ani4 = [CATransition animation];
    ani4.duration = 0.3;
    ani4.subtype = kCATransitionFade;
    
    [self.navigationController.navigationBar.layer addAnimation:ani4 forKey:nil];
    [self.tabBarController.tabBar.layer addAnimation:ani4 forKey:nil];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    /*文字数组*/
    self.array = [NSMutableArray arrayWithObjects:@"观看记录",@"我的收藏",@"清除缓存",@"我的设置", nil];
    /*图片数组*/
    self.picArray = [NSMutableArray arrayWithObjects:@"jilu.png",@"shoucang.png",@"qinghuan.png",@"shezhi.png", nil];
    /*顶部图片*/
    UIImageView *upView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT / 3)];
    upView.image = [UIImage imageNamed:@"myUpPic.jpg"];
    upView.backgroundColor = [UIColor lightGrayColor];
    
    /*顶部图片模糊*/
    UIVisualEffectView *mohu =[[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    mohu.frame = CGRectMake(0, 0, WIDTH, HEIGHT / 3);
    mohu.alpha = 0.7;
    [upView addSubview:mohu];
    
    /*用户默认头像*/
    UIImageView *picVIew = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-60, 50, 120, 120)];
    picVIew.backgroundColor = [UIColor colorWithRed:177/255.0 green:178/255.0 blue:177/255.0 alpha:1];
    picVIew.clipsToBounds = YES;
    picVIew.layer.cornerRadius = 60;
    picVIew.layer.borderWidth = 5;
    picVIew.layer.borderColor = [[UIColor whiteColor]CGColor];
    picVIew.image = [UIImage imageNamed:@"upPic.png"];
    //[upView addSubview:picVIew];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = upView;
    [self.view addSubview:_tableView];
    
    CGFloat size = [[SDImageCache sharedImageCache]getSize];
    NSString *str = [NSString stringWithFormat:@"%fM",size/1024/1024];
    
    self.reportView = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH / 2 - 120, HEIGHT / 2 - 100, 240, 155)];
    self.reportView.backgroundColor = [UIColor blackColor];
    self.reportView.clipsToBounds = YES;
    self.reportView.layer.cornerRadius = 25;
    self.reportView.alpha = 0;
    self.reportView.hidden = YES;
    self.reportView.userInteractionEnabled = YES;
    [self.view addSubview:self.reportView];
    
    self.reportLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH / 2 - 80, HEIGHT / 2 - 155, 160, 160)];
    self.reportLabel.textColor = [UIColor whiteColor];
    self.reportLabel.textAlignment = NSTextAlignmentCenter;
    self.reportLabel.text = @"清除缓存";
    self.reportLabel.alpha = 0;
    self.reportLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:self.reportLabel];
    
    UILabel *readLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 220, 90)];
    readLabel.text = @"       清除缓存将删除所有缓存的漫画,确定要清除缓存吗?";
    readLabel.textColor = [UIColor whiteColor];
    readLabel.numberOfLines = 0;
    readLabel.font = [UIFont systemFontOfSize:14];
    [self.reportView addSubview:readLabel];
    
    self.yesButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.yesButton.frame = CGRectMake(35, 108, 70, 35);
    [self.yesButton setTitle:@"确定" forState:normal];
    self.yesButton.layer.borderWidth = 0.5;
    self.yesButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    [self.yesButton setTitleColor:[UIColor whiteColor] forState:normal];
    self.yesButton.layer.cornerRadius = 15;
    [self.yesButton addTarget:self action:@selector(yesButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.reportView addSubview:self.yesButton];
    
    self.noButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.noButton.frame = CGRectMake(135, 108, 70, 35);
    [self.noButton setTitle:@"取消" forState:UIControlStateNormal];
    self.noButton.layer.borderWidth = 0.5;
    self.noButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    [self.noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.noButton.layer.cornerRadius = 15;
    [self.noButton addTarget:self action:@selector(noButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.reportView addSubview:self.noButton];


    self.successView = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH / 2 - 120, HEIGHT / 2 - 100, 240, 120)];
    self.successView.backgroundColor = [UIColor blackColor];
    self.successView.clipsToBounds = YES;
    self.successView.layer.cornerRadius = 25;
    self.successView.hidden = YES;
    self.successView.userInteractionEnabled = YES;
    [self.view addSubview:self.successView];
    
    self.successLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH / 2 - 80, HEIGHT / 2 - 155, 160, 160)];
    self.successLabel.textColor = [UIColor whiteColor];
    self.successLabel.textAlignment = NSTextAlignmentCenter;
    self.successLabel.text = @"清除成功";
    self.successLabel.alpha = 0;
    self.successLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:self.successLabel];
    
    UILabel *successLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 220, 90)];
    successLabel.text = [NSString  stringWithFormat:@"       成功清除%@缓存",str];
    successLabel.textColor = [UIColor whiteColor];
    successLabel.numberOfLines = 0;
    successLabel.font = [UIFont systemFontOfSize:14];
    [self.successView addSubview:successLabel];

}

- (void)yesButtonAction:(UIButton *)button
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.reportView.alpha = 0;
        self.reportLabel.alpha = 0;
        NSLog(@"对话框跳转");
        self.tableView.userInteractionEnabled = YES;
    }completion:^(BOOL finished) {
        NSLog(@"清理开始");
        SDImageCache *sd = [SDImageCache sharedImageCache];
        [sd clearDisk];
        [NetHandler deleteCaches];
        NSLog(@"清理结束");
        [UIView animateWithDuration:0.5 animations:^{
            NSLog(@"清理成功对话框弹出");
            self.successView.hidden = NO;
            self.successLabel.alpha = 1;
            self.successView.alpha = 0.8;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1 animations:^{
                NSLog(@"清理成功对话框消失");
                [UIView setAnimationDelay:1];
                self.successLabel.alpha = 0;
                self.successView.alpha = 0;
                
            }];
        }];
    }];
    

}

- (void)noButtonAction:(UIButton *)button
{
     NSLog(@"对话框消失");
    
    [UIView animateWithDuration:0.5 animations:^{
    self.reportView.alpha = 0;
    self.reportLabel.alpha = 0;
    self.tableView.userInteractionEnabled = YES;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"myReuse";
    
    MyMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (!cell) {
        cell = [[MyMainTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    
    cell.myLabel.text = [self.array objectAtIndex:indexPath.row];
    cell.rightLabel.text = @"›";
    cell.leftImage.image = [UIImage imageNamed:[self.picArray objectAtIndex:indexPath.row]];
        
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /* 观看记录 */
    if (indexPath.row == 0) {
        NSLog(@"观看记录");
        
        HistoryViewController *hisVC = [[HistoryViewController alloc]init];
        [self.navigationController pushViewController:hisVC animated:YES];
        
    }
    
    /* 我的收藏 */
    if (indexPath.row == 1) {
        NSLog(@"我的收藏");
        
        CollectViewController *collectVC = [[CollectViewController alloc]init];
        [self.navigationController pushViewController:collectVC animated:YES];
    }
    
    /* 清除缓存 */
    if (indexPath.row == 2) {
        
        NSLog(@"清除缓存,弹出对话框");
        
        [UIView animateWithDuration:0.5 animations:^{
            self.reportView.hidden = NO;
            self.reportView.alpha = 0.8;
            self.reportLabel.alpha = 1;
            self.tableView.userInteractionEnabled = NO;
        } completion:^(BOOL finished) {
          
        }];
    }
    
    /* 我的设置 */
    if (indexPath.row == 3) {
        NSLog(@"我的设置");
        SettingViewController *settingVC = [[SettingViewController alloc]init];
        [self.navigationController pushViewController:settingVC animated:YES];
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
