//
//  SettingViewController.m
//  Cartoon
//
//  Created by dllo on 15/11/5.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "SettingViewController.h"
#import "DutyViewController.h"
#import "CallUsViewController.h"
#import "JoinUsViewController.h"
#import "LeadViewController.h"

@interface SettingViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *settingArray;

@property (nonatomic,assign) NSString *myAppleId;

@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBar.hidden = NO;
        self.tabBarController.tabBar.hidden = NO;
    }];
    
    self.settingArray = [NSMutableArray arrayWithObjects:@"联系我们",@"加入我们",@"查看引导页", nil];
    
    self.myAppleId = @"1049620693";
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的设置";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.settingArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"settingReuse";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    
    cell.textLabel.text = [self.settingArray objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    if (indexPath.row == 0) {
        NSLog(@"跳转联系我们View");
        
        CallUsViewController *callVC = [[CallUsViewController alloc]init];
        [self.navigationController pushViewController:callVC animated:YES];
        
    }
    if (indexPath.row == 1) {
        NSLog(@"跳转加入我们View");
        
        JoinUsViewController *joinVC = [[JoinUsViewController alloc]init];
        [self.navigationController pushViewController:joinVC animated:YES];
        
    }
//    if (indexPath.row == 2) {
//        NSLog(@"跳转AppleStore");
//        
//        NSString *str = [NSString stringWithFormat:
//                         
//                         @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",
//                         self.myAppleId ];
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//        
//    }
    if (indexPath.row == 2) {
        NSLog(@"查看引导页");
        
        LeadViewController *leadVC = [[LeadViewController alloc]init];
        [self.navigationController pushViewController:leadVC animated:YES];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationController.navigationBar.hidden = YES;
            self.tabBarController.tabBar.hidden = YES;
        }];
        
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
