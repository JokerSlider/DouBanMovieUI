
    //
//  SportInfoViewController.m
//  CSchool
//
//  Created by mac on 17/4/12.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "SportInfoViewController.h"
#import "ChartCell.h"
#import "TodayStepCell.h"
#import "SportsMainCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "SportHeadView.h"
#import <YYModel.h>

#define HeadImgHeight 180+64


@interface SportInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)SportHeadView *headView;
@property (nonatomic,strong)NSMutableArray *stepModelArr;

@end

@implementation SportInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"运动详情";
    [self createView];
    [self loadBaseData];

}
-(void)createView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [UIView new];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 添加头视图 在头视图上添加ImageView
    self.headView = [[SportHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, HeadImgHeight) andUserID:_userID];

    self.mainTableView.tableHeaderView = _headView;
    
    [self.view addSubview:self.mainTableView];
}
#pragma mark 获赞以及背景图
-(void)loadBaseData
{
    _stepModelArr = [NSMutableArray array];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL  parameters:@{@"rid":@"getPersonSportInfo",@"userid":_userID} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject [@"data"];
        SportModel *model = [[SportModel alloc]init];
        [model yy_modelSetWithDictionary:dic];
        _headView.model= model;
        [_stepModelArr addObject:model];
        
        [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}


#pragma mark 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        static  NSString *cellID = @"chartView";
        ChartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell=[[ChartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.userID = _userID;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else if(indexPath.row==1){
        static  NSString *cellID = @"todayStep";
        TodayStepCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

        if (!cell) {
            cell=[[TodayStepCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.model = [_stepModelArr firstObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if (indexPath.row==0) {
        return 180+64;
    }
    
    Class currentClass = [TodayStepCell class];
    SportModel *model = [_stepModelArr firstObject];
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

//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//    /**
//     *  这里的偏移量是纵向从contentInset算起 则一开始偏移就是0 向下为负 上为正 下拉
//     */
//    
//    // 获取到tableView偏移量
//    CGFloat Offset_y = scrollView.contentOffset.y;
//    // 下拉 纵向偏移量变小 变成负的
//    if ( Offset_y < 0) {
//        // 拉伸后图片的高度
//        CGFloat totalOffset = HeadImgHeight - Offset_y;
//        // 图片放大比例
//        CGFloat scale = totalOffset / HeadImgHeight;
//        CGFloat width = kScreenWidth;
//        // 拉伸后图片位置
//        _headView.frame = CGRectMake(-(width * scale - width) / 2, Offset_y, width * scale, totalOffset);
//    }
//    
//}


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
