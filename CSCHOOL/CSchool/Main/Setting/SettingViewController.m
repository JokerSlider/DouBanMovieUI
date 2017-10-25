//
//  SettingViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/6.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "SettingViewController.h"
#import "QuestionListViewController.h"
#import "RepairListViewController.h"
#import "XGAlertView.h"
#import "PayListViewController.h"
#import "PayListViewController.h"
#import "UIView+SDAutoLayout.h"
#import <YYText.h>
#import "HelpListViewController.h"
#import "PaySelectViewController.h"
#import "PlayGroundViewController.h"
#import "LoginoneViewController.h"
#import "AppDelegate.h"
#import "AboutUsViewController.h"
#import "ChangePassWordViewController.h"
#import "RxWebViewController.h"
#import "SuggesstionViewController.h"


@class testModel,Basic,Update,Daily_Forecast,Cond,Wind,Tmp,Astro;
@interface SettingViewController ()<XGAlertViewDelegate, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate>
{
    UILabel *updateView;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *imageArr;
@end

@implementation SettingViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = Base_Color2;
    self.navigationController.delegate =self;
    _titleArr = @[@"我的订单",@"我的报修",@"修改密码",@"使用帮助",@"关于本软件",@"软件升级",@"意见与反馈",@"退出登录"];
    _imageArr = @[@"set_pay",@"set_repair",@"changePWD",@"set_help",@"set_about",@"set_update",@"suggestion",@"set_logout"];
    [self createTableHeaderView];
    _mainTableView.tableFooterView = [[UIView alloc] init];
    _mainTableView.backgroundColor =Base_Color2;
    [_mainTableView reloadData];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [ProgressHUD dismiss];
}
- (void)setIsUpdate:(BOOL)isUpdate{
    _isUpdate = isUpdate;
    updateView.hidden = !isUpdate;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    [_mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)createTableHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = Title_Font;
    titleLabel.text = @"账户信息";
    
    UILabel *schoolLabel = [[UILabel alloc] init];
    schoolLabel.font = Title_Font;
    schoolLabel.textColor = [UIColor grayColor];
    AppUserIndex *school = [AppUserIndex GetInstance];
    schoolLabel.text = [NSString stringWithFormat:@"我的学校：%@",school.schoolName];
    
    UILabel *studentIdLabel = [[UILabel alloc] init];
    studentIdLabel.font = Title_Font;
    studentIdLabel.textColor = [UIColor grayColor];
    studentIdLabel.text = [NSString stringWithFormat:@"账户：       %@",school.userName];
    
    YYLabel *kaitongLabel = [[YYLabel alloc] init];
    kaitongLabel.textColor = [UIColor grayColor];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"您还没有开通上网套餐，请 开通"];
    NSRange range = [@"您还没有开通上网套餐，请 开通" rangeOfString:@" 开通"];
    WEAKSELF;
    [text yy_setTextHighlightRange:range
                             color:Title_Color1
                   backgroundColor:[UIColor groupTableViewBackgroundColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                             [weakSelf openPaySelect];
                         }];
    kaitongLabel.attributedText = text;
    
    UILabel *mealInfo = [[UILabel alloc] init];
    mealInfo.font = Title_Font;
    mealInfo.textColor = [UIColor grayColor];
    NSArray *arr = [school.packageName componentsSeparatedByString:@"|"];
//    mealInfo.text = [NSString stringWithFormat:@"套餐类型：%@",arr[0]];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = Title_Font;
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.text = [NSString stringWithFormat:@"到期时间：%@",school.termBillingTime];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [addBtn setTitle:@"续费" forState:UIControlStateNormal];
    [addBtn setTitleColor:Title_Color1 forState:UIControlStateNormal];
    addBtn.titleLabel.font = Title_Font;
    [addBtn addTarget:self action:@selector(openPaySelect) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:titleLabel];
    [headerView addSubview:schoolLabel];
    [headerView addSubview:studentIdLabel];
    [headerView addSubview:mealInfo];
    [headerView addSubview:kaitongLabel];
    [headerView addSubview:timeLabel];
    [headerView addSubview:addBtn];
    
//    if ([[AppUserIndex GetInstance].role_type isEqualToString:@"1"]) {
//    }
    addBtn.hidden = YES;

    CGFloat topSpace = 5;
    
    titleLabel.sd_layout
    .leftSpaceToView(headerView,10)
    .rightSpaceToView(headerView,10)
    .topSpaceToView(headerView,40)
    .heightIs(25);
    
    schoolLabel.sd_layout
    .leftEqualToView(titleLabel)
    .rightEqualToView(titleLabel)
    .topSpaceToView(titleLabel,topSpace)
    .heightRatioToView(titleLabel,1);
    
    studentIdLabel.sd_layout
    .leftEqualToView(titleLabel)
    .rightEqualToView(titleLabel)
    .topSpaceToView(schoolLabel,topSpace)
    .heightRatioToView(titleLabel,1);
    
    
    kaitongLabel.sd_layout
    .leftEqualToView(titleLabel)
    .rightEqualToView(titleLabel)
    .topSpaceToView(studentIdLabel,topSpace)
    .heightRatioToView(titleLabel,1);
    
    mealInfo.sd_layout
    .leftEqualToView(titleLabel)
    .rightEqualToView(titleLabel)
    .topSpaceToView(studentIdLabel,topSpace)
    .heightRatioToView(titleLabel,1);
    
