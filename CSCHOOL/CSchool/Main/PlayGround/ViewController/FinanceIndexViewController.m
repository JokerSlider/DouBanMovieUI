//
//  FinanceIndexViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/8/1.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "FinanceIndexViewController.h"
#import "SDAutoLayout.h"
#import "XGButton.h"
#import "FinanceIndexCell.h"
#import "FinanceStepViewController.h"
#import "FinanceOderListViewController.h"
#import <YYModel.h>
#import "ChooseTypeViewController.h"

@interface FinanceIndexViewController ()<ChooseDelegate>

{
    UIView *_headerView;
    UIView *_emptyView;
}
@property (nonatomic, strong) UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataMutableArr;
@end

@implementation FinanceIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = @"报销预约";
//    [self createHeaderView];
//    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createHeaderView];
    [self loadData];
}

//创建头视图
- (void)createHeaderView{
    _headerView = [[UIView alloc] init];
    _headerView.width = [UIScreen mainScreen].bounds.size.width;
    _headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //设置拉伸点
    UIImage *image2 = [UIImage imageNamed:@"finance_bg"];
    image2 = [image2 stretchableImageWithLeftCapWidth:0 topCapHeight:30];
    
    UIImageView *noticeView = [[UIImageView alloc] init];
    noticeView.backgroundColor = RGB(29, 154, 130);
    noticeView.image = image2;
    
    [_headerView addSubview:noticeView];
    
    _noticeLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:14];
        view.textColor = [UIColor whiteColor];
        view;
    });
    
    [noticeView addSubview:_noticeLabel];
    
    UIImageView *titleImage = ({
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [UIImage imageNamed:@"finance_biao"];
        view;
    });
    [noticeView addSubview:titleImage];
    
    UILabel *titleImageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleImageLabel.textAlignment = NSTextAlignmentCenter;
    titleImageLabel.textColor = [UIColor whiteColor];
    titleImageLabel.text = @"最新公告";
    titleImageLabel.font = [UIFont boldSystemFontOfSize:14];
    [titleImage addSubview:titleImageLabel];
    
    titleImage.sd_layout
    .topSpaceToView(noticeView,10)
    .leftSpaceToView(noticeView,10)
    .widthIs(100)
    .heightIs(30);
    
    noticeView.sd_layout
    .leftSpaceToView(_headerView,15)
    .rightSpaceToView(_headerView,15)
    .topSpaceToView(_headerView,10);
    
    _noticeLabel.sd_layout
    .leftSpaceToView(noticeView,10)
    .rightSpaceToView(noticeView,10)
    .topSpaceToView(noticeView,60)
    .autoHeightRatio(0);
    
    [noticeView setupAutoHeightWithBottomView:_noticeLabel bottomMargin:55];
    
    
    UIView *buttonViews = [[UIView alloc] init];
    buttonViews.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:buttonViews];
    
    NSArray *btnTitleArr = @[@"预约报销",@"我的预约",@"逾期预约"];
    NSArray *btnImageArr = @[@"finance_new",@"finance_mine",@"finance_yu"];
    CGFloat btnWith = (kScreenWidth - 20-5*4)/3;
    for (int i = 0; i<btnTitleArr.count; i++) {
        XGButton *btn = [[XGButton alloc] initWithFrame:CGRectMake(btnWith*i+5, 5, btnWith, 105) withStyle:XGButtonStyleUpDown];
        [btn setTitle:btnTitleArr[i] image:btnImageArr[i] withXGButtonState:XGButtonStateNomal];
        btn.tag = i;
        WEAKSELF;
        btn.xgButtonClick = ^(NSInteger buttonTag){
            [weakSelf openVC:buttonTag];
        };
        [buttonViews addSubview:btn];
    }
    
    buttonViews.sd_layout
    .leftEqualToView(noticeView)
    .rightEqualToView(noticeView)
    .topSpaceToView(noticeView,10)
    .heightIs(115);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"  待办预约";
    titleLabel.textColor = Color_Black;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:titleLabel];
    
    titleLabel.sd_layout
    .topSpaceToView(buttonViews,10)
    .rightEqualToView(noticeView)
    .leftEqualToView(noticeView)
    .heightIs(30);
    
    
    _emptyView = [[UIView alloc] init];
    _emptyView.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:_emptyView];
    UIImageView *emptyImageView = [[UIImageView alloc] init];
    emptyImageView.image = [UIImage imageNamed:@"finance_wu"];
    emptyImageView.contentMode = UIViewContentModeCenter;
    [_emptyView addSubview:emptyImageView];
    
    UILabel *emptyLabel = ({
        UILabel *view = [UILabel new];
        view.text = @"您近期还没有任何报销预约呢，快点击上方报销预约吧";
        view.textColor = Color_Black;
        view.font = Title_Font;
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });
    [_emptyView addSubview:emptyLabel];
    _emptyView.clipsToBounds = YES;
    
    _emptyView.sd_layout
    .topSpaceToView(titleLabel,5)
    .leftEqualToView(noticeView)
    .rightEqualToView(noticeView);
    
    emptyImageView.sd_layout
    .centerXEqualToView(_emptyView)
    .topSpaceToView(_emptyView,10)
    .widthIs(141)
    .heightIs(72);
    
    emptyLabel.sd_layout
    .topSpaceToView(emptyImageView,10)
    .leftSpaceToView(_emptyView,40)
    .rightSpaceToView(_emptyView,40)
    .autoHeightRatio(0);
    
    [_headerView setupAutoHeightWithBottomView:_emptyView bottomMargin:2];
    
}

