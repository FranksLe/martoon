//
//  FMDBHandler.h
//  Cartoon
//
//  Created by dllo on 15/11/3.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KindModel.h"
#import "RecordModel.h"
@interface FMDBHandler : NSObject
@property(nonatomic ,strong)FMDatabase *db;
// 单例初始化
+ (FMDBHandler *)shareInstance;

// 创建数据
- (BOOL)createTable;

// 插入数据
- (void)insertData:(KindModel *)kindModel;

// 删除数据
- (void)deleteData:(KindModel *)kindModel;

// 查询
- (NSArray *)query;

//历史记录
- (BOOL)createTableHistory;

- (void)insertHistory:(NSString * )history;

- (void)deleteHistory:(NSString * )history;

- (NSArray *)selectAllHistory;

//阅读记录
- (BOOL)createTableRead;

- (void)insertRecord:(RecordModel *)read;
- (void)deleteRecord:(RecordModel *)read;
- (void)updateRecord:(RecordModel *)read;
- (NSArray *)selectAllRead;


@end
