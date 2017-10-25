//
//  PhoneDetailViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/7/6.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PhoneDetailViewController.h"
#import "PhoneCallCell.h"
#import "SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PhoneDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation PhoneDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"详情";

    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.navigationItem setHidesBackButton:NO];
    [self createTableHeaderView];
}

//设置头部视图
- (void)createTableHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    imageView.image = [UIImage imageNamed:@"phone_bgView"];
    imageView.contentMode = UIViewContentModeCenter;
    [view addSubview:imageView];
    
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
//    logoImageView.center = imageView.center;
//    [logoImageView sd_setImageWithURL:[NSURL URLWithString:[AppUserIndex GetInstance].schoolLogo]];
    [logoImageView sd_setImageWithURL:[NSURL URLWithString:[AppUserIndex GetInstance].schoolLogo] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    NSLog(@".%@.",[AppUserIndex GetInstance].schoolLogo);
    logoImageView.layer.cornerRadius = 31;
    [imageView addSubview:logoImageView];
    logoImageView.sd_layout
    .topSpaceToView(imageView,25)
    .centerXEqualToView(imageView)
    .widthIs(62)
    .heightIs(62);
    
    UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, kScreenWidth-20, 30)];
    mainLabel.textAlignment = NSTextAlignmentCenter;
    mainLabel.textColor = Color_Black;
    mainLabel.font = Title_Font;
    [view addSubview:mainLabel];
    
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, kScreenWidth-20, 30)];
    subLabel.textAlignment = NSTextAlignmentCenter;
    subLabel.textColor = Color_Gray;
    subLabel.font = [UIFont systemFontOfSize:12];
    [view addSubview:subLabel];
    
    mainLabel.text = _dataDic[@"DD_NAME"];
    subLabel.text = _dataDic[@"FATHER_NAME"];
    _mainTableView.tableHeaderView = view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 250, 30)];
    label.text = @"联系电话";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = Color_Gray;
    [view  addSubview:label];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 39, kScreenWidth-20, 1)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:lineView];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"PhoneCallCell";
    PhoneCallCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[PhoneCallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.phoneNumer = _dataDic[@"DP_PHONE"];
    cell.dataDic = _dataDic;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
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
