//
//  XGChatViewController.m
//  XMPPDemo
//
//  Created by 左俊鑫 on 17/2/7.
//  Copyright © 2017年 Xin the Great. All rights reserved.
//

#import "XGChatViewController.h"
#import "SDAutoLayout.h"
#import "XGMessageCell.h"
#import "XGMessageModel.h"
#import "XGChatBar.h"
#import "POPBasicAnimation.h"

#import "XGChatExpressionView.h"
#import "AIPictureViewer.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "MessageStorageTool.h"
#import "HQXMPPChatRoomManager.h"
#import "NSString+HQUtility.h"
#import "XMPPvCardTemp.h"

#import "OpenCameraViewController.h"
#import "ChatMessageViewController.h"
#import "FmdbTool.h"
#import "LocalPhotoBrowser.h"
#import "GroupInfoViewController.h"
#import <MJRefresh.h>
#import "NSDate+CH.h"

#import "SendImageProgressView.h"
#define imageRectRation  0.8

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@interface XGChatViewController ()<UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate,AIPictureViewerDelegate,UINavigationControllerDelegate,LocalPhotoBrowserDelegate,YYTextViewDelegate>

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *dataArray;

@property (nonatomic, retain) XGChatBar *chatBar;

@property (nonatomic, strong) XGChatExpressionView *faceView;

@property (nonatomic, strong) AIPictureViewer *picPikerView;

@property (strong, nonatomic) MessageStorageTool * messageTool;

@property (nonatomic,strong) NSMutableArray *imagearray;//图片数组
@property (nonatomic,strong) NSMutableDictionary *imageIndexDic;//图片数组

@end
static int  imageIndex =0;

@implementation XGChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11,*)) {
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.tableView.estimatedRowHeight = 0;
            self.tableView.estimatedSectionHeaderHeight = 0;
            self.tableView.estimatedSectionFooterHeight = 0;
        }
    }
    //不是群组标题显示用户名字
    if (!_isRoomChat) {
        self.title = _userName;
        if ([_userName containsString:kDOMAIN]) {
            XMPPJID *jid = [XMPPJID jidWithString:_userName];
            self.title= [[jid.user componentsSeparatedByString:@"_"]lastObject];
        }
        if (!_userName) {
            [self getUserName];
        }
    }else{
        self.title = _groupName;
        [self createRightNav];
    }

    self.view.backgroundColor = [UIColor whiteColor];
    //读取照片数据
    // Do any additional setup after loading the view.

    [self.view addSubview:self.tableView];
    
    
    [self.view addSubview:self.chatBar];
    
    self.chatBar.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0)
    .heightIs(_chatBar.normalHeight);
    
    self.tableView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .bottomSpaceToView(_chatBar,0);
