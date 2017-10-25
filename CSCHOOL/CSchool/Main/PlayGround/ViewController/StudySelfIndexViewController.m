//
//  StudySelfIndexViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 2017/7/7.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "StudySelfIndexViewController.h"
#import "SDAutoLayout.h"
#import "AutoWebViewController.h"
#import "StudyHeatMapViewController.h"
#import "RxWebViewController.h"

@interface StudySelfIndexViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) UILabel *nameLabel;

@property (nonatomic, retain) UILabel *statusLabel;

@property (nonatomic, retain) UIImageView *logoImageView;

@property (nonatomic, retain) NSArray *dataArray;

@property (nonatomic, copy) NSString *roomStr;

@property (nonatomic, copy) NSString *seatId;

@property (nonatomic, copy) NSString *state;

@end

@implementation StudySelfIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _roomStr = @"";
    _seatId = @"";
    _state = @"0";
    
    [self createHeaderView];
    _tableView.tableFooterView = [UIView new];
    [self loadData];
    [self loadStudyStandard];
}

- (void)createHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 230)];
    
    _logoImageView = ({
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selfStudy_lou"]];
        view;
    });
    
    _nameLabel = ({
        UILabel *view = [UILabel new];
//        view.text = @"逸夫楼";
        view.textColor = RGB(255,255,251);
        view.textAlignment = NSTextAlignmentCenter;
        view.font = [UIFont systemFontOfSize:18];
        view;
    });
    
    _statusLabel = ({
        UILabel *view = [UILabel new];
//        view.text = @"三天未打卡";
        view.textAlignment = NSTextAlignmentCenter;
        view.textColor = [UIColor whiteColor];
        view.font = [UIFont systemFontOfSize:15];
//        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    
    UIButton *signButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signButton setTitle:@"打卡" forState:UIControlStateNormal];
    [signButton setImage:[UIImage imageNamed:@"selfStudy_sign"] forState:UIControlStateNormal];
    [signButton setTitleColor:Base_Orange forState:UIControlStateNormal];
    signButton.sd_cornerRadius = @(5);
    signButton.layer.borderWidth = .5;
    signButton.layer.borderColor = Base_Orange.CGColor;
    signButton.backgroundColor = RGB(255,255,251);
    [signButton addTarget:self action:@selector(signAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *bacView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selfStudy_bg-"]];
    
    
    
    [view sd_addSubviews:@[bacView, _logoImageView, _nameLabel, _statusLabel, signButton]];
    
    bacView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 30, 0));
    
    _logoImageView.sd_layout
    .centerXEqualToView(view)
    .topSpaceToView(view, 17)
    .widthIs(90)
    .heightIs(90);
    
    _nameLabel.sd_layout
    .leftSpaceToView(view, 10)
    .rightSpaceToView(view, 10)
    .topSpaceToView(_logoImageView, 8)
    .heightIs(17);
    
    _statusLabel.sd_layout
    .leftSpaceToView(view, 10)
    .rightSpaceToView(view, 10)
    .topSpaceToView(_nameLabel, 8)
    .heightIs(17);
    
    signButton.sd_layout
    .leftSpaceToView(view, 25)
    .rightSpaceToView(view, 25)
    .topSpaceToView(_statusLabel, 23)
    .heightIs(40);
    
    _tableView.tableHeaderView = view;
}

- (void)signAction:(UIButton *)sender{
    
    if (![_state isEqualToString:@"1"]) {
        [ProgressHUD showError:@"该账户无法签到！"];
        return;
    }
    
    NSDictionary *dic = @{
                          @"rid":@"punchInSign",
                          @"userid":@"20131512042",//[AppUserIndex GetInstance].role_id,
                          @"macaddr":[NetworkCore getMacInfo],
                          @"room":_roomStr,
                          @"seatid":_seatId
                          };
    
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:responseObject[@"msg"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}

- (void)loadData{
    
    NSDictionary *commitDic = @{
                                @"rid":@"getSelfStudyroomInfoByStuNo",
                                @"userid":@"20131512042"//
                                };
    
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            return ;
        }
        _roomStr = [responseObject valueForKeyPath:@"data.roomname"];
        _seatId = [responseObject valueForKeyPath:@"data.seatid"];
        _state = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:@"data.state"]];
        _nameLabel.text = [NSString stringWithFormat:@"%@-%@",[responseObject valueForKeyPath:@"data.buildname"],[responseObject valueForKeyPath:@"data.roomname"]];
        if ([responseObject[@"black"] count] >0) {
            NSDictionary *blackDic = responseObject[@"black"][0];
            _statusLabel.text = blackDic[@"blackbz"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}

- (void)loadStudyStandard{
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getSelfStudyStandard"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _dataArray = responseObject[@"data"];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = Color_Black;
    }
//    [@"DD_NAME"];
    [cell.imageView setImage:[UIImage imageNamed:@"selfStudy_gong"]];
    NSDictionary *dic = _dataArray[indexPath.row];
    cell.textLabel.text = [dic allKeys][0];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic = _dataArray[indexPath.row];
    
    NSString *url = [dic allValues][0];
    
//    AutoWebViewController *vc = [[AutoWebViewController alloc] init];
//    vc.commitDic = @{@"rid":@"showDetByWelcomeId",@"id":@(sender.tag)};
//    vc.valueForKeyPath = @"data.wicontent";
//    vc.titleForKeyPath = @"data.wititle";
//    vc.hidesBottomBarWhenPushed = YES;
//    vc.navigationController.navigationBarHidden = YES;
//    vc.title = sender.titleLabel.text;
//    [self.navigationController pushViewController:vc animated:YES];
    
//    StudyHeatMapViewController *vc = [[StudyHeatMapViewController alloc] init];
    RxWebViewController* vc = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:url]];//

    [self.navigationController pushViewController:vc animated:YES];

//    [self.navigationController pushViewController:vc animated:YES];
    
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
