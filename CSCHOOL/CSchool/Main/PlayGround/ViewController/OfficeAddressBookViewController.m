//
//  OfficeAddressBookViewController.m
//  CSchool
//
//  Created by mac on 16/9/6.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "OfficeAddressBookViewController.h"
#import "RTArealocationView.h"
#import "ClassPhoneNumViewController.h"
#include "SearchBaseViewController.h"
#import "OfficeCell.h"
#import "OfficePersonInfoViewController.h"
#define Name  @"name"
#define Phone @"phonenum"
#define Bumen @"departments"
@interface OfficeAddressBookViewController ()<ArealocationViewDelegate,UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,SearchBaseViewControllerDelegate>
{
    NSMutableDictionary *deparDic;
    NSArray *_originData;
}
//搜索框的数据源
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *dataNameArray;
//下方分级的数据源
@property (nonatomic, strong) RTArealocationView *arealocationView;
@property (nonatomic, strong) NSMutableArray *allCity;
@property (nonatomic,strong)NSMutableArray *allBjAidArr;
@property (nonatomic,strong) NSMutableArray *SeniorArr;
@property (nonatomic,strong) NSMutableArray *idArr;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property  (nonatomic,assign)BOOL isBreakNet;

@end

@implementation OfficeAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ProgressHUD show:@"正在加载..."];
    [self createView];
    [self loadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}
/**
 *  初始化视图
 */
