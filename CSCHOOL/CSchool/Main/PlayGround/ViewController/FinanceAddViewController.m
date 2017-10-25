//
//  FinanceAddViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/8/3.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "FinanceAddViewController.h"
#import "SDAutoLayout.h"
#import "FinanceTypeCell.h"
#import "UIButton+BackgroundColor.h"
#import "FinanceStepViewController.h"
#import "OrderTimeViewController.h"
#import "ChooseTypeViewController.h"

@interface FinanceAddViewController ()<UITableViewDelegate, UITableViewDataSource,ChooseDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) NSMutableArray *dataMulArray;
@property (nonatomic, assign) NSInteger totalTime; //总耗时
@property (nonatomic, assign) NSInteger totalNum;  //单据总数量
@end

@implementation FinanceAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"报销列表";
    [self createViews];
}

- (void)createViews{
    _mainTableView = ({
        UITableView *view = [[UITableView alloc] init];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        view.delegate = self;
        view.dataSource = self;
        view.tableFooterView = [UIView new];
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view;
    });
    [self.view addSubview:_mainTableView];
    
    UIView *bottomView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [self.view addSubview:bottomView];
    
    UIView *lineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        view;
    });
    
    UILabel *infoTitleLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.text = @"报销信息";
        view;
    });
    
    _infoLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.text = [NSString stringWithFormat:@"共%ld张票据，约耗时%ld分钟",_totalNum,_totalTime];
        view.font = Title_Font;
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:@"继续添加" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addButton.titleLabel.font = Title_Font;
    addButton.backgroundColor = RGB(255,224,52);
    [addButton setBackgroundColor:RGB(242,205,0) forState:UIControlStateHighlighted];
    [addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    addButton.sd_cornerRadius = @(5);
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"开始预约" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = Title_Font;
    nextButton.backgroundColor = Base_Orange;
    [nextButton setBackgroundColor:RGB(213,116,11) forState:UIControlStateHighlighted];
    nextButton.sd_cornerRadius = @(5);
    [nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView sd_addSubviews:@[lineView, infoTitleLabel, _infoLabel, addButton, nextButton]];
    
    _mainTableView.sd_layout
    .leftSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(bottomView,1);
    
    bottomView.sd_layout
    .leftEqualToView(_mainTableView)
    .rightEqualToView(_mainTableView)
    .bottomSpaceToView(self.view,0);
    
    lineView.sd_layout
    .leftSpaceToView(bottomView,0)
    .rightSpaceToView(bottomView,0)
    .topSpaceToView(bottomView,20)
    .heightIs(0.5);
    
    infoTitleLabel.sd_layout
    .leftSpaceToView(bottomView,40)
    .topSpaceToView(bottomView,5)
    .heightIs(30)
    .widthIs(200);
    
    _infoLabel.sd_layout
    .leftSpaceToView(bottomView,10)
    .topSpaceToView(infoTitleLabel,10)
    .widthIs(200)
    .heightIs(25);
    
    addButton.sd_layout
    .leftSpaceToView(bottomView,10)
    .topSpaceToView(_infoLabel,15)
    .widthIs(kScreenWidth/2-20)
    .heightIs(40);
    
    nextButton.sd_layout
    .rightSpaceToView(bottomView,10)
    .topSpaceToView(_infoLabel,15)
    .widthIs(kScreenWidth/2-20)
    .heightIs(40);
    
    [bottomView setupAutoHeightWithBottomView:nextButton bottomMargin:10];
    
}

- (void)addNewDataDic:(NSDictionary *)dic{
    _totalNum += [dic[@"RRNUMBER"] integerValue];

    _totalTime += [dic[@"RTPROCESSINGTIME"] integerValue]*[dic[@"RRNUMBER"] integerValue];
    
    _infoLabel.text = [NSString stringWithFormat:@"共%ld张票据，约耗时%ld分钟",_totalNum,_totalTime];
    if (!_dataMulArray) {
        _dataMulArray = [NSMutableArray arrayWithObject:dic];
    }else{
        [_dataMulArray addObject:dic];
    }
    
    [_mainTableView reloadData];
}

- (void)addDataWithArray:(NSArray *)array{
    if (!_dataMulArray) {
        _dataMulArray = [NSMutableArray arrayWithArray:array];
    }else{
        [_dataMulArray addObjectsFromArray:array];
    }
    for (NSDictionary *dic in array) {
        _totalNum += [dic[@"RRNUMBER"] integerValue];
        _totalTime += [dic[@"RTPROCESSINGTIME"] integerValue]*[dic[@"RRNUMBER"] integerValue];
    }
    _infoLabel.text = [NSString stringWithFormat:@"共%ld张票据，约耗时%ld分钟",_totalNum,_totalTime];
    [_mainTableView reloadData];
}

- (void)addButtonAction:(UIButton *)sender{
    ChooseTypeViewController *vc = [[ChooseTypeViewController alloc] init];
    vc.ChooseDelegate = self;
    vc.chooseType = InvoiceYype;
    vc.navigationItem.title = @"选择预约报销类型";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)nextButtonAction:(UIButton *)sender{
    if (_dataMulArray.count == 0) {
        [ProgressHUD showError:@"请先添加票据"];
        return;
    }
    
    //时间过长不予处理
    if (_totalTime > 120) {
        XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"当前票据数量过多，请到窗口进行办理。" WithCancelButtonTitle:@"确定" withOtherButton:nil];
        [alert show];
        return;
    }
    
    NSMutableString *addString = [NSMutableString string];
    for (NSDictionary *dic in _dataMulArray) {
        [addString appendString:[NSString stringWithFormat:@"%@,%@;",dic[@"RTID"],dic[@"RRNUMBER"]]];
    }
    NSString *standardInfo = [addString substringToIndex:[addString length] - 1];
    
    OrderTimeViewController *vc = [[OrderTimeViewController alloc] init];
    vc.totaltime = [NSString stringWithFormat:@"%ld",_totalTime];
    vc.standardInfo = standardInfo;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark UITableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataMulArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *indenty = @"FinanceTypeCell";
    
    FinanceTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:indenty];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FinanceTypeCell" owner:self options:nil] lastObject];
    }
    
    NSDictionary *dic = _dataMulArray[indexPath.row];
    cell.titleLabel.text = dic[@"RTNAME"];
    cell.subLabel.text = [NSString stringWithFormat:@"%@张",dic[@"RRNUMBER"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


//左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 从数据源中删除
    [_dataMulArray removeObjectAtIndex:indexPath.row];
    // 从列表中删除
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    _totalNum = 0;
    _totalTime = 0;
    for (NSDictionary *dic in _dataMulArray) {
        _totalNum += [dic[@"RRNUMBER"] integerValue];
        _totalTime += [dic[@"RTPROCESSINGTIME"] integerValue]*[dic[@"RRNUMBER"] integerValue];
    }
    _infoLabel.text = [NSString stringWithFormat:@"共%ld张票据，约耗时%ld分钟",_totalNum,_totalTime];
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
