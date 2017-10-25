//
//  OneCardViewController.m
//  CSchool
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "OneCardViewController.h"
#import "UIView+SDAutoLayout.h"
#import "AboutUsViewController.h"
@interface OneCardViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
//余额
@property (nonatomic, strong)UILabel *balanceLabel;
@end

@implementation OneCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CreateView];
    [self loadData];
}
-(void)loadData
{
    AppUserIndex *user = [AppUserIndex GetInstance];
    [NetworkCore requestPOST:user.API_URL parameters:@{@"rid":@"oneCardPass",@"stuNo":[AppUserIndex GetInstance].accountId} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        float moneyNum = 0.0;
        //GSZT 挂失状态（0正常，1挂失）
        for (NSDictionary *dic in responseObject[@"data"]) {
            NSString *money = [NSString stringWithFormat:@"%@",dic[@"KYE"]];
            moneyNum = [money floatValue]/100;
        }
        self.balanceLabel.text = [NSString stringWithFormat:@"%0.2f",moneyNum];
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:@"点击重新加载..."];
    }];

}
-(void)CreateView
{
    self.title = @"一卡通查询";
    self.view.backgroundColor = Base_Color2;
    UILabel *noticeL = ({
        UILabel *view = [UILabel new];
        view.text = @"本数据仅供参考,实际金额请查询官方数据";
        view.font =[UIFont fontWithName:@"Arial-BoldMT" size:14.0f];
        view.textAlignment = NSTextAlignmentCenter;
        view.textColor = Base_Orange;
        view.backgroundColor =RGB(254, 234, 197);
        view;
    });
    UIView *backView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    UIImageView *imageV = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"wallet_ico"];
        view;
    });
    //当前余额(元)
    UILabel *nowMoneyLabel=({
        UILabel *view = [UILabel new];
        view.text=@"当前余额(元)";
        view.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
        view.textColor = Color_Black;
        view;
    });
    self.balanceLabel =({
        UILabel *view = [UILabel new];
        view.font = [UIFont fontWithName:@"Arial-BoldMT" size:50.0f];
        view.text = @"正在加载...";
        view.textAlignment = NSTextAlignmentCenter;
        view.textColor = Base_Orange;
        view;
    });
    self.tableView = ({
        UITableView *view = [UITableView new];
        view.delegate = self;
        view.dataSource = self;
        view;
    });
    [self.view addSubview:noticeL];
    [self.view addSubview:self.tableView];
//    [self.view addSubview:backView];
    [backView addSubview:imageV];
    [backView addSubview:nowMoneyLabel];
    [backView addSubview:self.balanceLabel];
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    self.tableView.tableFooterView = [UIView new];
    noticeL.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(50).topSpaceToView(self.view,0);
    backView.sd_layout.leftSpaceToView(self.tableView,0).rightSpaceToView(self.tableView,0).topSpaceToView(self.tableView,0).heightIs(204);
    imageV.sd_layout.leftSpaceToView(backView,10).topSpaceToView(backView,10).widthIs(20).heightIs(20);
    nowMoneyLabel.sd_layout.leftSpaceToView(imageV,0).topEqualToView(imageV).widthIs(110).heightIs(20);
    self.balanceLabel.sd_layout.topSpaceToView(backView,100).leftSpaceToView(backView,0).rightSpaceToView(backView,0).heightIs(50);
    self.tableView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(noticeL,0).bottomSpaceToView(self.view,0);
    self.tableView.tableHeaderView = backView;
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  *idenfiter = @"oneCardCell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenfiter];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:idenfiter];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 0:
        {
            cell.imageView.image = [UIImage imageNamed:@"WXPay"];
            cell.textLabel.text =@"微信一卡通充值说明";
        }
            break;
        case 1:
        {
            cell.imageView.image = [UIImage imageNamed:@"AliPay"];
            cell.textLabel.text= @"支付宝一卡通充值说明";
        }
            break;
            
        default:
            break;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 5;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *urlArr = @[ WEB_URL_HELP(@"wxpayhelp.html"), WEB_URL_HELP(@"alipayhelp.html")];
    
    AboutUsViewController *about = [[AboutUsViewController alloc]init];
    about.baseUrl =urlArr[indexPath.row];
    [self.navigationController pushViewController:about animated:YES];
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
