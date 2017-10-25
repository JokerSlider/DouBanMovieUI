//
//  FinfLosedViewController.m
//  CSchool
//
//  Created by mac on 16/8/22.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "FinfLosedViewController.h"
#import "SegmentTapView.h"
#import "FlipTableView.h"
#import "UIView+SDAutoLayout.h"
#import "TePopList.h"
#import "VTingSeaPopView.h"
#import "FindLose2Cell.h"
#import "FindLoseModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "MyPublishViewController.h"
#import "PushSearchViewController.h"
#import "FindInfoViewController.h"
#import "MyPublishBaseViewController.h"
#import "PushBaseViewController.h"
#import "MarketSendViewController.h"
#import "EditMymessageController.h"
#import "Reachability.h"
/*@"搜索条件"**/
#define Key1  @"name"
#define Key2 @"phonenum"
#define Key3 @"departments"
@interface FinfLosedViewController ()<UISearchBarDelegate,VTingPopItemSelectDelegate,SegmentTapViewDelegate,FlipTableViewDelegate,XGAlertViewDelegate>
{
    UIButton *_windowsBtn;
    UISearchBar *_customSearchBar;
    //两个发布按钮
    VTingSeaPopView *pop;
    UIWindow *_window;
}
@property(nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong)NSMutableArray *dataNameArray;//搜索数据源
@property (nonatomic,strong)NSArray *iconImageNamesArray;
//区分不同的功能数据 
@property (nonatomic,strong)NSArray *imageArr;//按钮图标
@property (nonatomic,strong)NSArray *MenutitleArr;//按钮标题
@property (nonatomic,strong)NSArray *titleArr;//标题
@property (nonatomic,strong)NSString *searbarPlacehoder;//搜索框
//灰色视图
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong)SegmentTapView *segment;
@property (nonatomic, strong)FlipTableView *flipView;
@end

@implementation FinfLosedViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
       if (_customSearchBar) {
        _customSearchBar.hidden = NO;
    }
    if (_windowsBtn) {
        _windowsBtn.hidden = NO;
    }
    AppUserIndex *user = [AppUserIndex GetInstance];
    if ([user.headImageUrl isEqualToString:@""] || [user.nickName isEqualToString:@""]) {
        XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"请先设置昵称和头像后使用！" WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
        alert.isBackClick = YES;
        alert.tag = 101;
        [alert show];
        return;
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _customSearchBar.hidden = YES;
    _windowsBtn.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBaseData];
    [self createView];
    [self.view setExclusiveTouch:YES];
    
}
//加载基本数据
-(void)loadBaseData
{
    if ([_funcType isEqualToString:@"1"]) {
        self.MenutitleArr = @[@"失物发布",@"招领发布"];
        self.titleArr = @[@"寻物启事",@"招领启事"];
        self.imageArr = @[@"add_Lost",@"add_Found"];
        self.searbarPlacehoder = @"搜索你要找的物品";
    }else if([_funcType isEqualToString:@"3"]){
        self.MenutitleArr = @[@"招聘发布",@"求职发布"];
        self.titleArr = @[@"招聘专区",@"求职专区"];
        self.imageArr = @[@"add_zhaopin",@"add_qiuzhi"];
        self.searbarPlacehoder = @"搜索你想做的兼职";
    }else{
        self.MenutitleArr = @[@"商品发布",@"求购发布"];
        self.titleArr = @[@"闲置市场",@"求购市场"];
        self.imageArr = @[@"add_shangpin",@"add_qiiugou"];
        self.searbarPlacehoder = @"搜索你想要的商品";
    }

}

