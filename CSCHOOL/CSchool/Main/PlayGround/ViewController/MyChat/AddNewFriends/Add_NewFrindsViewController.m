//
//  Add_NewFrindsViewController.m
//  CSchool
//
//  Created by mac on 17/3/2.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "Add_NewFrindsViewController.h"
#import "AddSearchView.h"
#import "AddSearchCell.h"
#import "HQXMPPManager.h"
#import "XMPPvCardTemp.h"
#import "XMPPFramework.h"
#import "ChatModel.h"
#import "ChatUserInfoViewController.h"
#import <YYModel.h>
#import "JohnAlertManager.h"
#import <MJRefresh.h>

@interface Add_NewFrindsViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableView;

@property (nonatomic,strong)NSMutableArray *modelArray;

@property (nonatomic,strong)NSMutableArray *dataSourceArr;//传递数组

@property (nonatomic,assign)int  page;

@end

@implementation Add_NewFrindsViewController
{
    AddSearchView *_navBarView;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self createView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _navBarView.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _navBarView.hidden = YES;
    [_navBarView.inputTxtV resignFirstResponder];
}

#pragma mark 初始化视图
-(void)createView
{
    _navBarView = [[AddSearchView alloc]initWithFrame:CGRectMake(50, 15,kScreenWidth-75, 16)];
    _navBarView.userInteractionEnabled = YES;
    _navBarView.inputTxtV.placeholder = @"学号/姓名搜索";

    [_navBarView.inputTxtV becomeFirstResponder];
    _navBarView.inputTxtV.delegate = self;
    [self.navigationController.navigationBar addSubview:_navBarView];
}
-(void)createTableView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [UIView new];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.mainTableView];
    //增加监听，当键盘出现或改变时
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
    [self showErrorView:@"请输入您要搜索的内容" andImageName:nil];

}
#pragma mark 下拉加载
-(void)loadNewData
{
    [ProgressHUD show:@"正在搜索..."];
    _page = 1;
    _modelArray = [NSMutableArray array];
    [self loadDatawithPage:@"1"];
}
#pragma mark 上拉刷新
-(void)loadPastData
{
    _page++;
    NSString *pageNum = [NSString stringWithFormat:@"%d",_page];
    [self loadDatawithPage:pageNum];
    
}
-(void)loadDatawithPage:(NSString *)page
{

    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"findFriendsByUser",@"searchkey":_navBarView.inputTxtV.text,@"page":page,@"pageCount":Message_Num} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [ProgressHUD dismiss];
        _dataSourceArr = [NSMutableArray array];
        [self.mainTableView.mj_header endRefreshing];

        NSArray *dataArray = responseObject[@"data"];
        if ([page isEqualToString:@"1"]) {
            if (dataArray.count==0) {
                _modelArray = [NSMutableArray array];
                [self.mainTableView reloadData];
                [JohnAlertManager showFailedAlert:@"没有查找到该用户！" andTitle:@"提示"];
                return ;
            }
        }
        for (NSDictionary *dic in responseObject[@"data"]) {
            ChatModel *model = [[ChatModel alloc]init];
            [model yy_modelSetWithDictionary:dic];
            [_dataSourceArr addObject:model];
        }
        [_modelArray addObjectsFromArray:_dataSourceArr];
        [_mainTableView reloadData];
        if (dataArray.count<[Message_Num intValue]) {
            if ([page intValue]>=0) {
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
        }
        [self.mainTableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
 
}
#pragma mark 加载数据
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_navBarView.inputTxtV resignFirstResponder];
    _modelArray = [NSMutableArray array];
    [self hiddenErrorView];
    [self loadDatawithPage:@"1"];
    return YES;

}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    _modelArray = [NSMutableArray array];
//    NSString *uname=[self trimStr:textField.text];
//    uname=[uname lowercaseString];  //转成小写
//    XMPPJID *jid=[XMPPJID jidWithUser:uname domain:kDOMAIN resource:nil];
//    //点击搜索
//    XMPPvCardTemp *friendvCard =[[HQXMPPManager shareXMPPManager].vCard vCardTempForJID:jid shouldFetch:YES];
//    if (friendvCard==nil) {
//        [self showErrorView:@"没有查找到该用户"];
//    }else{
//        [self hiddenErrorView];
//        NSLog(@"%@",friendvCard);
//        ChatModel *model = [[ChatModel alloc]init];
//        model.toStr = textField.text;
//        model.to = jid;
//        [_modelArray addObject:model];
//        [self.mainTableView reloadData];
//    }
//    [_navBarView.inputTxtV resignFirstResponder];
//    //收起键盘
//    return YES;
//}
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
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    CGRect frame = _mainTableView.frame;
    frame.size.height = kScreenHeight-64;
    _mainTableView.frame = frame;
}
#pragma mark  UITableviewDelete  DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"MyAdd_seacrhCell";
    AddSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[AddSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.model=_modelArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ChatUserInfoViewController *vc = [[ChatUserInfoViewController alloc]init];
    ChatModel *model = _modelArray[indexPath.row];
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@_%@@%@",[AppUserIndex GetInstance].schoolCode,model.YHBH,kDOMAIN]];
    vc.jid = jid;
    [self.navigationController pushViewController:vc animated:YES];
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
