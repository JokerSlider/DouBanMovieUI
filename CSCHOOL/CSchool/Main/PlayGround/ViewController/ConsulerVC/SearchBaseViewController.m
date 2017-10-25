//
//  SearchBaseViewController.m
//  CSchool
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "SearchBaseViewController.h"
#import "ZYPinYinSearch.h"

@interface SearchBaseViewController ()<UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate,XGAlertViewDelegate>
@property (nonatomic, strong) id leftBtn;
@property (nonatomic,strong) NSArray *dataSourceArray;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation SearchBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-70) style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [UIView new];
   
    [self.view addSubview:_mainTableView];
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataSourceArray.count==0) {
        return 20;
    }
    return _dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_dataSourceArray.count==0) {
        static NSString *idenfiter = @"cell";
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenfiter];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:idenfiter];
        }
        if (indexPath.row ==2) {
            cell.textLabel.text  =@"暂无搜索结果";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font =[UIFont fontWithName:@"Arial Old" size:16];
            cell.textLabel.textColor = Base_Orange;
        }
        return  cell;
        
    }else{
        return [self tableView:tableView IndexPath:indexPath withDataSourceArr:_dataSourceArray withSearchText:_searchBar.text];
    }
    return  nil;
}

#pragma mark  self delegate
//自定义cell的代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath withDataSourceArr:(NSArray *)dataArr withSearchText:(NSString *)text;
{
    if (self.delegate&&[self respondsToSelector:@selector(tableView:IndexPath:withDataSourceArr:withSearchText:)] ) {
        return [self.delegate tableView:tableView IndexPath:indexPath withDataSourceArr:dataArr withSearchText:_searchBar.text];
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForSearchRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate&&[self respondsToSelector:@selector(tableView:heightForSearchRowAtIndexPath:)]) {
        return  [self.delegate tableView:tableView heightForSearchRowAtIndexPath:indexPath];
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectSearchRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate &&[self respondsToSelector:@selector(tableView:didSelectSearchRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didSelectSearchRowAtIndexPath:indexPath];
    }
}
#pragma mark TableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView didSelectSearchRowAtIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSourceArray.count ==0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 30;
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return [self tableView:tableView heightForSearchRowAtIndexPath:indexPath];
    }
    
    return [self tableView:tableView heightForSearchRowAtIndexPath:indexPath];
}

#pragma -mark searchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar.text isEqualToString:@""]) {
        _dataSourceArray = [NSArray array];
    }
    else{
        // 主要功能，调用方法实现搜索
        _dataSourceArray = [ZYPinYinSearch searchWithOriginalArray:_originalArray andSearchText:searchBar.text andSearchByPropertyNames:_seacrKeyArr];
    }
    [_mainTableView reloadData];
    [_searchBar resignFirstResponder];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [ProgressHUD show:@"正在搜索..."];
    //子线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([searchText isEqualToString:@""]) {
            _dataSourceArray = [NSArray array];
        }
        else{
            // 主要功能，调用方法实现搜索
            _dataSourceArray = [ZYPinYinSearch searchWithOriginalArray:_originalArray andSearchText:searchBar.text andSearchByPropertyNames:_seacrKeyArr];
        }
        // 主线程
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [_mainTableView reloadData];
            [ProgressHUD dismiss];
        });
    });
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // self.navigationItem.rightBarButtonItem = _searchButton;
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