- (void)showEmptyView{
    UIView *emptyView = [[UIView alloc] init];
    emptyView.backgroundColor = [UIColor whiteColor];
    [_mainTableView addSubview:emptyView];
    UIImageView *emptyImageView = [[UIImageView alloc] init];
    emptyImageView.image = [UIImage imageNamed:@"finance_wu"];
    emptyImageView.contentMode = UIViewContentModeScaleAspectFit;
    [emptyView addSubview:emptyImageView];
    
    emptyView.sd_layout
    .topSpaceToView(_headerView,5)
    .leftSpaceToView(self.view,10)
    .rightSpaceToView(self.view,10)
    .heightIs(150);
    
    emptyImageView.sd_layout
    .centerXEqualToView(emptyView)
    .centerYEqualToView(emptyView)
    .widthIs(200)
    .heightIs(100);
}

- (void)openVC:(NSInteger)index{
    switch (index) {
        case 0:
        {
            ChooseTypeViewController *vc = [[ChooseTypeViewController alloc] init];
            vc.chooseType = InvoiceYype;
            vc.ChooseDelegate = self;
            vc.navigationItem.title = @"选择预约报销类型";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            FinanceOderListViewController *vc = [[FinanceOderListViewController alloc] init];
            vc.state = @"0";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            FinanceOderListViewController *vc = [[FinanceOderListViewController alloc] init];
            vc.state = @"5";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
}

- (void)loadData{
    
    //获取通知
//    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showNoticeInfo"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"11");
        _noticeLabel.text = responseObject[@"data"][@"NICONTENT"];
        [_headerView layoutSubviews];
        _mainTableView.tableHeaderView = _headerView;
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];

    }];
    
    //获取预约列表getAccountInfoByState
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getAccountInfoByState",@"userid":[AppUserIndex GetInstance].accountId, @"state":@"6"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _dataMutableArr = [NSMutableArray array];
        NSArray *arr = responseObject[@"data"];
        for (NSDictionary *dic in arr) {
            FinanceIndexModel *model = [[FinanceIndexModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
//            [model modelSetDic:dic];
            [_dataMutableArr addObject:model];
        }
        if ([_dataMutableArr count]!=0) {
            _emptyView.sd_layout.heightIs(0);
        }else{
            _emptyView.sd_layout.heightIs(150);
        }
        [_headerView layoutSubviews];
        _mainTableView.tableHeaderView = _headerView;
        [_mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
