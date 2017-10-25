//
//  FinanceOderListViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/8/4.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "FinanceOderListViewController.h"
#import "FinanceIndexCell.h"
#import "SDAutoLayout.h"
#import <YYModel.h>
#import "ChooseTypeViewController.h"
#import "FinanceStepViewController.h"
#import "UIButton+BackgroundColor.h"

@interface FinanceOderListViewController ()<ChooseDelegate>
{
    UIView *_selLineView;
    UIView *_buttonViews;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataMutableArr;

@end

@implementation FinanceOderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([_state isEqualToString:@"0"]) {
        self.title = @"我的预约";
    }else{
        self.title = @"逾期预约";
    }
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadData];
    [self createViews];
}

- (void)createViews{
    //第三种方式（自定义按钮）
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 33, 32);
    [rightButton addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"finance_add"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    if (![_state isEqualToString:@"0"]) {
        _mainTableView.sd_layout.topSpaceToView(self.view,0);
        return;
    }
    
    _buttonViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    _buttonViews.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_buttonViews];
    
    NSArray *titleArr = @[@"全部预约",@"待办预约",@"已经取消",@"逾期预约"];
    
    CGFloat btnWith = (kScreenWidth-1.5)/4;
    _selLineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = Base_Orange;
        view;
    });
    _selLineView.frame = CGRectMake(0, 39, btnWith, 1);
    _selLineView.tag =10;
    [_buttonViews addSubview:_selLineView];
    
    for (int i=0; i<titleArr.count; i++) {
        NSString *title = titleArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:Color_Black forState:UIControlStateNormal];
        [btn setTitleColor:Base_Orange forState:UIControlStateSelected];
        btn.frame = CGRectMake(i*btnWith+0.5*i, 0, btnWith, 39);
        [btn setBackgroundColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateSelected];
        [btn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        btn.titleLabel.font = Title_Font;
        [_buttonViews addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(selBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            btn.selected = YES;
        }
    }
    
}

- (void)selBtnClick:(UIButton *)sender{
    for (UIButton *btn in _buttonViews.subviews) {
        if (btn.tag < 10) {
            btn.selected = NO;
        }
    }
    sender.selected = YES;
    CGFloat btnWith = (kScreenWidth-1.5)/4;
    NSArray *statusArr = @[@"0",@"6",@"4",@"5"];
    _selLineView.frame = CGRectMake(sender.left, 39, btnWith, 1);
    _state = statusArr[sender.tag];
    [self loadData];
}

- (void)loadData{
    //获取预约列表getAccountInfoByState
    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getAccountInfoByState",@"userid":[AppUserIndex GetInstance].accountId, @"state":_state} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _dataMutableArr = [NSMutableArray array];
        [self setEmptyView:_mainTableView withString:@"" withImageName:@"finance_xiao"];

        for (NSDictionary *dic in responseObject[@"data"]) {
            FinanceIndexModel *model = [[FinanceIndexModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_dataMutableArr addObject:model];
        }
        [ProgressHUD dismiss];
        [_mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];

    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    [self.mainTableView startAutoCellHeightWithCellClass:[RepairListTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    
    return self.dataMutableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"FinanceIndexCell";
    FinanceIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[FinanceIndexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataMutableArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
        return [self.mainTableView cellHeightForIndexPath:indexPath model:self.dataMutableArr[indexPath.row] keyPath:@"model" cellClass:[FinanceIndexCell class] contentViewWidth:kScreenWidth];
}

- (void)rightBtnClick:(UIButton *)sender{
    ChooseTypeViewController *vc = [[ChooseTypeViewController alloc] init];
    vc.chooseType = InvoiceYype;
    vc.ChooseDelegate = self;
    vc.navigationItem.title = @"选择预约报销类型";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ChooseDelegate
-(void)pushOrPopMethod:(UIViewController *)vc withDataDictionary:(NSDictionary *)dic{
    FinanceStepViewController *vc1 = [[FinanceStepViewController alloc] init];
    vc1.typeDic = dic;
    [vc.navigationController pushViewController:vc1 animated:YES];
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