//    _jidStr = @"sad";
    if (!_messageTool) {
        _messageTool = [[MessageStorageTool alloc] init];
        __weak typeof(self) weakSelf = self;
        _messageTool.updateData = ^{
            
            XGMessageModel *model = [weakSelf translateFromMessageModel:[weakSelf.messageTool.messageArr lastObject]];
            [weakSelf.dataArray addObject:model];

            [weakSelf reloadChatMesasageViewData];

            [weakSelf scrollBottom];
        };
        if (!self.isRoomChat) {
            //单聊
            _messageTool.userJid = self.jidStr;
        }else{
            _messageTool.roomJidStr = self.jidStr;
            
        }
        [self setData];
    }
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];
    //获取相册权限
    [self getPhotoPriavcy];
    
}
-(void)getPhotoPriavcy
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
    } failureBlock:^(NSError *error) {
        NSLog(@"相册不可用");
    }];
}
-(void)getUserName
{
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",self.jidStr,kDOMAIN]];
    XMPPvCardTemp *friendvCard =[[HQXMPPManager shareXMPPManager].vCard vCardTempForJID:jid shouldFetch:YES];
    XMPPJID *newJId =[XMPPJID jidWithString:self.jidStr];
    XMPPUserCoreDataStorageObject * user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:newJId xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
    if (!user) {
        user =[[HQXMPPManager shareXMPPManager].rosterStorage userForJID:jid xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
    }
   
    if (friendvCard.nickname.length!=0) {
        if ([user.nickname containsString:kDOMAIN]) {
            self.title = [[user.jid.user componentsSeparatedByString:@"_"]lastObject];
        }
        self.title = [NSString stringWithFormat:@"%@(%@)",user.nickname,friendvCard.nickname];
    }else if(user.nickname){
        self.title  = [NSString stringWithFormat:@"%@",user.nickname];
    }else{
        self.title = [[jid.user componentsSeparatedByString:@"_"]lastObject];
    }
}
#pragma mark 打开群成员
-(void)createRightNav
{
    UIButton *add_Friends = [UIButton buttonWithType:UIButtonTypeCustom];
    add_Friends.frame = CGRectMake(0, 0, 30, 40);
    [add_Friends setImage:[UIImage imageNamed:@"groupMemer"] forState:UIControlStateNormal];
    [add_Friends addTarget:self action:@selector(showGroupUsers) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    view.backgroundColor = [UIColor greenColor];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:add_Friends];
    self.navigationItem.rightBarButtonItem = leftItem;
}
#pragma mark 展示群组成员
-(void)showGroupUsers
{
    GroupInfoViewController *vc = [[GroupInfoViewController alloc]init];
    vc.RoomJid = self.roomJid?self.roomJid:self.jidStr;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setJidStr:(NSString *)jidStr{
    NSRange range = [jidStr rangeOfString:@"@"];
    if (range.location != NSNotFound) {
        _jidStr = [jidStr substringToIndex:range.location];
    }else{
        _jidStr = jidStr;
    }
}

#pragma mark lazy
- (void)clickTextView:(UITapGestureRecognizer *)sender{
    if (_chatBar.textView.inputView) {
        CGSize sizeThatShouldFitTheContent = [self.chatBar.textView sizeThatFits:self.chatBar.textView.frame.size];
        CGFloat constant = MAX(50.f, MIN(sizeThatShouldFitTheContent.height + 8 + 8,117.f));
        //每次textView的文本改变后 修改chatBar的高度
        _chatBar.sd_layout.heightIs(constant+50);
        _chatBar.textView.scrollEnabled = constant >= 117.f;
        
        [self.chatBar.textView setSelectedRange:NSMakeRange(self.chatBar.textView.text.length - 1, 0)];
        self.chatBar.textView.inputView = nil;
        [self.chatBar.textView reloadInputViews];
        [self.chatBar.textView becomeFirstResponder];
    }else{
        [self.chatBar.textView becomeFirstResponder];
    }

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboard:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleExpressionChanged:) name:XGExpressionNotification object:nil];
}


- (XGChatExpressionView *)faceView{
    if (!_faceView) {
        _faceView = [[XGChatExpressionView alloc] initWithFrame:CGRectMake(0, 0, 320, 235)];
    }
    return _faceView;
}

- (AIPictureViewer *)picPikerView{
    if (!_picPikerView) {
        _picPikerView = [[AIPictureViewer alloc] init];
        _picPikerView.delegate = self;
    }
    return _picPikerView;
}

- (XGChatBar *)chatBar{
    if (!_chatBar) {
        _chatBar = [[XGChatBar alloc] init];
        _chatBar.textView.delegate = self;
        _chatBar.textView.inputView.backgroundColor = [UIColor clearColor];
        WEAKSELF;
        _chatBar.chatBarButtonClick = ^(XGChatBarButtonType chatBarButtonType){
            if (chatBarButtonType == XGChatBarExpression) {
                weakSelf.chatBar.textView.inputView = weakSelf.faceView;
                weakSelf.chatBar.textView.extraAccessoryViewHeight = 235.f;
                [weakSelf.chatBar.textView reloadInputViews];
                [weakSelf.chatBar.textView becomeFirstResponder];
            }else if (chatBarButtonType == XGChatBarPhoto){
                weakSelf.chatBar.textView.inputView = weakSelf.picPikerView;
                weakSelf.chatBar.textView.extraAccessoryViewHeight = 172.f;
                [weakSelf.chatBar.textView reloadInputViews];
                [weakSelf.chatBar.textView becomeFirstResponder];
            }else{
//                CGSize sizeThatShouldFitTheContent = [weakSelf.chatBar.textView sizeThatFits:weakSelf.chatBar.textView.frame.size];
//                CGFloat constant = MAX(50.f, MIN(sizeThatShouldFitTheContent.height + 8 + 8,117.f));
//                //每次textView的文本改变后 修改chatBar的高度
//                weakSelf.chatBar.sd_layout.heightIs(constant+50);
//                weakSelf.chatBar.textView.scrollEnabled = constant >= 117.f;
//                
//                [weakSelf.chatBar.textView setSelectedRange:NSMakeRange(weakSelf.chatBar.textView.text.length - 1, 0)];
//                weakSelf.chatBar.textView.inputView = nil;
//                [weakSelf.chatBar.textView reloadInputViews];
//                [weakSelf.chatBar.textView becomeFirstResponder];
                // 打开拍照界面
                OpenCameraViewController *vc = [[OpenCameraViewController alloc]init];
                vc.sendCameraImageBlock = ^(UIImage *imageData){
//                    [weakSelf sendMessageWithData:imageData bodyName:@"image"];
                    //  发送URL
                    [SendImageProgressView show:@"正在发送..." onView:weakSelf.view];
                    [NetworkCore uploadPhotoImagewithParams:imageData WithParams:@{@"person":@"chat"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                        NSDictionary *dic = responseObject;
                        NSString *imgURL = dic[@"data"][@"IRIURL"];
                        if (imgURL.length==0||imgURL==nil) {
                            [JohnAlertManager showFailedAlert:@"照片过大，无法发送" andTitle:@"提示"];
                            [SendImageProgressView removeAlert:@"文件太大,发送失败!"];
                            return ;
                        }
                        [SendImageProgressView removeAlert:@"发送成功!"];
                        NSString *url =[NSString stringWithFormat:@"%@",dic[@"data"][@"IRIURL"]];
                        [weakSelf sendMessageWithData:url bodyName:@"image"];
                        [weakSelf scrollBottom];
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                        [SendImageProgressView removeAlert:@"发送失败!"];
                        [JohnAlertManager showFailedAlert:@"照片过大，无法发送" andTitle:@"提示"];
                    } progress:^(NSProgress * _Nonnull uploadProgress) {
                        NSString *word = [NSString stringWithFormat:@"已发送%.0f%%",uploadProgress.fractionCompleted*100];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SendImageProgressView showString:word];
                            
                        });
                    }];
//                    */
                    
                };
                dispatch_async(dispatch_get_main_queue(), ^{
                    //主线程刷新界面。。。
                    [weakSelf.navigationController presentViewController:vc animated:YES completion:^{
                        
                    }];
                });
              
            }
            [weakSelf scrollBottom];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(clickTextView:)];
            [weakSelf.chatBar.textView addGestureRecognizer:tap];
        };
    }
    return _chatBar;

}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = RGB(245, 245, 245);
//        [self.view addSubview:_tableView];
        
