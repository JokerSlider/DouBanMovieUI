//
//  StudyStyleController.m
//  CSchool
//
//  Created by mac on 17/9/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "StudyStyleController.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "StudyStyleCell.h"
#import <MJRefresh.h>
#import "TableViewAnimationKitHeaders.h"

@interface StudyStyleController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UISegmentedControl *segMentView;

@property (nonatomic,assign)int  status;

@property (nonatomic,strong)NSMutableArray *modelArr;

@property (nonatomic,assign)int  pagenum;//总数

@property (nonatomic,strong)NSMutableArray *dataSourceArr;//传递数组

@end

@implementation StudyStyleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Base_Color2;
    self.title = @"学风排行榜";
    _pagenum = 1;
    _status = 1;
    _modelArr = [NSMutableArray array];

    [self createView];
    [self loadData];
    
    

}

-(void)createView
{
    //周 2 月 3 学期 4 年
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"周榜",@"月榜",@"学期榜",@"年榜",nil];
    _segMentView  = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segMentView.frame = CGRectMake(10, 15, kScreenWidth-20, 30);
    _segMentView.selectedSegmentIndex = 0;
    _segMentView.tintColor = RGB(170, 170, 170);
    _segMentView.backgroundColor = [UIColor whiteColor];
    [_segMentView addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:14.0],UITextAttributeFont,nil];
    [_segMentView setTitleTextAttributes:dic forState:UIControlStateSelected];
    NSDictionary *noseDic = [NSDictionary dictionaryWithObjectsAndKeys:RGB(85,85,85),UITextAttributeTextColor,[UIFont systemFontOfSize:14.0],UITextAttributeFont,nil];
    [_segMentView setTitleTextAttributes:noseDic forState:UIControlStateNormal];
    [self.view addSubview:_segMentView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30+15, kScreenWidth, kScreenHeight-64-30-15) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = Base_Color2;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOlDData)];
}
-(void)loadNewData
{
    _pagenum = 1;
    [self loadData];
}

-(void)loadOlDData
{
    _pagenum ++;
    [self loadData];
}
-(void)loadData{
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"styleOfStudyRankingList",@"status":@(self.status),@"page":@(_pagenum),@"pageCount":Message_Num} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        _dataSourceArr = [NSMutableArray array];
        NSArray *dataArray = responseObject[@"data"];
        [self hiddenErrorView];
        if (_pagenum    ==  1) {
            _modelArr = [NSMutableArray array];
            if (dataArray.count==0) {
                [self.tableView reloadData];
                [self showErrorViewLoadAgain:@"没有相关数据！"];
                return ;
            }
        }
        for (NSDictionary *dic in dataArray) {
            StudyStyleModel   *model = [[StudyStyleModel alloc] init];
    
            [model yy_modelSetWithDictionary:dic];
            [_dataSourceArr addObject:model];
        }
        [_modelArr addObjectsFromArray:_dataSourceArr];
        [self.tableView reloadData];
        if (_pagenum==1) {
            [self starAnimationWithTableView:self.tableView];
        }
        
        [self.tableView.mj_header endRefreshing];
        if (dataArray.count<[Message_Num intValue]) {
            if (_pagenum>0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
        }
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}

- (void)starAnimationWithTableView:(UITableView *)tableView {
    
    [TableViewAnimationKit showWithAnimationType:3 tableView:tableView];
}
#pragma mark
-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)segMentControl
{
    _status = (int)segMentControl.selectedSegmentIndex+1;
    _pagenum = 1;
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    [self loadData];
}
#pragma mark  DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _modelArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"StudyStyleCell";
    StudyStyleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[StudyStyleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    StudyStyleCell *model = _modelArr[indexPath.row];
//    model.  =  [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    cell.model = _modelArr[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class currentClass = [StudyStyleCell class];
    StudyStyleCell *model = _modelArr[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
    
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
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
