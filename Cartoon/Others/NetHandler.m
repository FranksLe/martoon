//
//  NetHandler.m
//  Gift
//
//  Created by dllo on 15/9/16.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import "NetHandler.h"

@implementation NetHandler
+ (void)dataWithUrl:(NSString *)str complant:(void (^)(NSData *))block
{
    NSLog(@"%@",NSHomeDirectory());
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"application/json",@"text/javascript",@"text/html", nil];

    //字符串哈希值
    NSInteger num = [str hash];
    [manager GET:str parameters:nil success:^ void(NSURLSessionDataTask *operation, id responseObject) {
        
         NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        //拼接一个文件路径
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        NSString *string = [NSString stringWithFormat:@"%ld.txt",num];
        NSString *path = [docPath stringByAppendingPathComponent:string];
        if (data == nil) {
            data = [NSData dataWithContentsOfFile:path];
            if (data != nil) {
                block(data);
            }
        }
        else
        {
            //数据写入本地
            [data writeToFile:path atomically:YES];
            NSLog(@"存储成功");
            block(data);
        }
        
    } failure:^ void(NSURLSessionDataTask * operation, NSError * error) {
        //拼接一个文件路径
        NSLog(@"%@",error);
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        NSString *string = [NSString stringWithFormat:@"%ld.txt",num];
        NSString *path = [docPath stringByAppendingPathComponent:string];
            NSLog(@"读取数据");
            NSData *data = [NSData dataWithContentsOfFile:path];
            if (data != nil) {
                NSLog(@"读取成功");
                block(data);
            }

        NSLog(@"错误");
        
    }];
    
}

// 清除缓存

+ (BOOL)deleteCaches
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    [manager removeItemAtPath:cachesPath error:&error];
    BOOL fileBool = [manager fileExistsAtPath:cachesPath];
    if (error == nil) {
        return YES;
    } else if (fileBool == YES) {
        NSLog(@"%@", error);
        return NO;
    } else {
        return NO;
    }
}

@end
