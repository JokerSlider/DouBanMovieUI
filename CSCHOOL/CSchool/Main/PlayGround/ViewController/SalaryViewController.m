//
//  SalaryViewController.m
//  CSchool
//
//  Created by mac on 16/8/11.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "SalaryViewController.h"
#import "UIView+SDAutoLayout.h"
#import "ChooseTypeViewController.h"
#import "SalaryrqueryLoginViewController.h"
#import "SalaryQueryFundViewController.h"

#define pictureHeight 170  //图片高度
@interface SalaryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)UIImageView *headerImageV;
@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong,)NSArray *imageArr;
@property (nonatomic,strong,)NSMutableArray *titleValuesArr;

@property (nonatomic, strong) UIView *header;
@end

@implementation SalaryViewController
{
    UIImageView *_labelImageV;
    UIButton *_salaryQueryBtn;
    UIButton *_fundQueryBtn;
    UIView *_footBackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:[SalaryrqueryLoginViewController  class]]) {
            [marr removeObject:vc];
            break;
        }
    }
    self.hidesBottomBarWhenPushed = YES;
    self.navigationController.viewControllers = marr;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loaBaseData];
    [self createView];
    [self createNavButton];
}
-(void)loaBaseData
{
    _titleArray = [NSMutableArray array];
    _titleValuesArr = [NSMutableArray array];
    AppUserIndex *user = [AppUserIndex GetInstance];
    if (user.salaryUserInfoArr.count!=0) {
        _imageArr = @[@"SPersonName",@"positional",@"SPersonBound",@"bumen"];
        _titleArray = @[@"姓名:",@"职称:",@"已绑账号:",@"部门:"];
        [_titleValuesArr addObject:user.salaryUserInfoArr[0][@"value"]];
        [_titleValuesArr addObject:user.salaryUserInfoArr[2][@"value"]];
        [_titleValuesArr addObject:user.salaryUserName];
        [_titleValuesArr addObject:user.salaryUserInfoArr[1][@"value"]];
    }else{

    }
}
-(void)createView
{
    self.title = @"用户个人信息";
    //列表
    _mainTableView = ({
        UITableView *view = [UITableView new];
        view.delegate = self;
        view.dataSource = self;
        view;
    });
    //头视图
    _headerImageV = ({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        view.image =[UIImage imageNamed:@"SHeaderBack.jpg"];
        view;
    });
    //文字视图
    _labelImageV = ({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleToFill;
        view.image = [UIImage imageNamed:@"salaryPTitle"];
        view;
    });
    //公积金查询按钮
    
    _fundQueryBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.tag = 1000;
        view.backgroundColor = RGB(253, 220, 42);
        view.layer.cornerRadius = 5;
        [view setTitle:@"公积金查询" forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont fontWithName:@ "Arial Rounded MT Bold"  size:(16.0)];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    //工资查询按钮
    _salaryQueryBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.tag = 1001;
        view.backgroundColor = Base_Orange;
        view.layer.cornerRadius = 5;
        [view setTitle:@"工资查询" forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont fontWithName:@ "Arial Rounded MT Bold"  size:(16.0)];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    _footBackView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    
    _header = ({
        UIView *view = [UIView new];
        view;
    });
    [self.view addSubview:_mainTableView];
    [_header addSubview:_headerImageV];
    [_headerImageV addSubview:_labelImageV];
    [_footBackView addSubview:_fundQueryBtn];
    [_footBackView addSubview:_salaryQueryBtn];
   
    _header.frame = CGRectMake(0, 0, kScreenWidth, pictureHeight);
    _headerImageV.frame = _header.bounds;
    _footBackView.frame = CGRectMake(0, 0, kScreenWidth, LayoutHeightCGFloat(80));
    self.mainTableView.tableHeaderView = _header;
    self.mainTableView.tableFooterView = _footBackView;
    
    self.mainTableView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    _labelImageV.sd_layout.leftSpaceToView(_headerImageV,60).rightSpaceToView(_headerImageV,60).heightIs(50).topSpaceToView(_headerImageV,50);
    _fundQueryBtn.sd_layout.leftSpaceToView(_footBackView,18).topSpaceToView(_footBackView,35).heightIs(37).widthIs(LayoutWidthCGFloat(151));
    _salaryQueryBtn.sd_layout.leftSpaceToView(_fundQueryBtn,23).topEqualToView(_fundQueryBtn).heightIs(37).rightSpaceToView(_footBackView,18);
    
}
-(void)createNavButton
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag = 1002;
    rightBtn.frame = CGRectMake(0, 0, 80, 15);
    [rightBtn setTitle:@"切换绑定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:16.0];
    UIBarButtonItem *rigntItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rigntItem;
}
#pragma  mark  私有方法
-(void)btnAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 1000:
        {
            [self openFundVC];
        }
            break;
        case 1001:
        {
            [self openSalaryQuery];
        }
            break;
        case 1002:
        {
            [self openLoginVC];
        }
            break;

        default:
            break;
    }

}
//查询公积金
-(void)openFundVC
{
    SalaryQueryFundViewController *vc = [[SalaryQueryFundViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//查询工资
-(void)openSalaryQuery
{
    ChooseTypeViewController *vc = [[ChooseTypeViewController alloc]init];
    vc.chooseType = SalaryType;
    vc.title = @"工资详情";
    [self.navigationController pushViewController:vc animated:YES];
}
//重新登录
-(void)openLoginVC{
    AppUserIndex *user = [AppUserIndex GetInstance];
    user.salaryUserName = nil;
    user.salaryPWD = nil;
    [user saveToFile];
    SalaryrqueryLoginViewController *vc = [[SalaryrqueryLoginViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//解决分割线不到左边界的问题
-(void)viewDidLayoutSubviews {
    if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.mainTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma  mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"salaryPersonCell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:_imageArr[indexPath.row]];
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.detailTextLabel.text = _titleValuesArr[indexPath.row];
    cell.detailTextLabel.textColor = Color_Black;
    cell.textLabel.textColor = RGB(26, 26, 26);
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40 ;
}

#pragma mark scrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//    CGFloat Offset_y = scrollView.contentOffset.y;
//    if ( Offset_y < 0) {
//        CGFloat totalOffset = pictureHeight - Offset_y;
//        CGFloat scale = totalOffset / pictureHeight;
//        CGFloat width = kScreenWidth;
//        _headerImageV.frame = CGRectMake(-(width * scale - width) / 2, Offset_y, width * scale, totalOffset);
//    }
//}

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
