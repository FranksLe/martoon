//
//  LookViewController.h
//  Cartoon
//
//  Created by dllo on 15/10/31.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "BaseViewController.h"


@interface LookViewController : BaseViewController
@property (nonatomic, strong) NSString *mark;
@property (nonatomic, assign) NSInteger indexPath;
@property (nonatomic, assign) NSInteger page;//页码
@property (nonatomic, strong) NSString *only;
@property (nonatomic, strong) NSString *cartoonId;//第一个Id
@property (nonatomic, strong) NSMutableArray *cartoonArr;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) NSString *bookId;
@property (nonatomic, strong) NSString *carId;//第二个Id
@property (nonatomic, strong) NSString *everyname;//第二个每一话
@property (nonatomic, strong) NSString *imageStr;//第二个图片
@property (nonatomic, assign) NSInteger part;//第几话
@end
