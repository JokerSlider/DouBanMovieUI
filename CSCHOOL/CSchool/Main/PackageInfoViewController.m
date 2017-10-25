//
//  PackageInfoViewController.m
//  CSchool
//
//  Created by mac on 16/8/24.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PackageInfoViewController.h"
#import "UIView+SDAutoLayout.h"
#import "UIButton+BackgroundColor.h"
#import "BenefitCell.h"
#import <YYModel.h>
#import "StandPrice.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "PayPackageCell.h"
#import "NoticeCell.h"
#import "PackageInfoCell.h"
#import "PackageModel.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "RxWebViewController.h"
#import "UILabel+stringFrame.h"
#import "PaySuccessViewController.h"
#import "ConfigObject.h"

@interface PackageInfoViewController ()<UITableViewDelegate,UITableViewDataSource,XGAlertViewDelegate>
@property (nonatomic,strong)UITableView *mainTableView;//tableview
@property (nonatomic,strong)NSMutableArray *keyNameArr;//标题的数组
@property (nonatomic,strong)NSMutableArray *imageArr;//存放图标的数据
@property (nonatomic,strong)NSMutableArray *nextSectionArr;
@property (nonatomic,strong)UIButton *payBtn;//支付按钮
@property(nonatomic,strong)NSIndexPath * currentSelectIndex;//记录选中的行
@property (nonatomic,strong)NSMutableArray *dataMutableArr;//存放model的数组
@property (nonatomic,strong)UIButton *checkBox;//选中框
@property (nonatomic,strong)NSMutableArray *originArr;//元数据

@property (nonatomic,strong)NSMutableArray *numArr;
@property(nonatomic,assign)int paySection;

@property (nonatomic, assign) BOOL canPay;
@property(nonatomic,assign)BOOL isWxPay;
@property (nonatomic,strong)NSArray *moneyArr;
@property (nonatomic,assign)NSInteger weixinNoticeNum;

@end

@implementation PackageInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    [self loadData];
    [self loadBaseData];
    if (_orderIdStr) {
        [self getCurrentTime];
    }
//    PaySuccessViewController *vc = [[PaySuccessViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    [self paySuccess];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
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
//        _currentTimeSec = [responseObject valueForKeyPath:@"data.currentServerTime"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}
//获取服务器数据
-(void)loadData{
    _dataMutableArr = [NSMutableArray array];
    _originArr = [NSMutableArray array];
    _numArr = [NSMutableArray array];
    AppUserIndex *user = [AppUserIndex GetInstance];
    [ProgressHUD show:@"正在加载..."];
    [NetworkCore requestPOST:user.API_URL parameters:@{@"rid":@"getMealDiscountInfo",@"meal":_orderStr} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        BOOL isDic =[responseObject[@"data"] isKindOfClass:[NSDictionary class]];
        //数组不全为空
        if (isDic) {
            PackageModel *model;
            _keyNameArr = [NSMutableArray arrayWithArray:@[@"套餐名:",@"时长:",@"",@""]];
            //判断是不是部分键不包含
            [_originArr addObject:responseObject[@"data"]];
            for (NSDictionary *dic in _originArr) {
                 model = [[PackageModel alloc] init];
                [model yy_modelSetWithDictionary:dic];
                [_dataMutableArr addObject:model];
            }
            [ProgressHUD dismiss];
            [_mainTableView reloadData];
        }
        //全为空  返回上个界面的数据  只展示套餐名和钱数
        else{
            _keyNameArr = [NSMutableArray arrayWithArray:@[@"套餐名:"]];
            [ProgressHUD dismiss];
            [_mainTableView reloadData];
        }
      
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
        _keyNameArr = [NSMutableArray arrayWithArray:@[@"套餐名:"]];
        [_mainTableView reloadData];
    }];

}
//加载基本数据
-(void)loadBaseData
{
    /**
     A：套餐名称，最多19个汉字
     B：有无优惠。无：0  有：1
     C：包月还是包学期。 包月：0  包学期：1
     D：价格，如一百元，则为100
     */
    NSIndexPath *indexp = [NSIndexPath indexPathForRow:1 inSection:1];
    _currentSelectIndex = indexp;
    _paySection = 1;
    _nextSectionArr = [NSMutableArray arrayWithArray:@[@"标准价格:",@"支付宝支付",@"微信支付"]];
    _imageArr = [NSMutableArray arrayWithArray:@[@"",@"zhi",@"wechat"]];
    _moneyArr = [NSArray array];
    _moneyArr = [_orderStr componentsSeparatedByString:@"|"];
    NSString *name =[NSString stringWithFormat:@"%@",_moneyArr[0]];
   
    NSString *price = [NSString stringWithFormat:@"%@",_moneyArr[3]];
    _moneyArr = @[name,price];
    [self.payBtn setTitle:[NSString stringWithFormat:@"确认支付￥%@",_moneyArr[1]] forState:UIControlStateNormal];
}
#pragma mark
-(void)createView
{
    
    self.title = @"套餐详情";
    self.mainTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.mainTableView.delegate =self;
    self.mainTableView.dataSource = self;
    self.mainTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    [self.view addSubview:self.mainTableView];

}
#pragma mark 私有方法
-(void)infoCheck:(UIButton *)sender
{
    sender.selected =!sender.selected;
}
-(void)alertShowWithTag:(int)tag{
    XGAlertView *alert  = [[XGAlertView alloc]initWithTarget:self withIdCode:@""];
    alert.tag = tag;
    [alert show];
}
- (void)alertView:(XGAlertView *)view didClickIdCode:(NSString *)idCode{
    switch (view.tag) {
        case 1:
        {
            //支付宝
            [self getStrForAlipay];
        }
            break;
        case 2:
        {
            //微信支付
            [self WxPay];
        }
            
        default:
            break;
    }
}

