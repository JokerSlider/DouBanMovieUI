//
//  GroupMemerInfoViewController.m
//  CSchool
//
//  Created by mac on 17/2/16.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "GroupMemerInfoViewController.h"
#import "GropUserInfoCollectionCell.h"
#import "UIView+SDAutoLayout.h"
#import "ChatUserInfoViewController.h"
#import "ChatUserModel.h"
@interface GroupMemerInfoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_mianCollectionView;
}

@end

@implementation GroupMemerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
    self.title = [NSString stringWithFormat:@"全部成员(%lu)",(unsigned long)self.groupUserArray.count];
}
-(void)createView
{
    self.view.backgroundColor = [UIColor whiteColor];
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _mianCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-64) collectionViewLayout:flowLayout];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing= 0.0;
    
    _mianCollectionView.dataSource=self;
    _mianCollectionView.delegate=self;
    [_mianCollectionView setBackgroundColor:[UIColor whiteColor]];
    [_mianCollectionView registerClass:[GropUserInfoCollectionCell class] forCellWithReuseIdentifier:@"chatGroupCell"];
    [self.view addSubview:_mianCollectionView];
    
    
    [self.view setupAutoHeightWithBottomView:_mianCollectionView bottomMargin:10];
    
}
#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.groupUserArray.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"chatGroupCell";
    
    GropUserInfoCollectionCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    //强制更新cell
    ChatUserModel  *model = _groupUserArray[indexPath.row];
    cell.model = model;
    [cell layoutSubviews];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect rect = collectionView.bounds;
    return CGSizeMake((rect.size.width-34-34)/5, 56);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 15, 8, 16);//上 左  下 右
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
    ChatUserInfoViewController *vc = [[ChatUserInfoViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    ChatUserModel *model = self.groupUserArray[indexPath.row];

    XMPPJID *jid=[XMPPJID jidWithString:model.ROOMJID];
    vc.jid =jid;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
