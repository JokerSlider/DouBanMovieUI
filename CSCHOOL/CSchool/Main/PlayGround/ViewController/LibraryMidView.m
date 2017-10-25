//
//  LibraryMidView.m
//  CSchool
//
//  Created by mac on 16/12/26.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "LibraryMidView.h"
#import "UIView+SDAutoLayout.h"
#import "LibraryMidCell.h"
#import "LibiraryModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "LibraryBookDetailViewController.h"
#import "UIView+UIViewController.h"
#import "LibraryBookModel.h"

@interface LibraryMidView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *modelArray;
@end
@implementation LibraryMidView
{
    UITableView *_mainTableview;
    UISegmentedControl *_segmentedControl;
    int  _pageNum;
    int  _loadType;
    NSArray *_listImagerArr;

}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
        [self setupTableView];
        _pageNum = 1;//默认第一页
        _loadType = 1;//默认加载周榜
      _listImagerArr   = @[@"flower1",@"flower2",@"flower3",@"flower4",@"flower5",@"flower6",@"flower7",@"flower8",@"flower9",@"flower10"];
    }
    return self;
}
-(void)loadNewData
{
    _pageNum = 1;
    [self loadDataLoadType:_loadType WithPage:_pageNum];
}
-(void)relodTableViewData
{
    [_mainTableview reloadData];
    [_mainTableview setContentOffset:CGPointMake(0,0) animated:NO];

}
-(void)loadDataLoadType:(int)loadType WithPage:(int)page
{
    _modelArray = [NSMutableArray array];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showTopBookList",@"book":@(loadType),@"page":@(page),@"pageNum":Message_Num} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSArray *dataArray = responseObject[@"data"];
        for (NSDictionary *dic in dataArray) {
            LibiraryModel   *model = [[LibiraryModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_modelArray addObject:model];
        }
        [_mainTableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}
-(void)setupView
{
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"周榜",@"月榜",@"学期榜",@"年榜",nil];
    
    _segmentedControl  = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segmentedControl.frame = CGRectMake(10, 0, kScreenWidth-20, 30);
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.tintColor = RGB(170, 170, 170);
    [_segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:14.0],UITextAttributeFont,nil];
    [_segmentedControl setTitleTextAttributes:dic forState:UIControlStateSelected];
     NSDictionary *noseDic = [NSDictionary dictionaryWithObjectsAndKeys:Color_Black,UITextAttributeTextColor,[UIFont systemFontOfSize:14.0],UITextAttributeFont,nil];
    [_segmentedControl setTitleTextAttributes:noseDic forState:UIControlStateNormal];
    [self addSubview:_segmentedControl];
}
//设置tableView
-(void)setupTableView{
    _mainTableview = ({
        UITableView *view  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        view.delegate = self;
        view.dataSource=self;
        view.tableFooterView = [UIView new];
        view;
    });
    [self addSubview:_mainTableview];
    _mainTableview.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).topSpaceToView(_segmentedControl,2).bottomSpaceToView(self,0);
    [self setupAutoHeightWithBottomView:_mainTableview bottomMargin:0];
}
#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idefitier = @"midTableCell";
    LibraryMidCell *cell = [tableView dequeueReusableCellWithIdentifier:idefitier];
    if (!cell) {
        cell = [[LibraryMidCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idefitier];
    }
    cell.listNum.image = [UIImage imageNamed:_listImagerArr[indexPath.row]];
    if (_modelArray.count==0) {
        return cell;
    }
    LibiraryModel *model = _modelArray[indexPath.row];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
#pragma mark 点击进入详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //点击进入详情
    LibiraryModel *model = _modelArray[indexPath.row];
    
    LibraryBookModel *bookModel = [[LibraryBookModel alloc] init];
    bookModel.suoshuNum = model.CALL_NO;
    
    LibraryBookDetailViewController *vc = [[LibraryBookDetailViewController alloc] init];
    vc.model = bookModel;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark SegementIndexCOntrolDelegate
-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender
{
    NSInteger selecIndex = sender.selectedSegmentIndex;
    _modelArray = [NSMutableArray array];
    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showTopBookList",@"book":@((int)selecIndex+1),@"page":@(1),@"pageNum":Message_Num} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSArray *dataArray = responseObject[@"data"];
        for (NSDictionary *dic in dataArray) {
            LibiraryModel   *model = [[LibiraryModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_modelArray addObject:model];
        }
        [self relodTableViewData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];


}
@end
