//
//  FindInfoViewController.m
//  CSchool
//
//  Created by mac on 16/10/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "FindInfoViewController.h"
#import "UIView+SDAutoLayout.h"
#import "FindInfoHeaderView.h"
#import "FindVCMidView.h"
#import "FindVcBottomView.h"
#import "LPActionSheet.h"
#import "FindLoseModel.h"
#import "WXApi.h"
@interface FindInfoViewController ()<XGAlertViewDelegate>
{
    LPActionSheet *_lpActionSheet;
    UIButton *_contactBtn;
    NSString *_contactTitle;
    
    NSString *_QQnum;
    NSString *_weChatNum;
    NSString *_phoneNum;

}
@property (nonatomic,strong)UIScrollView *mainScrollView;
@property (nonatomic,strong)FindInfoHeaderView *headerView;//头部视图
@property (nonatomic,strong)FindVcBottomView *footerView;//尾部视图
@property (nonatomic,strong)FindVCMidView *midView;//中间视图
@property (nonatomic,strong)UIView  *bottomView;//最底部视图
@end

@implementation FindInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    _phoneNum = @"无";
    _weChatNum = @"无";
    _QQnum = @"无";
}

- (void)setModel:(FindLoseModel *)model
{
    _model = model;
    _reiId = model.ID;
    if ([model.type isEqualToString:@"1"]) {
        self.title = @"失物招领详情";

    }else if([model.type isEqualToString:@"2"])
    {
        self.title = @"商品详情";

    }else{
        self.title = @"兼职详情";

    }
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _contactBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = Color_Gray.CGColor;
        [view setTitleColor:Base_Orange forState:UIControlStateNormal];
        [view setTitleColor:Base_Color2 forState:UIControlStateHighlighted];
        [view addTarget:self action:@selector(contactAction) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    [_bottomView addSubview:_contactBtn];
    //底部联系人控件
    [self.view insertSubview:_bottomView aboveSubview:_mainScrollView];
    _bottomView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0).heightIs(50);
    _contactBtn.sd_layout.leftSpaceToView(_bottomView,0).rightSpaceToView(_bottomView,0).bottomSpaceToView(_bottomView,0).heightIs(50);
    
    [_contactBtn setTitle:@"联系发布人" forState:UIControlStateNormal];

    if ([model.type isEqualToString:@"2"]) {
        [_contactBtn setImage:[UIImage imageNamed:@"shopcar"] forState:UIControlStateNormal];
        _contactTitle = @"本APP仅为二手交易提供平台,线下交易请注意资金与财产安全";
    }else{
        _contactTitle = @"";
    }
    
    _headerView.model =_model;
    _midView.model =_model;
    _footerView.model = _model;
    _QQnum = _model.AUIQQ;
    _weChatNum = _model.AUIWEIXIN;
    _phoneNum = _model.AUIPHONE;
//    if (_imageArr.count==3) {
//        _mainScrollView.contentSize = CGSizeMake(kScreenWidth,_footerView.height+_midView.height+80+10*15);
//    }else if(_imageArr.count==2){
//        _mainScrollView.contentSize = CGSizeMake(kScreenWidth,_footerView.height+_midView.height+80+10*15);
//        
//    }else if (_imageArr.count==1){
//        _mainScrollView.contentSize = CGSizeMake(kScreenWidth,_footerView.height+_midView.height+90+10*15);
//    }else{
//        _mainScrollView.contentSize = CGSizeMake(kScreenWidth,_footerView.height+80+10*15);
//    }
}
/**
 *  创建视图
 */
- (void)createView
{
    _mainScrollView = [UIScrollView new];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _headerView = [FindInfoHeaderView new];
    _midView = [FindVCMidView new];
    _footerView = [FindVcBottomView new];
    [self.view addSubview:_mainScrollView];
    [_mainScrollView addSubview:_headerView];
    [_mainScrollView addSubview:_midView];
    [_mainScrollView addSubview:_footerView];
    [_mainScrollView setupAutoContentSizeWithBottomView:_footerView bottomMargin:0];

    _mainScrollView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    _headerView.sd_layout.leftSpaceToView(_mainScrollView,0).topSpaceToView(_mainScrollView,0).heightIs(40).rightSpaceToView(_mainScrollView,0);
    _midView.sd_layout.leftEqualToView(_headerView).topSpaceToView(_headerView,0).rightEqualToView(_headerView).heightIs(50);
    _footerView.sd_layout.leftSpaceToView(_mainScrollView,0).topSpaceToView(_midView,0).rightSpaceToView(_mainScrollView,0);
   

}


