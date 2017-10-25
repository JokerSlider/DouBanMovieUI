//
//  YunListViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 17/4/26.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "YunListViewController.h"
#import "LEOWebDAVClient.h"
#import "XGWebDavManager.h"
#import "LEOWebDAVItem.h"
#import "LEOWebDAVPropertyRequest.h"
#import "LEOWebDAVDeleteRequest.h"
#import "YunListCell.h"
#import "SDAutoLayout.h"
#import "YLButton.h"
#import "YYWebImage.h"
#import "MRVLCPlayer.h"
#import "YunDownUpViewController.h"
#import "HXPhotoViewController.h"
#import "XGWebDavUploadManager.h"
#import "JhtLoadDocViewController.h"

@interface YunListViewController ()<UITableViewDelegate, UITableViewDataSource, LEOWebDAVRequestDelegate>
{
    NSString *_currentPath;
    LEOWebDAVItem *_currentItem;
    NSIndexPath *_selectIndexPath;
    UIToolbar *_toolBar;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, retain) LEOWebDAVClient *currentClient;

@property (nonatomic, retain) NSMutableArray *dataArray;

@property (nonatomic, retain) NSMutableArray *selectedArray;

@property (nonatomic, assign) BOOL isEdit;

@property (strong, nonatomic) HXPhotoManager *manager;

@end

@implementation YunListViewController

-(id)initWithPath:(NSString *)path{
    self=[self init];
    if (self) {
        _currentPath=[path==nil ? @"/":path copy];
        if (![_currentPath isEqualToString:@"/"]) {
            self.title=[_currentPath lastPathComponent];
//            [_titleView setTitle:self.title];
        }
        [XGWebDavUploadManager shareUploadManager].selctPath = @"";
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
        [XGWebDavUploadManager shareUploadManager].selctPath = _currentPath;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupClient]; //建立请求体
    [self sendLoadRequest];//发起请求
    [self createNav];
    [self createHeaderView];
    [self createToolBar];
    [_tableview setAllowsMultipleSelection:YES];
    _tableview.tableFooterView = [UIView new];
    _tableview.sd_layout
    .leftSpaceToView(self.view,0)
    .bottomSpaceToView(_toolBar,0)
    .topSpaceToView(self.view,0)
    .widthIs(kScreenWidth);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:NotificationYunListReload object:nil];

}

- (void)reloadData{
    [self sendLoadRequest];
}

