//
//  ClassPhoneNumViewController.m
//  CSchool
//
//  Created by mac on 16/7/6.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ClassPhoneNumViewController.h"
#import "PersonInfoViewController.h"
#import "DetailTableCell.h"
#import "SearchBaseViewController.h"
#import "ChineseString.h"

static NSString *const cellIdentifier = @"CellIdentifier";


@interface ClassPhoneNumViewController ()<UITableViewDataSource, UITableViewDelegate,XGAlertViewDelegate,UISearchBarDelegate,SearchBaseViewControllerDelegate>
{
    NSMutableArray *toBeReturned;
}
//通讯录列表
@property (nonatomic,strong) UITableView *infoTableView;
@property (nonatomic,strong) NSMutableArray *nameArr;
@property (nonatomic, strong)NSMutableArray *numArr;
@property (nonatomic,strong) NSMutableArray *phoneNumArr;
@property (nonatomic,strong) NSMutableDictionary *selectedDic;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) NSArray *dataNameArray;
@end

@implementation ClassPhoneNumViewController
- (void)showAlert{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"consulerShow"] isEqualToString:@"1"]) {
        XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"本数据仅供参考，请以实际为准。" WithCancelButtonTitle:@"不再提示" withOtherButton:nil];
        alert.isBackClick = YES;
        [alert show];
    }
}
- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"consulerShow"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showAlert];
    [self createView];
    [self loadData];
}
#pragma mark  初始化视图
/**
 *  初始化视图
 */
