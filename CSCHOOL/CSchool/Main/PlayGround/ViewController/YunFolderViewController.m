//
//  YunFolderViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 2017/6/2.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "YunFolderViewController.h"
#import "YunListCell.h"
#import "LEOWebDAVClient.h"
#import "XGWebDavManager.h"
#import "LEOWebDAVItem.h"
#import "LEOWebDAVPropertyRequest.h"
#import "LEOWebDAVDeleteRequest.h"
#import "YunFolderBottomView.h"
#import "XGWebDavUploadManager.h"
#import "LEOWebDAVMoveRequest.h"
#import "LEOWebDAVCopyRequest.h"

@interface YunFolderViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    LEOWebDAVItem *_currentItem;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) LEOWebDAVClient *currentClient;
@property (nonatomic, retain) YunFolderBottomView *yunFolderBottomView;
@property (nonatomic, copy) NSString *currentPath;
@end

@implementation YunFolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupClient]; //建立请求体
    [self sendLoadRequest];//发起请求
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-90-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    _yunFolderBottomView = [[YunFolderBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight-90-64, kScreenWidth, 90)];
    WEAKSELF;
    _yunFolderBottomView.leftClickBlock = ^(){
        
    };
    
    _yunFolderBottomView.rightClickBlock = ^{
        
        if (self.yunFolderType == YunFolderCopy) {
            [weakSelf copyAction];
        }else if (self.yunFolderType == YunFolderMove){
            [weakSelf moveAction];
        }else if (self.yunFolderType == YunFolderMake){
            [XGWebDavUploadManager shareUploadManager].selctPath = weakSelf.currentPath;
            [weakSelf cancelClick:nil];
        }
    };
    
    [self.view addSubview:_yunFolderBottomView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [XGWebDavUploadManager shareUploadManager].currentPath = self.currentPath;
}

- (void)reloadData{
    [self sendLoadRequest];//发起请求
}

- (void)createNav{
    UIBarButtonItem *leftItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClick:)];
    //    self.navigationItem.leftBarButtonItem = [leftItem2 autorelease];
    
    self.navigationItem.leftBarButtonItems = @[ leftItem2];
}

- (void)cancelClick:(UIBarButtonItem *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(id)initWithPath:(NSString *)path{
    self=[self init];
    if (self) {
        _currentPath=[path==nil ? @"/":path copy];
        if (![_currentPath isEqualToString:@"/"]) {
            self.title=[_currentPath lastPathComponent];
            //            [_titleView setTitle:self.title];
            
        }else{
            self.title = @"我的网盘";
        }
        //        _currentPath =
        [self createNav];
        
    }
    return self;
}

-(id)initWithItem:(LEOWebDAVItem *)_item
{
    self=[self init];
    if (self) {
        if (_item) {
            _currentItem=[[LEOWebDAVItem alloc] initWithItem:_item];
            _currentPath=_currentItem.href;
            if (![_currentPath isEqualToString:@"/"]) {
                self.title=[_currentPath lastPathComponent];
                //                [_titleView setTitle:self.title];
            }
        }else {
            _currentItem=nil;
            _currentPath=@"/";
        }
    }
    return self;
}

-(void)setupClient{
    XGWebDavManager *manager = [XGWebDavManager sharWebDavmManager];
    _currentClient=[[LEOWebDAVClient alloc] initWithRootURL:[NSURL URLWithString:manager.url]
                                                andUserName:manager.userName
                                                andPassword:manager.password];
}

- (void)copyAction{
    if (_currentClient==nil) {
        [self setupClient];
    }
    
    LEOWebDAVCopyRequest *request = [[LEOWebDAVCopyRequest alloc] initWithPath:_currentItem.href];
    request.delegate = self;
    request.destinationPath = [_currentPath stringByAppendingPathComponent:_currentItem.displayName];
    [_currentClient enqueueRequest:request];
}

//移动操作请求
- (void)moveAction{
    if (_currentClient==nil) {
        [self setupClient];
    }
    
    LEOWebDAVMoveRequest *request = [[LEOWebDAVMoveRequest alloc] initWithPath:_currentItem.href];
    request.delegate = self;
    request.destinationPath = [_currentPath stringByAppendingPathComponent:_currentItem.displayName];
    [_currentClient enqueueRequest:request];
}



// 属性请求 获取目录
-(void)sendLoadRequest
{
    if (_currentClient==nil) {
        [self setupClient];
    }
    LEOWebDAVPropertyRequest *request=[[LEOWebDAVPropertyRequest alloc] initWithPath:_currentPath];
    request.delegate=self;
    [_currentClient enqueueRequest:request];
}

//网络请求，获取到列表信息
- (void)request:(LEOWebDAVRequest *)aRequest didSucceedWithResult:(id)result
{
    if ([aRequest isKindOfClass:[LEOWebDAVPropertyRequest class]]) {
        // 获取成功，加载列表
        [self performSelectorOnMainThread:@selector(setContentArray:) withObject:result waitUntilDone:NO];
    }else if ([aRequest isKindOfClass:[LEOWebDAVMoveRequest class]]){
//        [self reloadData];
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationYunListReload object:self];

    }else if ([aRequest isKindOfClass:[LEOWebDAVCopyRequest class]]){
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationYunListReload object:self];
        
    }
}


-(void)setContentArray:(NSMutableArray *)contents
{
    //    _dataArray = contents;
    _dataArray=[[NSMutableArray alloc] init];
    for (LEOWebDAVItem *item in contents) {
        if (item.type==LEOWebDAVItemTypeCollection) {
            [_dataArray addObject:item];
        }
    }
    if ([_currentPath isEqualToString:@"/"]) {
        //       [XG ]
    }
    [_tableView reloadData];
}

//- (UITableView *)tableView{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-50) style:UITableViewStylePlain];
//        _tableView.dataSource = self;
//        _tableView.delegate = self;
//        [self.view addSubview:_tableView];
//    }
//    return _tableView;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    [self.mainTableView startAutoCellHeightWithCellClass:[RepairListTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"YunListCell";
    YunListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YunListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    LEOWebDAVItem *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LEOWebDAVItem *item=[_dataArray objectAtIndex:indexPath.row];
    NSString *type = [item.contentType componentsSeparatedByString:@"/"][0];
    
    YunFolderViewController *vc = [[YunFolderViewController alloc] initWithItem:item];
    vc.yunFolderType = self.yunFolderType;
    vc.currentItem = self.currentItem;
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
