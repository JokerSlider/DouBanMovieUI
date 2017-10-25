
//
//  GroupUserInfoCell.m
//  CSchool
//
//  Created by mac on 17/2/16.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "GroupUserInfoCell.h"
#import "GropUserInfoCollectionCell.h"
#import "UIView+SDAutoLayout.h"
#import "GroupMemerInfoViewController.h"
#import "UIView+UIViewController.h"
#import "ChatUserInfoViewController.h"
#import <YYModel.h>
#import "ChatUserModel.h"
@interface   GroupUserInfoCell()<UICollectionViewDelegate,UICollectionViewDataSource>
//@property (nonatomic,strong)NSMutableArray *modelArray;
@end
@implementation GroupUserInfoCell
{
    UICollectionView *_mianCollectionView;
    UIButton *_lookMoreFriends;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    self.backgroundColor = [UIColor whiteColor];
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    
    _mianCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,0) collectionViewLayout:flowLayout];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing= 0.0;
    _mianCollectionView.scrollEnabled = NO;
    _mianCollectionView.dataSource=self;
    _mianCollectionView.delegate=self;
    [_mianCollectionView setBackgroundColor:[UIColor whiteColor]];
    [_mianCollectionView registerClass:[GropUserInfoCollectionCell class] forCellWithReuseIdentifier:@"chatGroupCell"];
    _lookMoreFriends =({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.backgroundColor = [UIColor whiteColor];
        [view setTitle:@"查看全部成员" forState:UIControlStateNormal];
        [view setTitleColor:RGB(109, 109, 109) forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [view addTarget:self action:@selector(lookAllMembers) forControlEvents:UIControlEventTouchUpInside];
        view;
    });;
    [self.contentView addSubview:_lookMoreFriends];
    [self.contentView addSubview:_mianCollectionView];
    _mianCollectionView.sd_layout.leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).topSpaceToView (self.contentView,0).heightIs(4*50+3*15+14);
    _lookMoreFriends.sd_layout.widthIs(kScreenWidth).topSpaceToView(_mianCollectionView,15).heightIs(15).leftSpaceToView(self.contentView,0);
    [self setupAutoHeightWithBottomView:_lookMoreFriends bottomMargin:15];
}
-(void)setModelarray:(NSArray *)modelarray
{
    _modelarray = modelarray;
    int  countNum ;
    if (modelarray.count<5) {
        countNum = 1;
    }else{
        countNum =(int) modelarray.count/5;
    }
    if (countNum>4) {
        _lookMoreFriends.hidden = NO;
    }else{
        _lookMoreFriends.hidden = YES;
    }
    [_mianCollectionView reloadData];

}

#pragma mark 查看全部成员
-(void)lookAllMembers{
    GroupMemerInfoViewController    *vc = [[GroupMemerInfoViewController alloc]init];
    vc.groupUserArray = _modelarray;
    [self.viewController.navigationController pushViewController:vc animated:YES ];
}
#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _modelarray.count;
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
    ChatUserModel  *model = _modelarray[indexPath.row];
    cell.model = model;
    [cell layoutSubviews];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    CGRect rect = collectionView.bounds;
    return CGSizeMake((kScreenWidth-34-42)/5, 50);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 16);//上 左  下 右
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
    ChatUserModel *model = _modelarray[indexPath.row];
    XMPPJID *jid=[XMPPJID jidWithString:model.ROOMJID];
    vc.jid =jid;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
