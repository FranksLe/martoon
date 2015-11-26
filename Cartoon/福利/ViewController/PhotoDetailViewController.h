//
//  PhotoDetailViewController.h
//  UI_豆瓣解析
//
//  Created by dllo on 15/9/11.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDetailViewController : UIViewController
@property (nonatomic, assign) NSInteger indexPath;
@property (nonatomic, strong) NSMutableArray *photoArr;
@end
