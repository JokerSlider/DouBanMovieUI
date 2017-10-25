//
//  MukeViewController.m
//  CSchool
//
//  Created by mac on 16/11/5.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MukeViewController.h"
#import "MukeModel.h"
#import "MuKeCell.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "CommonCrypto/CommonDigest.h"
#import "AboutUsViewController.h"
#import <MJRefresh.h>
@interface MukeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *modelsArray;
@property (nonatomic,strong)NSMutableArray *dataSourceArr;
@property (nonatomic,assign)int  pageNum;
@end

@implementation MukeViewController
//static int pageNum=0;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    [self loadData];
    _pageNum = 0;
    self.title = @"全部课程";
    self.mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}
-(void)loadNewData
{
    _pageNum = 0;
    [self loadData];
}

/**
 *  获取最新的数据
 */
-(void)loadData
{
    if (_pageNum==0) {
        _modelsArray = [NSMutableArray array];
        _pageNum++;
    }else
    {
        _pageNum ++;
    }
    NSString *sian = [NSString stringWithFormat:@"2c6ade3103944ef54e194fcee01b251416546135431%@",[self dateTimeString]];
    NSString *signature = [self sha1:sian];
    //中文编码
    NSDictionary *parms = @{
                            @"appId":@"27b3e069286bd775b3336da3e880c8f9",
                            @"signature":signature,
                            @"format":@"json",
                            @"nonce":@"16546135431",
                            @"pageIndex":@(_pageNum),
                            @"pageSize":@"15",
                            @"publishStatus":@"2",
                            @"progress":@"2",
                            @"timestamp":[self dateTimeString],
                            @"format":@"json"
                            };
    [NetworkCore networkingGetMethod:parms urlName:@"http://www.icourse163.org/open/courses/mooc" success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"200"]) {
            NSArray *dataArr = responseObject[@"result"][@"list"];
            if (dataArr.count<15) {
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            for (NSDictionary *dic in dataArr) {
                MukeModel   *model = [[MukeModel alloc] init];
                [model yy_modelSetWithDictionary:dic];
                [_modelsArray addObject:model];
            }
        }else{
            [self showErrorViewLoadAgain:@"出了点小差错,点击重新加载!"];
        }
        [self.mainTableView.mj_footer endRefreshing];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        NSLog(@"%@",error);
        [self.mainTableView.mj_footer endRefreshing];
        [self.mainTableView.mj_header endRefreshing];
        [self showErrorViewLoadAgain:@"网络故障"];

    }];
}
-(NSString *)dateTimeString
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}
- (NSString *) sha1:(NSString *)input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}
-(void)createView
{
    self.view.backgroundColor = Base_Color2;
    self.mainTableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout.leftSpaceToView(self.view,7).rightSpaceToView(self.view,7).topSpaceToView(self.view,7).heightIs(kScreenHeight-64-7);
}

#pragma mark UitabelViewDelegate  UitableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.modelsArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *ID =@"mukeCell";
    
    MuKeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[MuKeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    MukeModel *model = self.modelsArray[indexPath.section];
    cell.model = model;
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (kScreenWidth-14)*1/2*240/426;
//    Class currentClass = [MuKeCell class];
//    MukeModel *model = self.modelsArray[indexPath.section];
//    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[UIScreen mainScreen].bounds.size.width];
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
    MukeModel *model = self.modelsArray[indexPath.section];
    AboutUsViewController *about = [[AboutUsViewController alloc]init];
    about.baseUrl =model.ctUrl;
    about.hidesBottomBarWhenPushed = YES;
    about.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:about animated:YES];
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
