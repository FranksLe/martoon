//
//  UpPicPushViewController.m
//  Cartoon
//
//  Created by dllo on 15/11/2.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "UpPicPushViewController.h"

@interface UpPicPushViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation UpPicPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@",self.url);
    
    self.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height + 15)];
    webView.scrollView.bounces = NO;
    webView.exclusiveTouch = YES;
    webView.delegate = self;
    NSString *str = self.url;
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    
    [self.view addSubview: webView];
    
    [webView loadRequest:request];
    
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width , self.view.bounds.size.height)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
    UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-40,180, 80, 80)];
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.hud.hidden = YES;
        //移除遮罩
        UIView *view = (UIView*)[self.view viewWithTag:108];
        [view removeFromSuperview];
    });

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
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
