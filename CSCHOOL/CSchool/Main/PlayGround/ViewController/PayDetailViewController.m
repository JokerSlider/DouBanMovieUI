//
//  PayDetailViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/12.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "PayDetailViewController.h"
#import "MZTimerLabel.h"
#import "UIView+SDAutoLayout.h"
#import "SingleSelectView.h"
#import "XGAlertView.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "NetworkCore.h"

#import "WXApi.h"
#import <UIImageView+WebCache.h>
#import "PaySuccessViewController.h"

@implementation Product


@end

@interface PayDetailViewController ()<UITableViewDelegate, UITableViewDataSource,MZTimerLabelDelegate, SingSelectViewDelegate, XGAlertViewDelegate>
{
    MZTimerLabel *_timerMzLabel;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) SingleSelectView *payStyleView;
@property (nonatomic, strong) NSString *orderString;
@property (nonatomic, strong) NSArray *contentArr;

@property (nonatomic, copy) NSString *currentTimeSec;

@property (nonatomic, assign) BOOL canPay;

@property(nonatomic,assign)BOOL isWxPay;

@end

@implementation PayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"订单支付";
    [self UMengEvent:@"pay_detail"];

    if (_orderIdStr) {
        _titleArr = @[@"剩余时间:",@"订单编号",@"金额",@"带宽",@"时长",@"支付方式:"];
        _contentArr = @[@"",_orderIdStr,_priceStr,_bitStr,_timeStr,@""];
    }else{
        _titleArr = @[@"剩余时间:",@"金额",@"带宽",@"时长",@"支付方式:"];
        _contentArr = @[@"",_priceStr,_bitStr,_timeStr,@""];
    }
    
    if (_orderIdStr) {
        [self getCurrentTime];
    }else{
        [self initSubViews];
    }

}

- (void)getCurrentTime{
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getOrderById", @"orderId":_orderIdStr} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"data"][@"userOrderInfo"][@"orderFunction"]  isEqualToString:@"wxpay"]) {
            //订单的支付方式是微信支付
            _isWxPay=YES;
        }else{
            //订单的支付方式不是微信支付
            _isWxPay=NO;
            
        }

        if ([[responseObject valueForKeyPath:@"data.canPay"] isEqualToString:@"false"]) {
            _canPay = NO;
        }else{
            _canPay = YES;
        }
        _currentTimeSec = [responseObject valueForKeyPath:@"data.currentServerTime"];
        [self initSubViews];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}

- (void)initSubViews{
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = Title_Font;
    
    _timerMzLabel = [[MZTimerLabel alloc] initWithLabel:_timeLabel andTimerType:MZTimerLabelTypeTimer];
    if (_currentTimeSec) {
        NSTimeInterval sec = [_orderOutDateTime doubleValue]-[_currentTimeSec doubleValue];
        [_timerMzLabel setCountDownTime:sec];
    }else{
        [_timerMzLabel setCountDownTime:3600*24*1];
    }
    _timerMzLabel.delegate = self;
    [_timerMzLabel start];
    
    _payStyleView = [[SingleSelectView alloc] init];
    _payStyleView.delegate = self;
    _payButton.userInteractionEnabled = NO;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    _payButton = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeSystem];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view setTitle:@"下一步" forState:UIControlStateNormal];
        [view setBackgroundColor:Base_Color3];
        [view addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
        view.layer.cornerRadius = 5;
        view.userInteractionEnabled = NO;
        view;
    });
    [footerView addSubview:_payButton];
    _payButton.sd_layout
    .centerXEqualToView(footerView)
    .centerYEqualToView(footerView)
    .widthRatioToView(_mainTableView,0.8)
    .heightIs(40);
    
    _mainTableView.tableFooterView = footerView;
    [_mainTableView reloadData];
}

- (void)nextAction:(UIButton *)sender{
    
    XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withIdCode:@""];
    [alert show];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_titleArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *titleStr = _titleArr[indexPath.row];
    cell.textLabel.font = Title_Font;
    
    if (indexPath.row ==0) {
        cell.textLabel.text = titleStr;
        _timeLabel.frame = CGRectMake(80, 0, 200, 30);
        [cell.contentView addSubview:_timeLabel];
    }else if (indexPath.row==_titleArr.count-1){
        cell.textLabel.text = titleStr;
        _payStyleView.frame = CGRectMake(100, 0, 200, 30);
        if (_waitPayString) {
            if (_isWxPay) {
                _payStyleView.titleArr = @[@"微信"];
                
            }else{
                _payStyleView.titleArr = @[@"支付宝"];
            }
        }
        else{
            _payStyleView.titleArr = @[@"支付宝",@"微信"];
            
        }
        
        [cell.contentView addSubview:_payStyleView];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@:     %@",titleStr,_contentArr[indexPath.row]];
    }
    cell.clipsToBounds = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_orderIdStr && (indexPath.row == 3 || indexPath.row == 4)) {
        return 0;
    }else if(!_orderIdStr && (indexPath.row == 3 || indexPath.row == 2)){
        return 0;
    }
    return 30;
}


- (NSString*)timerLabel:(MZTimerLabel *)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time
{
    if([timerLabel isEqual:_timerMzLabel]){
//        int second = (int)time  % 60;
        int minute = ((int)time / 60) % 60;
        int hours = time / 3600;
        return [NSString stringWithFormat:@"%02d小时 %02d分",hours,minute];
        //[NSString stringWithFormat:@"%02d小时 %02d分 %02ds",hours,minute,second]
    }
    else
        return nil;
}

