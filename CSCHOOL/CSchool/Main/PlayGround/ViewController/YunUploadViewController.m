//
//  YunUploadViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 17/5/11.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "YunUploadViewController.h"
#import "XGWebDavUploadManager.h"
#import "YunLoadingCell.h"

@interface YunUploadViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YunUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.tableFooterView = [UIView new];
    
    WEAKSELF;
    //上传进度指示
    [XGWebDavUploadManager shareUploadManager].receivedProgressClick = ^(NSInteger index, float percent){
        YunLoadingCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [cell updateProgress:percent];
    };
    
    //上传完成，需要优化。
    [XGWebDavUploadManager shareUploadManager].taskDidDown = ^(NSInteger index, LEOWebDAVItem *item){
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
        return [XGWebDavUploadManager shareUploadManager].uploadingArray.count;
    }else{
        return [XGWebDavUploadManager shareUploadManager].didUploadArray.count;
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
        cell.fileUrl = [XGWebDavUploadManager shareUploadManager].uploadingArray[indexPath.row];
        cell.isDown = NO;
    }else{
        cell.fileUrl = [XGWebDavUploadManager shareUploadManager].didUploadArray[indexPath.row];
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
        label.text = @"正在上传";
    }else{
        label.text = @"上传完成";
    }
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0 && [XGWebDavUploadManager shareUploadManager].uploadingArray.count == 0) {
        return 0;
    }
    if (section == 1 && [XGWebDavUploadManager shareUploadManager].didUploadArray.count == 0) {
        return 0;
    }
    
    return 26;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
