
//
//  LoginoneViewController.m
//  CSchool
//
//  Created by mac on 16/1/11.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "LoginoneViewController.h"
#import "ZYPinYinSearch.h"
#import "GTMBase64.h"
#import <JSONKit.h>
#import "SchoolModel.h"
#import "XGAlertView.h"
#import "NetworkCore.h"
#import "BaseGMT.h"
#import "Reachability.h"
//#import "RealReachability.h"
#import "LoginNewViewController.h"
#import "UIButton+BackgroundColor.h"
#import "ValidateObject.h"

@interface LoginoneViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,XGAlertViewDelegate>
 
@property (nonatomic,strong) NSMutableArray  * originalArray;
@property (nonatomic,strong) NSArray    * dataSourceArray;
@property (nonatomic,strong)NSMutableArray *modelArray;

@property (nonatomic,strong) UITableView     * tableView;
@property (nonatomic,strong) UITextField     * searchText;
@property(nonatomic,strong)  UIButton *nextBtn;
@property (nonatomic, strong)LoginNewViewController *login2;

@property (nonatomic,strong)SchoolModel *cuurentModel;//当前的model

//@property(nonatomic,copy)NSString *schoolId;

@end

@implementation LoginoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    [self LoginNotification];
    [self loadData];
}

#pragma -mark 数据请求
-(void)loadData{
    
    NSString *rid = @"getSchoolInfo";
    NSString *schVerNum = @"0";
    NSDictionary *params = @{
                             @"rid" : rid,
                             @"schVerNum" : schVerNum,
                             };

    _originalArray = [NSMutableArray array];
    _modelArray = [NSMutableArray array];
    [ProgressHUD show:@"正在加载..."];

    [NetworkCore requestTarget:self POST:API_HOST parameters:params withVerKey:@"schoolVersion" success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {

        NSDictionary *dic = [responseObject objectForKey:@"data"];
         NSArray *schoolInfo = [dic objectForKey:@"schoolInfo"];
        
        for (NSDictionary *schoolDic in schoolInfo) {
            SchoolModel *model = [[SchoolModel alloc]initWithDic:schoolDic];
            [_modelArray addObject:model];
            [_originalArray addObject:model.schoolName];
        }
        AppUserIndex *user = [AppUserIndex GetInstance];
        for (NSDictionary *schoolDic in schoolInfo) {
            SchoolModel *model = [[SchoolModel alloc]initWithDic:schoolDic];
            if ([model.schoolCode isEqualToString:user.schoolCode]) {
                user.schoolId = model.schoolId;
                user.schoolName = model.schoolName;
                user.API_URL = [NSString stringWithFormat:@"http://%@/index.php",model.serverIpAddress];
                user.wifiName = model.wifiName;
                [user saveToFile];
            }
        }
        _dataSourceArray = [NSMutableArray arrayWithArray:_originalArray];
        [self.tableView reloadData];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        //请求失败，开始请求第二个地址。
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

-(void)loadData3{
    NSString *rid = @"getSchoolInfo";
    NSString *schVerNum = @"0";
    NSDictionary *params = @{
                             @"rid" : rid,
                             @"schVerNum" : schVerNum,
                             };
    _originalArray = [NSMutableArray array];
    [NetworkCore requestTarget:self POST:API_HOST parameters:params withVerKey:@"schoolVersion" success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [self netSuccess:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:@"网络开小差了~重新加载试试"];
    }];
    
}
- (void)netSuccess:(NSDictionary *)responseObject{

    NSDictionary *dic = [responseObject objectForKey:@"data"];
    NSArray *schoolInfo = [dic objectForKey:@"schoolInfo"];
    //学校id
    for (NSDictionary *schoolDic in schoolInfo) {
        SchoolModel *model = [[SchoolModel alloc]initWithDic:schoolDic];

        [_modelArray addObject:model];
        [_originalArray addObject:model.schoolName];
    }
    AppUserIndex *user = [AppUserIndex GetInstance];
    for (NSDictionary *schoolDic in schoolInfo) {
        SchoolModel *model = [[SchoolModel alloc]initWithDic:schoolDic];
        if ([model.schoolCode isEqualToString:user.schoolCode]) {
            user.schoolId = model.schoolId;
            user.schoolName = model.schoolName;
            user.API_URL = [NSString stringWithFormat:@"http://%@/index.php",model.serverIpAddress];
            user.wifiName = model.wifiName;
            [user saveToFile];
        }
    }
    
    _dataSourceArray = [NSMutableArray arrayWithArray:_originalArray];
    [self.tableView reloadData];
    [ProgressHUD dismiss];
}

/*
 *UI界面
 */
-(void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"请选择学校";
    UINavigationBar *bar = [UINavigationBar appearance];
    //设置显示的颜色
    bar.barTintColor = Base_Orange;
    //初始化时如果输入文本框的内容为空 则下一步的btn不可使用
    [self.searchText setBorderStyle:UITextBorderStyleRoundedRect];
    _searchText = [[UITextField  alloc]initWithFrame:CGRectMake(kScreenWidth*.05/2, 16, kScreenWidth*.95, 30)];
    [_searchText setBorderStyle:UITextBorderStyleNone];
    _searchText.delegate = self;
    _searchText.font = Title_Font;
    _searchText.layer.borderColor = (Base_Color3).CGColor;
    _searchText.layer.borderWidth = 1;
    _searchText.clearButtonMode = UITextFieldViewModeAlways;
    _searchText.placeholder = @"请输入您的学校名称或者拼音缩写";
    
    [_searchText addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventAllEditingEvents];

    [_searchText addTarget:self action:@selector(alertTextFieldDidChanged:) forControlEvents:UIControlEventAllEditingEvents];

    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,26)];
    leftView.backgroundColor = [UIColor clearColor];
    _searchText.leftView = leftView;
    _searchText.leftViewMode = UITextFieldViewModeAlways;
    _searchText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.view addSubview:_searchText];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth*.05/2, 110-64, kScreenWidth*.95, kScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    [self.view addSubview:self.tableView];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 200)];
    self.tableView.tableFooterView = footView;
    
    [self.nextBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextBtn.layer.cornerRadius = 5;
    self.nextBtn.frame = CGRectMake((kScreenWidth-250)/2-15,100, 280, 40);
    self.nextBtn.backgroundColor = Base_Color3;
    [self.nextBtn setBackgroundColor:Color_Hilighted forState:UIControlStateHighlighted];
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(jumpLogin) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:self.nextBtn];
}
//点击跳转方法
-(void)jumpLogin{
    BOOL isTrue = NO;
    NSString *schoolName;
    NSString *str = [NSString stringWithFormat:@"%@",self.searchText.text];
    for (schoolName in _originalArray) {
        isTrue = [str isEqualToString:schoolName];
        if (isTrue==YES) {
            break;
        }else{
            continue;
        }
    }
if (isTrue==YES) {
        //学校名称  单例
        self.login2 = [[LoginNewViewController alloc]init];
        self.login2.schoolName = _cuurentModel.schoolName;
        self.login2.schoolID = _cuurentModel.schoolId;
        AppUserIndex *user = [AppUserIndex GetInstance];
        NSString *theWifi = _cuurentModel.wifiName;
        NSString *theIP = _cuurentModel.serverIpAddress?_cuurentModel.serverIpAddress:_cuurentModel.ltServerIpAddress;
        NSString *schoolNameLocal =_cuurentModel.schoolName;
        NSString *schoolCode = _cuurentModel.schoolCode;
        user.schoolCode = schoolCode;
        user.schoolName = schoolNameLocal;
        if (theWifi!=NULL) {
            user.wifiName = theWifi;
        }
        if (theIP!=NULL) {
            user.API_URL = [NSString stringWithFormat:@"http://%@/index.php",theIP];
        }
    NSLog(@"%@",_cuurentModel.isShowPhone);
    user.isShowPhone = [[NSString stringWithFormat:@"%@",_cuurentModel.isShowPhone] boolValue];
    user.eportalVer = [[NSString stringWithFormat:@"%@", _cuurentModel.eportalVer] boolValue];
    //确定是否使用新版本的一键上网 和 是否弹窗
    [user saveToFile];
    if (user.isShowPhone) {
        [self inputUserPhoneNum];

    }else{
        [self.navigationController pushViewController:self.login2 animated:YES];
        }
    }
    else{
        XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"尊敬的用户您好" withContent:@"您输入的学校名称有误,请重新输入" WithCancelButtonTitle:@"确定" withOtherButton:nil];
        [alert show];
    }
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
        
        [self.navigationController pushViewController:self.login2 animated:YES];
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(phoneTextFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification" object:phoneInputView.textField];
    phoneInputView.isBackClick = NO;
    [phoneInputView show];
}
-(void)LoginNotification
{
    //初始化时如果输入文本框的内容为空 则下一步的btn不可使用
    if (_searchText.text.length == 0) {
        _nextBtn.backgroundColor = Base_Color3;
        _nextBtn.enabled = NO;
    }
    //注册通知的方法监听三个文本输入框的值
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(TextFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:_searchText];
}
-(void)TextFieldDidChanged:(NSNotification *)notifi
{
    if (_searchText.text.length==0) {
        _nextBtn.enabled = NO;
        _nextBtn.backgroundColor =Base_Color3;
    }else{
        _nextBtn.enabled = YES;
        _nextBtn.backgroundColor = Base_Orange;
    }
    
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

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
}
#pragma -mark tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
     return _dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"schoochoosecell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"schoochoosecell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    if (_dataSourceArray.count==0) {
        _dataSourceArray = [NSArray arrayWithArray:_originalArray];
        cell.textLabel.text = _dataSourceArray[indexPath.row];
        [self.tableView reloadData];
    }
    cell.textLabel.text =_dataSourceArray[indexPath.row];
    cell.textLabel.font = Title_Font;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = _dataSourceArray[indexPath.row];
    SchoolModel *myModel ;
    for (SchoolModel *model in _modelArray) {
        if ([model.schoolName isEqualToString:name]) {
            myModel = model;
        }
    }
    _cuurentModel = myModel;
    self.searchText.text = _cuurentModel.schoolName;
    if (self.searchText.text.length!=0&&[self.searchText.text isEqualToString:_dataSourceArray[indexPath.row]] ) {
        self.nextBtn.backgroundColor = Base_Orange;
        self.nextBtn.enabled =YES;
    }else{
    
        self.nextBtn.backgroundColor = Base_Color3;
        self.nextBtn.enabled =NO;
    }
}
#pragma -mark textFieldDelegate
-(void)alertTextFieldDidChanged:(UITextField *)textfield
{
    _dataSourceArray = [ZYPinYinSearch searchWithOriginalArray:_originalArray andSearchText:self.searchText.text andSearchByPropertyName:@"name"];
    if (textfield.text.length== 0) {
        self.nextBtn.enabled = NO;
        self.nextBtn.backgroundColor = Base_Color3;
        }
    else{
        self.nextBtn.enabled = YES;
        self.nextBtn.backgroundColor = Base_Orange;
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.searchText.text isEqualToString:@""]) {
        _dataSourceArray = _originalArray;
    }else{
    
        _dataSourceArray = [ZYPinYinSearch searchWithOriginalArray:_originalArray andSearchText:self.searchText.text andSearchByPropertyName:@"name"];
    }
    [_tableView reloadData];
    [self.searchText becomeFirstResponder];


}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.searchText.text isEqualToString:@""]) {
        _dataSourceArray = _originalArray;
    }else{
        _dataSourceArray = [ZYPinYinSearch searchWithOriginalArray:_originalArray andSearchText:self.searchText.text andSearchByPropertyName:@"name"];
    }
    [_tableView reloadData];
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
