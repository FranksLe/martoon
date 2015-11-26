//
//  WelfareModel.h
//  Cartoon
//
//  Created by dllo on 15/10/28.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "BaseModel.h"

@interface WelfareModel : BaseModel
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *introduce;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *up_count;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@end
