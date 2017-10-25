//
//  QueryScoreViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/5/25.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "QueryScoreViewController.h"
#import "UIView+SDAutoLayout.h"
#import "ScoreListTableViewCell.h"
#import "XJComboBoxView.h"
#import "JSDropDownMenu.h"
#import "UIViewController+KSNoNetController.h"
#import "XGTempNoticeView.h"
#import "CRSA.h"
#import <JSONKit.h>

@interface QueryScoreViewController ()<UITableViewDelegate, UITableViewDataSource, JSDropDownMenuDataSource,JSDropDownMenuDelegate>
{
    UILabel *_passNumLabel;
    UILabel *_faildNumLabel;
    UILabel *_passScoreLabel;
    UILabel *_faildScoreLabel;
    XJComboBoxView *comboBox;

    UILabel *_nopassCount;
    UILabel *_nopassScore;
    UILabel *_passCount;
    UILabel *_passScore;
    
    
    NSMutableArray *_classStateArray; //存放科目状态（全部、通过、未通过）
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    
    NSInteger _currentData1SelectedIndex;
    JSDropDownMenu *menu;
    
    NSMutableDictionary *_termInfoDic; //存放学期名称与字段对应信息
    NSMutableArray *_termInfoArray; //存放学期信息

    NSMutableDictionary *_classStateDic; //存放科目名称与字段对应信息

}

@property (nonatomic, strong) UIView *selectTermView;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIView *userInfoView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) NSString *termStr;
@property (nonatomic, copy) NSString *isPassStr;
//@property (nonatomic, strong) NSArray *termInfoArray;

@end

@implementation QueryScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"成绩查询";
    _termStr = @"";
    _isPassStr = @"";
    [self loadTermInfo];
    [self createViews];
    [self loadData];
    [self showAlert];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

//加载学期信息
- (void)loadTermInfo{
    [ProgressHUD show:nil];
    NSDictionary *commitDic = @{
                                @"rid":@"getTermsAboutScore",
                                @"stuNo":stuNum
                                };

    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"2");
        
        _termInfoDic = [NSMutableDictionary dictionary];
        [_termInfoDic setObject:@"" forKey:@"全部学期"];
        
        for (NSDictionary *termDic in responseObject[@"data"]) {
            [_termInfoArray addObject:termDic[@"XNXQMC"]];
            [_termInfoDic setObject:termDic[@"XNXQDM"] forKey:termDic[@"XNXQMC"]];
        }


        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}
//RSA解密
-(NSString *)RSAdataToDic:(NSString *)my_String
{
    
    CRSA *rea = [CRSA shareInstance];
    NSString *nestSr = [rea decryptByRsa:my_String withKeyType:KeyTypePublic];//解密
    NSLog(@"%@",nestSr);
    return nestSr;
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}
- (void)showAlert{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"ScoreShow"] isEqualToString:@"1"]) {
        XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"本数据仅供参考，请以学校实际公布为准。" WithCancelButtonTitle:@"不再提示" withOtherButton:nil];
        alert.isBackClick = YES;
        [alert show];
    }
}

- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"ScoreShow"];
}

