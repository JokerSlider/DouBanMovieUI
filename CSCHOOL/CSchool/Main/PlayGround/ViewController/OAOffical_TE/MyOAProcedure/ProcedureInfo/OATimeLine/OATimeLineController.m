//
//  OATimeLineController.m
//  CSchool
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OATimeLineController.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "OATimeLineCell.h"
@interface OATimeLineController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *modelArr;

@property (nonatomic,strong)UITableView *mainTableView;

@end

@implementation OATimeLineController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
    [self loadData];
}
-(void)createView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64-50) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.showsVerticalScrollIndicator  =NO;
    [self.mainTableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.mainTableView];
    //适配iOS11 后 tableview不能滑到底部的问题
    if (@available(iOS 11,*)) {
        if ([self.mainTableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.mainTableView.estimatedRowHeight = 0;
            self.mainTableView.estimatedSectionHeaderHeight = 0;
            self.mainTableView.estimatedSectionFooterHeight = 0;
        }
    }
}
-(void)loadData
{
    _modelArr = [NSMutableArray new];
    NSString *url = [NSString stringWithFormat:@"%@/getFlowTimeByOid",OABase_URL];
    [NetworkCore requestMD5POST:url parameters:@{@"in_oi_id":_oi_id,@"scode":[AppUserIndex GetInstance].schoolCode,@"flag":@"in_oi_id,scode"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray *soureArr = responseObject[@"time"];
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *dic in soureArr) {
            for (NSDictionary *newdic in dic[@"data"]) {
                [dataArr addObject:newdic];
            }
        }
        for (NSDictionary *dic in dataArr) {
            OAModel *model =[OAModel new];
            [model yy_modelSetWithDictionary:dic];
            [_modelArr addObject:model];
        }
        
        [self.mainTableView reloadData];
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.modelArr.count-1 inSection:0];
        [self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}
#pragma mark
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"OATimeLineCell";
    OATimeLineCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[OATimeLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OAModel *model = _modelArr[indexPath.row];
    model.cellNum = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    model.totalCount = [NSString stringWithFormat:@"%lu",(unsigned long)_modelArr.count];
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [OATimeLineCell class];
    OAModel *model = _modelArr[indexPath.row];
//    return 250;
    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
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
