//
//  AppDelegate.m
//  Cartoon
//
//  Created by dllo on 15/10/27.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstPageViewController.h"
#import "KindViewController.h"
#import "MyViewController.h"
#import "WelfareViewController.h"
#import "LeadViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WeiboSDK.h"
#import "WXApi.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults *use = [NSUserDefaults standardUserDefaults];
    NSString *result = [use objectForKey:@"firstGetIn"];
    
    if (result != nil) {
        [self normalViewController];
        
    }
    else{
        LeadViewController *leadVC = [[LeadViewController alloc]init];
        
        self.window.rootViewController = leadVC;
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(receiveNotification:) name:@"enter" object:nil];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"suibian" forKey:@"firstGetIn"];
        
    }
    
    
    return YES;
}


- (void)receiveNotification:(NSNotification *)noti
{
        [self normalViewController];
}


- (void)normalViewController
{
    //红色字体号码1:mod平台自己申请的账号  貌似是一个软件一个对应的账号 (这个是自己开发的软件的对应号码)
    [ShareSDK registerApp:@"c1be8a523d46"
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType) {
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                             
                         default:
                             break;
                     }
                 }
     
     
     //红色字体号码2:想分享到什么平台就去什么开放平台申请开发者账号 得到对应的一个或多个码 对应的填入
     //腾讯家族貌似需要跳转分享(sso)(模拟器并不能模拟因为木有微信等软件)
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType) {
                  case SSDKPlatformTypeSinaWeibo:
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"1539774203"
                                                appSecret:@"b8812ad0c9591161daed60d1fe3451d3"
                                              redirectUri:@"https://api.weibo.com/oauth2/default.html"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                                       
                  default:
                      break;
              }
          }];
    

    
    FirstPageViewController *mainVC = [[FirstPageViewController alloc]init];
    UINavigationController *mainNavi = [[UINavigationController alloc]initWithRootViewController:mainVC];
    mainVC.tabBarItem.image = [UIImage imageNamed:@"zhuye.png"];
    
    
    WelfareViewController *welfareVC = [[WelfareViewController alloc]init];
    UINavigationController *welfareNavi = [[UINavigationController alloc]initWithRootViewController:welfareVC];
    welfareVC.title = @"福利";
    welfareVC.tabBarItem.image = [UIImage imageNamed:@"fuli.png"];
    
    
    KindViewController *kindVC = [[KindViewController alloc]init];
    UINavigationController *kindNavi = [[UINavigationController alloc]initWithRootViewController:kindVC];
    kindVC.tabBarItem.image = [UIImage imageNamed:@"fenlei.png"];
    kindVC.title = @"分类";
    
    MyViewController *myVC = [[MyViewController alloc]init];
    UINavigationController *myNavi = [[UINavigationController alloc]initWithRootViewController:myVC];
    myVC.title = @"我的";
    myVC.tabBarItem.image = [UIImage imageNamed:@"my.png"];
    
    
    UITabBarController *tabBar = [[UITabBarController alloc]init];
    
    tabBar.viewControllers = @[mainNavi,welfareNavi,kindNavi,myNavi];
    
    tabBar.tabBar.barTintColor = [UIColor whiteColor];
    
    tabBar.tabBar.translucent = NO;
    
    tabBar.tabBar.tintColor = [UIColor colorWithRed:2/255.0 green:189/255.0 blue:24/255.0 alpha:1];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:149/255.0 green:198/255.0 blue:64/255.0 alpha:1]];
     [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:153/255.0 green:203/255.0 blue:75/255.0 alpha:1]];
    [UINavigationBar appearance].barStyle = UIBarStyleBlackOpaque;
    
    self.window.rootViewController = tabBar;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
