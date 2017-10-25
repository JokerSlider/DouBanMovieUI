//
//  LibraryBookDetailViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/12/28.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "LibraryBookDetailViewController.h"
#import "LibraryBookDetailCell.h"
#import "SDAutoLayout.h"
#import "LibraryHiddenView.h"
#import "LibraryBookLocationCell.h"
#import "LibraryBookModel.h"
#import <YYModel.h>

@interface LibraryBookDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSMutableArray *dataMutableArr;

@property (nonatomic, retain) NSArray *detailArr;

@property (nonatomic, retain) NSMutableArray *locationArr;

@end

@implementation LibraryBookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"图书详情";
    
    [self loadData];
    _mainTableView.backgroundColor = RGB(245, 245, 245);
    _mainTableView.tableFooterView = [UIView new];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    
    [ProgressHUD show:nil];
    
    NSArray *titleArr = @[@"题名",@"文献类型",@"责任者",@"出版社",@"出版年份",@"价格",@"ISBN",@"入藏日期"];
//    NSArray *detailArr = [[NSArray alloc] init];
    
    NSDictionary *commitDic = @{
                          @"rid":@"showBookInfoByCallNo",
                          @"callNo":_model.suoshuNum
                          };
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [_model yy_modelSetWithDictionary:responseObject[@"basic"]];
        //图书model与搜索列表共用一个
        _detailArr = @[_model.bookName, _model.docType, _model.author, _model.publicName, _model.publicYear, _model.PRICE, _model.M_ISBN, _model.IN_DATE];
        
        //处理图书详情数据
        _dataMutableArr = [NSMutableArray array];
        for (int i= 0; i<titleArr.count; i++) {
            LibraryBookDetailModel *model = [[LibraryBookDetailModel alloc] init];
            model.title = titleArr[i];
            model.detail = _detailArr[i];
            [_dataMutableArr addObject:model];
        }
        [_mainTableView reloadData];
        
        //处理馆藏数据
        _locationArr = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            LibraryBookLocationModel *model = [[LibraryBookLocationModel alloc] init];
            model.statusDic = [responseObject valueForKeyPath:@"basic.LIB_STATE"];
            [model yy_modelSetWithDictionary:dic];
            [_locationArr addObject:model];
        }
        LibraryHiddenView *hiddenView = [[LibraryHiddenView alloc] initWithDataSource:_locationArr];
        [self.view addSubview:hiddenView];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    [self.mainTableView startAutoCellHeightWithCellClass:[RepairListTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    
    return self.dataMutableArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"LibraryBookDetailCell";
    LibraryBookDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LibraryBookDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataMutableArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    //    return [self.mainTableView cellHeightForIndexPath:indexPath model:self.dataMutableArr[indexPath.row] keyPath:@"model"];
    return [self.mainTableView cellHeightForIndexPath:indexPath model:self.dataMutableArr[indexPath.row] keyPath:@"model" cellClass:[LibraryBookDetailCell class] contentViewWidth:kScreenWidth];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