//    timeLabel.sd_layout
//    .leftEqualToView(titleLabel)
//    .rightEqualToView(titleLabel)
//    .topSpaceToView(mealInfo,topSpace)
//    .heightRatioToView(titleLabel,1);
    
    addBtn.sd_layout
    .rightSpaceToView(headerView,10)
    .topEqualToView(mealInfo)
    .widthIs(50)
    .heightRatioToView(mealInfo,1);
    
    kaitongLabel.hidden = YES;
    _mainTableView.tableHeaderView = headerView;
}


- (void)openPaySelect{
    PaySelectViewController *vc = [[PaySelectViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"cell";
    
    //询问talbeView是否有闲置的单元格对象
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
    if (cell == nil) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if (indexPath.row != 5) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
    
        updateView = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-45, 15, 35, 20)];
        updateView.backgroundColor = [UIColor redColor];
        updateView.text = @"升级";
        updateView.textAlignment = NSTextAlignmentCenter;
        updateView.font = Title_Font;
        updateView.textColor = [UIColor whiteColor];
        updateView.layer.cornerRadius = 7;
        updateView.clipsToBounds = YES;
        updateView.hidden = !_isUpdate;
        [cell.contentView addSubview:updateView];
    }
    
    cell.imageView.backgroundColor = [UIColor redColor];
    cell.backgroundColor = Base_Color2;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:_imageArr[indexPath.row]];
    imageView.frame = CGRectMake(10, 6, 36, 36);
    [cell.contentView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(60, 10, 200, 30);
    titleLabel.text = _titleArr[indexPath.row];
    [cell.contentView addSubview:titleLabel];
    cell.clipsToBounds = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 1) {
//        return 0;
//    }
    if ([[AppUserIndex GetInstance].role_type isEqualToString:@"1"] && indexPath.row == 0) {
        return 0;
    }
    if (indexPath.row == 2) {
        if (![AppUserIndex GetInstance].canModifyPassword) {
            return 0;
        }
    }
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
        {
            PayListViewController *vc = [[PayListViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            RepairListViewController *vc = [[RepairListViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            ChangePassWordViewController *changeVC = [[ChangePassWordViewController alloc]init];
            changeVC.hidesBottomBarWhenPushed = YES;
            changeVC.tabBarController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:changeVC animated:YES];

        }
            break;

        case 3:
        {
//            AboutUsViewController *about = [[AboutUsViewController alloc]init];
//            about.title = @"使用帮助";
//            about.baseUrl = WEB_URL_HELP(@"Helplist.html");
//            about.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:about animated:YES];
            RxWebViewController* vc = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:WEB_URL_HELP(@"Helplist.html")]];//
            vc.hidesBottomBarWhenPushed = YES;
            vc.navigationController.navigationBarHidden = YES;
            [self.navigationController pushViewController:vc animated:YES];
            [self UMengEvent:@"helpList"];
        }
            break;
        case 4:
        {
            //关于本软件

            AboutUsViewController *about = [[AboutUsViewController alloc]init];
            
            about.title = @"关于本软件";
            about.baseUrl = WEB_URL_HELP(@"Aboutme.html");
            about.hidesBottomBarWhenPushed = YES;            
            [self.navigationController pushViewController:about animated:YES];
            [self UMengEvent:@"aboutUs"];

        }
            break;
        case 5:
        {
            //软件升级
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdate object:@"HUD"];

            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        }
            break;
        case 6:
        {
            SuggesstionViewController *vc = [[SuggesstionViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.navigationController.navigationBarHidden = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            case 7:
        {
        XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"确定退出登录吗？" WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
            alert.tag = 2010;
            [alert show];
        }
            break;
        default:
            break;
    }
}




- (void)logoutAction{

    //注销  下线
    [self LogoutToNet];//根据 返回值确定一键上网的版本
    [self UMengEvent:@"logout"];
    //退出登录
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLogout object:self];

}


-(void)LogoutToNet{
    
    AppUserIndex *user = [AppUserIndex GetInstance];
    NSString *logoutUrl = user.LogoutURL; //[user objectForKey:@"logoutStr"];
    NSString *EpUrl = user.epurl;//[user objectForKey:@"Epurl"];
    [self UMengEvent:@"breakNet"];
    //截取字符串---单利传值  ----
    if (logoutUrl) {
        logoutUrl =[EpUrl stringByReplacingOccurrencesOfString:@"index.jsp?" withString:logoutUrl];
        NSRange start = [logoutUrl rangeOfString:@"http://"];
        NSRange end = [logoutUrl rangeOfString:@"wlanuserip"];
        if ((start.location&&end.location)!=NSNotFound) {
            logoutUrl = [logoutUrl substringWithRange:NSMakeRange(start.location, end.location-start.location)];
            [NetworkCore requestGET:logoutUrl parameters:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                
            }];

        }
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)remarkAction:(UIButton *)sender {
//    XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withRemarkTitle:@[@"服务速度",@"服务态度",@"服务结果"]];
//    XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"aaa" withContent:@"sdssad"];
    
//    XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withDropListTitle:@[@"服务速度",@"服务态度",@"服务结果",@"服务态度",@"服务结果"]];
    XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withIdCode:@""];
    [alert show];
}
- (IBAction)repairAction:(UIButton *)sender {
    RepairListViewController *vc = [[RepairListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)textAtion:(UIButton *)sender {
    QuestionListViewController *vc = [[QuestionListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)alertView:(XGAlertView *)view didClickRemarkView:(NSArray *)markArr{
    NSLog(@"%@",markArr);
}

- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title{
    if (view.tag==2010) {
        [self logoutAction];
    }
}


- (IBAction)payListAction:(UIButton *)sender {
    PayListViewController *vc = [[PayListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark  NAV代理事件
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[self class]]) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [navigationController setNavigationBarHidden:NO animated:YES];
    }
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
