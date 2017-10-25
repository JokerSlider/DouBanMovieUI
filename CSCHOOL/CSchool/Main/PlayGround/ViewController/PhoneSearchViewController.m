//
//  PhoneSearchViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/6/29.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PhoneSearchViewController.h"
#import "PhoneListTableViewCell.h"
#import "ZYPinYinSearch.h"
#import "PhoneDetailViewController.h"

@interface PhoneSearchViewController ()<UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic, strong) id leftBtn;

@property (nonatomic,strong) NSMutableArray *originalArray;
@property (nonatomic,strong) NSArray *dataSourceArray;

//@property (nonatomic,)

@end

@implementation PhoneSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadData];
    _mainTableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createViews];
}

- (void)viewWillDisappear:(BOOL)animated{
    [_searchBar removeFromSuperview];
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationItem setHidesBackButton:NO];
}

- (void)loadData{
    
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showPhoneInfoByRole",@"sysRole":@"1"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
//        _originalArray = [NSMutableArray array];
        _originalArray = responseObject[@"data"];
//        for (NSDictionary *dic in responseObject[@"data"]) {
//            //拼接搜索字符串，三个条件
//            NSString *str = [NSString stringWithFormat:@"%@;%@;%@",dic[@"DP_PHONE"],dic[@"DD_NAME"],dic[@"FATHER_NAME"]];
//            [_originalArray addObject:str];
//        }
        _dataSourceArray = [NSArray array];
        [_mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}

- (void)createViews
{
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.center = CGPointMake(kScreenWidth/2, 84);
    _searchBar.frame = CGRectMake(10, 20,kScreenWidth-20, 0);
    [_searchBar setContentMode:UIViewContentModeBottomLeft];
    _searchBar.delegate = self;
    _searchBar.backgroundColor=[UIColor clearColor];
    _searchBar.searchBarStyle=UISearchBarStyleProminent;
    _searchBar.showsCancelButton =YES;
    _searchBar.tag=1000;
    [self.navigationController.navigationBar addSubview:_searchBar];
//    _searchBar.placeholder = @"关键字搜索";
    //-------------------------------------------------------------------
    [_searchBar becomeFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *indenty = @"PhoneListTableViewCell";
    
    PhoneListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indenty];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PhoneListTableViewCell" owner:self options:nil] lastObject];
    }
    NSDictionary *dic = _dataSourceArray[indexPath.row];
    cell.nameLabel.text = dic[@"DD_NAME"];
    cell.subTitleLabel.text = dic[@"FATHER_NAME"];
    cell.phone = dic[@"DP_PHONE"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61 ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:NO];
    PhoneDetailViewController *vc = [[PhoneDetailViewController alloc] init];
    vc.dataDic = _dataSourceArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark searchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar.text isEqualToString:@""]) {
        _dataSourceArray = [NSArray array];
    }
    else{
        // 主要功能，调用方法实现搜索
//        _dataSourceArray = [ZYPinYinSearch searchWithOriginalArray:_originalArray andSearchText:searchBar.text andSearchByPropertyName:@""];dic[@"DP_PHONE"],dic[@"DD_NAME"],dic[@"FATHER_NAME"]
        _dataSourceArray = [ZYPinYinSearch searchWithOriginalArray:_originalArray andSearchText:searchBar.text andSearchByPropertyNames:@[@"DP_PHONE",@"DD_NAME",@"FATHER_NAME"]];
    }
    [_mainTableView reloadData];
    [_searchBar resignFirstResponder];
//    [_searchBar removeFromSuperview];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{    
    //子线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([searchText isEqualToString:@""]) {
            _dataSourceArray = [NSArray array];
        }
        else{
            // 主要功能，调用方法实现搜索
            _dataSourceArray = [ZYPinYinSearch searchWithOriginalArray:_originalArray andSearchText:searchBar.text andSearchByPropertyNames:@[@"DP_PHONE",@"DD_NAME",@"FATHER_NAME"]];
        }
        // 主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mainTableView reloadData];
            if (_dataSourceArray.count == 0) {
                [self showErrorView:@"没有找到相关数据。" andImageName:nil];
            }else{
                [self hiddenErrorView];
            }
        });
    });

}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
//    self.navigationItem.rightBarButtonItem = _searchButton;
    [_searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
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
