//
//  ImportWorkListViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/9/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ImportWorkListViewController.h"
#import "ImportWorkListCell.h"
#import <YYModel.h>
#import "ImportWorkDetailViewController.h"
#import <MJRefresh.h>
#import "SDAutoLayout.h"
#import "TePopList.h"

@interface ImportWorkListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIButton *_rightButton;
    UILabel *_btnTitleLabel;
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPageCount;
@property (nonatomic, retain) NSArray *yearArray;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, assign) NSInteger selIndex;
@end

@implementation ImportWorkListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"重点工作监控";
    _year = @"";

    [self createNav];
    [self getAllYear];
    [self loadData];
    _dataArray = [NSMutableArray array];
    _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}

- (void)createNav{
    //第三种方式（自定义按钮）
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 84, 24);
    [_rightButton addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"import_la"]];
    _btnTitleLabel = ({
        UILabel *view = [UILabel new];
//        view.text = @"2015年";
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = [UIColor whiteColor];
        view.textAlignment = NSTextAlignmentRight;
        view;
    });
    
    [_rightButton sd_addSubviews:@[_btnTitleLabel, imageView]];
    
    _btnTitleLabel.sd_layout
    .leftSpaceToView(_rightButton, 0)
    .topSpaceToView(_rightButton,0)
    .widthIs(60)
    .heightIs(24);
    
    imageView.sd_layout
    .leftSpaceToView(_btnTitleLabel,1)
    .centerYEqualToView(_btnTitleLabel)
    .widthIs(10)
    .heightIs(5);
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightBtnClick:(UIButton *)sender{
    //弹出选择年份的列表
    NSMutableArray *yearMutableArray = [NSMutableArray array];
    for (NSDictionary *dic in _yearArray) {
        [yearMutableArray addObject:[NSString stringWithFormat:@"%@",dic[@"ID"]]];
    }
    _currentPageCount = 0;
    WEAKSELF;
    TePopList *pop = [[TePopList alloc] initWithListDataSource:yearMutableArray withTitle:@"选择年度" withSelectedBlock:^(NSInteger select) {
        _year = yearMutableArray[select];
        _btnTitleLabel.text = [NSString stringWithFormat:@"%@年",_year];
        _dataArray = [NSMutableArray array];
        _selIndex = select;
        [weakSelf loadData];
    }];
    pop.isAllowBackClick = YES;
    [pop selectIndex:_selIndex];
    [pop show];
}

//获取到所有年度列表
- (void)getAllYear{
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getArrayYear"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _yearArray = responseObject[@"data"];
        _btnTitleLabel.text = [NSString stringWithFormat:@"%@年",responseObject[@"defaultyear"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
    }];
}

- (void)loadData{
    [ProgressHUD show:nil];
    _currentPageCount++;

    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showZdgzList",@"year":_year,@"department":@"", @"page":@(_currentPageCount),@"pageCount":@""} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        for (NSDictionary *dic in responseObject[@"data"]) {
            ImportWorkListModel *model = [[ImportWorkListModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_dataArray addObject:model];
        }
        
        if (_dataArray.count == 0) {
            [self showErrorView:@"暂无该年度重点工作" andImageName:nil];
            [ProgressHUD dismiss];
            return ;
        }else{
            [self hiddenErrorView];
            [_mainTableView reloadData];
        }
        
        [_mainTableView.mj_footer endRefreshing];
        
        //当获取到所有条目，将上拉加载禁掉
        if (_dataArray.count >= [responseObject[@"totalCount"] integerValue]) {
            [_mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [_mainTableView.mj_footer endRefreshing];

        [self showErrorViewLoadAgain:error[@"msg"]];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    [self.mainTableView startAutoCellHeightWithCellClass:[RepairListTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ImportWorkListCell";
    ImportWorkListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ImportWorkListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 86;
    return [self.mainTableView cellHeightForIndexPath:indexPath model:self.dataArray[indexPath.row] keyPath:@"model" cellClass:[ImportWorkListCell class] contentViewWidth:kScreenWidth];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ImportWorkDetailViewController *vc = [[ImportWorkDetailViewController alloc] init];
    ImportWorkListModel *model = _dataArray[indexPath.row];
    vc.workId = model.workId;
    vc.workName = model.workName;
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
