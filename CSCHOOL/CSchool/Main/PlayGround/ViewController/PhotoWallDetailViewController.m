//
//  PhotoWallDetailViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/10/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PhotoWallDetailViewController.h"
#import "PhotoWallDetailView.h"
#import "PhotoCarView.h"
#import "PhotoMsgCell.h"
#import "SDAutoLayout.h"
#import "XGChatBarView.h"
#import "IQKeyboardManager.h"
#import <YYModel.h>
#import "UIViewController+BackButtonHandler.h"

@interface PhotoWallDetailViewController ()<UIScrollViewDelegate, XGChatBarViewDelegate,UITableViewDelegate, UITableViewDataSource>
{
    XGChatBarView *_chatView;
    PhotoWallDetailView *_detailView;
}
@property (nonatomic, retain) UITableView *mainTableView;

@property (nonatomic, retain) NSMutableArray *dataMutableArr;

@end

@implementation PhotoWallDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"照片详情";
    _chatView = [[XGChatBarView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kMinHeight-64, kScreenWidth, kMinHeight)];
    _chatView.delegate = self;
    [self.view addSubview:_chatView];
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kMinHeight-64) style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainTableView];
    [self createHeaderView];
    if (_picID) {
        [self loadPicDetail];
    }
    [self loadData];
}

- (void)loadPicDetail{
    
    NSDictionary *commitDic = @{
                                @"rid":@"getPhotoWallInfoByPhotoId",
                                @"photoid":_picID
                                };
    
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _model = [[PhotoCarModel alloc] init];
        [_model yy_modelSetWithDictionary:responseObject[@"data"]];
        _detailView.model = _model;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}

-(BOOL)navigationShouldPopOnBackButton{
    [self.navigationController popViewControllerAnimated:NO];
    return NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_carView) {
        _carView.model = _model;
    }
}

- (void)chatBar:(XGChatBarView *)chatBar sendMessage:(NSString *)message{
    [self.view endEditing:YES];
    
    NSDictionary *commitDic = @{
                                @"rid":@"addPhotoComment",
                                @"photoid":_model.picId,
                                @"userid":[AppUserIndex GetInstance].role_id,
                                @"comment":message,
                                @"replyid":@""
                                };
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [self loadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}

- (void)chatBarFrameDidChange:(XGChatBarView *)chatBar frame:(CGRect)frame{
    if (frame.origin.y == self.mainTableView.frame.size.height) {
        return;
    }
    [UIView animateWithDuration:.3f animations:^{
        [self.mainTableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, frame.origin.y)];
        //        [self scrollToBottom];
    } completion:nil];
}
- (void)scrollToBottom {
    
    if (self.dataMutableArr.count >= 1&&self.dataMutableArr.count <= 4) {
        [self.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataMutableArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }else if (self.dataMutableArr.count >4){
        [self.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
}

- (void)loadData{
    
    if (_model) {
        _picID = _model.picId;
    }
    
    NSDictionary *commitDic = @{
                                @"rid":@"queryReviewInfo",
                                @"photoid":_picID
                                };
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _dataMutableArr = [NSMutableArray array];
        
        for (NSDictionary *dic in responseObject[@"data"]) {
            PhotoMsgModel *model = [[PhotoMsgModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_dataMutableArr addObject:model];
        }
        [_mainTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];
        
    }];
    
}

- (void)createHeaderView{
    _detailView = [[PhotoWallDetailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenHeight-64)*0.78*0.2+kScreenWidth)];
    _detailView.model = _model;
    _mainTableView.tableHeaderView = _detailView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataMutableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"PhotoMsgCell";
    PhotoMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[PhotoMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PhotoMsgModel *model = self.dataMutableArr[indexPath.row];
    
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    return [self.mainTableView cellHeightForIndexPath:indexPath model:self.dataMutableArr[indexPath.row] keyPath:@"model" cellClass:[PhotoMsgCell class] contentViewWidth:kScreenWidth];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 29)];
    view.backgroundColor = RGB(245, 245, 245);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 29)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"评论区";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = RGB(153, 153, 153);
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 29;
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

