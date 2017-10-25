//
//  GroupInfoViewController.m
//  CSchool
//
//  Created by mac on 17/2/16.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "GroupInfoViewController.h"
#import "GroupUserInfoCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "GroupNameCell.h"
#import "GropSetMessageCell.h"
#import "ChatUserModel.h"
#import <YYModel.h>
@interface GroupInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mianTableview;
@property (nonatomic,strong)NSMutableArray *modelArray;
@end

@implementation GroupInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    [self loadData];
    self.title = @"群组成员";
}
-(void)loadData
{
    _modelArray = [NSMutableArray array];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL  parameters:@{@"rid":@"showMembersByRoomid",@"roomid":self.RoomJid} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        for (NSDictionary *dic in responseObject[@"data"]) {
            ChatUserModel *model = [[ChatUserModel alloc]init];
            [model yy_modelSetWithDictionary:dic];
            [self.modelArray addObject:model];
        }
        
        [_mianTableview   reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}
-(void)createView
{
    _mianTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _mianTableview.delegate = self;
    _mianTableview.dataSource = self;
    [self.view addSubview:_mianTableview];

}

#pragma mark  UITableviewDelegate && UITableviewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1 ;
    }
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellID = @"GroupInfoMembercell";
        GroupUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[GroupUserInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.modelarray =[NSArray arrayWithArray:self.modelArray];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            static NSString *ceelID = @"GroupName";
            GroupNameCell *cell = [tableView dequeueReusableCellWithIdentifier:ceelID];
            if (!cell) {
                cell = [[GroupNameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ceelID];
            }
            cell.roomJid = self.RoomJid;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }
        //消息免打扰
//        else if (indexPath.row==1){
//        
//            static NSString *ceelID = @"GroupMessageSet";
//            GropSetMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ceelID];
//            if (!cell) {
//                cell = [[GropSetMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ceelID];
//            }
//            return cell;
//
//        }
    }
    
    static NSString *ceelID = @"GroupInfo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ceelID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ceelID];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        Class currentClass = [GroupUserInfoCell class];
        ChatUserModel *model = nil;;
        return [self.mianTableview cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
    }
    return 50;
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return 21.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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