//点击确认支付
-(void)payActyion:(UIButton *)sender
{
    if (!self.checkBox.selected) {
        [ProgressHUD showError:@"请阅读并确认《购买协议》"];
        return;
    }
    
    switch (_paySection) {
        case -1:
        {
            [ProgressHUD showError:@"请选择支付方式"];
        }
            break;
        case 1:
        {
            [self alertShowWithTag:1];

        }
            break;
        case 2:
        {
            [self alertShowWithTag:2];
        }
            break;
            
        default:
        {
            [ProgressHUD showError:@"请选择支付方式"];
        }
            break;
    }
}
//协议
-(void)infoAction:(UIButton *)sender
{
    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showSchoolPortocol"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        RxWebViewController* vc = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:[responseObject valueForKeyPath:@"data.buy"]]];
        [self.navigationController pushViewController:vc animated:YES];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
    }];
    

}
-(void)alertNotice:(UIButton *)sender
{
    PackageModel *model = [[PackageModel alloc]init];
    model = _dataMutableArr[0];
    NSString *message = [NSString stringWithFormat:@"%@",model.discountExplain];
    XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:message WithCancelButtonTitle:@"确定" withOtherButton:nil];
    [alert show];
}
#pragma mark tabelviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
    return _keyNameArr.count;
    }
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //第一组
    if (indexPath.section==0) {
        //优惠说明
        if (indexPath.row==2) {
            static NSString *cellId = @"beneiCell";
            BenefitCell *cell = [[BenefitCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            if (!cell) {
                cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            }
            if (_dataMutableArr.count!=0) {
                cell.model = _dataMutableArr[0];
                if ([cell.model.discountExplain isEqual:[NSNull null]]||[cell.model.discountExplain isEqualToString:@""]) {
                    cell.hidden=YES;
                }else{
                    cell.hidden =NO;
                }
            }else{
                cell.hidden = NO;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        //  温馨提示
        else if(indexPath.row==3)
        {
            static NSString *cellId = @"NoticeCell";
            NoticeCell *cell = [[NoticeCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            if (!cell) {
                cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            }
            if (_dataMutableArr.count!=0) {
                cell.model = _dataMutableArr[0];
                //isEqualTo:[NSNull Null]
                if ([cell.model.remark isEqual:[NSNull null]] ||[cell.model.remark isEqualToString:@""]) {
                    cell.hidden=YES;
                }else{
                    cell.hidden=NO;
                }
            }else{
                cell.hidden = YES;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        //套餐名
        else{
        static NSString *cellID = @"packageCell";
        PackageInfoCell *cell = [[PackageInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        if (!cell) {
                cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            }
            cell.textLabel.numberOfLines = 0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nameLabel.text   =_keyNameArr[indexPath.row];
            if (_dataMutableArr.count!=0) {
                cell.model = _dataMutableArr[0];
                if ([cell.model.mealName isEqual:[NSNull null]]||cell.model.timelength==nil||[cell.model.mealName isEqualToString:@""]||[cell.model.timelength isEqualToString:@""]) {
                    cell.packageName.text = _moneyArr[indexPath.row];
                    if (indexPath.row==1) {
                        cell.hidden = YES;
                    }
                }else{
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObject:cell.model.mealName];
                [arr addObject:cell.model.timelength];
                cell.packageName.text = arr[indexPath.row];
                }
            }else{
                cell.packageName.text = _moneyArr[indexPath.row];
            }
            return cell;
        }
    }
    //第二组
    else{
        if (indexPath.row==0) {
            //标准价格
            static NSString *cellId = @"packageFirCell";
            StandPrice *cell = [[StandPrice alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            if (!cell) {
                cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            }
            if (_dataMutableArr.count!=0) {
                cell.model = _dataMutableArr[0];
                [cell.noticeV addTarget:self action:@selector(alertNotice:) forControlEvents:UIControlEventTouchUpInside];
                if ([cell.model.discountDes isEqual:[NSNull null]]||[cell.model.discountDes isEqualToString:@""]) {
                    cell.noticeV.hidden = YES;
                    cell.beniftTitle.hidden = YES;
                }
            }else{
                cell.noticeV.hidden = YES;
                cell.beniftTitle.hidden = YES;
            }
            cell.priceTitle.text = [NSString stringWithFormat:@"%@元",_moneyArr[1]];
            CGSize size=[cell.priceTitle boundingRectWithSize:CGSizeMake(0, 20)];
            cell.priceTitle .sd_layout.widthIs(size.width);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return  cell;
            }
        //支付宝支付  微信支付
        else{
            static NSString *cellId = @"packagePayCell";
            PayPackageCell *cell = [[PayPackageCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            if (!cell) {
                cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSString *imageName = [NSString stringWithFormat:@"%@",_imageArr[indexPath.row]];
            cell.PayImageV.image  =[UIImage imageNamed:imageName];
            cell.title.text = [NSString stringWithFormat:@"%@",_nextSectionArr[indexPath.row]];
            cell.SelectIconBtn.tag = indexPath.row;
            //默认支付宝
                if ([_currentSelectIndex isEqual:indexPath]) {//你选择的条件
                    cell.SelectIconBtn.selected = YES;
                    
                }else {
                    cell.SelectIconBtn.selected = NO;
                }
            if (_orderIdStr) {
                if (indexPath.row==2) {
                }
            }
            return cell;
            }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PackageModel *model = [[PackageModel alloc] init];
    if (_dataMutableArr.count!=0) {
        model = _dataMutableArr[0];
    }
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    if (indexPath.section==0) {
        if (_dataMutableArr.count==0) {
            return 60;
        }else {
            
            switch (indexPath.row) {
                case 1:
                {
                    if ([model.timelength isEqual:[NSNull null]]||[model.timelength isEqualToString:@""]) {
                        return 0;
                    }
                }
                    break;
                case 2:
                {
                    if ([model.discountExplain isEqual:[NSNull null]]||[model.discountExplain isEqualToString:@""]) {
                        return 0 ;
                    }
                    return [self.mainTableView cellHeightForIndexPath:indexPath model:_dataMutableArr[0] keyPath:@"model" cellClass:[BenefitCell class]contentViewWidth:kScreenWidth];
                }
                    break;
                case 3:
                {
                    if ([model.remark isEqual:[NSNull null]]||[model.remark isEqualToString:@""]) {
                        return 0 ;
                    }
                    return [self.mainTableView cellHeightForIndexPath:indexPath model:_dataMutableArr[0] keyPath:@"model" cellClass:[NoticeCell class]contentViewWidth:kScreenWidth];
                }
                    break;
                default:
                    break;
            }
        }
    }
    else if(indexPath.section==1){
          //重新支付时不出现微信支付
        if (_orderIdStr) {
            if (indexPath.row==2) {
                return 0;
            }else{
                return 60;
            }
        }
    }
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1&&indexPath.row!=0) {
        if (_currentSelectIndex!=nil&&_currentSelectIndex != indexPath) {
            PayPackageCell * cell = [tableView cellForRowAtIndexPath:_currentSelectIndex];
            [cell UpdateCellWithState:NO];
        }
        PayPackageCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell UpdateCellWithState:!cell.isSelected];
        _currentSelectIndex = indexPath;
        if (!cell.selected) {
            _paySection =-1 ;
        }else{
        //1 是支付宝   2  是微信支付
        _paySection =(int)_currentSelectIndex.row;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1) {
        return 100;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==1) {
        UIView *backView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
        self.payBtn = ({
            UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
            view.backgroundColor = Base_Orange;
            view.layer.cornerRadius = 5.0;
            [view setBackgroundColor:Color_Hilighted forState:UIControlStateHighlighted];
            [view setTitle:[NSString stringWithFormat:@"确认支付"] forState:UIControlStateNormal];
            [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [view addTarget:self action:@selector(payActyion:) forControlEvents:UIControlEventTouchUpInside];
            view;
        });
        self.checkBox = ({
            UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
            [view setTitle:@"我已阅读并同意" forState:UIControlStateNormal];
            [view setTitleColor:Color_Black forState:UIControlStateNormal];
            [view setImage:[UIImage imageNamed:@"unchose1"] forState:UIControlStateNormal];
            [view setImage:[UIImage imageNamed:@"chose1"] forState:UIControlStateSelected];
            [view addTarget:self action:@selector(infoCheck:) forControlEvents:UIControlEventTouchUpInside];
            view.titleLabel.font = Small_TitleFont;
            view.titleLabel.textAlignment = NSTextAlignmentRight;
            view.selected = YES;
            view;
        });
        UIButton *infoBtn = ({
            UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
            [view setTitle:@"《购买协议》" forState:UIControlStateNormal];
            [view setTitleColor:Base_Orange forState:UIControlStateNormal];
            [view setTitleColor:Base_Color3 forState:UIControlStateHighlighted];
            view.titleLabel.font = Small_TitleFont;
            [view addTarget:self action:@selector(infoAction:) forControlEvents:UIControlEventTouchUpInside];
            view;
        });
        [backView addSubview:self.payBtn];
        [backView addSubview:self.checkBox];
        [backView addSubview:infoBtn];
        backView.sd_layout.leftSpaceToView(self.mainTableView,0).rightSpaceToView(self.mainTableView,0).topSpaceToView(self.mainTableView,0).heightIs(100);
        self.checkBox.sd_layout.leftSpaceToView(backView,100).widthIs(100).heightIs(21).topSpaceToView(backView,20);
        infoBtn.sd_layout.leftSpaceToView(self.checkBox,-19).topEqualToView(self.checkBox).heightIs(21).widthIs(90);
        self.payBtn.sd_layout.leftSpaceToView(backView,8).rightSpaceToView(backView,8).heightIs(40).topSpaceToView(self.checkBox,10);
        [self.payBtn setTitle:[NSString stringWithFormat:@"确认支付￥%@",_moneyArr[1]] forState:UIControlStateNormal];
        return backView;
    }
    return nil;
}
//获支付宝支付
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
        [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getPayOrder",@"username":appuser.accountId,@"pkgName":_orderStr, @"clientPackagePeriod":_timeStr, @"phone":[ConfigObject shareConfig].phoneNum} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
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
//            XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"支付成功" withContent:@"请尽情享受网络世界" WithCancelButtonTitle:@"确定" withOtherButton:nil];
//            alert.tag = 101;
//            [alert show];
//            PaySuccessViewController *vc = [[PaySuccessViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [self paySuccess];
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
    if (_weixinNoticeNum==0) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(handlePayResult:) name:WX_PAY_RESULT object:nil];
        _weixinNoticeNum++;
    }
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
                                    @"clientPackagePeriod":_timeStr,
                                    @"phone":[ConfigObject shareConfig].phoneNum
                                    };
        [ProgressHUD show:nil];
        [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL  parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            
            NSMutableArray *stamp = [responseObject objectForKey:@"data"];
            NSDictionary *payDic = [NSMutableDictionary dictionary];
            for (NSDictionary *weixinDic in stamp) {
                payDic= weixinDic;
            }
            [ProgressHUD dismiss];
            [self WxPay:payDic[@"mch_id"] PrepayId:payDic[@"prepayid"] Package:@"Sign=WXPay" NonceStr:payDic[@"nonce_str"] TimeStamp:payDic[@"timestamp"] Sign:payDic[@"sign"]];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
//            [Progresshu]
            [ProgressHUD showError:@"网络出了点问题,请稍后再试。"];
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
        
//        XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"支付成功" withContent:@"请尽情享受网络世界" WithCancelButtonTitle:@"确定" withOtherButton:nil];
//        alert.tag = 101;
//        [alert show];
//        PaySuccessViewController *vc = [[PaySuccessViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
        [self paySuccess];
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

- (void)paySuccess{
    PaySuccessViewController *vc = [[PaySuccessViewController alloc] init];
    vc.orderStr = _orderStr;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