//        _tableView.sd_layout
//        .leftSpaceToView(self.view,0)
//        .rightSpaceToView(self.view,0)
//        .topSpaceToView(self.view,0)
//        .bottomSpaceToView(_chatBar,0);
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        _tableView.mj_header = header;
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//        _tableView.header.hidden
    }
    return _tableView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    [self.view addSubview:self.chatBar];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XGExpressionNotification object:nil];

}
#pragma mark 更新聊天消息界面
-(void)reloadChatMesasageViewData
{
    XMPPMessageArchiving_Message_CoreDataObject *mymsg = [self.messageTool.messageArr lastObject];
    //重新读取照片数
    [self readImageDataFromMessageHistorary];
    NSString *messageType = _isRoomChat?@"groupchat":@"chat";
    NSString *uname=[self cutStr:mymsg.bareJidStr];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate=[formatter stringFromDate:mymsg.timestamp];
    NSString *mesBody = mymsg.body;
    XMPPJID *jid;
    if([[mymsg outgoing] boolValue]){
        jid =mymsg.bareJid;//接收方
        if (_isRoomChat) {
           mesBody = [NSString stringWithFormat:@"%@",mymsg.body];
            NSString *newJidStr = [NSString stringWithFormat:@"%@/%@",mymsg.bareJid,mymsg.message.from.user];
            jid = [XMPPJID jidWithString:newJidStr];
        }
    }else{
        jid = mymsg.message.from;
        if (_isRoomChat) {
            jid   =mymsg.message.from;
            mesBody = [NSString stringWithFormat:@"%@",mymsg.body];
        }
    }
    //更新数据库的值
    if([FmdbTool selectUname:uname withMyjid:[HQXMPPManager shareXMPPManager].xmppStream.myJID]){
        [FmdbTool updateWithName:uname detailName:mesBody time:strDate badge:nil withMyjid:[HQXMPPManager shareXMPPManager].xmppStream.myJID andUserJId:jid andMsgTyope:messageType];
    }else{
        [FmdbTool addHead:nil uname:uname detailName:mesBody time:strDate badge:nil xmppjid:jid withMyjid:[HQXMPPManager shareXMPPManager].xmppStream.myJID andMsgType:messageType];
    }


}
#pragma mark - tableview delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;//self.messageTool.messageArr.count;
}

- (void)loadData{
    
    NSInteger count = self.messageTool.messageArr.count - _dataArray.count;
    if (count == 0) {
        [_tableView.mj_header endRefreshing];

        return;
    }
    NSInteger start = count -5;
    if (start < 0) {
        start = 0;
    }
    for (NSInteger i=count-1; i>=start; i--) {
        XMPPMessageArchiving_Message_CoreDataObject * message = self.messageTool.messageArr[i];
        XGMessageModel *model = [self translateFromMessageModel:message];
        [_dataArray insertObject:model atIndex:0];
    }
    [self readImageDataFromMessageHistorary];
    [_tableView.mj_header endRefreshing];

    [_tableView reloadData];
}

