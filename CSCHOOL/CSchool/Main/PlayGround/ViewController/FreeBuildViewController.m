//
//  FreeBuildViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/4/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "FreeBuildViewController.h"
#import "UIView+SDAutoLayout.h"
#import "NSDate+Extension.h"
#import "FreeRoomViewController.h"

@interface FreeBuildViewController ()
{
    UILabel *_timeLabel;
    UIButton *beforBtn;
}

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) NSInteger countNum;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSString *requestTimeStr;
@end

@implementation FreeBuildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"空教室查询";

    [self createViews];
    [self showAlert];
}

- (void)createViews{
    
    _mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainScrollView];
    
    _headerView = [UIView new];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerView];
    
    _headerView.sd_layout
    .leftSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(35);
    
    _mainScrollView.sd_layout
    .leftSpaceToView(self.view,0)
    .topSpaceToView(_headerView,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0);
    
    _requestTimeStr = @"";
    [self loadData];
    [self addDate];
}

- (void)loadData{
    NSDictionary *dic = @{
                          @"rid":@"getEmptyClassroomWithCount",
                          @"schoolCode":[AppUserIndex GetInstance].schoolCode,
                          @"requesttime":_requestTimeStr
                          };
    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _dataArray = [responseObject objectForKey:@"data"];
        [self loadBuildButton];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];

    }];
}

- (void)showAlert{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"freeBuildShow"] isEqualToString:@"1"]) {
        XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"本数据仅供参考，请以学校实际公布为准。" WithCancelButtonTitle:@"不再提示" withOtherButton:nil];
        alert.isBackClick = YES;
        [alert show];
    }
}

- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"freeBuildShow"];
}

//加载教室信息列表的按钮
- (void)loadBuildButton{
    [_mainScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    CGFloat btnWith = (kScreenWidth-40)/2;
    CGFloat btnHeight = 35;
    UIButton *lastBtn = nil;
    for (int i=0; i<_dataArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15+(i%2)*(btnWith+10), 10+(i/2)*(btnHeight+10), btnWith, btnHeight);
        btn.backgroundColor = Base_Color2;
        btn.tag = i;
        [btn addTarget:self action:@selector(buildSelect:) forControlEvents:UIControlEventTouchUpInside];
        [_mainScrollView addSubview:btn];
        
        //教室名称
        UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, btnWith/2+40, btnHeight)];
        mainLabel.text = [_dataArray[i] objectForKey:@"JXLM"];
        mainLabel.font = [UIFont systemFontOfSize:12];
        mainLabel.textAlignment = NSTextAlignmentCenter;
        mainLabel.textColor = Color_Black;
        [btn addSubview:mainLabel];
        //空教室数量
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(btnWith/2+40, 0, btnWith/2-20, btnHeight)];
        numLabel.text = [NSString stringWithFormat:@"(%@)",[_dataArray[i] objectForKey:@"KJSSL"]];
        numLabel.font = [UIFont systemFontOfSize:10];
        numLabel.textColor = Color_Gray;
        [btn addSubview:numLabel];
        
        lastBtn = btn;
    }
    
    [_mainScrollView setupAutoContentSizeWithBottomView:lastBtn bottomMargin:20];

}

- (void)addDate{
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = Title_Font;
    _timeLabel.textColor = Base_Orange;
    [_headerView addSubview:_timeLabel];
    _timeLabel.text = [NSDate formatYMD:[NSDate date]];
    UIButton *afterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [afterBtn setImage:[UIImage imageNamed:@"chooseRight"] forState:UIControlStateNormal];
    [afterBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    afterBtn.tag = 1001;
    [_headerView addSubview:afterBtn];
    _headerView.backgroundColor = Base_Color2;
    beforBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [beforBtn setImage:[UIImage imageNamed:@"chooseLeft"] forState:UIControlStateNormal];
    [beforBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    beforBtn.tag = 1002;
    [_headerView addSubview:beforBtn];
    
    _timeLabel.sd_layout
    .centerXEqualToView(_headerView)
    .centerYEqualToView(_headerView)
    .heightRatioToView(_headerView,1)
    .widthIs(80);
    
    afterBtn.sd_layout
    .leftSpaceToView(_timeLabel,0)
    .topEqualToView(_timeLabel)
    .heightRatioToView(_timeLabel,1)
    .widthIs(50);
    
    beforBtn.sd_layout
    .rightSpaceToView(_timeLabel,0)
    .topEqualToView(_timeLabel)
    .heightRatioToView(_timeLabel,1)
    .widthIs(50);
    
    beforBtn.hidden = YES;

}

- (void)btnClick:(UIButton *)sender{
    if (sender.tag==1001) {
        _countNum++;
    }else if (sender.tag == 1002){
        _countNum--;
    }
    
    if (_countNum<=0) {
        beforBtn.hidden = YES;
    }else{
        beforBtn.hidden = NO;
    }
    
    NSDate *tempDate = [NSDate dateAfterDate:[NSDate date] day:_countNum];
    _timeLabel.text = [NSDate formatYMD:tempDate];
    
    int timer = [tempDate timeIntervalSince1970];
    _requestTimeStr = [NSString stringWithFormat:@"%d",timer ];
    [self loadData];
}

- (void)buildSelect:(UIButton *)sender{
    FreeRoomViewController *vc = [[FreeRoomViewController alloc] init];
    vc.requestTimeStr = _requestTimeStr;
    vc.buildNoStr = _dataArray[sender.tag][@"JXLH"];
    vc.floorNum = [_dataArray[sender.tag][@"LCZS"] integerValue];
    vc.buildName = _dataArray[sender.tag][@"JXLM"];
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
