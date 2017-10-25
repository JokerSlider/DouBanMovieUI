//
//  SchoolSelectViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 2017/7/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "SchoolSelectViewController.h"
#import "UserLoginViewController.h"
#import "ValidateObject.h"
#import "EncryptObject.h"

@interface SchoolSelectViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) NSDictionary *logoDic;

@end

@implementation SchoolSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择学校";
    _tableView.tableFooterView = [UIView new];
    self.navigationController.navigationBar.shadowImage = [UIImage new];

    [self loadData];
//    [self loadData2];
}

-(void)loadData{
    //开始请求第一个服务器地址
    [ProgressHUD show:@"正在加载..."];
    NSString *rid = @"getSchoolInfo";
    NSString *schVerNum = @"0";
    NSDictionary *params = @{
                             @"rid" : rid,
                             @"schVerNum" : schVerNum
                             };
    
    [NetworkCore requestTarget:self POST:API_HOST parameters:params withVerKey:@"schoolVersion" success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [self netSuccess:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self loadData2];
    }];
    
}

-(void)loadData2{
    //开始请求第二个服务器地址
    [ProgressHUD show:@"正在加载,请稍等"];
    NSString *rid = @"getSchoolInfo";
    NSString *schVerNum = @"0";
    NSDictionary *params = @{
                             @"rid" : rid,
                             @"schVerNum" : schVerNum,
                             @"isp":@"lt"  //新加参数，联通地址
                             };
    
    [NetworkCore requestTarget:self POST:API_HOST2 parameters:params withVerKey:@"schoolVersion" success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [self netSuccess:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
        [self showErrorViewLoadAgain:error[@"msg"]];
    }];
    
}

- (void)netSuccess:(NSDictionary *)responseObject{
    
    NSDictionary *dic = [responseObject objectForKey:@"data"];
//    NSArray *schoolInfo = [dic objectForKey:@"schoolInfo"];
    _dataArray = [dic objectForKey:@"schoolInfo"];
    _logoDic = responseObject[@"logos"];
    //学校id
//    for (NSDictionary *schoolDic in schoolInfo) {
//        SchoolModel *model = [[SchoolModel alloc]initWithDic:schoolDic];
//        
//        [_modelArray addObject:model];
//        [_originalArray addObject:model.schoolName];
//    }
    
//    for (NSDictionary *schoolDic in schoolInfo) {
//        SchoolModel *model = [[SchoolModel alloc]initWithDic:schoolDic];
//        if ([model.schoolCode isEqualToString:user.schoolCode]) {
//
//        }
//    }
//    
//    _dataSourceArray = [NSMutableArray arrayWithArray:_originalArray];
    [self.tableView reloadData];
    [ProgressHUD dismiss];
}
#pragma -mark tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
//    NSDictionary *dic = _dataArray[]
    cell.textLabel.text = _dataArray[indexPath.row][@"schoolName"];
    cell.textLabel.textColor = Color_Black;
    cell.textLabel.font = Title_Font;
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *dic = _dataArray[indexPath.row];
    
    AppUserIndex *user = [AppUserIndex GetInstance];
    user.schoolId = dic[@"schoolId"];
    user.schoolCode = dic[@"schoolCode"];
    user.schoolName = dic[@"schoolName"];
//    user.API_URL = [NSString stringWithFormat:@"http://%@/index.php",dic[@"serverIpAddress"]?dic[@"serverIpAddress"]:dic[@"ltServerIpAddress"]];
    user.API_URL = API_HOST2;

    user.wifiName = dic[@"wifiName"];
    user.schoolLogo = _logoDic[dic[@"schoolCode"]];
//    [user saveToFile];
    
    if ([dic[@"isShowPhone"] boolValue]) {
        XGAlertView *phoneInputView = [[XGAlertView alloc]initWithTitle:@"请输入您的手机号码（手机号码必须确保真实有效）" withUnit:@"" click:^(NSString *index) {
            if (![ValidateObject validateMobile:index]) {
                [ProgressHUD showError:@"请输入正确的手机号"];
                return ;
            }
            [AppUserIndex GetInstance].userInputPhonenum = index;
            [[AppUserIndex GetInstance] saveToFile];
            
            //        [self.navigationController pushViewController:self.login2 animated:YES];
            UserLoginViewController *vc = [[UserLoginViewController alloc] init];
            vc.isShowNew = [dic[@"isNewEntry"] boolValue];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(phoneTextFiledEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification" object:phoneInputView.textField];
        phoneInputView.isBackClick = NO;
        [phoneInputView show];
        return;
    }

    UserLoginViewController *vc = [[UserLoginViewController alloc] init];
    vc.isShowNew = [dic[@"isNewEntry"] boolValue];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 用户输入手机号
 */
-(void)inputUserPhoneNum
{
    XGAlertView *phoneInputView = [[XGAlertView alloc]initWithTitle:@"请输入您的手机号码（手机号码必须确保真实有效）" withUnit:@"" click:^(NSString *index) {
        if (![ValidateObject validateMobile:index]) {
            [ProgressHUD showError:@"请输入正确的手机号"];
            return ;
        }
        [AppUserIndex GetInstance].userInputPhonenum = index;
        [[AppUserIndex GetInstance] saveToFile];
        
//        [self.navigationController pushViewController:self.login2 animated:YES];
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(phoneTextFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification" object:phoneInputView.textField];
    phoneInputView.isBackClick = NO;
    [phoneInputView show];
}

#pragma MARK  notifi
-(void)phoneTextFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > 11)
        {
            
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:8];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:11];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 11)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    
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
