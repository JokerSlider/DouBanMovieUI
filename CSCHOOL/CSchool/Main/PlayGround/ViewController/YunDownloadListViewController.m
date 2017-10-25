//
//  YunDownloadListViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 17/5/11.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "YunDownloadListViewController.h"
#import "YunLoadingCell.h"
#import "XGWebDavDownloadManager.h"

@interface YunDownloadListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YunDownloadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.tableFooterView = [UIView new];
    
    WEAKSELF;
    //下载进度指示
    [XGWebDavDownloadManager shareDownloadManager].receivedProgressClick = ^(NSInteger index, float percent){
        YunLoadingCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [cell updateProgress:percent];
    };
    
    //下载完成，需要优化。
    [XGWebDavDownloadManager shareDownloadManager].taskDidDown = ^(NSInteger index, LEOWebDAVItem *item){
//        [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
//        [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        
//        [weakSelf.tableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] toIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        [weakSelf.tableView reloadData];
    };
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    [self.mainTableView startAutoCellHeightWithCellClass:[RepairListTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    if (section == 0) {
        return [XGWebDavDownloadManager shareDownloadManager].downloadingArray.count;
    }else{
        return [XGWebDavDownloadManager shareDownloadManager].didDownloadArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"YunLoadingCell";
    YunLoadingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YunLoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.model = [XGWebDavDownloadManager shareDownloadManager].downloadingArray[indexPath.row];
        cell.isDown = NO;
    }else{
        cell.model = [XGWebDavDownloadManager shareDownloadManager].didDownloadArray[indexPath.row];
        cell.isDown = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = RGB(240, 247, 247);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(13, 7, 200, 12)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = RGB(107, 107, 107);
    [view addSubview:label];
    
    if (section == 0) {
        label.text = @"正在下载";
    }else{
        label.text = @"下载完成";
    }
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0 && [XGWebDavDownloadManager shareDownloadManager].downloadingArray.count == 0) {
        return 0;
    }
    if (section == 1 && [XGWebDavDownloadManager shareDownloadManager].didDownloadArray.count == 0) {
        return 0;
    }
    
    return 26;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
