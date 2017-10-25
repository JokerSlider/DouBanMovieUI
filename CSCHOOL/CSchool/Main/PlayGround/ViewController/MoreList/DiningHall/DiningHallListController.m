//
//  DiningHallListController.m
//  CSchool
//
//  Created by mac on 17/9/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "DiningHallListController.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "DHListCell.h"
#import "TableViewAnimationKitHeaders.h"
#import "DingHallChartView.h"
@interface DiningHallListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UISegmentedControl *segMentView;

@property (nonatomic,assign)int  status;

@property (nonatomic,strong)NSMutableArray *modelArr;

@property (nonatomic,strong)DingHallChartView *chartView;
@end

@implementation DiningHallListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Base_Color2;
    self.title = @"餐厅排行榜";
    [self createView];
    
    _status = 1;
    [self loadData];
}

-(void)createView
{
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"周榜",@"月榜",@"季榜",@"年榜",nil];
    _segMentView  = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segMentView.frame = CGRectMake(10, 15, kScreenWidth-20, 30);
    _segMentView.selectedSegmentIndex = 0;
    _segMentView.tintColor = RGB(170, 170, 170);
    _segMentView.backgroundColor = [UIColor whiteColor];
    [_segMentView addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:14.0],UITextAttributeFont,nil];
    [_segMentView setTitleTextAttributes:dic forState:UIControlStateSelected];
    NSDictionary *noseDic = [NSDictionary dictionaryWithObjectsAndKeys:RGB(85,85,85),UITextAttributeTextColor,[UIFont systemFontOfSize:14.0],UITextAttributeFont,nil];
    [_segMentView setTitleTextAttributes:noseDic forState:UIControlStateNormal];
    [self.view addSubview:_segMentView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, kScreenWidth, kScreenHeight-64-30-15) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = Base_Color2;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self starAnimationWithTableView:self.tableView];
    
    self.chartView = [[DingHallChartView alloc]initWithFrame:CGRectMake(0, 45, kScreenWidth, kScreenHeight-45)];
    self.chartView.hidden = YES;
    [self.view addSubview:self.chartView];
    
    UIButton *changeCahrt = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.frame = CGRectMake(0, 0, 50, 50);
        [view setTitle:@"切换" forState:UIControlStateNormal];
        [view addTarget:self action:@selector(changeChart) forControlEvents:UIControlEventTouchUpInside];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        view;
    });
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:changeCahrt];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
-(void)loadData{
    _modelArr = [NSMutableArray array];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"windowConsumeRankingList",@"status":@(self.status)} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray *sourcArr = responseObject[@"data"];
        for (NSDictionary *dic in sourcArr) {
            DHListModel *model = [[DHListModel alloc]init];
            [model yy_modelSetWithDictionary:dic];
            [_modelArr addObject:model];
        }
        [self setChartData:_modelArr];
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}

#pragma mark 切换视图
-(void)changeChart{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:2];
    [UIView setAnimationTransition:self.tableView.hidden ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [UIView commitAnimations];
    if (self.tableView.hidden) {
       
        self.tableView.hidden = NO;
        self.chartView.hidden = YES;
 
    }else {
        self.chartView.hidden = NO;
        self.tableView.hidden = YES;
    }

}
#pragma mark 设置柱状图数据
/*
 wid 窗口ID
 wname 窗口名称
 avgsum 窗口平均一天消费
 datesum 当前日期窗口的消费
 count 数量
 
 y坐标轴的值 战斗力 = 当前消费次数 /10000
 */
-(void)setChartData:(NSArray *)responseObject
{

    NSMutableArray *xArr = [NSMutableArray array];
    NSMutableArray *yArr = [NSMutableArray array];
    /*
     [xArr addObject:dic[@"wname"]];
     NSString *yValue =[NSString stringWithFormat:@"%d",[dic[@"count"] intValue]/10000];
     [yArr addObject:yValue];
     */
    for (DHListModel  *model in responseObject) {
        [xArr addObject:model.wname];
        NSString *yValue =[NSString stringWithFormat:@"%d",[model.avgsum intValue]/1000];
        [yArr addObject:yValue];
    }
    DHListModel *model = [DHListModel new];
    model.xArray = xArr;
    model.yArray = yArr;
    self.chartView.model = model;
}
#pragma tableView动画
- (void)starAnimationWithTableView:(UITableView *)tableView {
    
    [TableViewAnimationKit showWithAnimationType:3 tableView:tableView];
}

#pragma mark 
-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)segMentControl
{
    _status = (int)segMentControl.selectedSegmentIndex+1;
    
    [self loadData];
}
#pragma mark  DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _modelArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"DingHallCell";
    DHListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[DHListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    DHListModel *model = _modelArr[indexPath.row];
    model.lisNum  =  [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    cell.model = _modelArr[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class currentClass = [DHListCell class];
    DHListCell *model = _modelArr[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];

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
