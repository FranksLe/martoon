//
//  BooksPushViewController.h
//  Cartoon
//
//  Created by dllo on 15/10/28.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BooksPushViewController : UIViewController

@property (nonatomic,strong ) NSString *booksId;
@property (nonatomic, strong) NSString *name;

@property (nonatomic,strong ) NSMutableDictionary *pageDic;

@property (nonatomic,strong ) NSMutableArray *booksArray;

@property (nonatomic,strong ) NSMutableArray *detailArray;

@end
