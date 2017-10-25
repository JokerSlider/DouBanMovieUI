//
//  LibarySearchViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/12/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "LibarySearchViewController.h"
#import "XGTypeSearchBar.h"
#import "LibarySearchCell.h"
#import "SDAutoLayout.h"
#import "LibraryBookDetailViewController.h"
#import <YYModel.h>
#import <MJRefresh.h>

@interface LibarySearchViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) XGTypeSearchBar *searchBar;
@property (nonatomic, retain) NSMutableArray *dataMutableArr;

@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation LibarySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self loadData];
    _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadDataFooter)];
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _mainTableView.tableFooterView = [UIView new];
     [self showErrorView:@"请输入搜索内容" andImageName:nil];
    _currentPage = 1;
    if (_keyType && _keyWord) {
        [self loadData];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createViews];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removieMyView];
//    [ProgressHUD dismiss];

}


-(void)removieMyView
{
    [_searchBar removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationItem setHidesBackButton:NO];
}

- (void)createViews
{
    self.view.backgroundColor = Base_Color2;
    _searchBar = [[XGTypeSearchBar alloc] initWithTypeArray:@[@{@"value":@"书名", @"key":@"1"}, @{@"value":@"作者", @"key":@"2"}]];
    _searchBar.frame = CGRectMake(10, 8,kScreenWidth-20, 30);
    _searchBar.tag=1000;
    WEAKSELF;
    if (_keyWord) {
        _searchBar.textField.text = _keyWord;
    }
    if (_keyType) {
        [_searchBar setTypeButtonTitleWithType:_keyType];
    }
    _searchBar.searchClick = ^(NSString *searchString, NSDictionary *typeDic){
        NSLog(@"%@",searchString);
        _keyWord = searchString;
        _keyType = typeDic[@"key"];
        _currentPage = 1;
//        [weakSelf.mainTableView  setContentOffset:CGPointMake(0,0) animated:NO];
//        [weakSelf loadData];
        [weakSelf.mainTableView.mj_header beginRefreshing];
        
    };
    _searchBar.searchCancel = ^(){
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController.navigationBar addSubview:_searchBar];

//
}

- (void)loadDataFooter{
    _currentPage++;
    [self loadData];
}

- (void)loadData{
    NSDictionary *commitDic = @{
                                @"rid":@"getBookInfoByInput",
                                @"keyword":_keyWord,
                                @"type":_keyType,
                                @"page":@(_currentPage),
                                @"pageCount":@"10"
                                };
    if (_currentPage == 1) {
        [ProgressHUD show:nil];
    }
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        [self hiddenErrorView];
        if (_currentPage == 1) {
            _dataMutableArr = [NSMutableArray array];
        }
        [_mainTableView.mj_footer endRefreshing];
        [_mainTableView.mj_header endRefreshing];
        if ([responseObject[@"data"] count] == 0){
            if (_currentPage == 1) {
                [self showErrorView:@"没有搜索数据" andImageName:nil];
            }
            return ;
        }else if ([responseObject[@"data"] count] < 10){
            [_mainTableView.mj_footer endRefreshingWithNoMoreData];
            
        }
        for (NSDictionary *dic in responseObject[@"data"]) {
            
            LibraryBookModel *model = [[LibraryBookModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_dataMutableArr addObject:model];
        }
        [_mainTableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [_mainTableView.mj_footer endRefreshing];

        [self showErrorViewLoadAgain:error[@"msg"]];
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataMutableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"LibarySearchCell";
    LibarySearchCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LibarySearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = self.dataMutableArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    return [self.mainTableView cellHeightForIndexPath:indexPath model:self.dataMutableArr[indexPath.row] keyPath:@"model" cellClass:[LibarySearchCell class] contentViewWidth:kScreenWidth];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    LibraryBookDetailViewController *vc = [[LibraryBookDetailViewController alloc] init];
    LibraryBookModel *model = _dataMutableArr[indexPath.row];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
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