- (void)createNav{
    
    self.navigationItem.leftBarButtonItems = @[];
    [self.navigationItem setHidesBackButton:NO];

    //第三种方式（自定义按钮）
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(0, 0, 33, 32);
    [editButton addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [editButton setImage:[UIImage imageNamed:@"finance_add"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithCustomView:editButton];

    //第三种方式（自定义按钮）
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    updateButton.frame = CGRectMake(0, 0, 33, 32);
    [updateButton addTarget:self action:@selector(uploadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [updateButton setImage:[UIImage imageNamed:@"finance_add"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithCustomView:updateButton];
    
    self.navigationItem.rightBarButtonItems = @[rightItem1,rightItem2];
}

- (void)resetNav{
    [self.navigationItem setHidesBackButton:YES];
//    [self.navigationItem.rightBarButtonItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.navigationItem.rightBarButtonItems = @[];
    //第三种方式（自定义按钮）
    UIButton *allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    allButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    allButton.frame = CGRectMake(0, 0, 60, 33);
    [allButton addTarget:self action:@selector(selectAllButton:) forControlEvents:UIControlEventTouchUpInside];
    [allButton setTitle:@"全选" forState:UIControlStateNormal];
    UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc] initWithCustomView:allButton];
    
    //第三种方式（自定义按钮）
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentRight;
    cancelButton.frame = CGRectMake(0, 0, 60, 33);
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    self.navigationItem.rightBarButtonItems = @[rightItem2];
    self.navigationItem.leftBarButtonItems = @[leftItem1];
}


- (void)createHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headerView.backgroundColor = RGB(246,246,246);
    UIButton *newFloderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    newFloderButton.frame = CGRectMake(15, 2, 36, 36);
    [newFloderButton setImage:[UIImage imageNamed:@"pan_new"] forState:UIControlStateNormal];
    [headerView addSubview:newFloderButton];
    
    UIButton *sortButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sortButton.frame = CGRectMake(55, 2, 36, 36);
    [sortButton setImage:[UIImage imageNamed:@"pan_sortBtn"] forState:UIControlStateNormal];
    [sortButton addTarget:self action:@selector(downloadList:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:sortButton];
    
    _tableview.tableHeaderView = headerView;
}

- (void)createToolBar{
//    self.navigationController.toolbarHidden = NO;
    _toolBar = [[UIToolbar alloc] init];
    _toolBar.clipsToBounds = YES;
    [_toolBar setBarStyle:UIBarStyleDefault];
    
    [self.view addSubview:_toolBar];
    _toolBar.sd_layout
    .leftSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0)
    .heightIs(0)
    .widthIs(kScreenWidth);
    
    YLButton *_shareButton = [self createYLButton];
    [_shareButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
    
    YLButton *_downButton = [self createYLButton];
    [_downButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_downButton setTitle:@"下载" forState:UIControlStateNormal];
    
    YLButton *_deleteButton = [self createYLButton];
    [_deleteButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    
    YLButton *_moreButton = [self createYLButton];
    [_moreButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
    
    float space = (kScreenWidth-(30*4))/5;
    for (int i =0; i<4; i++) {
        YLButton *btn = @[_shareButton, _downButton, _deleteButton, _moreButton][i];
        btn.frame = CGRectMake((space+30)*i+space, 0, 30, 50);
    }
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:_shareButton];
    UIBarButtonItem *downloadItem = [[UIBarButtonItem alloc] initWithCustomView:_downButton];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithCustomView:_deleteButton];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:_moreButton];
    
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *space3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *space4 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *space5 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    [_toolBar setItems:@[space4, shareItem, space1, downloadItem, space2, deleteItem, space3, moreItem, space5]];
}

- (YLButton *)createYLButton{
    YLButton *button = [YLButton buttonWithType:UIButtonTypeCustom];
    button.imageRect = CGRectMake(7, 9, 16, 16);
    button.titleRect = CGRectMake(0, 30, 30, 12);
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:Color_Black forState:UIControlStateNormal];
    [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//点击下载按钮事件
- (void)downloadList:(UIButton *)sender{
    YunDownUpViewController *vc = [[YunDownUpViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//底部栏点击事件
- (void)bottomButtonClick:(UIButton *)sender{
    NSLog(@"22");
}

-(void)setupClient{
    XGWebDavManager *manager = [XGWebDavManager sharWebDavmManager];
    _currentClient=[[LEOWebDAVClient alloc] initWithRootURL:[NSURL URLWithString:manager.url]
                                                andUserName:manager.userName
                                                andPassword:manager.password];
}

- (HXPhotoManager *)manager
{
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
//        _manager.videoMaxNum = 5;
        _manager.rowCount = 3;
        _manager.openCamera = NO;
    }
    return _manager;
}

- (void)uploadBtnClick:(UIButton *)sender{
    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
    vc.delegate = self;
    vc.manager = self.manager;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}
//编辑按钮点击事件
- (void)rightBtnClick:(UIButton *)sender{
    _isEdit = YES;
    if (_isEdit) {
        _selectedArray = [NSMutableArray array];
        _toolBar.sd_layout.heightIs(46);
        _selectIndexPath = nil;
        [self resetNav];
    }else{
        _toolBar.sd_layout.heightIs(0);
    }
    //清空选择属性
    [_dataArray makeObjectsPerformSelector:@selector(setBeSelected:) withObject:@NO];
    [_tableview reloadData];
}

//全选按钮
- (void)selectAllButton:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"全选"]) {
        [_dataArray makeObjectsPerformSelector:@selector(setSelected)];
        [sender setTitle:@"全不选" forState:UIControlStateNormal];
    }else{
        [_dataArray makeObjectsPerformSelector:@selector(setBeSelected:) withObject:@NO];
        [sender setTitle:@"全选" forState:UIControlStateNormal];
    }
    [_tableview reloadData];
}

//取消按钮
- (void)cancelButtonClick:(UIButton *)sender{
    _isEdit = NO;
    [self createNav];
    _toolBar.sd_layout.heightIs(0);
    [_tableview reloadData];
}

- (void)resetArray{

}

// 属性请求
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
    }
//    else if ([aRequest isKindOfClass:[LEOWebDAVDeleteRequest class]]) {
//        LEOWebDAVDeleteRequest *req=(LEOWebDAVDeleteRequest *)aRequest;
//        if (req.info) {
//            [_deleteArray removeObject:req.info];
//        }
//        if ([_deleteArray count]<1) {
//            [self performSelectorOnMainThread:@selector(finishDeleteList) withObject:nil waitUntilDone:NO];
//        }
//    }else if ([aRequest isKindOfClass:[LEOWebDAVDownloadRequest class]]) {
//        // 下载类请求
//        NSData *myDate=result;
//        LEOWebDAVDownloadRequest *req=(LEOWebDAVDownloadRequest *)aRequest;
//        //        LEOWebDAVItem *downloadItem=req.item;
//        NSDictionary *dictionary=req.dictionary;
//        LEOWebDAVItem *downloadItem=dictionary==nil?nil:[dictionary objectForKey:@"item"];
//        NSString *cacheFolder=[[LEOUtility getInstance] cachePathWithName:@"download"];
//        NSString *cacheUrl=[[cacheFolder stringByAppendingPathComponent:downloadItem.cacheName] stringByAppendingPathExtension:[downloadItem.displayName pathExtension]];
//        [myDate writeToFile:cacheUrl atomically:YES];
//        if (downloadItem!=nil && [downloadItem.contentType rangeOfString:@"image"].location!=NSNotFound) {
//            [self performSelectorInBackground:@selector(computeThumbnail:) withObject:cacheUrl];
//        }
//        if (req.callback) {
//            //            [self performSelectorOnMainThread:req.callback withObject:downloadItem waitUntilDone:NO];
//            [self performSelectorOnMainThread:req.callback withObject:dictionary waitUntilDone:NO];
//        }
//    }else if ([aRequest isKindOfClass:[LEOWebDAVMoveRequest class]]) {
//        [self performSelectorInBackground:@selector(loadCurrentPath) withObject:nil];
//    } else if ([aRequest isKindOfClass:[LEOWebDAVUploadRequest class]]) {
//        [self performSelectorOnMainThread:@selector(finishUpload) withObject:nil waitUntilDone:NO];
//    }
}

