//
//  HelpListViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/19.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "HelpListViewController.h"
#import "HelpListTableViewCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "HelpDetailViewController.h"

@interface HelpListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataMutableArr;
@end

@implementation HelpListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"帮助中心";
    [self loadData];
}

- (void)loadData{
    _dataMutableArr = [NSMutableArray array];
    for (int i= 0; i<10; i++) {
        HelpListModel *model = [[HelpListModel alloc] init];
        model.title = @"支付宝支付不了怎么办？";
        model.content = @"第一种情况是，当你在阿里巴巴代付交易付款时候，由于你没有安装支付宝的数字证书，没办法使用你支付宝的资金进行付款，这时你需要登录支付宝，找到“安全中心”进行数字证书申请。第一种情况是，当你在阿里巴巴代付交易付款时候，由于你没有安装支付宝的数字证书，没办法使用你支付宝的资金进行付款，这时你需要登录支付宝，找到“安全中心”进行数字证书申请。第一种情况是，当你在阿里巴巴代付交易付款时候，由于你没有安装支付宝的数字证书，没办法使用你支付宝的资金进行付款，这时你需要登录支付宝，找到“安全中心”进行数字证书申请。第一种情况是，当你在阿里巴巴代付交易付款时候，由于你没有安装支付宝的数字证书，没办法使用你支付宝的资金进行付款，这时你需要登录支付宝，找到“安全中心”进行数字证书申请。第一种情况是，当你在阿里巴巴代付交易付款时候，由于你没有安装支付宝的数字证书，没办法使用你支付宝的资金进行付款，这时你需要登录支付宝，找到“安全中心”进行数字证书申请。第一种情况是，当你在阿里巴巴代付交易付款时候，由于你没有安装支付宝的数字证书，没办法使用你支付宝的资金进行付款，这时你需要登录支付宝，找到“安全中心”进行数字证书申请。第一种情况是，当你在阿里巴巴代付交易付款时候，由于你没有安装支付宝的数字证书，没办法使用你支付宝的资金进行付款，这时你需要登录支付宝，找到“安全中心”进行数字证书申请。第一种情况是，当你在阿里巴巴代付交易付款时候，由于你没有安装支付宝的数字证书，没办法使用你支付宝的资金进行付款，这时你需要登录支付宝，找到“安全中心”进行数字证书申请。";
        [_dataMutableArr addObject:model];
    }
    
    [_mainTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    [self.mainTableView startAutoCellHeightWithCellClass:[HelpListTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    
    return self.dataMutableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"RepairListTableViewCell";
    HelpListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HelpListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataMutableArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
//    return [sef.mainTableView cellHeightForIndexPath:indexPath model:self.dataMutableArr[indexPath.row] keyPath:@"model"];
    return [self.mainTableView cellHeightForIndexPath:indexPath model:self.dataMutableArr[indexPath.row] keyPath:@"model" cellClass:[HelpListTableViewCell class] contentViewWidth:kScreenWidth];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpDetailViewController *vc = [[HelpDetailViewController alloc] init];
    vc.model = _dataMutableArr[indexPath.row];
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