- (void)setData{
    _dataArray = [NSMutableArray array];
    
    for (NSInteger i = self.messageTool.messageArr.count>7?(self.messageTool.messageArr.count-7):0; i<self.messageTool.messageArr.count; i++) {
        XMPPMessageArchiving_Message_CoreDataObject * message = self.messageTool.messageArr[i];
        XGMessageModel *model = [self translateFromMessageModel:message];
        [_dataArray addObject:model];
    }
    [self readImageDataFromMessageHistorary];
//    [_tableView reloadData];
}


/**
 根据coreData转换成需要的model

 @param message  201612101001@toplion.toplion-domain
 @return
 */
- (XGMessageModel *)translateFromMessageModel:(XMPPMessageArchiving_Message_CoreDataObject *)message{
    XMPPJID *jid = [HQXMPPManager shareXMPPManager].xmppStream.myJID;
    XMPPJID * friendJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",[NSString useNameWithUserJid:self.jidStr],kDOMAIN]];
    if (message.isOutgoing == NO) {
        jid = message.bareJid;
        if (_isRoomChat) {
            NSString *friendJIdStr = message.message.fromStr;
            NSArray *friendArr = [friendJIdStr componentsSeparatedByString:@"/"];
            jid   =[XMPPJID jidWithUser:[friendArr lastObject] domain:kDOMAIN resource:nil];
        }

    }
    
    XMPPUserCoreDataStorageObject * user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:jid xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];

    XMPPvCardTemp *friendvCard =[[HQXMPPManager shareXMPPManager].vCard vCardTempForJID:jid shouldFetch:YES];
    XGMessageModel *model = [[XGMessageModel alloc] init];
    model.isMySend = message.isOutgoing;
    model.messageType = XGMsgTypeText;
    model.text = message.body;
    model.chatTime = message.timestamp;
    model.headerImage = [UIImage imageWithData:friendvCard.photo];
    model.name = user.nickname?user.nickname:friendJid.user;

    model.groupName = _sectionName;
    model.jid = jid;
    model.isGrouoChat = _isRoomChat;//是否是群聊
    NSError *error = nil;
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithXMLString:message.messageStr options:0 error:&error];
    if (error) {
        NSLog(@"error:%@",[error localizedDescription]);
    }
    /////解析
    DDXMLDocument *msg = [doc children][0];
    
    for (DDXMLNode *obj in [msg children]) {
        if ([[obj name] isEqualToString:@"attachment"]) {
            
            for (DDXMLNode *chlid in [obj children]) {
                //是图片格式进行处理
                if ([[chlid name] isEqualToString:@"image"]) {
                    model.messageType = XGMsgTypeImage;
                    model.imageBody = [chlid stringValue];
                    

                }
            }
            
        }
    }
    
    return model;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"XGMessageCell";
    XGMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[XGMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    XGMessageModel *model = _dataArray[indexPath.row];//[self translateFromMessageModel:indexPath];
    if (indexPath.row>0) {
        //判断上个消息的时间
        XGMessageModel *lastModel = _dataArray[indexPath.row-1];
        //上一条消息距离当前消息的时间没有半小时  不显示时间
        if (![NSDate dateTimeDifferenceWithStartTime:model.chatTime endTime:lastModel.chatTime]) {
            //正常显示
            cell.timeLabel.hidden = YES;
        }else{
            cell.timeLabel.hidden = NO;

        }
    }
    cell.model = model;
    if (model.messageType==XGMsgTypeImage) {
        UITapGestureRecognizer *gesture  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zommImage:)];
        [cell.messageImageView addGestureRecognizer:gesture];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = [self.tableView cellHeightForIndexPath:indexPath model:_dataArray[indexPath.row] keyPath:@"model" cellClass:[XGMessageCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    return h;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark 读取照片
//从历史消息中读取照片信息
-(void)readImageDataFromMessageHistorary
{
    imageIndex = 0;
    self.imagearray = [NSMutableArray array];
    self.imageIndexDic = [NSMutableDictionary dictionary];
    NSArray *messageArr = _dataArray;
    [messageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XGMessageModel *model = obj;
        if (model.messageType == XGMsgTypeImage) {
            /*
            NSData* imageData = [[NSData alloc] initWithBase64EncodedString:model.imageBody options:0];//[model.imageBody dataUsingEncoding:NSUTF8StringEncoding];
            UIImage *image = [UIImage imageWithData:imageData];
            [self.imagearray addObject:image];
             */
            NSString *breakString =[NSString stringWithFormat:@"/thumb"];
            NSString *photoUrl = [model.imageBody stringByReplacingOccurrencesOfString:breakString withString:@""];

//            UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:photoUrl]]];
            [self.imagearray addObject:photoUrl];
            NSString *iObj = [NSString stringWithFormat:@"%d",imageIndex];
    
            NSString *idxObj = [NSString stringWithFormat:@"%lu",idx];
            [self.imageIndexDic setValue:iObj forKey:idxObj];
            imageIndex++;
        }

    }];
    [self.tableView reloadData];
}

#pragma mark 点击浏览图片
-(void)zommImage:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];

    CGPoint tmpPointTouch = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tmpPointTouch];
  
    NSString *tagValue = [NSString stringWithFormat:@"%ld",indexPath.row];
    NSString *index = [self.imageIndexDic valueForKey:tagValue];
    NSArray *visibleCells = self.tableView.visibleCells;
    NSMutableArray *visiblePicCells = [NSMutableArray array];
    NSMutableArray *maxIndexArray = [NSMutableArray array];

    for (XGMessageCell *cell in visibleCells) {
        if (cell.model.messageType==XGMsgTypeImage) {
            [visiblePicCells addObject:cell.messageImageView];
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            NSString *maxIndexNum = [NSString stringWithFormat:@"%ld",indexPath.row];
            [maxIndexArray addObject:maxIndexNum];
        }
    }
    NSString * maxValue =[NSString stringWithFormat:@"%@",[maxIndexArray valueForKeyPath:@"@max.floatValue"]];
    LocalPhotoBrowser *browser = [[LocalPhotoBrowser alloc] init];
    browser.sourceImagesContainerView =gestureRecognizer.view ; // 原图的父控件superViewArray[[cellIndex intValue]]
    browser.imageArray =self.imagearray; // 图片总数
    browser.currentImageIndex =[index intValue];//点击的图片
    browser.superViewArray   = [NSArray arrayWithArray:visiblePicCells];
    //取出当前页面最大的图片数组下标
    NSString *maxindexnum = [self.imageIndexDic valueForKey:maxValue];
    browser.currentMaxsNum = [maxindexnum intValue];//当前页面图片数组最大下标
    browser.delegate = self;
    [browser show];

}
#pragma mark 图片代理事件
- (UIImage *)photoBrowser:(LocalPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return self.imagearray[index];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - YYTextViewDelegate

- (void)textViewDidChange:(YYTextView *)textView {
    
    CGSize sizeThatShouldFitTheContent = [textView sizeThatFits:textView.frame.size];
    CGFloat constant = MAX(50.f, MIN(sizeThatShouldFitTheContent.height + 8 + 8,117.f));
    //每次textView的文本改变后 修改chatBar的高度
//    self.chatBarHConstraint.constant = constant;
    _chatBar.sd_layout.heightIs(constant+50);
    textView.scrollEnabled = constant >= 117.f;
    
    /** 解决chatBar高度变化后,tableView高度修改 */
    [self.view layoutIfNeeded];
}

- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView {
    
//    self.showingViewType = XMNChatShowingKeyboard;
    //添加文本输入区域
    textView.textContainerInset = UIEdgeInsetsMake(4, 4, 4, 4);
    
    //修复了textView默认了contentInset.top = 64的问题
    textView.contentInset = UIEdgeInsetsMake( 2, 0, 4, 0);
    
    //解决textView大小不定时 contentOffset不正确的bug
    //固定了textView后可以设置滚动YES
    CGSize sizeThatShouldFitTheContent = [textView sizeThatFits:textView.frame.size];
    //每次textView的文本改变后 修改chatBar的高度
    CGFloat chatBarHeight = MAX(50.f, MIN(sizeThatShouldFitTheContent.height + 8 + 8,117.f));
    
    textView.scrollEnabled = chatBarHeight>=117.f;
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //实现textView.delegate  实现回车发送,return键发送功能
    if ([@"\n" isEqualToString:text]) {
        
//        self.chatBarHConstraint.constant = 44.f;
        _chatBar.sd_layout.heightIs(_chatBar.normalHeight);

        NSString *messageContent;
        if (textView.text.length > 0) {
            messageContent = textView.text;
        }
        
        [textView setAttributedText:nil];
//        [self.chatBar setNeedsLayout];
//        _chatBar.sd_layout.bottomSpaceToView(self.view,0);
        
//        [_chatBar updateLayout];
        if (messageContent) {
//            XMNChatTextMessage *textMessage = [[XMNChatTextMessage alloc] initWithContent:messageContent state:XMNMessageStateSending owner:XMNMessageOwnerSelf];
//            [self sendMessage:textMessage];
            [self sendMessage:messageContent toUser:self.jidStr];
        }
        return NO;
    }
    return YES;
}

//发送文字消息
- (void)sendMessage:(NSString *) message toUser:(NSString *) user {
    
    
    if (_isRoomChat) {
        [[HQXMPPChatRoomManager shareChatRoomManager] sendMessage:message inChatRoom:[NSString jidStrWithRoomName:self.jidStr]];
        //        self.inputTextView.text=@"";
        //        self.sendMessageButton.enabled = NO;
    }else{
        XMPPJID * friendNameJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",[NSString useNameWithUserJid:self.jidStr],kDOMAIN]];
        XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:friendNameJid];
        [msg addBody:message];
        //添加   我发送的信息
        [[HQXMPPManager shareXMPPManager].xmppStream sendElement:msg];
    }
    
    [self saveChatMessage:message withType:@"1"];
    
    [self scrollBottom];
}
#pragma mark 获得离线消息的时间

