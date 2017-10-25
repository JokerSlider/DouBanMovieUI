//
//  MyOriderBookViewController.m
//  CSchool
//
//  Created by mac on 16/12/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MyOriderBookViewController.h"
#import "UIView+SDAutoLayout.h"
#import "SegmentTapView.h"
#import "FlipTableView.h"
#import "NoReturnViewController.h"
#import "MyOrderBottomView.h"
#import "HaveReturnViewController.h"
@interface MyOriderBookViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate>
@property (nonatomic, strong)SegmentTapView *segment;
@property (nonatomic, strong)FlipTableView *flipView;
@property (nonatomic, retain) NoReturnViewController *busListVC;//未归还
@property (nonatomic, retain) HaveReturnViewController *busRoteVC;//已归还

@end

@implementation MyOriderBookViewController
{
    MyOrderBottomView *_MyBorrowInfoView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的借阅";
    self.view.backgroundColor = Base_Color2;
    [self setupSegmentView];
    [self setBottomView];
    [self loadData];
}
-(void)setupSegmentView
{
    _busListVC = [[NoReturnViewController alloc]init];
    _busRoteVC = [[HaveReturnViewController alloc]init];
    NSArray *controllers=@[_busListVC,_busRoteVC];
    NSArray *titleArr = @[@"未归还",@"已归还"];
    // 分段视图
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 40) withDataArray:titleArr withFont:13];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, self.view.frame.size.height - 40-64) withArray:controllers withRootVC:self];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];

}
-(void)loadData{
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"userid":[AppUserIndex GetInstance].role_id,@"rid":@"showMyBorrowInfo"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        LibiraryModel *model = [[LibiraryModel alloc]init];
        [model yy_modelSetWithDictionary:dic];
        _MyBorrowInfoView.model = model;
        [_MyBorrowInfoView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        static int i = 0;
        i++;
        if (i>3) {
            return ;
        }
        [self loadData];
    }];
}
-(void)setBottomView
{
    _MyBorrowInfoView   = [MyOrderBottomView new];
    [self.view addSubview:_MyBorrowInfoView];
    _MyBorrowInfoView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0).heightIs(80);
}
#pragma mark -------- select Index
-(void)selectedIndex:(NSInteger)index
{
    if (index==0) {
        
    }else{
        
    }
    [self.flipView selectIndex:index];
    
}
-(void)scrollChangeToIndex:(NSInteger)index
{
    if (index==0) {
        
        
    }else{
        
    }
    [self.segment selectIndex:index];
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
