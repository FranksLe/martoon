//
//  HistoryViewController.m
//  Cartoon
//
//  Created by dllo on 15/11/4.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "FMDBHandler.h"
#import "RecordModel.h"
#import "BooksPushViewController.h"
#import "TotalDetailsViewController.h"
#import "KindModel.h"
#import "AnimationModel.h"
@interface HistoryViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

/*  用来装观看记录个数的数组  */
@property (nonatomic,strong) NSMutableArray *historyArray; //阅读记录
@property (nonatomic, strong) NSString *imageStr;

@property (nonatomic, strong) NSMutableArray *deleteArr; // 删除数组
@property (nonatomic, strong) UIBarButtonItem *righBtn;
@property (nonatomic, strong) UIImageView *backImage;
@end

@implementation HistoryViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.tabBarController.tabBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    
    CATransition *ani4 = [CATransition animation];
    ani4.duration = 0.5;
    ani4.subtype = kCATransitionFade;
    
    [self.navigationController.navigationBar.layer addAnimation:ani4 forKey:nil];
    [self.tabBarController.tabBar.layer addAnimation:ani4 forKey:nil];
    if (self.historyArray.count == 0) {
        
        self.backImage.hidden = NO;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"观看记录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.deleteArr = [NSMutableArray array];
     self.historyArray = [NSMutableArray array];
    FMDBHandler *db = [FMDBHandler shareInstance];
    [db createTableRead];
    NSArray *tempArr = [db selectAllRead];
    self.historyArray = [NSMutableArray arrayWithArray:tempArr];
    NSLog(@"观看记录:%@",self.historyArray);
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];

    
    self.righBtn = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBtnAction:)];
    
    self.navigationItem.rightBarButtonItem = _righBtn;
    self.backImage = [[UIImageView alloc]init];
    _backImage.image = [UIImage imageNamed:@"empty_recent.png"];
    _backImage.contentMode = UIViewContentModeScaleAspectFit;
    _backImage.frame = self.view.bounds;
    [self.view addSubview:_backImage];
    self.backImage.hidden = YES;

    if (self.historyArray.count == 0) {
        
        self.backImage.hidden = NO;
    }
    else{
        self.backImage.hidden = YES;
    }
    
  
}

- (void)rightBtnAction:(UIBarButtonItem *)btn
{
    [self.tableView setEditing:YES animated:YES];
    _righBtn.title = @"确定";
    [_righBtn setAction:@selector(righBtnWithsure:)];
    
}

- (void)righBtnWithsure:(UIBarButtonItem *)btn
{

 
    NSLog(@"删除%@", _deleteArr);
    [_historyArray removeObjectsInArray:_deleteArr];
    
    FMDBHandler *db = [FMDBHandler shareInstance];
    [db createTableRead];
    for (RecordModel *collected in _deleteArr) {
        NSLog(@"%@", collected);
        [db deleteRecord:collected];
    }

    [_deleteArr removeAllObjects];
    [self.tableView reloadData];
    [self.tableView setEditing:NO animated:YES];
    _righBtn.title = @"删除";
    [_righBtn setAction:@selector(rightBtnAction:)];
    if (self.historyArray.count == 0) {
 
        
        UIImageView *backImage = [[UIImageView alloc]init];
        backImage.image = [UIImage imageNamed:@"empty_recent.png"];
        backImage.contentMode = UIViewContentModeScaleAspectFit;
        backImage.frame = self.view.bounds;
        [self.view addSubview:backImage];
        
        self.tableView.separatorStyle = NO;

    }

    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    //ViewControler 提供了一个可以切换状态的edit按钮
    [super setEditing:editing animated:animated];
    
    //开启编辑状态
    [self.tableView setEditing:editing animated:animated];
    if (self.editing) {
        self.editButtonItem.title = @"确定";
    }
    else{
        self.editButtonItem.title = @"编辑";
    }
    
}

//添加一项
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.righBtn.title isEqualToString:@"确定"]) {
        
        [self.deleteArr addObject:[_historyArray objectAtIndex:indexPath.row]];
    }
     NSLog(@"点击");
}

//取消一项
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([self.righBtn.title isEqualToString:@"确定"]) {
        [_deleteArr removeObject:[_historyArray objectAtIndex:indexPath.row]];
        }
 
   }


/* 返回tableview个数的方法 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyArray.count;
}


/* tableview铺设以及赋值 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"historyReuse";
    
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (!cell) {
        cell = [[HistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    RecordModel *readModel = [self.historyArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = readModel.name;
    if ([readModel.only isEqualToString:@"a"]) {
        self.imageStr = [NSString stringWithFormat:@"http://%@",readModel.imageStr];
    }
    else{
        self.imageStr = readModel.imageStr;
    }
   
    [cell.leftPic sd_setImageWithURL:[NSURL URLWithString:self.imageStr] placeholderImage:[UIImage imageNamed:@"placeholder_comicCover.png"]];
    /* 已经看到第几话(用数据库赋值) */
    NSInteger num = [readModel.bigPage integerValue];
    NSString *didWatchStr = [NSString stringWithFormat:@"您已经观看到第%ld话",num+1];
    
    cell.didWatchLabel.text = didWatchStr;
    cell.didWatchLabel.textColor = [UIColor redColor];
    
    [cell.goOnButton addTarget:self action:@selector(goOnButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.goOnButton.tag = indexPath.item;
    return cell;
}


/* tableview 高度设定方法 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.bounds.size.width*180/375;
}


/* 继续观看按钮方法 */
- (void)goOnButtonAction:(UIButton *)button
{
    RecordModel *readModel = [self.historyArray objectAtIndex:button.tag];
    
    BooksPushViewController *bookV = [[BooksPushViewController alloc]init];
    TotalDetailsViewController *bookVC = [[TotalDetailsViewController alloc]init];
    if ([readModel.only isEqualToString:@"b"]) {
        NSRange range = [readModel.pageId rangeOfString:@"/"];
        NSString *subString = [readModel.pageId substringToIndex: range.location];
        bookVC.comicId = subString;
        bookVC.name = readModel.name;
        [self.navigationController pushViewController:bookVC animated:YES];
        
    }else{
        // 要传的id
        bookV.booksId = readModel.pageId;
        bookV.name = readModel.name;
        
        [self.navigationController pushViewController:bookV animated:YES];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