-(void)createView
{
    self.navigationItem.title= @"教工通讯录";
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入要搜索的部门/姓名/手机号";
    [self.view addSubview:_searchBar];
    
    //分级页面
    self.arealocationView = [[RTArealocationView alloc] initWithFrame:CGRectMake(0, 50,kScreenWidth, kScreenHeight-100)];
    self.arealocationView.delegate = self;
    for (int i = 0; i<self.allCity.count; i++) {
        self.arealocationView.otherTableviewArr = [NSMutableArray arrayWithArray:self.allCity[i]];
    }
    self.arealocationView.firstTableviewArr = [NSMutableArray arrayWithArray:_SeniorArr];
    self.arealocationView.totalTiltle = @[@"部门",@"职位",@"姓名"];
    //初始化 选择的格子
    NSInteger select[3] = {0,0,-1};
    [self.arealocationView selectRowWithSelectedIndex:select];
    [self.arealocationView showArealocationInView:self.view];
    [self.view addSubview:self.arealocationView];
}
#pragma mark 初始化数据
-(void)loadData{
    _originData = [NSArray array];
    AppUserIndex *user =  [AppUserIndex GetInstance];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getDepartInfo" } success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _originData = [responseObject objectForKey:@"data"];
        if (_originData.count==0) {
            [ProgressHUD dismiss];
            [self showErrorViewLoadAgain:@"获取通讯录信息失败"];
        }
        else{
            [self handleData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];
    }];
    //获取全部通讯信息
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getAllTeacherInfo"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        _dataNameArray = responseObject[@"data"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD showError:error[@"msg"]];
    }];
}
-(void)handleData
{
    //年级数组
    _SeniorArr = [NSMutableArray array];
    self.allCity = [NSMutableArray array];
    self.allBjAidArr = [NSMutableArray array];
    deparDic = [NSMutableDictionary dictionary];
    //学院数组
    NSMutableArray *deparNameArr = [NSMutableArray array];
    //班级数组
    NSMutableArray *classNameArr = [NSMutableArray array];
    //按照学院 将班级分类
    NSMutableArray *class = [NSMutableArray array];
    //所有的班级
    NSMutableArray *totalClass = [NSMutableArray array];
    //存放班级id的数组
    _idArr = [NSMutableArray array];
    for (NSDictionary *dic in _originData) {
        //存储部门数组
        [_SeniorArr  addObject:[NSString stringWithFormat:@"%@",dic[@"seniorname"]]];
        [_idArr addObject:dic[@"seniorid"]];
        //将不同年级各学院的信息 按照年级存储为字典格式
        long key = [[NSString stringWithFormat:@"%@",dic[@"seniorid"]] longLongValue];
        NSNumber *longNumber = [NSNumber numberWithLong:key];
        NSString *longStr = [longNumber stringValue];
        [deparDic setObject:dic[@"departments"] forKey:longStr];
    }
    //处理学院数组
    NSMutableArray *totalDepartArr = [NSMutableArray array];
    NSArray *keyCount = [deparDic allKeys];
    for (int i =0 ; i<keyCount.count; i++) {
        NSString *key =[NSString stringWithFormat:@"%d",i+1];
        for (NSDictionary *dic in deparDic[key]) {
            [deparNameArr addObject:dic[@"departname"]];
            [class addObject:dic[@"personname"]];
        }
        [totalClass addObject:class];
        [totalDepartArr addObject:deparNameArr];
        //将继续作为存所有放班级的数组
        class = [NSMutableArray array];
        //继续作为存放班级id的数组
        deparNameArr = [NSMutableArray array];
    }
    NSMutableArray *perCity = [NSMutableArray array];
    NSMutableArray *perIDCity = [NSMutableArray array];
    NSMutableArray *preClassArr = [NSMutableArray array];
    for (int j = 0; j<totalDepartArr.count; j++) {
        NSArray *depar = totalDepartArr[j];
        for (int i = 0; i<depar.count; i++) {
            NSArray *nameArr = totalClass[j];
            NSMutableArray *BjidArr = [NSMutableArray array];
            for (NSDictionary *nameDic in nameArr[i]) {
                [classNameArr addObject:nameDic[@"name"]];
                [BjidArr addObject:nameDic[@"nameid"]];
            }
            //存放该班级的所有信息的数组
            [class addObject:classNameArr];
            //存放班级代码
            [deparNameArr addObject:BjidArr];
            NSDictionary *dic = @{@"district":totalDepartArr[j][i],@"commercial":class[i]};
            NSDictionary *IDDic = @{@"district":totalDepartArr[j][i],@"commercial":deparNameArr[i]};
            classNameArr = [NSMutableArray array];
            preClassArr = [NSMutableArray array];
            BjidArr = [NSMutableArray array];
            [perCity addObject:dic];
            [perIDCity addObject:IDDic];
        }
        [self.allCity addObject:perCity];
        [self.allBjAidArr addObject:perIDCity];
        //重新初始化
        class = [NSMutableArray array];
        deparNameArr= [NSMutableArray array];
        perCity = [NSMutableArray array];
        perIDCity = [NSMutableArray array];
    }
    if (_SeniorArr.count==0) {
        _SeniorArr =[NSMutableArray arrayWithArray: @[@"暂无数据"]];
        _isBreakNet = YES;
    }else if (self.allCity.count ==0) {
        _isBreakNet = YES;
        NSArray *cw = @[@"暂无数据"];
        NSDictionary *xzq1 = @{@"district":@"暂无数据",@"commercial":cw};
        self.allCity =[NSMutableArray arrayWithArray:@[@[xzq1]]];
    }else{
        _isBreakNet = NO;
    }
    [self.arealocationView reloadRTData];
    NSInteger select[3] = {0,0,-1};
    [self.arealocationView selectRowWithSelectedIndex:select];
    [ProgressHUD dismiss];
}
//懒加载
- (NSArray *)dataNameArray
{
    if (_dataNameArray == nil) {
        _dataNameArray = [NSArray array];
    }
    return _dataNameArray;
}
#pragma mark  -UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    SearchBaseViewController  *vc = [[SearchBaseViewController alloc] init];
    vc.originalArray = [NSMutableArray arrayWithArray:self.dataNameArray];
    vc.placeholder = @"姓名/部门/手机号搜索";
    vc.seacrKeyArr = @[Name,Bumen,Phone];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}
#pragma mark searchDel
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
}

