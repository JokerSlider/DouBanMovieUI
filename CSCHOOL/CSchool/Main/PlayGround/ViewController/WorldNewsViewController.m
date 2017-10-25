//
//  WorldNewsViewController.m
//  CSchool
//
//  Created by mac on 17/1/17.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "WorldNewsViewController.h"
#import "ZJScrollPageView.h"
#import "WordNewsTableViewController.h"
#import "WorldNewsSearchViewController.h"
#import "WorldNewsFirstSelectViewController.h"
#import "LRLChannelEditController.h"

@interface WorldNewsViewController ()<ZJScrollPageViewDelegate>
@property(strong, nonatomic)NSMutableArray<NSString *> *titles;
@property (nonatomic,strong)ZJScrollPageView *scrollPageView ;

@property (nonatomic, copy) NSArray *selectArray;
@property (nonatomic,strong)  NSMutableArray *titleSelectArr;//选中的标题数组
@property (nonatomic,strong)NSMutableArray *selctIDArray;//选中id
@end

@implementation WorldNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"天下事";
    [self addSearchView];
    self.view.backgroundColor = Base_Color2;
    self.titles = [NSMutableArray array];
    self.titleSelectArr = [NSMutableArray array];
    self.selctIDArray   = [NSMutableArray array];
    [self getMyNewsTagData];
}
-(void)firstopenChooseTitles
{
    //    首次打开新闻弹出种类选择
    WorldNewsFirstSelectViewController *vc = [[WorldNewsFirstSelectViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    WEAKSELF;
    vc.closeVCBliock = ^(NSArray *selectArray){
        NSLog(@"%@",selectArray);
        _selectArray = selectArray;
        _titleSelectArr = [NSMutableArray arrayWithArray:selectArray];
        [self createTitleSegment];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"firstOpenNews2"];
        NSMutableArray *cidStringArray = [NSMutableArray array];
        for (NSDictionary *dic in selectArray) {
            [cidStringArray addObject:dic[@"ID"]];
        }
        NSString *cidStringID = [cidStringArray componentsJoinedByString:@","];
        NSLog(@"%@",cidStringID);
        [weakSelf uploadIDString:cidStringID withFunction:@"1"];
    };
}
//获取我得标签
-(void)getMyNewsTagData
{
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getMyNewsTags",@"userid":[AppUserIndex GetInstance].role_id} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        for (NSDictionary *dic in responseObject[@"data"]) {
            [self.titles addObject:dic[@"NAME"]];
            [self.selctIDArray addObject:dic[@"ID"]];
        }
        _selectArray = responseObject[@"data"];
        if (self.titles.count!=0) {
            [self createTitleSegment];
        }else{
            [self firstopenChooseTitles];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
    
    }];
}
-(void)createTitleSegment
{
    for (NSDictionary *dic in _titleSelectArr) {
        [self.titles addObject:dic[@"NAME"]];
        [self.selctIDArray addObject:dic[@"ID"]];
    }
    
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    // 缩放标题
    style.scaleTitle = YES;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    // 设置附加按钮的背景图片
    
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    // 这里可以设置头部视图的属性(背景色, 圆角, 背景图片...)
    //    scrollPageView.segmentView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_scrollPageView];

    
    // 添加标题按钮
    UIButton *add_title = [UIButton buttonWithType:UIButtonTypeCustom];
    add_title.frame = CGRectMake(kScreenWidth-41, 0, 41, 40);
    [add_title setImage:[UIImage imageNamed:@"news_add"] forState:UIControlStateNormal];
    [add_title addTarget:self action:@selector(addTitle) forControlEvents:UIControlEventTouchUpInside];
    add_title.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:add_title];
}
#pragma mark 添加搜索按钮
-(void)addSearchView
{
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(50, 0, 50, 50);
    [searchBtn setImage:[UIImage imageNamed:@"news_sou"] forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(openMyZone) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];

}
#pragma mark 点击添加或者删除标题
-(void)addTitle
{
    //重新设置titles的方法。
    [self showSelVC];
    
}
-(void)resetTitles
{
    for (NSDictionary *dic in _titleSelectArr) {
        [self.titles addObject:dic[@"NAME"]];
        [self.selctIDArray addObject:dic[@"ID"]];
    }

    [_scrollPageView reloadWithNewTitles:self.titles];
}
- (void)showSelVC{

    LRLChannelEditController *channelEdit = [[LRLChannelEditController alloc] initWithTopDataSource:_selectArray andBottomDataSource:nil andInitialIndex:0];
    
    //编辑后的回调
    WEAKSELF;
    channelEdit.removeInitialIndexBlock = ^(NSMutableArray<ChannelUnitModel *> *topArr, NSMutableArray<ChannelUnitModel *> *bottomArr){
//        weakSelf.topChannelArr = topArr;
//        weakSelf.bottomChannelArr = bottomArr;
//        NSLog(@"删除了初始选中项的回调:\n保留的频道有: %@", topArr);
        //初始化
        self.titleSelectArr = [NSMutableArray array];
        self.titles  =[NSMutableArray array];
        self.selctIDArray = [NSMutableArray array];
        NSMutableArray *cidStringArray = [NSMutableArray array];
        for (ChannelUnitModel *model in topArr) {
            NSDictionary *dic = @{
                                  @"ID":model.cid,
                                  @"NAME":model.name
                                  };
            
            [self.titleSelectArr addObject:dic];
            [cidStringArray addObject:model.cid];
        }
        [self resetTitles];
        NSString *cidStringID = [cidStringArray componentsJoinedByString:@","];
        NSLog(@"%@",cidStringID);
        [weakSelf uploadIDString:cidStringID withFunction:@"2"];
    };
    channelEdit.chooseIndexBlock = ^(NSInteger index, NSMutableArray<ChannelUnitModel *> *topArr, NSMutableArray<ChannelUnitModel *> *bottomArr){
//        weakSelf.topChannelArr = topArr;
//        weakSelf.bottomChannelArr = bottomArr;
//        weakSelf.chooseIndex = index;
        NSLog(@"选中了某一项的回调:\n保留的频道有: %@, 选中第%ld个频道", topArr, index);
    };
    
    channelEdit.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:channelEdit animated:YES completion:nil];
}

- (void)uploadIDString:(NSString *)tags withFunction:(NSString *)function{
    
    NSDictionary *commitDic = @{
                                @"rid":@"addMyNewsTag",
                                @"tags":tags,
                                @"userid":[AppUserIndex GetInstance].role_id,//[AppUserIndex GetInstance].role_id,
                                @"function":function
                                };
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}

#pragma mark 搜索按钮点击
-(void)openMyZone
{
    WorldNewsSearchViewController *vc = [[WorldNewsSearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma ZJScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    //    NSLog(@"%ld---------", index);
    
    if (!childVc) {
        childVc = [[WordNewsTableViewController alloc] init];
        childVc.title = self.titles[index];
        WordNewsTableViewController *vc =(WordNewsTableViewController *)childVc;
        vc.selectIDArr = _selctIDArray;
    }
    
    return childVc;
}


- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    NSLog(@"%ld ---将要出现",index);
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    NSLog(@"%ld ---已经出现",index);
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    NSLog(@"%ld ---将要消失",index);
    
}
- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    NSLog(@"%ld ---已经消失",index);
    
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
