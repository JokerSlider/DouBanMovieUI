//
//  SettingLeftViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 17/1/10.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "SettingLeftViewController.h"
#import "SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "UILabel+stringFrame.h"
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
#import "EditMymessageController.h"
#import "FinanceOderListViewController.h"
#import "MCLeftSliderManager.h"

@interface SettingLeftViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_titleArray;
    NSArray *_iconArray;
    UILabel *_nameLabel;
    UILabel *_flowerNumLabel;
    UIImageView *_headerImageView;
    UILabel *_schoolLabel;
    UIImageView *_sexImageView;
}
@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation SettingLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(245, 245, 245);
    
    _titleArray = @[
                    @[@"我的订单", @"我的报修", @"我的报销"],
                    @[@"修改密码", @"使用帮助", @"软件升级", @"关于本软件", @"意见与反馈"],
                    ];
    
    _iconArray = @[
                   @[@"mine_dingdan", @"mine_repair", @"mine_finance"],
                   @[@"mine_password", @"mine_help", @"mine_update", @"mine_about" ,@"mine_advice"],
                   ];
    
    UITableView *tableview = [[UITableView alloc] init];
    self.mainTableView = tableview;
//    tableview.sectionHeaderHeight = 0;
//    tableview.sectionFooterHeight = 0;
    tableview.frame = CGRectMake(0, 191, kScreenWidth-70, kScreenHeight);
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    
//    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.showsVerticalScrollIndicator = NO;
    [self createHeaderView];

//    [_mainTableView reloadData];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    _nameLabel.text = [AppUserIndex GetInstance].nickName;
    _flowerNumLabel.text = [AppUserIndex GetInstance].flowerNum;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[AppUserIndex GetInstance].headImageUrl] placeholderImage:PlaceHolder_Image];
    _schoolLabel.text = [AppUserIndex GetInstance].schoolName;
    
    CGSize size=[_nameLabel boundingRectWithSize:CGSizeMake(0, 21)];
    
    _nameLabel.sd_layout.widthIs(size.width+5);
    [_mainTableView reloadData];
}

-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

- (void)updateUserInfo{
    _nameLabel.text = [AppUserIndex GetInstance].nickName;
    _flowerNumLabel.text = [AppUserIndex GetInstance].flowerNum;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[AppUserIndex GetInstance].headImageUrl] placeholderImage:PlaceHolder_Image];
    _schoolLabel.text = [AppUserIndex GetInstance].schoolName;
    
    CGSize size=[_nameLabel boundingRectWithSize:CGSizeMake(0, 21)];
    
    _nameLabel.sd_layout.widthIs(size.width+5);
    [_mainTableView reloadData];
    
    UIViewController *firstVC = [MCLeftSliderManager sharedInstance].mainNavigationController.viewControllers.firstObject;
    UIBarButtonItem *item = firstVC.navigationItem.leftBarButtonItem;
    UIButton *btn = item.customView;
    if (btn.tag == 2020) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[AppUserIndex GetInstance].headImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //            [btn sd_setImageWithURL:[NSURL URLWithString:[AppUserIndex GetInstance].headImageUrl] forState:UIControlStateNormal placeholderImage:PlaceHolder_Image];
            [btn setImage:[self OriginImage:image scaleToSize:CGSizeMake(35, 35)] forState:UIControlStateNormal];
        }];
    }

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [ProgressHUD dismiss];
}