#pragma mark 联系人点击事件
- (void)contactAction
{
    NSString *phone = [NSString stringWithFormat:@"手机:%@",_phoneNum];
    NSString *qq = [NSString stringWithFormat:@"QQ:%@",_QQnum];
    NSString *weixin = [NSString stringWithFormat:@"微信:%@",_weChatNum];
    
    
    NSMutableArray *titleArr = [[NSMutableArray alloc]initWithObjects:phone,qq,weixin,nil];
    if (_phoneNum.length==0) {
        [titleArr removeObject:phone];
        //[qq,weixin],[qq],[weixin]
    }
    if (_QQnum.length==0) {
        [titleArr removeObject:qq];
        //[phone,weixin],[phone],[weixin]
    }
    if (_weChatNum.length==0) {
        [titleArr removeObject:weixin];
        //[phone,qq],[phone],[qq]
    }
    [LPActionSheet showActionSheetWithTitle:_contactTitle
                          cancelButtonTitle:@"取消"
                     destructiveButtonTitle:@""
                          otherButtonTitles:titleArr
                                    handler:^(LPActionSheet *actionSheet, NSInteger index) {
                                        
                                        switch (index) {
                                            case 0:
                                            {
                                                //取消操作
                                            }
                                                break;
                                            case 1:
                                            {
                                                if (_phoneNum.length==0) {
                                                    if (_QQnum.length!=0) {
                                                        [self contactQQ:_QQnum];
                                                    }else{
                                                        [self pagWechatNum:_weChatNum];
                                                    }
                                                    
                                                }else{
                                                    NSString *message = [NSString stringWithFormat:@"拨打%@?",_phoneNum];
                                                    XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:message WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
                                                    alert.delegate = self;
                                                    alert.tag = 123;
                                                    [alert show];
//                                                    [self callPhoneNum:_phoneNum];
                                                    
                                                }
                                                //直接打电话
                                            }
                                                break;
                                            case 2:
                                            {
                                                if (_phoneNum.length!=0) {
                                                    if (_QQnum.length!=0) {
                                                        [self contactQQ:_QQnum];
                                                    }else{
                                                        [self pagWechatNum:_weChatNum];
                                                        
                                                    }
                                                }else{
                                                    //直接打开微信
                                                    [self pagWechatNum:_weChatNum];
                                                }
                                            }
                                                break;
                                            case 3:
                                            {
                                                //复制微信号 并打开微信
                                                [self pagWechatNum:_weChatNum];
                                            }
                                                break;
                                            default:
                                                break;
                                        }
                                        
                                    }];
 
}
//打电话
- (void)callPhoneNum:(NSString *)phoneNum
{
    if (phoneNum.length==0) {
        [ProgressHUD showError:@"手机号为空!"];
        return;
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
//联系qq
- (void)contactQQ:(NSString *)QQNUm
{
    if (QQNUm.length==0) {
        [ProgressHUD showError:@"QQ号为空!"];
        return;
    }
    NSString *qq=[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",QQNUm];
    NSURL *url = [NSURL URLWithString:qq];
    [[UIApplication sharedApplication] openURL:url];

}
//复制微信号
- (void)pagWechatNum:(NSString *)wechatNum
{
    if (wechatNum.length==0) {
    [ProgressHUD showError:@"微信号为空!"];
    return;
        }
    
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    if (wechatNum.length!=0) {
        [pab setString:wechatNum];
        if (pab == nil) {
            [ProgressHUD showError:@"复制失败"];
        }else{
            XGAlertView *alert  = [[XGAlertView alloc]initWithTarget:self withTitle:@"复制成功" withContent:@"点击确定打开微信并添加好友!" WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
            alert.delegate =  self;
            alert.tag = 124;
            [alert show];
        }
    }
   
}
#pragma  mark XGAlertViewDelegate
- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title
{
    switch (view.tag) {
        case 123:
        {
            [self callPhoneNum:_phoneNum];
        }
            break;
            case 124:
        {
            if ([WXApi isWXAppInstalled]) {
                NSString *str = [NSString stringWithFormat:@"weixin://dl/moments/%@",_weChatNum];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }else
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有安装微信，现在去安装" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
                
            }
        }
            break;
        default:
            break;
    }
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