-(NSDate *)getDelayStampTime:(XMPPMessage *)message{
    //获得xml中德delay元素
    XMPPElement *delay=(XMPPElement *)[message elementsForName:@"delay"];
    if(delay){  //如果有这个值 表示是一个离线消息
        //获得时间戳
        NSString *timeString=[[ (XMPPElement *)[message elementForName:@"delay"] attributeForName:@"stamp"] stringValue];
        //创建日期格式构造器
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        //按照T 把字符串分割成数组
        NSArray *arr=[timeString componentsSeparatedByString:@"T"];
        //获得日期字符串
        NSString *dateStr=[arr objectAtIndex:0];
        //获得时间字符串
        NSString *timeStr=[[[arr objectAtIndex:1] componentsSeparatedByString:@"."] objectAtIndex:0];
        //构建一个日期对象 这个对象的时区是0
        NSDate *localDate=[formatter dateFromString:[NSString stringWithFormat:@"%@T%@+0000",dateStr,timeStr]];
        return localDate;
    }else{
        return nil;
    }
    
}
/** 发送URL图片 */

- (void)sendMessageWithData:(NSString *)dataUrl bodyName:(NSString *)name
{
    
    NSString *breakString =[NSString stringWithFormat:@"/thumb"];
    NSString *photoUrl = [dataUrl stringByReplacingOccurrencesOfString:breakString withString:@""];
    
    if (_isRoomChat) {
        [[HQXMPPChatRoomManager shareChatRoomManager] sendImageData:photoUrl inChatRoom:[NSString jidStrWithRoomName:self.jidStr]];
        
    }else{
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:@"[图片]"];
        
        NSXMLElement *dataElement = [NSXMLElement elementWithName:@"attachment"];
        
        NSXMLElement *imageEl = [NSXMLElement elementWithName:@"image" stringValue:photoUrl];
        [dataElement addChild:imageEl];
        
        
        NSXMLElement *message1 = [NSXMLElement elementWithName:@"message"];
        [message1 addAttributeWithName:@"type" stringValue:@"chat"];
        NSString *to = [NSString stringWithFormat:@"%@@%@",self.jidStr,kDOMAIN];
        [message1 addAttributeWithName:@"to" stringValue:to];
        [message1 addChild:dataElement];
        
        [message1 addChild:body];
        [[HQXMPPManager shareXMPPManager].xmppStream sendElement:message1];
    }
    [self saveChatMessage:photoUrl withType:@"2"];
    
    [self scrollBottom];
}

