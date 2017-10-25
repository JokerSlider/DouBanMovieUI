//
//  LotterDrawController.m
//  CSchool
//
//  Created by mac on 17/5/10.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "LotterDrawController.h"
#import "UIView+SDAutoLayout.h"
#import "LSEmojiFly.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PriseAlertView.h"
#import "DrawPriseWord.h"
#import "PriseModel.h"
#import <YYModel.h>
#import "ActivityModel.h"
#import "AutoWebViewController.h"
#import "MyPriseListController.h"
#define pointWidth  100
#define defaultTime 2
@interface LotteryItem : NSObject
@property(nonatomic,copy)NSNumber   *time;
@property(nonatomic,assign)int      angle;
@end
@implementation LotteryItem
@end
@interface LotterDrawController ()<CAAnimationDelegate>
{
    NSString * _strPrise ;

}
@property (nonatomic,retain) UIImageView  *bgView;//背景视图
@property (nonatomic,retain) UIView       *popView;//弹出视图
@property (nonatomic,retain) UILabel      *priseLabel;//中奖Label 展示中奖次数  展示是否中奖
@property (nonatomic,retain) UIButton     *myLatterBtn;//我的中奖
@property (nonatomic,retain) UIButton     *startLatter;//开始抽奖
@property (nonatomic,retain) UIImageView  *latterView;//转盘
@property (nonatomic,retain) UIImageView  *pointView;//指针视图
@property (nonatomic,retain) UIScrollView  *mainScroview;
@property(nonatomic,strong)  NSMutableArray *arrAngle;//奖品范围
@property (strong, nonatomic) LSEmojiFly *emojiFlay;
@property (nonatomic,strong) UIButton *infoImageView;//活动详情
@property (nonatomic,assign) int   level;//奖品等级
@property (nonatomic,strong)DrawPriseWord *prisewordView;
@property (nonatomic,strong)NSMutableArray *priseNameArr;//奖品名称
@property (nonatomic,strong)NSMutableArray *priseIDArr;//奖品ID数组

@property (nonatomic,strong)PriseModel *priseModel;
@property (nonatomic,copy)NSString *lotteryNum;//可以抽奖次数

//@property (nonatomic)

@end

@implementation LotterDrawController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"抽奖";
    self.view.backgroundColor = Base_Color2 ;
    [self createView];
    [self loadData];
//    if (!self.isUse) {
//        [JohnAlertManager showFailedAlert:@"活动尚未开始,敬请期待!" andTitle:@"提示"];
//    }
}


-(void)loadData
{
    self.priseNameArr = [NSMutableArray array];
    self.arrAngle   = [NSMutableArray array];
    self.priseIDArr = [NSMutableArray array];
    NSMutableArray *nameArr = [NSMutableArray array];
    NSMutableArray *anleArr = [NSMutableArray array];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showPrizeActivityList",@"id":self.activityID} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray *dataSourarr = [responseObject objectForKey:@"data"];
        if (dataSourarr.count==0) {
            [JohnAlertManager showFailedAlert:@"暂无活动信息，请稍后再试!" andTitle:@"提示"];
            self.startLatter.enabled = NO;
            return ;
        }
        for (NSDictionary *dic in dataSourarr) {
            PriseModel   *model = [[PriseModel alloc] init];
            NSArray *singleAnglearr = [NSArray array];
            NSMutableArray *totalAngleArr = [NSMutableArray array];
            [model yy_modelSetWithDictionary:dic];
            singleAnglearr = [model.destription componentsSeparatedByString:@";"];
            for (NSString *obj in singleAnglearr) {
                NSArray *angleArrinfo = [obj componentsSeparatedByString:@","];
                [totalAngleArr addObject:angleArrinfo];
                [nameArr addObject:model.priseName];
                [anleArr addObject:angleArrinfo];
            }
            [self.arrAngle addObject:totalAngleArr];
            [self.priseNameArr addObject:model.priseName];
            [self.priseIDArr addObject:model.priseID];//活动ID
        }
        [self drawLatterViewWithNameArr:nameArr andAngleArr:anleArr];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}
