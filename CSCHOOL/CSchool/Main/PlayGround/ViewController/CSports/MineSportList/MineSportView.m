//
//  MineSportView.m
//  CSchool
//
//  Created by mac on 17/3/17.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "MineSportView.h"
#import "UIView+SDAutoLayout.h"
#import "SendMessageView.h"
#import "MySportView.h"
#import "SportListCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "SportsMainCell.h"
#import "DanMuView.h"
#import "LSEmojiFly.h"
#import <YYModel.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+UIViewController.h"
#import "SportsMainViewController.h"
#import "SportInfoViewController.h"
@interface MineSportView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIImageView *headView;

@property (nonatomic,strong) MySportView *mySoportview;//

@property (nonatomic,strong) UITableView *mainTableview;

@property (strong, nonatomic) LSEmojiFly *emojiFlay;

@property (nonatomic,strong)DanMuView *danmuView;

@property (nonatomic,strong)NSMutableArray *stepModelArray;

@property (nonatomic,strong)NSMutableArray *danmuArray;


@property (nonatomic,assign)BOOL  isEnd;//弹幕是否已经消失
@end
@implementation MineSportView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setHeadView];
        [self setMiddView];
        [self setTableView];
        self.backgroundColor = Base_Color2;
        [self loadBaseData];
        //获取全部好友步数信息
        [self loadMyFriendsStepData];
        //获取弹幕数据  只获取一次   展示一次
        [self initDanMuData];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadBaseData) name:@"ChangeSportMainImage" object:nil];
    }
    return self;
}

-(void)loadMyFriendsStepData
{
    _stepModelArray = [NSMutableArray array];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL  parameters:@{@"rid":@"showFriendsSportsNum",@"userid":[AppUserIndex GetInstance].role_id} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        //个人运动详情
        NSDictionary *dic = responseObject[@"data"];
        SportModel *midViewModel = [[SportModel alloc]init];
        [midViewModel yy_modelSetWithDictionary:dic];
        self.mySoportview.model = midViewModel;
        //该人是第一的话就掉落奖杯
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
        [ProgressHUD dismiss];
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
        [self.headView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"Sportbanner"]];
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
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        view.clipsToBounds = YES;
        [view setContentScaleFactor:[[UIScreen mainScreen] scale]];
        view;
    });
    [self addSubview:self.headView];
    self.headView.sd_layout.leftSpaceToView(self,0).topSpaceToView(self,0).rightSpaceToView(self,0).heightIs(kScreenHeight/3);
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
    msgView.sendDanMuMessageSuccessblock = ^(NSString *danmuStr){
        SportModel *model =[[SportModel alloc]init];
        self.danmuView = [[DanMuView alloc]initWithFrame:CGRectMake(kScreenWidth, arc4random()%(190), 300, 31)];
        model.NC = [AppUserIndex GetInstance].nickName;
        model.TXDZ = [AppUserIndex GetInstance].headImageUrl;
        model.SMICONTENT = danmuStr;
        self.danmuView.model = model;
        //将label加入本视图中去。
        [self.headView addSubview:self.danmuView];
        [self moveDanmu:self.danmuView];
        
    };
    
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
    [self addSubview:self.mySoportview];
    self.mySoportview.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).topSpaceToView(self.headView,0).heightIs(60);
}
-(void)setTableView
{
    self.mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    self.mainTableview.delegate = self;
    self.mainTableview.dataSource = self;
    self.mainTableview.tableFooterView = [UIView new];
    [self addSubview:self.mainTableview];
    self.mainTableview.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).topSpaceToView(_mySoportview,6).heightIs(kScreenHeight-kScreenHeight/3-60-64-10);
}
#pragma mark 掉落奖杯
-(void)dropGlobView
{
//    //大于某个时间点就不再上传数据
//    NSDate *now = [NSDate date];
//    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
//    [formatter1 setDateStyle:NSDateFormatterMediumStyle];
//    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *dateStr1 = [formatter1 stringFromDate:now];
//    NSArray *array=[dateStr1 componentsSeparatedByString:@" "];
//    
//    NSArray *array1=[[array objectAtIndex:1] componentsSeparatedByString:@":"];
//    //晚上九点半点之后不再上传数据
//    if ([[array1 objectAtIndex:0] intValue]>=21&[[array1 objectAtIndex:1]intValue]>=30) {
//        self.emojiFlay = [LSEmojiFly emojiFly];
//        [self.emojiFlay startFlyWithEmojiImage:@[[UIImage imageNamed:@"sportCup"],[UIImage imageNamed:@"sport_Zand"]] onView:self];
//        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(endFly) userInfo:nil repeats:NO];
//        if (![[NSUserDefaults standardUserDefaults]objectForKey:@"hasFly"]) {
//            self.emojiFlay = [LSEmojiFly emojiFly];
//            [self.emojiFlay startFlyWithEmojiImage:@[[UIImage imageNamed:@"sportCup"],[UIImage imageNamed:@"sport_Zand"]] onView:self];
//            [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(endFly) userInfo:nil repeats:NO];
//            [[NSUserDefaults standardUserDefaults]setValue:@"hasFly" forKey:@"hasFly"];
//        }
//        
//    }else{
//    
//        NSLog(@"还不到时间掉奖杯");
//    }
    self.emojiFlay = [LSEmojiFly emojiFly];
    [self.emojiFlay startFlyWithEmojiImage:@[[UIImage imageNamed:@"sportCup"],[UIImage imageNamed:@"sport_Zand"],[UIImage imageNamed:@"suprise"]] onView:self];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(endFly) userInfo:nil repeats:NO];

}
#pragma mark  重置奖杯掉落动画
//-(void)resetGloView
//{
//    NSDate *now = [NSDate date];
//    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
//    [formatter1 setDateStyle:NSDateFormatterMediumStyle];
//    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *dateStr1 = [formatter1 stringFromDate:now];
//    NSArray *array=[dateStr1 componentsSeparatedByString:@" "];
//    
//    NSArray *array1=[[array objectAtIndex:1] componentsSeparatedByString:@":"];
//    //早上6点之后重置掉落动画
//    if ([[array1 objectAtIndex:0] intValue]>6&&([[array1 objectAtIndex:0] intValue]<=21&[[array1 objectAtIndex:1]intValue]<=30)) {
//        //重置
//        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"hasFly"];
//    }
//  
//}

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
    [self.viewController.navigationController pushViewController:vc animated:YES];

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

@end
