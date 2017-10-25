//
//  RequestMessageListViewController.m
//  CSchool
//
//  Created by mac on 17/4/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "RequestMessageListViewController.h"
#import "RequstListCell.h"
#import "HomeModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "FmdbTool.h"
#import "UIView+SDAutoLayout.h"
@interface RequestMessageListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *modelsArray;
@end

@implementation RequestMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统消息";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createView];
    [self loadData];
}
-(void)createView
{
    self.mainTableView = ({
        UITableView *view = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        view.delegate =self;
        view.dataSource = self;
        view;
    });
    
    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(kScreenHeight-64);
}
-(void)loadData
{
    self.modelsArray = [NSMutableArray arrayWithArray:[FmdbTool selectAllDatawithXmppID:[HQXMPPManager shareXMPPManager].xmppStream.myJID andMessageType:@"system"]];
    [self.mainTableView reloadData];
}
#pragma mark  
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.modelsArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static  NSString *ID =@"requestMessageCell";
    RequstListCell *cell   = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[RequstListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    HomeModel *model = self.modelsArray[indexPath.section];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
/*设置标题尾的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
/*设置标题脚的名称*/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor redColor];
    return headView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
