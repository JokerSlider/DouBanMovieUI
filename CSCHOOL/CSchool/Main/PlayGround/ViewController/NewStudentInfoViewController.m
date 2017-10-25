//
//  NewStudentInfoViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 2017/9/6.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "NewStudentInfoViewController.h"

@interface NewStudentInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation NewStudentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self createHeaderTableView];
    AppUserIndex *user = [AppUserIndex GetInstance];
    
    NSString *sushe = ([user.SSMC length]>0)?user.SSMC:user.SSLH;
    if (!sushe) {
        sushe = @"";
    }
    NSString *xuefei = user.XSJF?@"已扣费":@"";
    _titleArray = @[@"姓名",@"学院",@"班级",@"学号",@"宿舍", @"学费"];
    _dataArray = @[user.role_username, user.XYMC, user.BJMC, user.role_id, sushe, xuefei];
}

- (void)createHeaderTableView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 30)];
    label.text = @"基本资料";
    label.textColor = Color_Black;
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    _tableView.tableHeaderView = view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%@：    %@",_titleArray[indexPath.section], _dataArray[indexPath.section]];
    cell.textLabel.textColor = Color_Black;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
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