- (void)createViews{
    
//    XGTempNoticeView *tempView = [[XGTempNoticeView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 40) WithText:@"本数据仅供参考，请以学校实际公布为准。" WithFlashTime:5];
//    [self.view addSubview:tempView];
    
    _selectTermView = [[UIView alloc] init];
    _mainTableView = [[UITableView alloc] init];
    _mainTableView.tableFooterView =[[UIView alloc] init];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _userInfoView = [[UIView alloc] init];
    
    [self.view addSubview:_mainTableView];
    [self.view addSubview:_userInfoView];
    [self.view addSubview:_selectTermView];
    
    _userInfoView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _selectTermView.sd_layout
    .topSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .leftSpaceToView(self.view,0)
    .heightIs(40);
    
    _classStateArray = [NSMutableArray array];
    [_classStateArray addObjectsFromArray:@[@"全部",@"通过",@"未通过"]];
    _classStateDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                     @"全部":@"",
                                                                     @"通过":@"1",
                                                                     @"未通过":@"0"
                                                                     }];
    _termInfoArray = [NSMutableArray array];
    [_termInfoArray addObject:@"全部学期"];
    
    
    //下拉按钮
    menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    menu.dataSource = self;
    menu.delegate = self;
    // 指定默认选中
    _currentData1Index = 0;
    _currentData1SelectedIndex = 0;
    [self.view addSubview:menu];
    
    _mainTableView.sd_layout
    .topSpaceToView(menu,0)
    .rightSpaceToView(self.view,0)
    .leftSpaceToView(self.view,0)
    .bottomSpaceToView(_userInfoView,0);
    
    UILabel *userId = [UILabel new];
    userId.text = [NSString stringWithFormat:@"学号: %@",[AppUserIndex GetInstance].accountId];
    userId.textColor = Color_Black;
    userId.font = [UIFont systemFontOfSize:14];
    
    _passNumLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.text = @"通过科目：";
        view.textColor = Color_Gray;
        view;
    });
    
    _passScoreLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.text = @"获取学分：";
        view.textColor = Color_Gray;
        view;
    });
    
    _faildNumLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.text = @"未通过科目：";
        view.textColor = Color_Gray;
        view;
    });
    
    _faildScoreLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.text = @"未获取学分：";
        view.textColor = Color_Gray;
        view;
    });
    
    _nopassCount = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Base_Orange;
        view;
    });
    
    _nopassScore = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Base_Orange;
        view;
    });
    
    _passCount = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Gray;
        view;
    });
    
    _passScore = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Gray;
        view;
    });
    
    [_userInfoView addSubview:userId];
    [_userInfoView addSubview:_passScoreLabel];
    [_userInfoView addSubview:_passNumLabel];
    [_userInfoView addSubview:_faildScoreLabel];
    [_userInfoView addSubview:_faildNumLabel];
    
    [_userInfoView addSubview:_passCount];
    [_userInfoView addSubview:_passScore];
    [_userInfoView addSubview:_nopassCount];
    [_userInfoView addSubview:_nopassScore];
    
    _userInfoView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0)
    .heightIs(90);
    
    userId.sd_layout
    .topSpaceToView(_userInfoView,5)
    .leftSpaceToView(_userInfoView,5)
    .rightSpaceToView(_userInfoView,5)
    .heightIs(25);
    
    _passNumLabel.sd_layout
    .topSpaceToView(userId, 5)
    .leftEqualToView(userId)
    .widthIs(80)
    .heightIs(25);

    _passCount.sd_layout
    .topEqualToView(_passNumLabel)
    .leftSpaceToView(_passNumLabel,0)
    .widthIs(70)
    .heightRatioToView(_passNumLabel,1);

    
    _passScoreLabel.sd_layout
    .topEqualToView(_passNumLabel)
    .xIs(kScreenWidth/2-5)
    .widthRatioToView(_passNumLabel,1)
    .heightRatioToView(_passCount,1);
    
    _passScore.sd_layout
    .topEqualToView(_passNumLabel)
    .leftSpaceToView(_passScoreLabel,0)
    .widthIs(70)
    .heightRatioToView(_passNumLabel,1);
    
    _faildNumLabel.sd_layout
    .topSpaceToView(_passNumLabel,5)
    .leftEqualToView(userId)
    .widthIs(80)
    .heightIs(25);
    
    _nopassCount.sd_layout
    .topEqualToView(_faildNumLabel)
    .leftSpaceToView(_faildNumLabel,0)
    .widthIs(70)
    .heightRatioToView(userId,1);
    
    _faildScoreLabel.sd_layout
    .topSpaceToView(_passNumLabel,5)
    .xIs(kScreenWidth/2-5)
    .widthRatioToView(_passScoreLabel,1)
    .heightRatioToView(_faildNumLabel,1);
    
    _nopassScore.sd_layout
    .topEqualToView(_faildScoreLabel)
    .leftSpaceToView(_faildScoreLabel,0)
    .widthIs(70)
    .heightRatioToView(userId,1);
    

}

//加载数据-科目成绩
- (void)loadData{
    if (!_termStr) {
        _termStr = @"";
    }
    NSDictionary *commitDic = @{
                                @"rid":@"getScoreByInput",
                                @"stuNo":stuNum,
                                @"term":_termStr,
                                @"isPass":_isPassStr
                                };
    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
//        NSArray *arr = []
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            _dataArray = [NSArray arrayWithArray:[responseObject[@"data"] objectFromJSONString]];
        }else if ([responseObject[@"data"] isKindOfClass:[NSArray class]]){
            _dataArray = [NSArray arrayWithArray:responseObject[@"data"]];
        }
     
        _nopassScore.text = [NSString stringWithFormat:@"%@",responseObject[@"nopass_score"]];
        _nopassCount.text = [NSString stringWithFormat:@"%@",responseObject[@"nopass_count"]];
        _passScore.text = [NSString stringWithFormat:@"%@",responseObject[@"pass_score"]];
        _passCount.text = [NSString stringWithFormat:@"%@",responseObject[@"pass_count"]];
        if (_dataArray.count<1) {
            [self showErrorView:responseObject[@"msg"] andImageName:nil];

        }else{
            [self hiddenErrorView];
            
        }
        [_mainTableView reloadData];
        [self.view bringSubviewToFront:menu];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];

    }];

}