#pragma mark 绘制圆盘
-(void)drawLatterViewWithNameArr:(NSArray *)nameArr andAngleArr:(NSArray *)angleArr
{
    NSArray *checkArr = [angleArr firstObject];
    if (checkArr.count<=1) {
        [JohnAlertManager showFailedAlert:@"暂无活动信息哦~" andTitle:@"提示"];
        self.startLatter.enabled = NO;
        return;
    }
    NSMutableArray *angleValueArr = [NSMutableArray array];
    NSMutableDictionary *mudic = [NSMutableDictionary dictionary];
    for (NSArray *arrObj in angleArr) {
        [angleValueArr addObject:arrObj[1]];
    }
    for (int i = 0; i<nameArr.count; i++) {
        [mudic setValue:nameArr[i] forKey:angleValueArr[i]];
    }
    [angleValueArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 intValue]>[obj2 intValue]) {
            return NSOrderedDescending;
        }else{
            return  NSOrderedAscending;
        }
    }];
    NSMutableArray *finalNameArr = [NSMutableArray array];
    for (int i = 0; i<angleValueArr.count; i++) {
        NSString *key =angleValueArr[i];
        NSString *name = [mudic valueForKey:key];
        [finalNameArr addObject:name];
    }
    [self.prisewordView showPieWithAccountArray:finalNameArr withcenterPoint:self.mainScroview.center];
    

}
#pragma mark 创建视图
-(void)createView
{
    self.mainScroview = ({
        UIScrollView *view = [UIScrollView new];
        view;
    });
    self.infoImageView =({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"activeInfo"] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(openActivityInfo) forControlEvents:UIControlEventTouchDown];
        view;
    });
    
    //背景
    self.bgView = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"priseBg"];
        view.contentMode = UIViewContentModeScaleToFill;
        view.userInteractionEnabled = YES;
        view;
    });
    //转盘
    self.latterView = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"zhuanView"];
        view.contentMode = UIViewContentModeScaleToFill;
        view.userInteractionEnabled = YES;
        view;
    });
    //指针
    self.pointView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-pointWidth/2, kScreenHeight/6+(kScreenWidth-50)/2-pointWidth/2, pointWidth, pointWidth)];
    self.pointView.image = [UIImage imageNamed:@"prisePoint"];
    self.pointView.contentMode = UIViewContentModeScaleAspectFit;
    self.pointView.layer.anchorPoint = CGPointMake(0.5, 0.58);
    self.pointView.userInteractionEnabled = self.isUse;//根据活动的状态判断是否可以点击
 
    //开始抽奖按钮
    self.startLatter = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"startPrise"] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(latterPriseAction:) forControlEvents:UIControlEventTouchDown];
        view;
    });
    //中奖纪录显示文字
    self.priseLabel = ({
        UILabel *view = [UILabel new];
//        [view setText:@"欢迎来到幸运大转盘抽奖！"];
        view.font = [UIFont fontWithName:@"GeeZaPro-Bold" size:18];
        view.textColor = [UIColor whiteColor];
        view;
    });
    //打开我的中奖纪录
    self.myLatterBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.titleLabel.font = [UIFont fontWithName:@"GeeZaPro-Bold" size:18];
        [view setImage:[UIImage imageNamed:@"Myprise"] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(openMyLatterView) forControlEvents:UIControlEventTouchDown];
        view;
    });


    self.mainScroview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).widthIs(kScreenWidth).heightIs(kScreenHeight);
    [self.view addSubview:self.mainScroview ];
    [self.mainScroview addSubview:self.bgView];
    //获取数据书写文字
    self.prisewordView = [[DrawPriseWord alloc]initWithFrame:self.mainScroview.bounds];
    [self.mainScroview addSubview:self.prisewordView];
    [self.mainScroview addSubview:self.latterView];
    [self.mainScroview addSubview:self.prisewordView];
    
    [self.mainScroview sd_addSubviews:@[self.priseLabel,self.myLatterBtn,self.pointView,self.startLatter,self.infoImageView]];

    
    self.bgView.sd_layout.leftSpaceToView(self.mainScroview,0).topSpaceToView(self.mainScroview,0).bottomSpaceToView(self.mainScroview,0).rightSpaceToView(self.mainScroview,0);//背景图
    self.latterView.sd_layout.centerXIs(self.mainScroview.centerX).centerYIs(kScreenHeight/6+(kScreenWidth-50)/2).widthIs(kScreenWidth-50).heightIs(kScreenWidth-50);//转盘
    
    self.infoImageView.sd_layout.leftSpaceToView(self.latterView,-(kScreenWidth-50)/4+7).topSpaceToView(self.mainScroview,kScreenHeight/6-2).widthIs(80).heightIs(31);
    self.startLatter.sd_layout.centerXIs(self.mainScroview.centerX).topSpaceToView(self.mainScroview,kScreenHeight/6+(kScreenWidth-50)/2-50).widthIs(100).heightIs(100);//开始抽奖
    self.priseLabel.sd_layout.centerXIs(self.mainScroview.centerX).topSpaceToView(self.latterView,30).heightIs(25);//开始转盘
    self.myLatterBtn.sd_layout.centerXIs(self.mainScroview.centerX).topSpaceToView(self.priseLabel,20).widthIs(100).heightIs(30);//打开我的中奖纪录
    [self.mainScroview setupAutoContentSizeWithBottomView:self.myLatterBtn bottomMargin:90];
    //调整宽度
    CGSize size = [self.priseLabel boundingRectWithSize:CGSizeMake(0, 25)];
    self.priseLabel.sd_layout.widthIs(size.width);
    size = [self.myLatterBtn.titleLabel boundingRectWithSize:CGSizeMake(0, 30)];
    self.myLatterBtn.sd_layout.widthIs(size.width+self.myLatterBtn.imageView.bounds.size.width+30);

    
}

