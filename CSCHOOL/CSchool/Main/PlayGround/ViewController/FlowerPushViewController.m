//
//  FlowerPushViewController.m
//  CSchool
//
//  Created by mac on 16/11/4.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "FlowerPushViewController.h"
#import "FlowerListCollectionCell.h"
#import "EditMymessageController.h"
#import <MJRefresh.h>
#import <YYModel.h>
#import "PhotoWallDetailViewController.h"
#import "MyFlowerPushDataVC.h"
#import "MyFlloweFlowerDataVC.h"
@interface FlowerPushViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,XGAlertViewDelegate>
{
    NSMutableArray *_modelArray;
}
@property (nonatomic,strong)NSMutableArray *dataSourceArr;//传递数组
@property (nonatomic,strong)id  deleEvent;//删除事件
@end

@implementation FlowerPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Base_Color2;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    _modelArray = [NSMutableArray array];
    [self createView];
}
-(void)loadData
{
  
}
-(void)loadDataWithRID:(NSString *)rid  pageNum:(NSString *)page
{
    AppUserIndex *user = [AppUserIndex GetInstance];
    [NetworkCore requestPOST:user.API_URL parameters:@{@"rid":rid,@"page":page,@"pageCount":@"10",@"userid":user.role_id,} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        _dataSourceArr = [NSMutableArray array];
        NSArray *dataArray = responseObject[@"data"];
        [self hiddenErrorView];
        if ([page isEqualToString:@"1"]) {
            _modelArray = [NSMutableArray array];
            if (dataArray.count==0) {
                [self.FlowercollectionView reloadData];
                [self showErrorViewLoadAgain:@"没有相关数据！"];
                return ;
            }
        }
        for (NSDictionary *dic in dataArray) {
            PhotoCarModel   *model = [[PhotoCarModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_dataSourceArr addObject:model];
        }
        [_modelArray addObjectsFromArray:_dataSourceArr];
        [self.FlowercollectionView reloadData];
        [self.FlowercollectionView.mj_header endRefreshing];
        if (dataArray.count<10) {
            if ([page intValue]>=1) {
                [self.FlowercollectionView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
        }
        [self.FlowercollectionView.mj_footer endRefreshing];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD showError:@"没有更多信息了"];
         [self.FlowercollectionView.mj_footer endRefreshing];
        [self.FlowercollectionView.mj_header endRefreshing];

    }];

}
-(void)createView
{
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.FlowercollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth,kScreenHeight-40-64-20) collectionViewLayout:flowLayout];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing= 0.0;
    
    self.FlowercollectionView.dataSource=self;
    self.FlowercollectionView.delegate=self;
    [self.FlowercollectionView setBackgroundColor:Base_Color2];
    [_FlowercollectionView registerClass:[FlowerListCollectionCell class] forCellWithReuseIdentifier:@"flowerCollectionCell"];
    [self.view addSubview:self.FlowercollectionView];

}
#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _modelArray.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"flowerCollectionCell";
    
    FlowerListCollectionCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell.deleBtnPhoto addTarget:self action:@selector(deletPhoto:event:) forControlEvents:UIControlEventTouchUpInside];
    //强制更新cell
    PhotoCarModel *model = _modelArray[indexPath.row];
    cell.model = model;
    [cell layoutSubviews];
    return cell;
}
/**
 *  删除鲜花关注
 *
 *  @param sender 点击的button
 */
-(void)deletPhoto:(UIButton *)sender event:(id)event
{
    if ([[self class] isEqual:[MyFlowerPushDataVC class]]) {
        XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:@"确定删除吗？" WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
        alert.tag = 1128;
        alert.delegate = self;
        [alert show];
        _deleEvent = event;
    
    }else{
        XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:@"确定删除该条足迹吗？" WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
        alert.tag = 1128;
        alert.delegate = self;
        [alert show];
        _deleEvent = event;
    
    }
    
    
}
#pragma mark --XGAlertViewDelegate
-(void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title
{
    if (view.tag==1128) {
        NSSet *touches =[_deleEvent allTouches];
        UITouch *touch =[touches anyObject];
        CGPoint currentTouchPosition = [touch locationInView:self.FlowercollectionView];
        NSIndexPath *indexPath= [self.FlowercollectionView indexPathForItemAtPoint:currentTouchPosition];
        PhotoCarModel *model = _modelArray[indexPath.row];
        AppUserIndex *user = [AppUserIndex GetInstance];
        if ([[self class] isEqual:[MyFlowerPushDataVC class]]) {
            //删除
            [NetworkCore requestPOST:user.API_URL parameters:@{@"rid":@"delPhotowall",@"photoid":model.photoID} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                [_modelArray removeObjectAtIndex:indexPath.row];
                [self.FlowercollectionView reloadData];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                
            }];
        }else{
                    //取消关注
            [NetworkCore requestPOST:user.API_URL parameters:@{@"rid":@"cancelFocusPhoto",@"photoid":model.photoID,@"userid":user.role_id} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                [ProgressHUD showSuccess:responseObject[@"msg"]];
                [_modelArray removeObjectAtIndex:indexPath.row];
                [self.FlowercollectionView reloadData];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                
            }];

        }
       
    }
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect rect = collectionView.frame;
    return CGSizeMake((rect.size.width-30)/2, 220);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0.001, 10);//上 左  下 右
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 11.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.04f;
}

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated{
    
}
#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //点击某个cell跳转到对应的照片墙信息墙页面。
    PhotoWallDetailViewController *vc = [[PhotoWallDetailViewController alloc] init];
    vc.model = _modelArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    
}
#pragma mark 滑动隐藏导航栏
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
//-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    if(velocity.y>0)
//    {
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        CGRect frame = CGRectMake(0, 10, kScreenWidth,kScreenHeight-40-20);
//        self.FlowercollectionView.frame = frame;
//    }
//    else
//    {
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        CGRect frame = CGRectMake(0, 10, kScreenWidth,kScreenHeight-40-20-64);
//        self.FlowercollectionView.frame = frame;
//    }
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
