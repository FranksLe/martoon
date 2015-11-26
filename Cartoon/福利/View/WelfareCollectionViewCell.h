//
//  WelfareCollectionViewCell.h
//  Cartoon
//
//  Created by dllo on 15/10/28.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMWaterflowLayout.h"
#import "PicCollectionViewCell.h"

@protocol pushPhotoViewController <NSObject>

- (void)passPhotoArr:(NSMutableArray*)photoArr index:(NSInteger)indexpath;

@end

@interface WelfareCollectionViewCell : UICollectionViewCell<UICollectionViewDelegate,UICollectionViewDataSource,HMWaterflowLayoutDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *picCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *hotArr;
@property (nonatomic, strong) NSMutableArray *bestArr;
@property (nonatomic, strong) NSDictionary *portDic;
@property (nonatomic, strong) NSDictionary *hotPortDic;
@property (nonatomic, assign) NSInteger bestPage;
@property (nonatomic, assign) NSInteger hotPage;
@property (nonatomic, assign) id<pushPhotoViewController>photoDelegate;
- (void)createCollectionView;
- (void)createHotCollectionView;
@end
