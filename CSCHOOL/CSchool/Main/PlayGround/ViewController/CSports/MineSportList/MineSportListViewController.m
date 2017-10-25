//
//  MineSportListViewController.m
//  CSchool
//
//  Created by mac on 17/3/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "MineSportListViewController.h"
#import "UIView+SDAutoLayout.h"
#import "SendMessageView.h"
#import "MySportView.h"
#import "SportListCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "SportsMainCell.h"
#import "DanMuView.h"
#import "LSEmojiFly.h"
//#import "MySportInfoViewController.h"
#import <YYModel.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+UIViewController.h"
#import "SportsMainViewController.h"
#import "SportInfoViewController.h"
@interface MineSportListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIImageView *headView;

@property (nonatomic,strong) MySportView *mySoportview;//

@property (nonatomic,strong) UITableView *mainTableview;

@property (strong, nonatomic) LSEmojiFly *emojiFlay;

@property (nonatomic,strong) NSTimer  *danmuTimer;

@property (nonatomic,strong)NSMutableArray *stepModelArray;

@property (nonatomic,strong)NSMutableArray *danmuArray;

@property (nonatomic,strong)DanMuView *danmuView;


@end

@implementation MineSportListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"您在群组%@的排名",_model.GROUPNAME];
    [self setHeadView];
    [self setMiddView];
    [self setTableView];
    self.view.backgroundColor = Base_Color2;
    [self loadBaseData];
    //获取全部好友步数信息
    [self loadMyFriendsStepData];
    [self initDanMuData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.danmuTimer invalidate];
}
-(void)loadMyFriendsStepData
{
    _stepModelArray = [NSMutableArray array];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL  parameters:@{@"rid":@"showFriendsSportsNumByGroup",@"groupid":_model.ROOMJID,@"groupcode":_model.SCODE,@"userid":[AppUserIndex GetInstance].role_id} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray *dataArr = responseObject[@"data"];
        if (dataArr.count==0) {
            [self showErrorView:@"获取列表失败.请稍后再试" andImageName:nil];
        
            return ;
        }
        //个人运动详情
        NSDictionary *dic = responseObject[@"data"];
        SportModel *midViewModel = [[SportModel alloc]init];
        [midViewModel yy_modelSetWithDictionary:dic];
        self.mySoportview.model = midViewModel;
        //该人是第一的话就掉落奖杯  并且超过截止点
        if ([midViewModel.pm  isEqualToString:@"1"]) {
            [self dropGlobView];
        }
        
        for (NSDictionary *dic in midViewModel.children) {
            SportModel *model = [[SportModel alloc]init];
            [model yy_modelSetWithDictionary:dic];
            [_stepModelArray addObject:model];
        }
        [self.mainTableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}
#pragma mark 弹幕
-(void)initDanMuData
{
    self.danmuArray = [NSMutableArray array];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL  parameters:@{@"rid":@"getBarrageInfo",@"userid":[AppUserIndex GetInstance].role_id,@"starttime":@"",@"endtime":@"",@"page":@"1",@"pageCount":@"100"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        for (NSDictionary *dic in responseObject[@"data"]) {
            SportModel *model = [[SportModel alloc]init];
            [model yy_modelSetWithDictionary:dic];
            [self.danmuArray addObject:model];
        }
        //处理数据
        self.danmuTimer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleDanmuDataByDataArr) userInfo:nil repeats:YES];
        [self.danmuTimer fire];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self.danmuTimer setFireDate:[NSDate distantFuture]];

    }];
   }
