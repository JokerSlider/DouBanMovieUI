//
//  PayInfoViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/13.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "PayInfoViewController.h"
#import "NSDate+Extension.h"

@interface PayInfoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *contenrArr;
@end

@implementation PayInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"订单详情";

    _titleArr = @[@"订单编号",@"下单时间",@"带宽",@"金额",@"时长",@"支付方式"];
    
    NSDate *staDate = [NSDate dateWithTimeIntervalSince1970:[_orderStartTime doubleValue]];

    //修改时间为UTC
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *localDateString = [dateFormatter stringFromDate:staDate];
    
    _contenrArr = @[_orderId, localDateString, _orderBit, _orderFee, _orderTime, _orderPayStyle];
}

#pragma mark UITableviewDataSource
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@:  %@",titleStr,_contenrArr[indexPath.row]];
    if (indexPath.row == 0) {
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-95, 0, 90, 35)];
        if (_isSuccess) {
            statusLabel.text = @"交易成功";
        }else{
            statusLabel.text = @"交易关闭";
        }
        statusLabel.font = Title_Font;
        statusLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:statusLabel];
    }
    cell.clipsToBounds = YES;
    return cell;
}
#pragma mark UITableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2|| indexPath.row == 4) {
        return 0;
    }
    return 35;
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