-(void)createView
{
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入要搜索的姓名/学号/手机号";
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    backView.backgroundColor = [UIColor redColor];
    self.infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, kScreenWidth,kScreenHeight-114) style:UITableViewStylePlain];
    [_infoTableView registerNib:[UINib nibWithNibName:@"DetailTableCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.infoTableView.dataSource = self;
    self.infoTableView.delegate = self;
    self.infoTableView.tableFooterView = [UIView new];
    [backView addSubview:_searchBar];
    [self.view addSubview:backView];
    [self.view addSubview:_infoTableView];
}
#pragma mark 解析数据
-(void)loadData{
    [ProgressHUD show:@"正在加载..."];
    AppUserIndex *user =  [AppUserIndex GetInstance];
    NSString *role_type = user.role_type;
    //学生角色进入的时候
    if ([role_type isEqualToString: @"2"]) {
        [NetworkCore requestPOST:user.API_URL parameters:@{@"userid":stuNum,@"rid":@"getStudentAdressBook"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            [ProgressHUD dismiss];
            _dataNameArray = responseObject[@"data"];
            if (_dataNameArray.count==0) {
                [self showErrorViewLoadAgain:@"未查询到相关数据"];
            }
            else{
            [self handleData];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            [ProgressHUD dismiss];
            [self showErrorViewLoadAgain:error[@"msg"]];
        }];
    }else if([role_type isEqualToString:@"1"]){//教师角色进入
        [NetworkCore requestPOST:user.API_URL parameters:@{@"classNo":_classID,@"rid":@"getStuAdressBookByClass"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            [ProgressHUD dismiss];
            _dataNameArray = responseObject[@"data"];
            if (_dataNameArray.count==0) {
                [self showErrorViewLoadAgain:@"未查询到相关数据"];
            }
            else{
                [self handleData];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            [ProgressHUD dismiss];
            [self showErrorViewLoadAgain:error[@"msg"]];
        }];
    }else//非教师学生角色进入
    {
        [ProgressHUD dismiss];
        [self showErrorView:@"未查询到相关数据" andImageName:nil];
    }
    
}
/**
 *  解析数据
 */
-(void)handleData
{
    _numArr = [NSMutableArray array];
    _phoneNumArr = [NSMutableArray array];
    _nameArr = [NSMutableArray array];

    for (NSDictionary *dic in self.dataNameArray) {
        if (dic[@"SJH"]) {
            [_phoneNumArr addObject:dic[@"SJH"]];
        }else
        {
            [_phoneNumArr addObject:@"无"];
        }
        [_nameArr addObject:dic[@"XM"]];
        [_numArr addObject:dic[@"XH"]];
    }
    [self.infoTableView reloadData];
}
-(NSMutableDictionary*)selectedDic{
    if (_selectedDic==nil) {
        _selectedDic = [[NSMutableDictionary alloc]init];
    }
    return _selectedDic;
}
#pragma mark 私有方法
//解决分割线不到左边界的问题
-(void)viewDidLayoutSubviews {
    if ([_infoTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_infoTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_infoTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_infoTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataNameArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([DetailTableCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        nibsRegistered = YES;
    }
    DetailTableCell *cell = (DetailTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    cell.studentInfoArr = _seniorArr;
    NSDictionary *dic = _dataNameArray[indexPath.row];
    cell.dic = dic;
    if (dic[@"SJH"]) {
        cell.phoneLabel.text =dic[@"SJH"];
    }else{
        cell.phoneLabel.text = @"无";
    }
    cell.nameLabel.text = dic[@"XH"];
    cell.numLabel.text = dic[@"XM"];
    cell.dic = dic;
    return cell;
}
#pragma mark TableviewDelegate
//自定义cell的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedIndexPath && _selectedIndexPath.row == indexPath.row) {
        _selectedIndexPath = nil;
    } else {
        _selectedIndexPath = indexPath;
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedIndexPath && _selectedIndexPath.row == indexPath.row) {
        return 120;
    } else {
        return 70;
    }
}

#pragma mark  -UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    SearchBaseViewController  *vc = [[SearchBaseViewController alloc] init];
    vc.originalArray = [NSMutableArray arrayWithArray:self.dataNameArray];
    vc.placeholder = @"学号/姓名/手机号搜索";
    vc.seacrKeyArr = @[@"XM",@"XH",@"SJH"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}
#pragma mark SearchViewControllerDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath withDataSourceArr:(NSMutableArray *)dataArr withSearchText:(NSString *)text
{
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([DetailTableCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"CellIdentifier"];
        nibsRegistered = YES;
    }
    DetailTableCell *cell = (DetailTableCell *)[tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    NSDictionary *dic = dataArr[indexPath.row];
    cell.dic = dic;
    if (dic[@"SJH"]) {
        cell.phoneLabel.attributedText =[self searchText:text withContentString:dic[@"SJH"]];
    }else{
        cell.phoneLabel.attributedText = [self searchText:text withContentString:@"无"];
    }
    cell.nameLabel.attributedText = [self searchText:text withContentString:dic[@"XH"]];
    cell.numLabel.attributedText = [self searchText:text withContentString:dic[@"XM"]];
    return cell;
}
-(NSMutableAttributedString *)searchText:(NSString *)text withContentString:(NSString *)content
{
    NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc]initWithString:content];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<text.length; i++) {
        NSString *a = [text substringWithRange:NSMakeRange(i, 1)];
        [arr addObject:a];
    }
    for (int i = 0; i < content.length; i ++) {
        NSString *a = [content substringWithRange:NSMakeRange(i, 1)];
        if ([arr containsObject:a]) {
            [attributeString setAttributes:@{NSForegroundColorAttributeName:Base_Orange,NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(i, 1)];
        }
    }
    return attributeString;
}
-(void)tableView:(UITableView *)tableView didSelectSearchRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];//取消第一相应
    if (_selectedIndexPath && _selectedIndexPath.row == indexPath.row) {
        _selectedIndexPath = nil;
    } else {
        _selectedIndexPath = indexPath;
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
-(CGFloat)tableView:(UITableView *)tableView heightForSearchRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedIndexPath && _selectedIndexPath.row == indexPath.row) {
        return 120;
    } else {
        return 70;
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
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