#pragma  mark SearchViewControllerDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath withDataSourceArr:(NSMutableArray *)dataArr withSearchText:(NSString *)text
{
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([OfficeCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"officeInfoCell"];
        nibsRegistered = YES;
    }
    OfficeCell *cell = (OfficeCell *)[tableView dequeueReusableCellWithIdentifier:@"officeInfoCell"];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    NSDictionary *dic = dataArr[indexPath.row];
    cell.dic = dic;
   
    cell.nameLabel.text =[NSString stringWithFormat:@"%@",dic[@"departments"]];
    cell.numLabel.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
    cell.phoneLabel.text =[NSString stringWithFormat:@"%@",dic[@"phonenum"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectSearchRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"officeCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"officeCell"];
    }
    return cell;
}

#pragma mark ArealocationViewDelegate
/**
 *  每一级要展示的数量
 *
 *  @param arealocationView arealocationView
 *  @param level            层级
 *  @param index            cell索引
 *  @param selectedIndex    所有选中的索引数组
 *
 *  @return 展示的数量
 */
- (NSInteger)arealocationView:(RTArealocationView *)arealocationView countForClassAtLevel:(NSInteger)level index:(NSInteger)index selectedIndex:(NSInteger *)selectedIndex {
    NSMutableArray *num = [NSMutableArray array];
    if (level==0) {
        return _SeniorArr.count;
        
    }else if (level==1) {
        NSInteger i = [_idArr[selectedIndex[0]] integerValue];
        for (NSDictionary *dic in self.allCity[i-1]) {
            [num addObject:dic[@"district"]];
        }
        return num.count;
        
    }else {
        //        NSArray *preArr = self.allCity[index];
        //        NSDictionary *dict = preArr[index];
        //        NSArray *comArr = dict[@"commercial"];
        //        return comArr.count;
        NSInteger i = [_idArr[selectedIndex[0]] integerValue];
        
        NSDictionary *dict = self.allCity[i-1][selectedIndex[1]];
        
        NSArray *comArr = dict[@"commercial"];
        
        return comArr.count;
    }
}
/**
 *  cell的标题
 *
 *  @param arealocationView arealocationView
 *  @param level            层级
 *  @param index            cell索引
 *  @param selectedIndex    所有选中的索引数组
 *
 *  @return cell的标题
 */
- (NSString *)arealocationView:(RTArealocationView *)arealocationView titleForClass:(NSInteger)level index:(NSInteger)index selectedIndex:(NSInteger *)selectedIndex {
    //第一级标题
    if (level==0) {
        return [NSString stringWithFormat:@"%@", _SeniorArr[index]];
    }
    //第二级标题
    else if (level==1) {
        NSInteger i = [_idArr[selectedIndex[0]] integerValue];
        NSDictionary *dict = self.allCity[i-1][index];
        return dict[@"district"];
    }else {
        NSInteger i = [_idArr[selectedIndex[0]] integerValue];
        
        NSDictionary *dict = self.allCity[i-1][selectedIndex[1]];
        
        NSArray *comArr = dict[@"commercial"];
        
        return comArr[index];
    }
}
/**
 *  选取完毕执行的方法
 *
 *  @param arealocationView arealocationView
 *  @param selectedIndex           每一层选取结果的数组
 */
- (void)arealocationView:(RTArealocationView *)arealocationView finishChooseLocationAtIndexs:(NSInteger *)selectedIndex{
    
    NSLog(@"年级%ld",(long)selectedIndex[0]);
    NSLog(@"学院%ld",(long)selectedIndex[1]);
    NSLog(@"班级%ld",(long)selectedIndex[2]);
    
    if (_isBreakNet) {
        [ProgressHUD showError:@"没有数据了,请检查网络~"];
        return;
    }
    NSDictionary *dic  = self.allCity[selectedIndex[0]][selectedIndex[1]];
    NSArray *classArr = [dic objectForKey:@"commercial"];
    OfficePersonInfoViewController *classPhoneVC = [[OfficePersonInfoViewController alloc]init];
    classPhoneVC.title = @"详情";
    NSDictionary *IDdic  = self.allBjAidArr[selectedIndex[0]][selectedIndex[1]];
    NSArray *classIDArr = [IDdic objectForKey:@"commercial"];
    classPhoneVC.nameID = classIDArr[selectedIndex[2]];
    classPhoneVC.personSeniorArr = @[_SeniorArr[selectedIndex[0]],dic[@"district"],classArr[selectedIndex[2]]];

    [self.navigationController pushViewController:classPhoneVC animated:YES];
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
