//
//  LibraryViewController.m
//  CSchool
//
//  Created by mac on 16/12/26.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "LibraryViewController.h"
#import "UIView+SDAutoLayout.h"
#import "LBTextField.h"
#import "SearchBaseViewController.h"
#import "MyOriderBookViewController.h"
#import "LibiraryModel.h"
#import "LibarySearchViewController.h"
#import "UILabel+stringFrame.h"
#define leftWidth 10
#define BottomTableViewHeight  70*10+32
#define MidTableViewHeight  650+32

@interface LibraryViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIScrollView *mainScrollview;
@property (nonatomic,strong)UITableView *mainTableVoew;
@property (nonatomic,strong) LBTextField *searchBar; //搜索框
@property (nonatomic,strong)LBTextField *windowSearchBar;
@property (nonatomic,strong)NSMutableArray *searchModelArray;//热搜关键词数组

@end

@implementation LibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"图书馆";
    self.mainScrollview = ({
        UIScrollView *view = [UIScrollView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [self.view addSubview:self.mainScrollview];
    self.mainScrollview.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    [self setupNavButton];
    [self setUpHeaderView];
    [self loadData];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}
-(void)loadData
{
    [ProgressHUD show:nil];
    [self loadSearchData];
}
-(void)loadSearchData
{
    [ProgressHUD show:nil];
    _searchModelArray = [NSMutableArray array];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showHotSearch"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSMutableArray *searchWordArr = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            [searchWordArr addObject:dic[@"WORDS"]];
            LibiraryModel *model = [LibiraryModel new];
            [model yy_modelSetWithDictionary:dic];
            [_searchModelArray addObject:model];
        }
        [self.mainTableVoew reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}
-(void)setupNavButton
{
    UIButton *myZone = [UIButton buttonWithType:UIButtonTypeCustom];
    myZone.frame = CGRectMake(50, 0, 50, 50);
//    [myZone setImage:[UIImage imageNamed:@"my_book"] forState:UIControlStateNormal];
    [myZone setTitle:@"我的" forState:UIControlStateNormal];
    [myZone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [myZone addTarget:self action:@selector(openMyZone) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:myZone];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:myZone];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];
}
-(void)setUpHeaderView
{
    _searchBar = [[LBTextField alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 30)];
    _searchBar.delegate = self;
    _searchBar.layer.borderWidth = 1.0;
    _searchBar.layer.borderColor = RGB(255, 251, 240).CGColor;
    [_searchBar customWithPlaceholder:@"   请输入检索关键字" color:Color_Gray font:[UIFont systemFontOfSize:13.0]];
    _searchBar.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.8];
    _searchBar.layer.cornerRadius = 1.0;
    _searchBar.layer.masksToBounds = YES;
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe=_searchBar.layer.frame;
    fixframe.size.width=kScreenWidth-20;
    subLayer.frame=fixframe;
    subLayer.cornerRadius=1.0;
    subLayer.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    subLayer.masksToBounds=NO;
    subLayer.shadowColor=[UIColor grayColor].CGColor;
    subLayer.shadowOffset=CGSizeMake(0,0);
    subLayer.shadowOpacity=0.5;
    subLayer.shadowRadius=8;
    [self.mainScrollview.layer insertSublayer:subLayer below:_searchBar.layer];
    [self.mainScrollview addSubview:_searchBar];
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-200)/2, 100, 200, 20)];
    titleLable.text = @"热门检索";
    titleLable.font = [UIFont systemFontOfSize:16];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = Color_Black;
    [self.mainScrollview addSubview:titleLable];
    _mainTableVoew = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _mainTableVoew.delegate = self;
    _mainTableVoew.dataSource =self;
    _mainTableVoew.scrollEnabled = NO;
    _mainTableVoew.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainScrollview addSubview:_mainTableVoew];
    _mainTableVoew.sd_layout.leftSpaceToView(self.mainScrollview,0).topSpaceToView(titleLable,20).widthIs(kScreenWidth).heightIs(kScreenHeight-64-140);
    [self.mainScrollview setupAutoHeightWithBottomView:_mainTableVoew bottomMargin:10];
}

#pragma mark HXTagsViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchModelArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ide = @"searchLibirarCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ide];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ide];
    }
    LibiraryModel *model = _searchModelArray[indexPath.row];
    cell.textLabel.text = model.WORDS;
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    LibarySearchViewController *vc = [[LibarySearchViewController alloc] init];
    LibiraryModel *model = _searchModelArray[indexPath.row];
    vc.keyWord = model.WORDS;
    vc.keyType = model.TYPE;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark  -UISearchBarDelegate
#pragma mark  点击搜索框搜索
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    LibarySearchViewController *vc = [[LibarySearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    return NO;
}
#pragma mark 点击进入我的借阅
-(void)openMyZone
{
    MyOriderBookViewController *vc = [[MyOriderBookViewController alloc]init];
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