#pragma 抽奖事件处理
-(void)latterPriseAction:(UIButton *)sender
{
    self.startLatter.enabled = NO;
    [ProgressHUD show:@"正在抽奖..."];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"luckyDraw",@"activityId":self.activityID,@"stuNo":[AppUserIndex GetInstance].role_id} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        CGSize size = [self.priseLabel boundingRectWithSize:CGSizeMake(0, 25)];
        self.priseLabel.sd_layout.widthIs(size.width);
        NSDictionary *dic = [responseObject objectForKey:@"data"];
        PriseModel   *model = [[PriseModel alloc]init];
        [model yy_modelSetWithDictionary:dic];
        self.priseModel = [[PriseModel alloc]init];
        self.priseModel = model;
        _strPrise =  model.awardName;  ;
        [self getAngleFromActivityID: model.awardId];
        self.priseLabel.sd_layout.widthIs(size.width);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
        [JohnAlertManager showFailedAlert:error[@"msg"] andTitle:@"提示"];
    }];
}
#pragma mark 获取下标
-(void)getAngleFromActivityID:(NSString *)indexValue
{
    int index = 0 ;
    for (int i = 0; i<self.priseIDArr.count; i++) {
        NSString *value = self.priseIDArr[i];
        if ([value isEqualToString:indexValue]) {
            index = i;
            //网络获取index
            self.level = index;
            LotteryItem *item = [[LotteryItem alloc] init];
            item.time = [NSNumber numberWithDouble:0.1];
            item.angle = [self getAngle:index];
            [self lotteryAction:item];
        }
    }
   

}
#pragma mark  根据下标获取指针最终停滞的角度
- (int)getAngle:(int)index
{
    NSArray* arr = [_arrAngle objectAtIndex:index];
    int x = arc4random() % arr.count;
    NSArray* arrJu = [arr objectAtIndex:x];
    int centerAngle = ([[arrJu objectAtIndex:1] intValue] - [[arrJu objectAtIndex:0] intValue])/2 + [[arrJu objectAtIndex:0] intValue];
    return centerAngle;
}

- (void)lotteryAction:(LotteryItem*)item
{
    if([item.time doubleValue] > defaultTime)
    {
        if(item.angle > 180)
        {
            [UIView animateWithDuration:[item.time doubleValue] animations:^{
                self.pointView.transform=CGAffineTransformMakeRotation(180*M_PI/180);
            }];
        }
    
        //如果是特等奖  或者 没中奖  就不弹出页面   无法判断中奖等级
        [UIView animateWithDuration:[item.time doubleValue] animations:^{
            self.pointView.transform=CGAffineTransformMakeRotation(item.angle*M_PI/180);
        }completion:^(BOOL finished) {
            self.startLatter.enabled = YES;//改为NO
            [self winThePrise];
        }];
    }
    else
    {
        self.startLatter.enabled = NO;
        [UIView animateWithDuration:[item.time doubleValue] animations:^{
            self.pointView.transform=CGAffineTransformMakeRotation(180*M_PI/180);
        }];
        
        
        [UIView animateWithDuration:[item.time doubleValue] animations:^{
            self.pointView.transform=CGAffineTransformMakeRotation(360*M_PI/180);
        }];
        
        NSNumber* animationTime = [NSNumber numberWithDouble:[item.time doubleValue] + 0.1];
        
        LotteryItem* newItem = [[LotteryItem alloc] init];
        newItem.time = animationTime;
        newItem.angle = item.angle;
        [self performSelector:@selector(lotteryAction:) withObject:newItem afterDelay:[item.time doubleValue] - [item.time doubleValue] / 2];
    }
}
-(void)endFly
{
    [self.emojiFlay endFly];
}
//抽奖成功 弹窗
-(void)winThePrise
{
    PriseAlertView *view = [[PriseAlertView alloc]initWithPriseViewwithPriseLevel:self.level];
    view.model = self.priseModel;
    [UIView animateWithDuration:.5 animations:^{
        view.transform = CGAffineTransformMakeScale(1.2, 1.2);
        [self.view addSubview:view];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            view.transform = CGAffineTransformIdentity;
        }];
    }];
}
#pragma mark 打开我的中奖纪录
-(void)openMyLatterView
{
    MyPriseListController *vc = [MyPriseListController new];
    vc.activityID = self.activityID;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark  打开活动详情
-(void)openActivityInfo
{
    AutoWebViewController *vc = [[AutoWebViewController alloc] init];
    vc.commitDic = @{@"rid":@"showActivityDesById",@"id":self.activityID};
    vc.valueForKeyPath = @"data.content";
    vc.navigationItem.title = @"活动详情";
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
