//
//  BaseModel.h
//  Cartoon
//
//  Created by dllo on 15/10/28.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
@property(nonatomic,copy)NSString *uId;

-(instancetype)initWithDic:(NSDictionary *)dic;


+ (NSMutableArray *)baseModelByArr:(NSArray *)modelArr;
@end
