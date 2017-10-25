//
//  WIFILocationSignMainController.m
//  CSchool
//
//  Created by mac on 17/6/27.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "WIFILocationSignMainController.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "WIFiBtnCell.h"
#import <YYModel.h>
#import "WIFICellModel.h"
@interface WIFILocationSignMainController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableview;
@property (nonatomic,strong)NSMutableArray *modelArr;
@end

@implementation WIFILocationSignMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createVC];
    [self loadData];
    self.title = @"签到";
}
-(void)loadData
{
    _modelArr = [NSMutableArray array];

    NSArray *sourceArr = @[
                           @{
                               @"funcID":@"0",
                               
                               },
                           @{
                               @"funcID":@"1",
                               },
                           @{
                               
                               @"funcID":@"2",
                               
                               }
                           ];
    for (NSDictionary *dic in sourceArr) {
        WIFICellModel *model = [[WIFICellModel alloc]init];
        [model yy_modelSetWithDictionary:dic];
        [_modelArr addObject:model];
    }
    [self.mainTableview reloadData];

}
-(void)createVC
{
    self.view.backgroundColor = Base_Color2;
    self.mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.mainTableview.delegate =self;
    self.mainTableview.dataSource = self;
    self.mainTableview.tableFooterView = [UIView new];
    self.mainTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mainTableview];
}

#pragma mark delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArr.count   ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"wifiMainCell";
    WIFiBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WIFiBtnCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID ];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _modelArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [WIFiBtnCell class];
    WIFICellModel *model = _modelArr[indexPath.row];
    return [self.mainTableview cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];

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
