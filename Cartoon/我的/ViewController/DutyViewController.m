//
//  DutyViewController.m
//  Cartoon
//
//  Created by dllo on 15/11/6.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "DutyViewController.h"

@interface DutyViewController ()

@end

@implementation DutyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"版权说明";
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height)];
    image.image = [UIImage imageNamed:@"mzsm.png"];
    [self.view addSubview:image];
    
    
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
