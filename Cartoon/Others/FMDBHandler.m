//
//  FMDBHandler.m
//  Cartoon
//
//  Created by dllo on 15/11/3.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "FMDBHandler.h"

@implementation FMDBHandler

+(FMDBHandler *)shareInstance
{
    static FMDBHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[FMDBHandler alloc]init];

    });
    return handler;
}

- (BOOL)createTable
{
    //1.获得数据库文件的路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"t_data.sqlite"];
    NSLog(@"数据库路径:%@",fileName);
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
    
    //3.打开数据库
    if ([db open]) {
        //4.创表
        
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_date (classify_id integer PRIMARY KEY , classify_title text, classify_url text,only text);"];
        if (result) {
            NSLog(@"创建表成功");
        }else{
            NSLog(@"创建表失败");
            return !result;
        }
    }
    self.db = db;
    return YES;
    
}

- (void)insertData:(KindModel *)kindModel
{
    
    if (kindModel.classify_id && kindModel.classify_title && kindModel.classify_url &&kindModel.only) {
        
        [self.db executeUpdate:@"INSERT INTO t_date (classify_id, classify_title, classify_url,only) VALUES (?,?,?,?);",kindModel.classify_id,kindModel.classify_title, kindModel.classify_url,kindModel.only];
    }
    
}

- (void)deleteData:(KindModel *)kindModel
{
    
    [self.db executeUpdate:[NSString stringWithFormat: @"delete from t_date where classify_id = '%@'",kindModel.classify_id]];
    
}

-(NSArray *)query
{
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_date"];
    NSMutableArray *titleArr = [NSMutableArray array];
    
    while ([resultSet next]) {
        KindModel *kind = [[KindModel alloc]init];
        
        NSString *title = [resultSet stringForColumn:@"classify_title"];
        
        NSString *ID = [resultSet stringForColumn:@"classify_id"];
        
        NSString *image = [resultSet stringForColumn:@"classify_url"];
        
        NSString *only =[resultSet stringForColumn:@"only"];
        
        kind.classify_id = ID;
        kind.classify_title =title;
        kind.classify_url = image;
        kind.only = only;
        [titleArr addObject:kind];
    }
    
    return titleArr;
    
}
//历史记录
- (BOOL)createTableHistory
{
    //1.获得数据库文件的路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"record.sqlite"];
    NSLog(@"历史记录路径:%@",fileName);
    
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
    
    //3.打开数据库
    if ([db open]) {
        //4.创表
        
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS history (classify_title text PRIMARY KEY);"];
        if (result) {
            NSLog(@"创建表成功");
        }else{
            NSLog(@"创建表失败");
            return !result;
        }
    }
    self.db = db;
    return YES;
 
}

- (void)insertHistory:(NSString * )history
{
    if (history) {
        
        [self.db executeUpdate:@"INSERT INTO history (classify_title) VALUES (?);",history];
    }
}


- (void)deleteHistory:(NSString *)history
{
    [self.db executeUpdate:[NSString stringWithFormat: @"delete from history where classify_title = '%@'",history]];
}

- (NSArray *)selectAllHistory
{
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM history"];

    NSMutableArray *titleArr = [NSMutableArray array];
    while ([resultSet next]) {
        NSString *classify_title = [resultSet stringForColumn:@"classify_title"];
        [titleArr addObject:classify_title];
        
    }

    return titleArr;
 
}

- (BOOL)createTableRead
{
    //1.获得数据库文件的路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"read.sqlite"];
    NSLog(@"数据库路径:%@",fileName);
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
    
    //3.打开数据库
    if ([db open]) {
        //4.创表
        
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS read (name text PRIMARY KEY , bigPage text, smallPage text,pageId text,only text,imageStr text);"];
        if (result) {
            NSLog(@"创建表成功");
        }else{
            NSLog(@"创建表失败");
            return !result;
        }
    }
    self.db = db;
    return YES;
    
}

- (void)insertRecord:(RecordModel *)read
{
    
    if (read.name && read.bigPage && read.smallPage && read.only && read.pageId && read.imageStr) {
        
        [self.db executeUpdate:@"INSERT INTO read (name, bigPage, smallPage,pageId,only,imageStr) VALUES (?,?,?,?,?,?);",read.name,read.bigPage, read.smallPage,read.pageId,read.only,read.imageStr];
    }
    
}

- (void)deleteRecord:(RecordModel *)read
{
    
    [self.db executeUpdate:[NSString stringWithFormat: @"delete from read where name = '%@'",read.name]];
    
}
- (void)updateRecord:(RecordModel *)read
{
    [self.db executeUpdate:@"UPDATE read SET bigPage = ?,smallPage = ? WHERE name = ?;", read.bigPage,read.smallPage,read.name ];
}

-(NSArray *)selectAllRead
{
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM read"];
    NSMutableArray *stuArr = [NSMutableArray array];

    while ([resultSet next]) {
        NSString *name = [resultSet stringForColumn:@"name"];
        NSString *bigPage = [resultSet stringForColumn:@"bigPage"];
        NSString *smallPage = [resultSet stringForColumn:@"smallPage"];
        NSString *pageId = [resultSet stringForColumn:@"pageId"];
        NSString *only = [resultSet stringForColumn:@"only"];
        NSString *imageStr = [resultSet stringForColumn:@"imageStr"];
        RecordModel *readModel = [[RecordModel alloc]init];
        readModel.name = name;
        readModel.bigPage = bigPage;
        readModel.smallPage = smallPage;
        readModel.pageId = pageId;
        readModel.only = only;
        readModel.imageStr = imageStr;
        [stuArr addObject:readModel];
        
    }
    return stuArr;
    
}


@end
