//
//  PushSearchViewController.m
//  CSchool
//
//  Created by mac on 16/10/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PushSearchViewController.h"
#import "ZYPinYinSearch.h"
#import "FindLoseModel.h"
#import "FindLose2Cell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import <MJRefresh.h>
#import "FindInfoViewController.h"
@interface PushSearchViewController ()<UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate,XGAlertViewDelegate>

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) UITableView *mainTableView;
@property (nonatomic,assign)int  page;
@property (nonatomic,copy)NSString *goodName;
@property (nonatomic, strong) NSMutableArray *modelsArray;

@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

@implementation PushSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _modelsArray =[NSMutableArray arrayWithArray:@[]];
    [self createViews];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removieMyView];
}
-(void)removieMyView
{
    [_searchBar removeFromSuperview];
    [_mainTableView removeFromSuperview];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationItem setHidesBackButton:NO];
}
//最新的
-(void)loadPushData
{
    if (!_page) {
        _page = 1;
    }
    NSString *pageNum = [NSString stringWithFormat:@"%d",_page];
    [self loadDataWithFuncTypePushpageNum:pageNum withGoodName:_goodName];
}
//以前的
-(void)loadPushPastData
{
    _page = 1;
    NSString *pageNum = [NSString stringWithFormat:@"%d",_page];
    [self loadDataWithFuncTypePushpageNum:pageNum withGoodName:_goodName];
    
}
-(void)loadDataWithFuncTypePushpageNum:(NSString *)page withGoodName:(NSString *)goodName
{
    [ProgressHUD show:@""];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"searchReleaseInfoByInput",@"module":_funcType,@"auitype":@"0",@"page":page,@"pageCount":Message_Num,@"keyword":goodName} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        _dataSourceArr = [NSMutableArray array];
        [self hiddenErrorView];
        NSArray *dataArray = responseObject[@"data"];
        if ([page isEqualToString:@"1"]) {
            _modelsArray = [NSMutableArray array];
            if (dataArray.count==0) {
                [self.mainTableView.mj_footer resetNoMoreData];
//                [self showErrorView:@"没有找到相关内容,试试搜索别的关键字吧"];
                [self showErrorView:@"没有找到相关内容,试试搜索别的关键字吧" andImageName:nil];

                return ;
            }
        }
        for (NSDictionary *dic in dataArray) {
            FindLoseModel   *model = [[FindLoseModel alloc] init];
            model.type = _funcType;
            model.isSearch = @"1";
            model.thumb  = responseObject[@"thumb"];
            [model yy_modelSetWithDictionary:dic];
            [_dataSourceArr addObject:model];
        }
        [_modelsArray addObjectsFromArray:_dataSourceArr];
        [self hiddenErrorView];
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        if (dataArray.count<[Message_Num intValue]) {
            if ([page intValue]>=0) {
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
        }
        [self.mainTableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
        [self showErrorViewLoadAgain:@"没有相关数据！"];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }];

}
/*@"键盘监听"**/
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
//    int width = keyboardRect.size.width;
    CGRect frame = _mainTableView.frame;
    frame.size.height = kScreenHeight-70-height;
    _mainTableView.frame = frame;
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    CGRect frame = _mainTableView.frame;
    frame.size.height = kScreenHeight-70;
    _mainTableView.frame = frame;
    
}
- (void)createViews
{
    self.view.backgroundColor = Base_Color2;
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.center = CGPointMake(kScreenWidth/2, 84);
    _searchBar.frame = CGRectMake(10, 20,kScreenWidth-20, 0);
    [_searchBar setContentMode:UIViewContentModeBottomLeft];
    _searchBar.delegate = self;
    _searchBar.backgroundColor=[UIColor clearColor];
    _searchBar.searchBarStyle=UISearchBarStyleDefault;
    _searchBar.tintColor = [UIColor greenColor];
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor yellowColor];
    [_searchBar becomeFirstResponder];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[NSValue valueWithUIOffset:UIOffsetMake(0, 1)],UITextAttributeTextShadowOffset,nil] forState:UIControlStateNormal];
    _searchBar.showsCancelButton =YES;
    _searchBar.tag=1000;
    [self.navigationController.navigationBar addSubview:_searchBar];
    _searchBar.placeholder = _placeholder;
    
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [UIView new];
    
    [self.view addSubview:_mainTableView];
    self.mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadPushPastData)];
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadPushData)];
//    [self showErrorView:@"请输入搜索内容"];
    [self showErrorView:@"请输入搜索内容" andImageName:nil];

    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}
////设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _modelsArray.count;
}
//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_modelsArray.count==0) {
        static NSString *idenfiter = @"cell";
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenfiter];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:idenfiter];
        }
        if (indexPath.row ==2) {
            cell.textLabel.text  =@"没有找到相关内容,试试别的关键字吧";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font =[UIFont fontWithName:@"Arial Old" size:16];
            cell.textLabel.textColor = Base_Orange;
        }
        return  cell;
        
    }else{
        static  NSString *ID =@"myPublish";
        FindLose2Cell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[FindLose2Cell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        FindLoseModel *model = self.modelsArray[indexPath.section];
        cell.model = model;
        return cell;
    }
    return  nil;
}


#pragma mark TableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [FindLose2Cell class];
    
    FindLoseModel *model = self.modelsArray[indexPath.section];
    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
/*设置标题尾的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
/*设置标题脚的名称*/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor redColor];
    return headView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindInfoViewController *vc = [[FindInfoViewController alloc]init];
    FindLoseModel *model = self.modelsArray[indexPath.section];
    vc.model = model;
    vc.imageArr = model.thumblicArray;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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


#pragma -mark searchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length==0) {
        _modelsArray = [NSMutableArray array];
    }
    [_mainTableView reloadData];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _goodName = searchBar.text;
    [self loadPushData];
    [searchBar resignFirstResponder];
//    CGRect frame = _searchBar.frame;
//    //    _searchBar.frame = CGRectMake(10, 20,kScreenWidth-20, 0);
//    frame = CGRectMake(50, 20, kScreenWidth-80, 0);
//    _searchBar.frame = frame;
//    [self.navigationItem setHidesBackButton:NO];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder]; //searchBar失去焦点
    UIButton *cancelBtn = [searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
    cancelBtn.enabled = YES; //把enabled设置为yes
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
