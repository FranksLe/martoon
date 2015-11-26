//
//  FirstPageHeaderView.h
//  Cartoon
//
//  Created by dllo on 15/10/29.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PushMoreButton <NSObject>

- (void)PathIdValue:(NSString *)booksId;

@end

@interface FirstPageHeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *moreButton;

@property (nonatomic,strong) UIView *leftView;

@property (nonatomic,strong) UIView *upView;

@property (nonatomic,assign) NSInteger *indexPath;

@property (nonatomic,strong) id<PushMoreButton>pushMoreButtonDelegate;



@end
