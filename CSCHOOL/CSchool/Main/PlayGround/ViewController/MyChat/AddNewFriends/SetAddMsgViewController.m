//
//  SetAddMsgViewController.m
//  CSchool
//
//  Created by mac on 17/3/2.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "SetAddMsgViewController.h"
#import "UIView+SDAutoLayout.h"
#import "XMPPFramework.h"
#import "HQXMPPManager.h"
@interface SetAddMsgViewController ()
@property (nonatomic,strong)UITextField *noteTxtInputV;
@property (nonatomic,strong)UITextField *txtInputView;
@property (nonatomic,strong)UIScrollView *mainScrollview;
@end

@implementation SetAddMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证申请";
    self.view.backgroundColor = Base_Color2;
    self.mainScrollview  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.mainScrollview];
    [self createView];
    [self createMainView];
   
}
-(void)createView
{
    UIButton *sendRequest = [UIButton buttonWithType:UIButtonTypeCustom];
    sendRequest.frame = CGRectMake(0, 0, 40, 30);
    [sendRequest addTarget:self action:@selector(sendRequest:) forControlEvents:UIControlEventTouchUpInside];
    [sendRequest setTitle:@"发送" forState:UIControlStateNormal];
    [sendRequest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *customBar = [[UIBarButtonItem alloc]initWithCustomView:sendRequest];
    self.navigationItem.rightBarButtonItem = customBar;

}

/**
 创建视图 -- 修改
 */
-(void)createMainView
{
    UIView *headerView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    UILabel *noticeLabel = ({
        UILabel *view = [UILabel new];
        view.text = @"您需要发送验证申请，等待对方通过";
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(153, 153, 153);
        view;
    });
     _txtInputView = ({
        UITextField *view = [UITextField new];
        view.placeholder = @"输入验证信息";
        view.font = [UIFont systemFontOfSize:12.0];
        view.textColor = RGB(85, 85, 85);
        view.borderStyle = UITextBorderStyleNone;
        view.returnKeyType = UIReturnKeyDone;
        view;
    });
    
    UIView *lineView = ({
        UIView *view = [UIView new];
        view.backgroundColor =  RGB(213, 213, 213);
        view.userInteractionEnabled = YES;
        view;
    });
    [self.mainScrollview  addSubview:headerView];
    [headerView sd_addSubviews:@[noticeLabel,_txtInputView,lineView]];
    headerView.sd_layout.leftSpaceToView(self.mainScrollview,0).rightSpaceToView(self.mainScrollview,0).topSpaceToView(self.mainScrollview,0).heightIs((kScreenHeight-64-30)/2);
    noticeLabel.sd_layout.leftSpaceToView(headerView,12).topSpaceToView(headerView,28).widthIs(250).heightIs(15);
    _txtInputView.sd_layout.leftSpaceToView(headerView,46).topSpaceToView(noticeLabel,18).widthIs(kScreenWidth-46-46).heightIs(15);
    lineView.sd_layout.leftEqualToView(_txtInputView).topSpaceToView (_txtInputView,0).widthIs(kScreenWidth-46-46).heightIs(1);
    
    UIView *footerView =({
        UIView *view  = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    UILabel *setNoticeL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.text = @"为朋友设置备注";
        view.textColor = RGB(153, 153, 153);
        view;
    });
    _noteTxtInputV = ({
        UITextField *view = [UITextField new];
        view.placeholder = @"备注名";
        view.font = [UIFont systemFontOfSize:12.0];
        view.textColor = RGB(85, 85, 85);
        view.borderStyle = UITextBorderStyleNone;
        view.returnKeyType = UIReturnKeyDone;
        view;
    });
    
    UIView *secLineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = RGB(213, 213, 213);
        view.userInteractionEnabled = YES;
        view;
    });
    UIView *lastLine = ({
        UIView *view = [UIView new];
        view.backgroundColor = RGB(219, 219, 219);
        view.userInteractionEnabled = YES;
        view;
    });
    [self.mainScrollview  addSubview:footerView];
    [footerView sd_addSubviews:@[setNoticeL,_noteTxtInputV,secLineView,lastLine]];
    footerView.sd_layout.leftSpaceToView(self.mainScrollview,0).rightSpaceToView(self.mainScrollview,0).topSpaceToView(headerView,21).bottomSpaceToView(self.mainScrollview,0);
    setNoticeL.sd_layout.leftSpaceToView(footerView,12).topSpaceToView(footerView,50).widthIs(120).heightIs(14);
    _noteTxtInputV.sd_layout.leftSpaceToView(footerView,46).topSpaceToView(setNoticeL,20).widthIs(kScreenWidth-46-46).heightIs(15);
    secLineView.sd_layout.leftEqualToView(_noteTxtInputV).topSpaceToView (_noteTxtInputV,0).widthIs(kScreenWidth-46-46).heightIs(1);
//    lastLine.sd_layout.leftSpaceToView(footerView,0).topSpaceToView(secLineView,30).widthIs(kScreenWidth).heightIs(1);
}
#pragma mark 发送请求
-(void)sendRequest:(UIButton *)sender
{
    NSString *requestMsg = _txtInputView.text;
    NSString *noteName = _noteTxtInputV.text;
//    noteName  = [noteName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *groupName = @"我的好友";
//    groupName = [groupName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    requestMsg = [requestMsg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if([_uname isEqualToString:@""]) return;
    //添加好友
    XMPPJID *jid=[XMPPJID jidWithString:_uname];
    //判断时代否为自己
    NSString *jidStr = [NSString stringWithFormat:@"%@",jid];
    if (![jidStr containsString:kDOMAIN]) {
        jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@_%@@%@",[AppUserIndex GetInstance].schoolCode,jid,kDOMAIN]];
    }
    NSString *me=[HQXMPPUserInfo shareXMPPUserInfo].user;
    me = [[me componentsSeparatedByString:@"_"]lastObject];
    if([me isEqualToString:_uname]){
        [ProgressHUD showError:@"不能添加自己为好友"];
        return;
    }
    XMPPUserCoreDataStorageObject * user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:jid xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
    if ([user.subscription isEqualToString:@"both"]) {
        [ProgressHUD showError:@"该用户已经是您的好友了，请勿重复添加!"];
        sender.selected = YES;
        return;
    }else if ([user.subscription isEqualToString:@"to"]){
        [ProgressHUD showError:@"好友请求已发送,请等待对方确认!"];
        return;
    }
    if ([noteName isEqualToString:@""]) {
        noteName = self.uname;
    }
    if ([self stringContainsEmoji:noteName]) {
        [JohnAlertManager showFailedAlert:@"昵称设置暂时不支持表情" andTitle:@"温馨提示"];
        return ;
    }
    //发送好友请求
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
   dispatch_async(queue, ^{
       [[HQXMPPManager shareXMPPManager].roster addUser:jid withNickname:noteName groups:@[groupName] RequestMessageInfo:requestMsg mySchoolCode:[AppUserIndex GetInstance].schoolCode andFriendCode:[AppUserIndex GetInstance].schoolCode subscribeToPresence:YES];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD showSuccess:@"好友请求已发送!"];
    });
    
}
#pragma mark 检查是否有表情
- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    return returnValue;
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