//存储聊天记录到服务器
- (void)saveChatMessage:(NSString *)message withType:(NSString *)type{
    NSDictionary *dic = @{
                          @"rid":@"addChatMessageInfo",
                          @"type":_isRoomChat?@"2":@"1",
                          @"username":[HQXMPPUserInfo shareXMPPUserInfo].user,
                          @"receiveName":_jidStr,
                          @"content":message,
                          @"state":type
                          };
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}

/** 发送二进制文件 */
/*
- (void)sendMessageWithData:(NSData *)data bodyName:(NSString *)name
{
    // 转换成base64的编码

    NSString *base64str = [data base64EncodedStringWithOptions:0];
    
    // 设置节点内容

    if (_isRoomChat) {
        [[HQXMPPChatRoomManager shareChatRoomManager] sendImageData:base64str inChatRoom:[NSString jidStrWithRoomName:self.jidStr]];

    }else{
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:@"[图片]"];
        
        NSXMLElement *dataElement = [NSXMLElement elementWithName:@"attachment"];
        
        NSXMLElement *imageEl = [NSXMLElement elementWithName:@"image" stringValue:base64str];
        [dataElement addChild:imageEl];
        
        
        NSXMLElement *message1 = [NSXMLElement elementWithName:@"message"];
        [message1 addAttributeWithName:@"type" stringValue:@"chat"];
        NSString *to = [NSString stringWithFormat:@"%@@%@",self.jidStr,kDOMAIN];
        [message1 addAttributeWithName:@"to" stringValue:to];
        [message1 addChild:dataElement];
        
        [message1 addChild:body];
        [[HQXMPPManager shareXMPPManager].xmppStream sendElement:message1];
    }

    [self scrollBottom];
}
*/