- (void)selectView:(SingleSelectView *)view didSelectAtIndex:(NSInteger)index{
    _payButton.backgroundColor = Base_Orange;
    _payButton.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(XGAlertView *)view didClickIdCode:(NSString *)idCode{
    if([_payStyleView getSelectIndex] == 0 ){
        //再次支付的时候  若是微信支付则走微信支付
        if (_isWxPay) {
            [self WxPay];
        }
        else{
            [self getStrForAlipay];
        }
    }else
    {
        [self WxPay];
        
    }
}

- (void)getStrForAlipay{
    //如果有支付宝支付字符串
    if (_waitPayString) {
        if (_canPay) {
            [self alipay:_waitPayString];
        }else{
            [ProgressHUD showError:@"订单失效"];
        }
    }else{
    
        AppUserIndex *appuser = [AppUserIndex GetInstance];
        [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getPayOrder",@"username":appuser.accountId,@"pkgName":_orderStr, @"clientPackagePeriod":_timeStr} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            
            NSString *payString = [[responseObject objectForKey:@"data"] stringByReplacingOccurrencesOfString:@"\\" withString:@""];//[responseObject objectForKey:@"alipayString"];
            [self alipay:payString];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            [ProgressHUD showError:[error objectForKey:@"msg"]];
        }];
    }

}
/**
 *  支付宝回调方法
 *
 *  @param payString 支付宝支付串
 */
- (void)alipay:(NSString *)payString{
    [[AlipaySDK defaultService] payOrder:payString fromScheme:@"cschoolpay" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
            XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"支付成功" withContent:@"请尽情享受网络世界" WithCancelButtonTitle:@"确定" withOtherButton:nil];
            alert.tag = 101;
            [alert show];
        }else{
            XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"支付失败" withContent:[resultDic objectForKey:@"memo"] WithCancelButtonTitle:@"确定" withOtherButton:nil];
            alert.tag = 102;
            [alert show];
        }
    }];

}

//微信支付
- (void)WxPay{
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handlePayResult:) name:WX_PAY_RESULT object:nil];

    //是否已经生成订单
    if (_waitPayString) {
        if (_canPay) {
            NSData *data = [_waitPayString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            [self WxPay:dic[@"mch_id"] PrepayId:dic[@"prepayid"] Package:@"Sign=WXPay" NonceStr:dic[@"nonce_str"] TimeStamp:dic[@"timestamp"] Sign:dic[@"sign"]];
            
        }else{
            [ProgressHUD showError:@"订单失效"];
        }
    }else{

        NSDictionary *commitDic = @{
                                    @"rid":@"getWxPayOrder",
                                    @"username": [AppUserIndex GetInstance].accountId,
                                    @"pkgName": _orderStr,
                                    @"schoolCode": [AppUserIndex GetInstance].schoolCode,
                                    @"clientIp":[NetworkCore getIPAddress],
                                    @"clientPackagePeriod":_timeStr
                                    };
        [ProgressHUD show:nil];
        [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            
            NSMutableArray *stamp = [responseObject objectForKey:@"data"];
            NSDictionary *payDic = [NSMutableDictionary dictionary];
            for (NSDictionary *weixinDic in stamp) {
                payDic= weixinDic;
            }
            [ProgressHUD dismiss];
            [self WxPay:payDic[@"mch_id"] PrepayId:payDic[@"prepayid"] Package:@"Sign=WXPay" NonceStr:payDic[@"nonce_str"] TimeStamp:payDic[@"timestamp"] Sign:payDic[@"sign"]];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            ;
        }];

    }

}

//调起微信支付
-(void)WxPay:(NSString *)partnerId PrepayId:(NSString *)prepayId Package:(NSString *)package NonceStr:(NSString *)nonceStr TimeStamp:(NSString *)timeStamp Sign:(NSString *)sign {
    
        PayReq *request = [[PayReq alloc] init];
        request.partnerId =partnerId;
        request.prepayId=prepayId;
        request.package =package;
        request.nonceStr= nonceStr;
        request.timeStamp= [timeStamp intValue];
        request.sign= sign;
        //监测是否安装微信
        if ([WXApi isWXAppInstalled]) {
            //监测当前微信版本是否支持
            if ([WXApi isWXAppSupportApi]) {
                [WXApi sendReq:request];
            
            }else{
                XGAlertView *supportAlert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:@"当前微信版本较低，请升级后使用!" WithCancelButtonTitle:@"确定" withOtherButton:nil];
                [supportAlert show];
            }
            
        }else{
            XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:@"您尚未安装微信，请安装微信后重试!" WithCancelButtonTitle:@"确定" withOtherButton:nil];
            
            [alert show];
        }
    
}

//微信支付返回结果处理
- (void)handlePayResult:(NSNotification *)noti{
    
    if ([noti.object isEqualToString:@"成功"]) {
        
        XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"支付成功" withContent:@"请尽情享受网络世界" WithCancelButtonTitle:@"确定" withOtherButton:nil];
        alert.tag = 101;
        [alert show];
        
    }
    else
    {
        XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"支付失败" withContent:nil WithCancelButtonTitle:@"确定" withOtherButton:nil];
        alert.tag = 102;
        [alert show];
        
    }
    //上边添加了监听，这里记得移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"weixin_pay_result" object:nil];
}


- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title{
    if (view.tag == 101) {
        NSArray *vcArr = self.navigationController.viewControllers;
        for (NSInteger i=vcArr.count-1; i>-1; i--) {
            if (i==vcArr.count-3) {
                UIViewController *vc = vcArr[i];
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }else if (view.tag == 102){
    
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
