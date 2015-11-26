//
//  JoinUsViewController.m
//  Cartoon
//
//  Created by dllo on 15/11/6.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "JoinUsViewController.h"

@interface JoinUsViewController ()

@end

@implementation JoinUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"加入我们";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 70, 300, 200)];
    label.text = @"蓝鸥科技联系电话 : 18362272111";
    [self.view addSubview:label];
    
    
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