-(void)setContentArray:(NSMutableArray *)contents
{

    _dataArray = contents;
//    _dataArray=[[NSMutableArray alloc] init];
    for (LEOWebDAVItem *item in contents) {
        if (item.type==LEOWebDAVItemTypeCollection) {
//            [_dataArray addObject:item];
            NSLog(@"11");
        }
    }
    
    [_tableview reloadData];
}

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
    model.showEdit = _isEdit;
    cell.model = model;
    cell.showButtonClick = ^(LEOWebDAVItem *model){

        NSIndexPath *lastIndexPath = _selectIndexPath;
        if (_selectIndexPath == indexPath) {
            _selectIndexPath = nil;
        }else{
            _selectIndexPath = indexPath;
        }
        if (lastIndexPath) {
            [_tableview reloadRowsAtIndexPaths:@[indexPath, lastIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            [_tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }

//        [_tableview reloadData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == _selectIndexPath) {
        return 110;
    }
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LEOWebDAVItem *item=[_dataArray objectAtIndex:indexPath.row];
    NSString *type = [item.contentType componentsSeparatedByString:@"/"][0];

    if (_isEdit) { //编辑状态，选中按钮
        item.beSelected = !item.beSelected;
        if (item.beSelected) {
            [_selectedArray addObject:item];
        }else{
            [_selectedArray removeObject:item];
        }
        
        [_tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else if (item.type == LEOWebDAVItemTypeCollection) {
        YunListViewController *vc = [[YunListViewController alloc] initWithItem:item];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"video"]){
        MRVLCPlayer *player = [[MRVLCPlayer alloc] init];
        
        player.bounds = CGRectMake(0, 0, self.view.bounds.size.width, kScreenHeight);
                player.center = self.view.window.center;
        player.mediaURL = [NSURL URLWithString:item.url];
        [player showInView:self.view.window];
    }else if ([[item.displayName pathExtension] isEqualToString:@"docx"] || [[item.displayName pathExtension] isEqualToString:@"doc"] || [[item.displayName pathExtension] isEqualToString:@"txt"] || [[item.displayName pathExtension] isEqualToString:@"pdf"] || [[item.displayName pathExtension] isEqualToString:@"xls"] || [[item.displayName pathExtension] isEqualToString:@"ppt"] || [[item.displayName pathExtension] isEqualToString:@"odt"]){
        JhtFileModel *fileModel = [[JhtFileModel alloc] init];
//        fileModel.fileId = fileArr[indexPath.row][@"attachId"];
        fileModel.vFileName = item.displayName;
        fileModel.url = item.url;
        fileModel.fileName = item.displayName;
//        fileModel.vFileId = fileArr[indexPath.row][@"attachId"];
        fileModel.contentType = item.contentType;
        NSArray  * array= [fileModel.fileName componentsSeparatedByString:@"."];
        fileModel.fileType = [array lastObject];
        
        JhtLoadDocViewController *load = [[JhtLoadDocViewController alloc] init];
        JhtFileModel *model = fileModel;
        load.titleStr = model.fileName;
        load.currentFileModel = model;
        [self.navigationController pushViewController:load animated:YES];
    }
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LEOWebDAVItem *item=[_dataArray objectAtIndex:indexPath.row];
    NSString *type = [item.contentType componentsSeparatedByString:@"/"][0];

    if (_isEdit) {
        //        [cell viewSelected];
        item.beSelected = !item.beSelected;
        if (item.beSelected) {
            [_selectedArray addObject:item];
        }else{
            [_selectedArray removeObject:item];
        }
        
        [_tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else if (item.type == LEOWebDAVItemTypeCollection) {
        YunListViewController *vc = [[YunListViewController alloc] initWithItem:item];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"video"]){
        //视频播放器
        MRVLCPlayer *player = [[MRVLCPlayer alloc] init];
        
        player.bounds = CGRectMake(0, 0, self.view.bounds.size.width, kScreenHeight);
        player.center = self.view.window.center;
        player.mediaURL = [NSURL URLWithString:item.url];
        [player showInView:self.view.window];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    if (_currentClient!=nil) {
        [_currentClient cancelRequest];
    }
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