-(void)handleDanmuDataByDataArr
{
    if (self.danmuArray.count==0) {
        [self.danmuTimer invalidate];
        return;
    }
    SportModel *model = [self.danmuArray firstObject];
    self.danmuView = [[DanMuView alloc]initWithFrame:CGRectMake(kScreenWidth, arc4random()%(190), 300, 31)];
    self.danmuView.model = model;
    if (self.danmuArray.count>0) {
        [self.danmuArray removeObjectAtIndex:0];
        //将label加入本视图中去。
        [self.headView addSubview:self.danmuView];
        [self moveDanmu:self.danmuView];
    }else{
        [self.danmuTimer invalidate];
    }
}
-(void)moveDanmu:(DanMuView*)View
{
    [UIView animateWithDuration: 10 animations:^{
        View.frame = CGRectMake(-kScreenWidth-View.width, View.frame.origin.y, View.frame.size.width, View.frame.size.height);
    } completion:^(BOOL finished) {
        [View removeFromSuperview];
    }];
}
#pragma mark 获取背景图
-(void)loadBaseData
{
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL  parameters:@{@"rid":@"getPersonSportInfo",@"userid":[AppUserIndex GetInstance].role_id} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject [@"data"];
        SportModel *model = [[SportModel alloc]init];
        [model yy_modelSetWithDictionary:dic];
        NSString *breakString =[NSString stringWithFormat:@"/thumb"];
        NSString *photoUrl = [model.UMBIMGURL stringByReplacingOccurrencesOfString:breakString withString:@""];
        [_headView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"Sportbanner"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}
#pragma mark 初始化head
-(void)setHeadView
{
    self.headView = ({
        UIImageView *view = [UIImageView new];
        view.userInteractionEnabled= YES;
        view.image = [UIImage imageNamed:@"Sportbanner"];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        view;
    });
    [self.view addSubview:self.headView];
    self.headView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(kScreenHeight/3);
    UIButton *shieldBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"bgeOpen"] forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"bgeClose"] forState:UIControlStateSelected];
        [view addTarget:self action:@selector(danmuEndOrStart:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    SendMessageView *msgView = ({
        SendMessageView *view = [SendMessageView new];
        view;
    });
    [self.headView sd_addSubviews:@[shieldBtn,msgView]];
    shieldBtn.sd_layout.rightSpaceToView(self.headView,15).topSpaceToView(self.headView,5).widthIs(17).heightIs(21);
    msgView.sd_layout.leftSpaceToView(self.headView,0).rightSpaceToView(self.headView,0).heightIs(41).bottomSpaceToView(self.headView,0);
    
}
-(void)setMiddView
{
    self.mySoportview = ({
        MySportView *view = [MySportView new];
        view;
    });
    [self.view addSubview:self.mySoportview];
    self.mySoportview.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.headView,0).heightIs(60);
    self.mySoportview.model = [[SportModel alloc]init];
}
-(void)setTableView
{
    self.mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    self.mainTableview.delegate = self;
    self.mainTableview.dataSource = self;
    self.mainTableview.tableFooterView = [UIView new];
    [self.view addSubview:self.mainTableview];
    self.mainTableview.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(_mySoportview,6).heightIs(kScreenHeight-kScreenHeight/3-60-64-10);
}
#pragma mark 掉落奖杯
-(void)dropGlobView
{
    self.emojiFlay = [LSEmojiFly emojiFly];
    [self.emojiFlay startFlyWithEmojiImage:@[[UIImage imageNamed:@"sportCup"],[UIImage imageNamed:@"sport_Zand"],[UIImage imageNamed:@"suprise"]] onView:self.view];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(endFly) userInfo:nil repeats:NO];
}
#pragma mark  重置奖杯掉落动画

-(void)endFly
{
    [self.emojiFlay endFly];
}
#pragma mark 屏蔽或者打开弹幕
-(void)danmuEndOrStart:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.danmuTimer setFireDate:[NSDate distantFuture]];
    }else{
        [self.danmuTimer setFireDate:[NSDate date]];

    }
}

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stepModelArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"sportListcell";
    SportListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[SportListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.model =self.stepModelArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [SportListCell class];
    SportModel  *model = self.stepModelArray[indexPath.row];
    return [self.mainTableview cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SportInfoViewController *vc = [[SportInfoViewController alloc]init];
    SportModel *model = _stepModelArray[indexPath.row];
    vc.userID = model.yhbh;
    [self.navigationController pushViewController:vc animated:YES];

}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
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