- (void)textViewDidEndEditing:(YYTextView *)textView {
    
    /** 用户不在输入文字时, 重置按钮状态 */
//    if (self.showingViewType == XMNChatShowingNoneView) {
//        [self.chatBar resetButtonState];
//    }
}

#pragma mark - 通知相关事件处理

/**
 *  处理键盘frame改变通知
 *
 *  @param aNotification
 */
- (void)handleKeyboard:(NSNotification *)aNotification {
    
    CGRect keyboardFrame = [aNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _chatBar.sd_layout.bottomSpaceToView(self.view,([UIScreen mainScreen].bounds.size.height - keyboardFrame.origin.y)) ;
    [_chatBar updateLayout];
    /** 增加监听键盘大小变化通知,并且让tableView 滚动到最底部 */
    [self.view layoutIfNeeded];
//    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];

    [self scrollBottom];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                            withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                            withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
-(void)scrollBottom
{

    if (_dataArray.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];


    [self performSelector:@selector(scrollBottom) withObject:nil afterDelay:0.1];
}
#pragma  mark 去掉@符号
-(NSString*)cutStr:(NSString*)str
{
    NSArray *arr=[str componentsSeparatedByString:@"@"];
    return arr[0];
}
#pragma mark 新增
//接受表情键盘按键通知
- (void)handleExpressionChanged:(NSNotification *)aNotification {
    
    NSDictionary *info = (NSDictionary *)aNotification.object;
    XGExpressionType type = [info[@"type"] integerValue];
    
    switch (type) {
        case XGExpDelete:
        {
            [self.chatBar.textView deleteBackward];
        }
            break;
        case XGExpQQNormal:
        {
            [self.chatBar.textView insertText:info[@"expKey"]];
            [self.chatBar.textView scrollRangeToVisible:NSMakeRange(self.chatBar.textView.text.length - 1, 1)];
        }
            break;
        case XGExpSend:
        {
            [self textView:self.chatBar.textView shouldChangeTextInRange:NSMakeRange(0, 0) replacementText:@"\n"];

        }
            break;
        default:
            break;
    }
}

#pragma mark  ALPictureViewDelegate  此处已经实现发送GIF  
-(void)pictureViewer:(AIPictureViewer*)pictureViewer didGestureSelectedImage:(UIImage *)image withOriginSoure:(ALAsset *)sorueData andImageWorldRect:(CGRect)imageWorldRect{

    UIImageView *imageView                = [[UIImageView alloc]initWithImage:image];
    imageView.frame                       = imageWorldRect;
    [self.view addSubview:imageView];
    POPBasicAnimation *popAnimation       =   [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    popAnimation.toValue                  =   [NSValue valueWithCGPoint:CGPointMake([UIScreen mainScreen].bounds.size.width-imageView.bounds.size.width, [UIScreen mainScreen].bounds.size.height-172-_chatBar.normalHeight-imageView.bounds.size.height)];//锁定图片位置
    popAnimation.duration                 =   0.5;
    popAnimation.timingFunction           =   [CAMediaTimingFunction functionWithName:kCAAnimationLinear];
    [imageView.layer pop_addAnimation:popAnimation forKey:nil];
    //
    [SendImageProgressView show:@"正在发送..." onView:self.view];
    //动画完成后赋值
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(popAnimation.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
  
        [imageView removeFromSuperview];
        [NetworkCore uploadChatImagewithParams:sorueData WithParams:@{@"person":@"chat"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSDictionary *dic = responseObject;
            NSString *imgURL = dic[@"data"][@"IRIURL"];
            if (imgURL.length==0||imgURL==nil) {
                [JohnAlertManager showFailedAlert:@"照片太大，发送失败!" andTitle:@"提示"];
                [SendImageProgressView removeAlert:@"文件太大,发送失败!"];
                return ;
            }
            [SendImageProgressView removeAlert:@"发送成功!"];
            NSString *url =[NSString stringWithFormat:@"%@",dic[@"data"][@"IRIURL"]];
            [self sendMessageWithData:url bodyName:@"image"];
            [self scrollBottom];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            [SendImageProgressView removeAlert:@"发送失败!"];
            [JohnAlertManager showFailedAlert:@"照片过大，无法发送" andTitle:@"提示"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
  
            NSString *word = [NSString stringWithFormat:@"已发送%.0f%%",uploadProgress.fractionCompleted*100];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SendImageProgressView showString:word];
                
            });
        }];
    
        /*
        NSData *data =  UIImageJPEGRepresentation(image, 0.95);//图片压缩 0.5 倍
        
        [self sendMessageWithData:data bodyName:@"image"];
         */
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [self scrollBottom];
        
    });
}

