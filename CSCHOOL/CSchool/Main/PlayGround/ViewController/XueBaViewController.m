//
//  XueBaViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 2017/9/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "XueBaViewController.h"
#import <YYLabel.h>
#import "SDAutoLayout.h"
#import "XuebaRankCell.h"
#import <YYModel.h>
#import "XGSegmentedControl.h"
#import <MJRefresh.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface XueBaViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) UIImageView *headerView;

@property (nonatomic, retain) YYLabel *rankLabel;

@property (nonatomic, retain) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger statusCode;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation XueBaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    _tableView.backgroundColor = Base_Orange;
    self.title = @"学霸排行榜";
    _currentPage = 1;
    _statusCode = 1;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadDataFoot)];

    
    [self createHeaderView];
    [self loadData];
}

- (void)createHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 220)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bacImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
    [bacImageView setImage:[UIImage imageNamed:@"rank_bg"]];
    
    _headerView = [[UIImageView alloc] init];
    [_headerView setImage:PlaceHolder_Image];
    
    UIImageView *logoView = [UIImageView new];
    [logoView setImage:[UIImage imageNamed:@"rank_g"]];
    
    _rankLabel = [YYLabel new];
    _rankLabel.font = [UIFont systemFontOfSize:20];
    _rankLabel.textColor = [UIColor whiteColor];
//    _rankLabel.text = @"12名";
    
    [bacImageView sd_addSubviews:@[_headerView, logoView, _rankLabel]];
    
    [view addSubview:bacImageView];
    
    _headerView.sd_layout
    .centerXEqualToView(bacImageView)
    .centerYEqualToView(bacImageView)
    .heightIs(68)
    .widthEqualToHeight();
    
    logoView.sd_layout
    .rightSpaceToView(_headerView, 32)
    .centerYEqualToView(_headerView)
    .heightIs(37)
    .widthIs(32);
    
    _rankLabel.sd_layout
    .leftSpaceToView(_headerView, 26)
    .rightSpaceToView(bacImageView, 2)
    .centerYEqualToView(_headerView)
    .heightIs(48);
    
    XGSegmentedControl *segment = [[XGSegmentedControl alloc] initWithItems:@[@"班级",@"学院",@"年级"]];
    [view addSubview:segment];
    
    segment.sd_layout
    .leftSpaceToView(view, 30)
    .rightSpaceToView(view, 30)
    .heightIs(30)
    .topSpaceToView(bacImageView, 10);
    
    segment.segmentItemClick = ^(NSInteger index) {
        switch (index) {
            case 0:{
                _statusCode = 1;
                _currentPage = 1;
            }
                break;
            case 1:{
                _statusCode = 3;
                _currentPage = 1;
            }
                break;
            case 2:{
                _currentPage = 1;
                _statusCode = 2;
            }
                break;
            default:
                break;
        }
        [_tableView.mj_header beginRefreshing];
    };
    
    _tableView.tableHeaderView = view;
}

- (void)loadDataFoot{
    _currentPage++;
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"superScholarRankingList", @"userid":[AppUserIndex GetInstance].role_id, @"status":@(_statusCode), @"page":@(_currentPage), @"pageCount":@"10"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [_tableView.mj_footer endRefreshing];
        for (NSDictionary *dic in [responseObject valueForKeyPath:@"data.childrens"]) {
            XuebaModel *model = [[XuebaModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [_tableView.mj_footer endRefreshing];
    }];
}

- (void)loadData{
    _currentPage = 1;
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"superScholarRankingList", @"userid":[AppUserIndex GetInstance].role_id, @"status":@(_statusCode), @"page":@(_currentPage), @"pageCount":@"10"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _dataArray = [NSMutableArray array];
        [_tableView.mj_header endRefreshing];
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            return ;
        }
        [_headerView sd_setImageWithURL:[NSURL URLWithString:[responseObject valueForKeyPath:@"data.txdz"]]];
        _rankLabel.text = [NSString stringWithFormat:@"%@名",[responseObject valueForKeyPath:@"data.pm"]];
        
        for (NSDictionary *dic in [responseObject valueForKeyPath:@"data.childrens"]) {
            XuebaModel *model = [[XuebaModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [_tableView.mj_header endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indenty = @"XuebaRankCell";
    XuebaRankCell *cell = [tableView dequeueReusableCellWithIdentifier:indenty];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XuebaRankCell" owner:self options:nil] lastObject];
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