- (void)createHeaderView{
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 0, kScreenWidth-70, 191)];
    headerView.image = [UIImage imageNamed:@"mine_my_bg"];
    headerView.userInteractionEnabled = YES;
    
    _nameLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = [UIFont boldSystemFontOfSize:17];
        view.text = [AppUserIndex GetInstance].nickName;
        view;
    });
    
    _sexImageView = ({
        UIImageView *view = [UIImageView new];
        view.image = ([[AppUserIndex GetInstance].sex isEqualToString:@"1"])?[UIImage imageNamed:@"photoWall_boy"]:(([[AppUserIndex GetInstance].sex isEqualToString:@"2"]?[UIImage imageNamed:@"photoWall_girl"]:[UIImage imageNamed:@""]));
        view;
    });
    
    _schoolLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.text = [AppUserIndex GetInstance].schoolName;
        view.font = [UIFont systemFontOfSize:13];
        view;
    });
    
    
    _headerImageView = ({
        UIImageView *view = [UIImageView new];
        [view sd_setImageWithURL:[NSURL URLWithString:[AppUserIndex GetInstance].headImageUrl] placeholderImage:PlaceHolder_Image];
        view;
    });
    
    UIButton *editBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeSystem];
        [view setTitle:@"编辑" forState:UIControlStateNormal];
        [view setTitleColor:Base_Orange forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:15];
        [view addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    _flowerNumLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = [UIColor whiteColor];
        view.font = [UIFont systemFontOfSize:13];
        view.text = [AppUserIndex GetInstance].flowerNum;
        view.textAlignment = NSTextAlignmentRight;
        view;
    });
    
    UILabel *flowerLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = [UIColor whiteColor];
        view.font = [UIFont systemFontOfSize:13];
        view.text = @"鲜花";
        view.textAlignment = NSTextAlignmentLeft;
        view;
    });
    
    UIView *flowerBacView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
        view;
    });
    
    
    [headerView sd_addSubviews:@[_nameLabel, _schoolLabel, editBtn, _headerImageView, flowerBacView,_sexImageView]];
    [flowerBacView sd_addSubviews:@[_flowerNumLabel, flowerLabel]];
    
    _headerImageView.sd_layout
    .leftSpaceToView(headerView,16)
    .topSpaceToView(headerView,26)
    .widthIs(75)
    .heightIs(75);
    
    _headerImageView.sd_cornerRadius = @(37.5);
    

    
    
    CGSize size=[_nameLabel boundingRectWithSize:CGSizeMake(0, 21)];
    
    _nameLabel.sd_layout
    .leftSpaceToView(headerView,14)
    .heightIs(15)
    .widthIs(size.width+5)
    .topSpaceToView(_headerImageView,33);
    
    _schoolLabel.sd_layout
    .leftSpaceToView(headerView,14)
    .heightIs(15)
    .widthIs(150)
    .topSpaceToView(_nameLabel,13);
    
    _sexImageView.sd_layout
    .leftSpaceToView(_nameLabel,3)
    .centerYEqualToView(_nameLabel)
    .widthIs(17)
    .heightIs(17);
    
    flowerBacView.sd_layout
    .rightSpaceToView(headerView,8)
    .bottomSpaceToView(headerView,10)
    .heightIs(31);
    
    flowerBacView.sd_cornerRadius = @(15);
    
    flowerLabel.sd_layout
    .leftSpaceToView(flowerBacView,8)
    .centerYEqualToView(flowerBacView)
    .widthIs(50)
    .heightIs(21);
    
    CGSize size1=[_flowerNumLabel boundingRectWithSize:CGSizeMake(0, 21)];
    
    _flowerNumLabel.sd_layout
    .rightSpaceToView(flowerBacView,8)
    .centerYEqualToView(flowerBacView)
    .widthIs(size1.width+5)
    .heightIs(13);
    
    
    
    flowerBacView.sd_layout.widthIs(size1.width+75);
    
    editBtn.sd_layout
    .rightSpaceToView(headerView,10)
    .topSpaceToView(headerView,35)
    .heightIs(21)
    .widthIs(80);
    
//    _mainTableView.tableHeaderView = headerView;
    [self.view addSubview:headerView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 50)];
    UIButton *logOut = [UIButton buttonWithType:UIButtonTypeCustom];
    logOut.frame = CGRectMake(5, 12, 200, 24);
    [logOut setImage:[UIImage imageNamed:@"mine_logout"] forState:UIControlStateNormal];
    [logOut setTitle:@"   退出登录" forState:UIControlStateNormal];
    logOut.titleLabel.font = [UIFont systemFontOfSize:15];
    [logOut setTitleColor:RGB(85, 85, 85) forState:UIControlStateNormal];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:logOut];
    [logOut addTarget:self action:@selector(logOut:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:view];
}