/**
 
 发送多张图片
 @param pictureViewer 发送图片的控件
 @param images 照片数组
 */
-(void)pictureView:(AIPictureViewer*)pictureViewer didSelectedImage:(NSArray *)images
{

 //点击发送多张图片
        [SendImageProgressView show:@"正在发送..." onView:self.view];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [images enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                UIImage *image = obj;
//                NSData *data =  UIImageJPEGRepresentation(image, imageRectRation);
//                UIImage *newImage = [UIImage imageWithData:data];
                ALAsset *image = obj;
                [NetworkCore uploadChatImagewithParams:image WithParams:@{@"person":@"chat"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                    NSDictionary *dic = responseObject;
                    NSString *imgURL = dic[@"data"][@"IRIURL"];
                    if (imgURL.length==0||imgURL==nil) {
                        [JohnAlertManager showFailedAlert:@"照片太大，发送失败!" andTitle:@"提示"];
                        [SendImageProgressView removeAlert:@"文件太大,发送失败!"];
                        return ;
                    }
                    [SendImageProgressView removeAlert:@"发送成功!"];
                    NSString *url =[NSString stringWithFormat:@"%@",dic[@"data"][@"IRIURL"]];
                    [self sendMessageWithData:url bodyName:@"image"];
                    [self scrollBottom];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                    [SendImageProgressView removeAlert:@"发送失败!"];
                    [JohnAlertManager showFailedAlert:@"照片过大，无法发送" andTitle:@"提示"];
                } progress:^(NSProgress * _Nonnull uploadProgress) {
           
                    NSString *word = [NSString stringWithFormat:@"已发送%.0f%%",uploadProgress.fractionCompleted*100];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SendImageProgressView showString:word];
                        
                    });
                }];                /*
                NSData *data =  UIImageJPEGRepresentation(image,0.95);
                [self sendMessageWithData:data bodyName:@"image"];
                 */
            }];
         
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [self scrollBottom];

        });
}
/**
 相册选择界面选中图片  点击发送
 
 @param pictureViewer 发送图片的控件
 @param images 照片数组
 */
-(void)pictureViewOpenSystemPhoto:(AIPictureViewer *)pictureViewer withimageArray:(NSArray *)imageArray
{
    [SendImageProgressView show:@"正在发送..." onView:self.view];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for (int i =0 ; i<imageArray.count; i++) {
            ALAsset *result =imageArray[i];
//            // [[asset defaultRepresentation] fullResolutionImage]  // 原图
//            CGImageRef cimg =[[result defaultRepresentation] fullResolutionImage];
//            UIImage *img = [UIImage imageWithCGImage:cimg];//aspectRatioThumbnail
//            NSData *data =  UIImageJPEGRepresentation(img, imageRectRation);
//            UIImage *newImage = [UIImage imageWithData:data];
            [NetworkCore uploadChatImagewithParams:result WithParams:@{@"person":@"chat"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                NSDictionary *dic = responseObject;
                NSString *imgURL = dic[@"data"][@"IRIURL"];
                if (imgURL.length==0||imgURL==nil) {
                    [JohnAlertManager showFailedAlert:@"照片太大，发送失败!" andTitle:@"提示"];
                    [SendImageProgressView removeAlert:@"文件太大,发送失败!"];
                    return ;
                }
                [SendImageProgressView removeAlert:@"发送成功!"];
                NSString *url =[NSString stringWithFormat:@"%@",dic[@"data"][@"IRIURL"]];
                [self sendMessageWithData:url bodyName:@"image"];
                [self scrollBottom];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                [SendImageProgressView removeAlert:@"发送失败!"];
                [JohnAlertManager showFailedAlert:@"照片过大，无法发送" andTitle:@"提示"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
            
                NSString *word = [NSString stringWithFormat:@"已发送%.0f%%",uploadProgress.fractionCompleted*100];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SendImageProgressView showString:word];
                    
                });
            }];
            /*
            NSData *data =  UIImageJPEGRepresentation(img, 0.95);
            //发送图片
            [self sendMessageWithData:data bodyName:@"image"];
             */
        }
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [self scrollBottom];
        
    });

}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma clang diagnostic pop

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
