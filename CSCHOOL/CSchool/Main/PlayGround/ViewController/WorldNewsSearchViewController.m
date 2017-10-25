//
//  WorldNewsSearchViewController.m
//  CSchool
//
//  Created by mac on 17/1/17.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "WorldNewsSearchViewController.h"
#import "HXTagsView.h"
#import "WordNewsCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import <MJRefresh.h>
#import <YYModel.h>
#import "AboutUsViewController.h"
#import "RxWebViewController.h"
@interface WorldNewsSearchViewController ()<UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate,XGAlertViewDelegate>
//数据源
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,copy) NSString *placeholder;
@property (nonatomic,strong)NSArray *tagArray;//标签名

@property (strong, nonatomic) UITableView *mainTableView;
@property (nonatomic,assign)int  page;
@property (nonatomic,copy)NSString *goodName;
@property (nonatomic, strong) NSMutableArray *modelsArray;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (nonatomic,strong)UIView  *hotView;
@end

@implementation WorldNewsSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _modelsArray =[NSMutableArray arrayWithArray:@[]];
    [self getHotWords];
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
//获取热搜词
-(void)getHotWords
{
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getHotWords"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSMutableArray *hotWords = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            [hotWords addObject:dic[@"KEYWORD"]];
        }
        self.tagArray = [NSArray arrayWithArray:hotWords];
        [self createHotView];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}
-(void)createHotView
{
    _hotView = [UIView new];
    
    UILabel *titleLable  = [[UILabel alloc] initWithFrame:CGRectMake(13, 10, 47, 15)];
    titleLable.text = @"近期热词";
    titleLable.font = Small_TitleFont;
    [_hotView addSubview:titleLable];
    //分割线
    UIView *line = [UIView new];
    line.backgroundColor = RGB(225, 225, 225);
    line.frame = CGRectMake(0, 31, kScreenWidth, 0.5);
    [_hotView addSubview:line];
    //多行不滚动,则计算出全部展示的高度,让maxHeight等于计算出的高度即可,初始化不需要设置高度
    HXTagsView *tagsView = [[HXTagsView alloc] initWithFrame:CGRectMake(10, line.frame.origin.y+5, self.view.frame.size.width, 0)];
    tagsView.type = 0;
    tagsView.backgroundColor = Base_Color2;
    [tagsView setTagAry:self.tagArray delegate:self];
    [_hotView addSubview:tagsView];
    
    [self.view addSubview:_hotView];
    
    self.hotView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).heightIs(kScreenHeight);
    [self.hotView setupAutoHeightWithBottomView:tagsView bottomMargin:10];
}

//最新的
-(void)loadData
{
    if (!_page) {
        _page = 1;
    }
    NSString *pageNum = [NSString stringWithFormat:@"%d",_page];
    [self loadDataWithFuncTypePushpageNum:pageNum];
}
//以前的
-(void)loadPushPastData
{
    _page = 1;
    NSString *pageNum = [NSString stringWithFormat:@"%d",_page];
    [self loadDataWithFuncTypePushpageNum:pageNum];
    
}
-(void)loadDataWithFuncTypePushpageNum:(NSString *)page
{
    [ProgressHUD show:@""];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showNewsByHotword",@"page":page,@"pageCount":Message_Num,@"keywords":_goodName} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _dataSourceArr = [NSMutableArray array];
        NSArray *dataArray = responseObject[@"data"];
        if ([page isEqualToString:@"1"]) {
            _modelsArray = [NSMutableArray array];
            if (dataArray.count==0) {
                [self.mainTableView.mj_footer resetNoMoreData];
                [self.mainTableView.mj_header endRefreshing];
                [ProgressHUD showError:@"没有找到相关数据"];
                return ;
            }
        }
        //加载成功数据
        [ProgressHUD dismiss];
        for (NSDictionary *dic in dataArray) {
            WorldNewsModel   *model = [[WorldNewsModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_dataSourceArr addObject:model];
        }
        [_modelsArray addObjectsFromArray:_dataSourceArr];
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
        [ProgressHUD showError:@"没有找到相关数据"];
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
    frame.size.height = kScreenHeight-64-height;
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
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
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
    _mainTableView.hidden = YES;
}


////设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelsArray.count;
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
        static  NSString *ID =@"worldNewssearchId";
        WordNewsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[WordNewsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        WorldNewsModel *model = self.modelsArray[indexPath.row];
        cell.model = model;
        return cell;
    }
    return  nil;
}


#pragma mark TableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [WordNewsCell class];
    
    WorldNewsModel *model = self.modelsArray[indexPath.row];
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
    //点击跳转到详情界面
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    WorldNewsModel *model = self.modelsArray[indexPath.row];
    RxWebViewController* vc = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:model.ARTICLEURL]];//
    [self.navigationController pushViewController:vc animated:YES];
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
//隐藏热搜  展示列表
-(void)hiddenHotView
{
    [_hotView removeFromSuperview];
    _mainTableView.hidden = NO ;
}
#pragma mark HXTagsViewDelegate

/**
 *  tagsView代理方法
 *
 *  @param tagsView tagsView
 *  @param sender   tag:sender.titleLabel.text index:sender.tag
 */
- (void)tagsViewButtonAction:(HXTagsView *)tagsView button:(UIButton *)sender {
    
    [self hiddenHotView];
    _goodName =_tagArray[sender.tag];
    [self loadDataWithFuncTypePushpageNum:@"1"];
    [_searchBar resignFirstResponder];
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
    [self hiddenHotView];
    _goodName = searchBar.text;
    [self loadDataWithFuncTypePushpageNum:@"1"];
    [searchBar resignFirstResponder];
    
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
