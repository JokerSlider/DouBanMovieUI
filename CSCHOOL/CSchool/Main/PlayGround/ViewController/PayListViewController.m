//
//  PayListViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/13.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "PayListViewController.h"
#import "UIView+SDAutoLayout.h"
#import "PayListTableViewCell.h"
#import "PayInfoViewController.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "PayDetailViewController.h"
#import <MJRefresh.h>
#import <YYModel.h>
#import "PackageInfoViewController.h"

@interface PayListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic)  UIButton *allBtn;
@property (strong, nonatomic)  UIButton *watingBtn;
@property (strong, nonatomic)  UIButton *sucessBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataMutableArr;
@property (nonatomic, copy) NSString *orderOder; //10000：未支付，未超时 20000：未支付，已超时 30000：已支付  100000：全部

@property(nonatomic,strong)PayListModel *Detailmodel;
@end

@implementation PayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的订单";
    [self UMengEvent:@"pay_list"];

    _orderOder = @"100000";
    [self initSubViews];
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [_mainTableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setEmptyView:_mainTableView withString:@"暂无订单" withImageName:@""];
}

- (void)initSubViews{
    
    _allBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"全部" forState:UIControlStateNormal];
        [view setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [view setTitleColor:Base_Orange forState:UIControlStateSelected];
        view.titleLabel.font = Title_Font;
        [view addTarget:self action:@selector(allBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    _watingBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"待付款" forState:UIControlStateNormal];
        [view setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [view setTitleColor:Base_Orange forState:UIControlStateSelected];
        view.titleLabel.font = Title_Font;
        [view addTarget:self action:@selector(waitingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    _sucessBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"交易成功" forState:UIControlStateNormal];
        [view setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [view setTitleColor:Base_Orange forState:UIControlStateSelected];
        view.titleLabel.font = Title_Font;
        [view addTarget:self action:@selector(sucessBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    [_buttonView addSubview:_allBtn];
    [_buttonView addSubview:_watingBtn];
    [_buttonView addSubview:_sucessBtn];
    
    _allBtn.sd_layout
    .leftSpaceToView(_buttonView,0)
    .heightRatioToView(_buttonView,1)
    .widthIs(kScreenWidth/3)
    .topSpaceToView(_buttonView,0);
    
    _allBtn.selected = YES;
    _allBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _watingBtn.sd_layout
    .leftSpaceToView(_allBtn,0)
    .heightRatioToView(_allBtn,1)
    .widthRatioToView(_allBtn,1)
    .topEqualToView(_allBtn);
    
    _sucessBtn.sd_layout
    .leftSpaceToView(_watingBtn,0)
    .heightRatioToView(_allBtn,1)
    .widthRatioToView(_allBtn,1)
    .topEqualToView(_allBtn);
}

- (void)loadData{
    AppUserIndex *user = [AppUserIndex GetInstance];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getUserOrderInfo", @"username":user.accountId, @"type":_orderOder} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        _dataMutableArr = [NSMutableArray array];
        for (NSDictionary *dic in [responseObject valueForKeyPath:@"data.userOrderInfo"]) {
            PayListModel *model = [[PayListModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_dataMutableArr addObject:model];
        }
        [_mainTableView reloadData];
        [_mainTableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [_mainTableView.mj_header endRefreshing];
        [self showErrorViewLoadAgain:error[@"msg"]];

    }];
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    [self.mainTableView startAutoCellHeightWithCellClass:[PayListTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    
    return self.dataMutableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"PayListTableViewCell";
    PayListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[PayListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PayListModel *model = self.dataMutableArr[indexPath.row];
    if ([_orderOder isEqualToString:@"10000"]) {
        model.payStatus = PayWaiting;
    }else if ([_orderOder isEqualToString:@"30000"]){
        model.payStatus = PaySucess;
    }
    
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
//    return [self.mainTableView cellHeightForIndexPath:indexPath model:self.dataMutableArr[indexPath.row] keyPath:@"model"];
    return [self.mainTableView cellHeightForIndexPath:indexPath model:self.dataMutableArr[indexPath.row] keyPath:@"model" cellClass:[PayListTableViewCell class] contentViewWidth:kScreenWidth];

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _Detailmodel = self.dataMutableArr[indexPath.row];
    [self userOrderDetailInfo];
    
}
//用户详细信息界面
-(void)userOrderDetailInfo
{
    if (!_Detailmodel.orderClientPackagePeriod) {
        _Detailmodel.orderClientPackagePeriod = @"";
    }
    switch (_Detailmodel.payStatus) {
        case PaySucess:
        {
            NSLog(@"%@",_Detailmodel.orderFunction);
            PayInfoViewController *vc = [[PayInfoViewController alloc] init];
            vc.orderId = _Detailmodel.orderId;
            vc.orderStartTime = _Detailmodel.orderCreateTime;
            vc.orderFee = _Detailmodel.orderFee;
            vc.orderTime =  _Detailmodel.orderClientPackagePeriod;
            vc.orderBit = _Detailmodel.payBit;
            vc.isSuccess = YES;
            if (_Detailmodel.orderPayString) {
                if ([_Detailmodel.orderFunction isEqualToString:@"wxpay"]) {
                    vc.orderPayStyle = @"微信";

                }else if([_Detailmodel.orderFunction isEqualToString:@"alipay"])
                {
                    vc.orderPayStyle = @"支付宝";
                }
                
            }
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case PayWaiting:
        {
//            PayDetailViewController *vc = [[PayDetailViewController alloc] init];
//            vc.timeStr = _Detailmodel.orderClientPackagePeriod;
//            vc.priceStr = _Detailmodel.orderFee;
//            vc.bitStr = _Detailmodel.payBit;
//            vc.orderIdStr = _Detailmodel.orderId;
//            vc.waitPayString = _Detailmodel.orderPayString;
//            vc.orderOutDateTime = [NSString stringWithFormat:@"%@",_Detailmodel.orderOutdateTime];
//            [self.navigationController pushViewController:vc animated:YES];
            
            PackageInfoViewController *vc = [[PackageInfoViewController alloc] init];
            vc.orderIdStr = _Detailmodel.orderId;
            vc.waitPayString = _Detailmodel.orderPayString;
            vc.timeStr = _Detailmodel.orderClientPackagePeriod;
            vc.orderStr = _Detailmodel.orderPackageName;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case PayCancel:
        {
            PayInfoViewController *vc = [[PayInfoViewController alloc] init];
            vc.orderId = _Detailmodel.orderId;
            vc.orderStartTime =_Detailmodel.orderCreateTime;
            vc.orderFee = _Detailmodel.orderFee;
            vc.orderTime = _Detailmodel.orderClientPackagePeriod;
            vc.orderBit = _Detailmodel.payBit;
            if (_Detailmodel.orderPayString) {
                if ([_Detailmodel.orderFunction isEqualToString:@"wxpay"]) {
                    vc.orderPayStyle = @"微信";
                    
                }else if([_Detailmodel.orderFunction isEqualToString:@"alipay"])
                {
                    vc.orderPayStyle = @"支付宝";
                }
                
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }

}



- (void)allBtnAction:(UIButton *)sender {
    _orderOder = @"100000";
    sender.selected = YES;
    sender.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _watingBtn.selected = NO;
    _watingBtn.backgroundColor = [UIColor whiteColor];
    _sucessBtn.selected = NO;
    _sucessBtn.backgroundColor = [UIColor whiteColor];
    [_mainTableView.mj_header beginRefreshing];
}
- (void)waitingBtnAction:(UIButton *)sender {
    _orderOder = @"10000";
    sender.selected = YES;
    sender.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _allBtn.selected = NO;
    _allBtn.backgroundColor = [UIColor whiteColor];
    _sucessBtn.selected = NO;
    _sucessBtn.backgroundColor = [UIColor whiteColor];
    [_mainTableView.mj_header beginRefreshing];
}
- (void)sucessBtnAction:(UIButton *)sender {
    _orderOder = @"30000";
    sender.selected = YES;
    sender.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _allBtn.selected = NO;
    _allBtn.backgroundColor = [UIColor whiteColor];
    _watingBtn.selected = NO;
    _watingBtn.backgroundColor = [UIColor whiteColor];
    [_mainTableView.mj_header beginRefreshing];
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