- (void)editBtnAction:(UIButton *)sender{
    
    EditMymessageController *vc = [[EditMymessageController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self pushAction:vc];
}

#pragma UITableView delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = _titleArray[section];
    return arr.count;
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
    
    cell.imageView.image = [UIImage imageNamed:_iconArray[indexPath.section][indexPath.row]];
    cell.textLabel.text = _titleArray[indexPath.section][indexPath.row];
    
    if (indexPath.section == 2) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
    }else{
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = Color_Black;
    }
    cell.contentView.backgroundColor = RGB(245, 245, 245);
    cell.clipsToBounds = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppUserIndex *user = [AppUserIndex GetInstance];
    if ([user.role_type isEqualToString:@"1"]) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            //教师身份不显示我的订单
            return 0;
        }
    }else{
        if (indexPath.section == 0 && indexPath.row == 2) {
            //学生身份不显示我的报销
            return 0;
        }
    }
    
    if (!user.canModifyPassword) {
        if (indexPath.section == 1 && indexPath.row == 0) {
            //标注不能修改密码的身份不显示修改密码
            return 0;
        }
    }
    
    return 44;
}


//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.1;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section) {
//        <#statements#>
//    }
//    return 15;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            PayListViewController *vc = [[PayListViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self pushAction:vc];
        }else if (indexPath.row == 1){
            RepairListViewController *vc = [[RepairListViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self pushAction:vc];
        }else if (indexPath.row == 2){
            
            FinanceOderListViewController *vc = [[FinanceOderListViewController alloc] init];
            vc.state = @"0";
            vc.hidesBottomBarWhenPushed = YES;
            [self pushAction:vc];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            ChangePassWordViewController *changeVC = [[ChangePassWordViewController alloc]init];
            changeVC.hidesBottomBarWhenPushed = YES;
            changeVC.tabBarController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:changeVC animated:YES];
        }else if (indexPath.row == 1){
            RxWebViewController* vc = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:WEB_URL_HELP(@"Helplist.html")]];//
            vc.hidesBottomBarWhenPushed = YES;
            vc.navigationController.navigationBarHidden = YES;
            [self pushAction:vc];
            [self UMengEvent:@"helpList"];
        }else if (indexPath.row == 2){
            //软件升级
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdate object:@"HUD"];
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else if (indexPath.row == 3){
            //关于本软件
            
            RxWebViewController* vc = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:WEB_URL_HELP(@"Aboutme.html")]];//
            vc.hidesBottomBarWhenPushed = YES;
            vc.navigationController.navigationBarHidden = YES;
            [self pushAction:vc];
            
            //            AboutUsViewController *about = [[AboutUsViewController alloc]init];
            //
            //            about.title = @"关于本软件";
            //            about.baseUrl = WEB_URL_HELP(@"Aboutme.html");
            //            about.hidesBottomBarWhenPushed = YES;
            //            [self.navigationController pushViewController:about animated:YES];
            [self UMengEvent:@"aboutUs"];
        }else if (indexPath.row == 4){
            //意见与反馈
            SuggesstionViewController *vc = [[SuggesstionViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.navigationController.navigationBarHidden = YES;
            [self pushAction:vc];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            
        }
    }
}

- (void)logOut:(UIButton *)sender{
    XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"确定退出登录吗？" WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
    alert.tag = 2010;
    [alert show];
}

- (void)pushAction:(UIViewController *)vc{
    [[MCLeftSliderManager sharedInstance].LeftSlideVC closeLeftView];//关闭左侧抽屉
    [[MCLeftSliderManager sharedInstance].mainNavigationController pushViewController:vc animated:NO];
}

- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title{
    if (view.tag==2010) {
        //注销  下线
        if ([AppUserIndex GetInstance].eportalVer ) {
            [self NewLogoutToNet];//根据返回值确定一键上网的版本
        }else{
            [self LogoutToNet];
        }
        [self UMengEvent:@"logout"];
        AppUserIndex *user = [AppUserIndex GetInstance];
        user.funcMsgArr = [NSArray array];//移除所有通知类的消息；
        [user saveToFile];
        //退出登录
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLogout object:self];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NotificationBreakNet" object:self];
    }
}

/*
 *断开网络
 */
-(void)NewLogoutToNet{
    NSString *userIndex=[AppUserIndex GetInstance].userIndex;
    NSString *userip = [AppUserIndex GetInstance].userIp;
    
    if (!userIndex||!userip) {
        return;
    }
    NSDictionary *logoutDic = @{
                                @"userip":userip,
                                @"userIndex":userIndex
                                };
    
    NSString *logoutUrl = [NSString stringWithFormat:@"%@logout",[AppUserIndex GetInstance].BaseUrl];
    
    [NetworkCore requestOriginlTarget:logoutUrl parameters:logoutDic isget:NO block:^(id responseObject) {
        
    }];
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