-(void)createView{
    CGRect mainViewBounds = self.navigationController.view.bounds;
    _customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, mainViewBounds.size.width-120, 31)];
    _customSearchBar.delegate = self;
    _customSearchBar.backgroundColor = Base_Orange;
    _customSearchBar.placeholder  = self.searbarPlacehoder;
    _customSearchBar.showsCancelButton = NO;
    _customSearchBar.searchBarStyle = UISearchBarStyleDefault;
    
    //将搜索条放在一个UIView上
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(-50, 0, mainViewBounds.size.width-120, 31)];
    [searchView addSubview:_customSearchBar];
    self.navigationItem.titleView = searchView;
    
    for (UIView *view in _customSearchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    
    UIButton *myZone = [UIButton buttonWithType:UIButtonTypeCustom];
    [myZone setBackgroundImage:[UIImage imageNamed:@"my_head"] forState:UIControlStateNormal];
    myZone.frame = CGRectMake(0, 0, 30, 30);
    [myZone addTarget:self action:@selector(myZoneAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:myZone];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadsegMent];
}
//加载分段视图 并加载数据
-(void)loadsegMent
{
    [self addWindowBtn];
    _news = [[FindViewController alloc]init];
    _news2 = [[ReceiveViewController alloc]init];
    _news.funcType = _funcType;
    _news2.funcType = _funcType;
    [_news loadData];
    NSArray *controllers=@[_news,_news2];
    _titleArray =self.titleArr;
    // 分段视图
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 40) withDataArray:_titleArr withFont:13];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, self.view.frame.size.height - 40) withArray:controllers withRootVC:self];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];

}

/*@"懒加载"*/
-(NSMutableArray *)dataNameArray
{
    if (!_dataNameArray) {
        _dataNameArray = [NSMutableArray array];
    }
    return _dataNameArray;
}
/*@"创建window按钮"*/
-(void)addWindowBtn
{
    _window  = [UIApplication sharedApplication].keyWindow;
    _windowsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_windowsBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    _windowsBtn.frame =CGRectMake(kScreenWidth-70, kScreenHeight-70, 50, 50);
    [_windowsBtn addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
    [_window addSubview:_windowsBtn];
    pop = [[VTingSeaPopView alloc] initWithButtonBGImageArr:_imageArr andButtonBGT:_MenutitleArr];
    pop.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coviewHiddeAction)];
    [pop.contentViewLeft addGestureRecognizer:tap];
}
#pragma CXAlterItemButtonDelegate 悬浮按钮点击事件
-(void)showAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_window addSubview:pop];
        [pop show];
    }else
    {
        [pop dismissSelfBtn];
        [pop removeFromSuperview];
    }
}
-(void)coviewHiddeAction
{
    [pop dismissSelfBtn];
    _windowsBtn.selected = !_windowsBtn.selected;
}
#pragma mark delegate
-(void)itemDidSelected:(NSInteger)index {
    _windowsBtn.selected = !_windowsBtn.selected;
    //发布  传functype 代表不同的功能(二手市场、失物招领、兼职招聘)
    MarketSendViewController *vc = [[MarketSendViewController alloc] init];
    vc.module = _funcType;
    vc.reltype = [NSString stringWithFormat:@"%ld",index+1];
    vc.sendSucessBlock = ^(NSString *relType){
        if ([relType isEqualToString:@"1"]) {
            [_news loadPushData];
        }else{
            [_news2 loadReData];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -------- select Index
-(void)selectedIndex:(NSInteger)index
{
    if (index==0) {
        [_news loadPushData];
    }else{
//        [_news2 loadNewData];
    }
    
    [self.flipView selectIndex:index];
    
}
-(void)scrollChangeToIndex:(NSInteger)index
{
    if (index==0) {
        [_news loadPushData];
    }else{
//        [_news2 loadNewData];
    }
    [self.segment selectIndex:index];
}
#pragma  mark myZoneAction 个人中心点击事件
-(void)myZoneAction:(UIButton *)sender
{
    /*@"跳转到个人中心"*/
    MyPublishViewController *vc = [[MyPublishViewController alloc]init];
    vc.titleArray = _titleArr;
    vc.funcType = _funcType;//1,2,3代表不同功能的请求
    vc.block = ^(NSString *relType){
        if ([relType isEqualToString:@"1"]) {
            [_news loadPushData];
        }else if ([relType isEqualToString:@"2"]){
            [_news2 loadReData];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma  mark searchDeledate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    PushSearchViewController *vc = [[PushSearchViewController alloc]init];
    vc.funcType = _funcType;//1.2.3代表不同功能的请求
    vc.placeholder = [_funcType isEqualToString:@"2"]?@"标题/学校/标签":@"标题/学校";
    NSLog(@"%@",self.navigationController);
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}
- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title{
    if (view.tag == 101) {
        EditMymessageController *vc = [[EditMymessageController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)alertView:(XGAlertView *)view didClickCancel:(NSString *)title{
    if (view.tag == 101) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark SearchViewDelegate
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
