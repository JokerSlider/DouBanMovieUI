//
//  BaseListSelectViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/9/6.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseListSelectViewController.h"
#import "SDAutoLayout.h"
#import "BaseListButton.h"

@interface BaseListSelectViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *buttonViews;
@property (nonatomic, assign) NSInteger clickNum; //当前第几层

@end

@implementation BaseListSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
    
    [self loadData];
}

- (void)createView{

    _buttonViews = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    
    _mainTableView = ({
        UITableView *view = [[UITableView alloc] init];
        view.delegate = self;
        view.dataSource = self;
        view.tableFooterView = [UIView new];
        view;
    });
    
    [self.view addSubview:_mainTableView];
    
    _buttonViews.sd_layout
    .topSpaceToView(self.view,0)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(0);
    
    _mainTableView.sd_layout
    .topSpaceToView(_buttonViews,0)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0);
    
    _mainTableView.tableHeaderView = _buttonViews;
}

- (void)loadData{
    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:_commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        _totalDataArray = responseObject[@"data"];
        _currentDataArray = responseObject[@"data"];
        [_mainTableView reloadData];
        if (_totalDataArray.count == 0) {
            [self showErrorViewLoadAgain:@"暂无数据"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _currentDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"BXCell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *title;
    NSMutableString *string = [[NSMutableString alloc]initWithString:@""];
    for (int i = 0; i<_clickNum; i++) {
        [string  appendString: @"    "];
        string = string;
    }
    title = [NSString stringWithFormat:@"%@%@",string,_currentDataArray[indexPath.row][@"RTNAME"]];
    cell.textLabel.text  = title;
    return cell;
}

//点击cell，是根节点则直接走代理，否则创建button展开下一级
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([_currentDataArray[indexPath.row][@"RNODE"] boolValue]) {
        NSLog(@"push something...");
        if ([self.delegate respondsToSelector:@selector(selectVc:didSelectCellWithDic:)]) {
            [_delegate selectVc:self didSelectCellWithDic:_currentDataArray[indexPath.row]];
        }
    }else{
        [self createButton:indexPath];
    }
}

//若还有按钮，则返回上一个按钮
-(BOOL)navigationShouldPopOnBackButton{
    if (_buttonViews.subviews.count == 0) {
        return YES;
    }else{
        [self selButtonAction:_buttonViews.subviews[_buttonViews.subviews.count-1]];
        return NO;
    }

}

//添加头视图按钮
- (void)createButton:(NSIndexPath *)indexPath{
    CGFloat btnWidth = 50;
    BaseListButton *btn = [BaseListButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, _clickNum*btnWidth, kScreenWidth, btnWidth);
    
    btn.layer.borderWidth = 0.1;
    btn.layer.borderColor = Base_Color2.CGColor;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.tag = _clickNum;
    
    btn.backgroundColor =[self getColorBysenderId:btn.tag];
    
    [btn setTitleColor:Base_Orange forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [btn addTarget:self action:@selector(selButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    NSString *title;
    NSMutableString *string = [[NSMutableString alloc]initWithString:@""];
    for (int i = 1; i<=_clickNum; i++) {
        [string  appendString: @"    "];
        string = string;
    }
    title = [NSString stringWithFormat:@"%@%@",string,_currentDataArray[indexPath.row][@"RTNAME"]];
    [btn setTitle:title forState:UIControlStateNormal];
    
    _clickNum++;
    //重新设置头视图及高度
    _buttonViews.sd_layout.heightIs(_clickNum*btnWidth);
    _mainTableView.tableHeaderView = _buttonViews;
    [_buttonViews addSubview:btn];
    //将该按钮的数据源记录
    btn.dataArray = _currentDataArray;
    //转换当前的数据源
    _currentDataArray = _currentDataArray[indexPath.row][@"CHILDREN"];
    [_mainTableView reloadData];
}

- (void)selButtonAction:(BaseListButton *)sender{

    for (UIButton *btn in _buttonViews.subviews) {
        if (btn.tag>=sender.tag) {
            [btn removeFromSuperview];
        }
    }
    _buttonViews.sd_layout.heightIs(_buttonViews.subviews.count*50);
    _mainTableView.tableHeaderView = _buttonViews;
    //转换当前的数据源
    _currentDataArray = sender.dataArray;
    [_mainTableView reloadData];
    _clickNum = _buttonViews.subviews.count;
}

/**
 *  返回按钮颜色
 *
 *  @param tag 控件的tag
 *
 *  @return 返回颜色
 */
-(UIColor *)getColorBysenderId:(NSInteger )tag{
    if (tag==0) {
        return [UIColor lightGrayColor];
    }
    return Base_Color2;
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