#pragma mark UITableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"ScoreListTableViewCell";
    
    //询问talbeView是否有闲置的单元格对象
    ScoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        /*
         复用单元格，能优化内存操作，提高效率，没有必要每一次不断地创建和释放
         复用后，最多只需要创建n+1个单元格,n表示的是视图上能够显示的单元格数量
         */
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] lastObject];
    }
    NSDictionary *dic = _dataArray[indexPath.row];
    cell.dataDic = dic;
    cell.classNameLabel.text = dic[@"KCM"];
    cell.classTypeLabel.text = dic[@"KCXZMC"];
    
    if (([dic[@"PJKG"] integerValue] == 0) && ([dic[@"CKZT"] integerValue] > 0) && ([dic[@"PJZT"] integerValue] == 0)) {
        cell.classScoreLabel.text = @"未评教";
    }else{
        cell.classScoreLabel.text = [NSString stringWithFormat:@"%.1f",[dic[@"ZCJ"] doubleValue]];
    }

    cell.classXuefenLabel.text = [NSString stringWithFormat:@"%@",dic[@"XF"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 30)];
    nameLabel.text = @"课程名";
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.textColor = Color_Black;
    [view addSubview:nameLabel];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-10-20-15-42*3, 5, 70, 30)];
    typeLabel.text = @"课程性质";
    typeLabel.font = [UIFont systemFontOfSize:13];
    typeLabel.textColor = Color_Black;
    [view addSubview:typeLabel];
    
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-10-42*2-15, 5, 42, 30)];
    scoreLabel.text = @"成绩";
    scoreLabel.font = [UIFont systemFontOfSize:13];
    scoreLabel.textColor = Color_Black;
    [view addSubview:scoreLabel];
    
    UILabel *xuefenLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-10-42, 5, 42, 30)];
    xuefenLabel.text = @"学分";
    xuefenLabel.font = [UIFont systemFontOfSize:13];
    xuefenLabel.textColor = Color_Black;
    [view addSubview:xuefenLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:lineView];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [comboBox hiddenList];
}

#pragma mark ComboBoxView delegate
-(void)comboBoxView:(XJComboBoxView *)comboBoxView didSelectRowAtValueMember:(NSString *)valueMember displayMember:(NSString *)displayMember{
    _termStr = valueMember;
    [self loadData];
}

#pragma mark JSDropDownMene delegate & datasource

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 2;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        
        return _currentData1Index;
        
    }
    if (column==1) {
        
        return _currentData2Index;
    }
    
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        
        return _termInfoArray.count;
        
    } else if (column==1){
        
        return _classStateArray.count;
        
    }
    
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0: return _termInfoArray[_currentData1Index];
            break;
        case 1: return _classStateArray[_currentData2Index];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        
        return [_termInfoArray objectAtIndex:indexPath.row];
        
    } else {
        
        return _classStateArray[indexPath.row];
        
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        _currentData1Index = indexPath.row;
        _termStr = [_termInfoDic objectForKey:[_termInfoArray objectAtIndex:indexPath.row]];
        [self loadData];
    } else{
        _currentData2Index = indexPath.row;
        _isPassStr = [_classStateDic objectForKey:[_classStateArray objectAtIndex:indexPath.row]];
        switch (indexPath.row) {
            case 0:
            {
                _faildScoreLabel.sd_layout.heightIs(25);// = 25;
                _faildNumLabel.sd_layout.heightIs(25);// = 25;
                _passNumLabel.sd_layout.heightIs(25);// = 25;
                _passScoreLabel.sd_layout.heightIs(25);// = 25;
                _userInfoView.sd_layout.heightIs(90);

            }
                break;
            case 1:
            {
                _faildScoreLabel.sd_layout.heightIs(0);// = 0;
                _faildNumLabel.sd_layout.heightIs(0);// = 0;
                _passNumLabel.sd_layout.heightIs(25);// = 25;
                _passScoreLabel.sd_layout.heightIs(25);// = 25;
                _userInfoView.sd_layout.heightIs(70);
            }
                break;
            case 2:
            {
                _passNumLabel.sd_layout.heightIs(0);
                _passScoreLabel.sd_layout.heightIs(0);
                _faildScoreLabel.sd_layout.heightIs(25);// = 25;
                _faildNumLabel.sd_layout.heightIs(25);// = 25;
                _userInfoView.sd_layout.heightIs(70);
            }
                break;
            default:
                break;
        }
        [self loadData];
    }
}


- (void)btnClick{
    _faildScoreLabel.height = 0;
    _faildNumLabel.height = 0;
    
    _userInfoView.sd_layout.heightIs(70);
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
