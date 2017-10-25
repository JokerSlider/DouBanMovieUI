//
//  OfficalSearchController.m
//  CSchool
//
//  Created by mac on 17/8/22.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OfficalSearchController.h"
#import "OfficalSearchInfoController.h"
#import <MJRefresh.h>
#import <YYModel.h>
#import "OfficalSearchCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "OfficalEndCell.h"
@interface OfficalSearchController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,TagTypeDelegate>
@property (nonatomic,copy)NSString *keyword;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (strong, nonatomic) UITableView *mainTableView;

@property (strong, nonatomic) UITableView *tagTableView;

@property (nonatomic,strong)NSMutableArray *modelArr;//内容数组
@property (nonatomic,strong)NSMutableArray *tagArr;//标签数组
@property (nonatomic,strong)NSMutableArray *dataSourceArr;
@property (nonatomic,assign)int  page;
@end

@implementation OfficalSearchController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
    [self loadTadData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _searchBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _searchBar.hidden = YES;
    [_searchBar resignFirstResponder];

}
//创建视图
- (void)createViews
{
    _modelArr = [NSMutableArray new];
    _tagArr = [NSMutableArray new];
    _page = 1;
    
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[NSValue valueWithUIOffset:UIOffsetMake(0, 1)],UITextAttributeTextShadowOffset,nil] forState:UIControlStateNormal];
    _searchBar.showsCancelButton =YES;
    _searchBar.tag=1000;
    [self.navigationController.navigationBar addSubview:_searchBar];
    _searchBar.placeholder = @"请输入部门/发布标题搜索";
    
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.hidden = YES;
    [self.view addSubview:_mainTableView];
    
    _tagTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tagTableView.delegate = self;
    _tagTableView.dataSource = self;
    _tagTableView.showsVerticalScrollIndicator = NO;
    [_tagTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tagTableView.tableFooterView = [UIView new];
    
    if (@available(iOS 11,*)) {
        if ([self.mainTableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.mainTableView.estimatedRowHeight = 0;
            self.mainTableView.estimatedSectionHeaderHeight = 0;
            self.mainTableView.estimatedSectionFooterHeight = 0;
        }
    }
    
    [self.view addSubview:_tagTableView];
    
    
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
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadPastData)];

}
-(void)loadTadData
{
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getDocumentInfo"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        for (NSDictionary *dic in responseObject[@"data"]) {
            OfficalSearchModel *model = [OfficalSearchModel new];
            [model yy_modelSetWithDictionary:dic];
            [_tagArr addObject:model];
        }
        [self.tagTableView reloadData];
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
    


}
#pragma 公文数据
-(void)loadBaseData
{
    [self.searchBar resignFirstResponder];
    [ProgressHUD show:@"正在搜索..."];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL  parameters:@{@"rid":@"searchDocumentListByInput",@"keyword":_keyword ,@"page":@(_page),@"pageCount":Message_Num} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        _dataSourceArr = [NSMutableArray array];
        NSArray *dataArray = responseObject[@"data"];
        if (_page == 1) {
            _modelArr = [NSMutableArray array];
            if (dataArray.count==0) {
                [self.mainTableView reloadData];
                [JohnAlertManager showFailedAlert:@"无搜索结果" andTitle:@"提示"];
                return ;
            }
        }
        for (NSDictionary *dic in dataArray) {
            OfficalSearchModel   *model = [[OfficalSearchModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_dataSourceArr addObject:model];
        }
        [_modelArr addObjectsFromArray:_dataSourceArr];
        //撤销的放到最后显示
        
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        if (dataArray.count<[Message_Num intValue]) {
            if (_page>=1) {
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
        }
        [self.mainTableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
        [self.mainTableView.mj_footer endRefreshing];
        [self.mainTableView.mj_header endRefreshing];
        [JohnAlertManager showFailedAlert:@"网络故障,请稍候再试!" andTitle:@""];
    }];

}
//加载新数据
-(void)loadNewData{
    _page = 1;
    [self loadBaseData];
}
//加载旧数据
-(void)loadPastData{
    _page ++;
    [self loadBaseData];
}

#pragma mark  TableViewDelegate  TableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.mainTableView]) {
        return _modelArr.count;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.mainTableView]) {
        return 1;
    }
    return self.tagArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.tagTableView]) {
        static NSString *cellID = @"officalTagCell";
        OfficalSearchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[OfficalSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.delegate = self;
        OfficalSearchModel *model = _tagArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;
    }
    static NSString *cellID = @"officalEndCell";
    OfficalEndCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[OfficalEndCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    OfficalSearchModel *model = _modelArr[indexPath.section];
    cell.model = model;
    return cell;

    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tagTableView]) {
        Class currentClass = [OfficalSearchCell class];
        OfficalSearchModel *model = self.tagArr[indexPath.row];
        return [self.tagTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
    }
    return 105;
//    Class currentClass = [OfficalEndCell class];
//    OfficalSearchModel *model = self.modelArr[indexPath.section];
//    return [self.tagTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
/*设置标题尾的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([tableView isEqual:self.mainTableView]) {
   
        return 8;
    }
    return 0.0001;
}
/*设置标题脚的名称*/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor redColor];
    return headView;
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
//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([tableView isEqual:self.mainTableView]) {
        OfficalSearchModel *model = self.modelArr[indexPath.section];
        OfficalSearchInfoController *vc = [[OfficalSearchInfoController alloc]init];
        vc.newsID = model.ID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark 点击关键字进行搜索
-(void)tagsAction:(HXTagsView *)tagsView button:(UIButton *)sender
{
    self.searchBar.text = sender.titleLabel.text;
    _keyword = sender.titleLabel.text;
    self.tagTableView.hidden = YES;
    self.mainTableView.hidden = NO;
    [self loadNewData];
}

#pragma mark SearchDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    // called when keyboard search button pressed
        //隐藏 搜索关键词界面
    self.tagTableView.hidden = YES;
    self.mainTableView.hidden = NO;
    //子线程
    _keyword = searchBar.text;
    [self loadNewData];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    if (searchBar.text.length == 0) {
        self.tagTableView.hidden = NO;
        self.mainTableView.hidden = YES;
    }
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if (searchBar.text.length == 0) {
        self.tagTableView.hidden = NO;
        self.mainTableView.hidden = YES;
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark 去掉两边空格的方法
-(NSString*)trimStr:(NSString*)str
{
    str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return str;
}
#pragma mark 键盘高度
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
    frame.size.height = kScreenHeight-64-height;
    _mainTableView.frame = frame;
    _tagTableView.frame = frame;
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    CGRect frame = _mainTableView.frame;
    frame.size.height = kScreenHeight-64;
    _mainTableView.frame = frame;
    _tagTableView.frame = frame;

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
