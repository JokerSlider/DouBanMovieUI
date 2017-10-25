//
//  CallRepairViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/6.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "CallRepairViewController.h"
#import "SingleSelectView.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "IQDropDownTextField.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "UIView+SDAutoLayout.h"
#import "RepairUserInfoViewController.h"
#import "RepairListTableViewCell.h"
#import "TePopList.h"

#define TextViewPlaceHolder @"请描述您的问题"
@interface CallRepairViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, SingSelectViewDelegate,IQDropDownTextFieldDelegate>
{
    NSArray *_deviceTypeArr;
    NSArray *_netStyleArr;
    NSArray *_aroudSpeedArr;
    NSDictionary *_deviceTypeDic;
    NSDictionary *_netStyleDic;
    NSDictionary *_aroudSpeedDic;
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, retain) SingleSelectView *deviceSelectView;
@property (nonatomic, retain) SingleSelectView *netTypeSelectView;
@property (nonatomic, retain) SingleSelectView *arountSelectView;
@property (nonatomic, retain) UITextField *zoneTextField;
@property (nonatomic, retain) UITextView *descripTextView;

@property (nonatomic, retain) UIButton *zoneSelBtn;
@property (nonatomic, retain) UIButton *buildSelBtn;
@property (nonatomic, retain) UIButton *quetionListBtn;

@property (nonatomic, strong) NSMutableArray *questionType;
@property (nonatomic, strong) NSDictionary *quesTypeDic;
@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, strong) NSArray *questionArr;

@property (nonatomic, strong) NSMutableArray *questionZoneArr;  //故障区域
@property (nonatomic, strong) NSMutableArray *questionBuildArr; //故障楼号
@property (nonatomic, assign) NSInteger selZoneNum;
@property (nonatomic, assign) NSInteger selQuesNum;
@property (nonatomic, assign) NSInteger selBuildNum;
@property (nonatomic, strong) NSArray *quetionZoneDicArr; //故障区域所有字典数据
@property (nonatomic, strong) NSArray *questionBuildDicArr; //故障楼号所有字典数据

@property (nonatomic, strong) NSString *questionTypeKey; //提交的故障现象id
@property (nonatomic, strong) NSString *areaAddKey; //提交的区域信息id
@property (nonatomic, strong) NSString *buildAddKey; //楼层id

@end

@implementation CallRepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSArray *viewControllerArray = [self.navigationController viewControllers];
    long previousViewControllerIndex = [viewControllerArray indexOfObject:self] - 1;
    UIViewController *previous;
    if (previousViewControllerIndex >= 0) {
        previous = [viewControllerArray objectAtIndex:previousViewControllerIndex];
        previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                     initWithTitle:@""
                                                     style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:nil];
    }

    self.navigationItem.title = @"新建报修单";
    if (_repairModel) {
        self.navigationItem.title = @"编辑报修单";
    }
    _titleArr = @[@"终端类型:",@"接入方式:",@"周围朋友的上网情况:",@"故障地点:",@"",@"故障现象:",@"故障补充描述"];

//    _deviceTypeArr = @[@"手机、pad",@"电脑"];
//    _netStyleArr = @[@"无线上网", @"有线上网"];
//    _aroudSpeedArr = @[@"正常", @"不正常"];
    _selZoneNum = -1;
    _selQuesNum = -1;
    _selBuildNum = -1;
    [self loadData];
}



- (void)loadData{
    
    [ProgressHUD show:nil];
    //获取常量数据 forKey:@"stuNo"
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getConstInfo",@"stuNo":[AppUserIndex GetInstance].accountId} success:^(NSURLSessionDataTask * _Nullable task, NSDictionary *responseObject) {
        
        if ([responseObject[@"repairCount"] integerValue] !=0 && !_repairModel) {
            XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"您有正在处理的工单，请在处理完成后提交新的工单！" WithCancelButtonTitle:@"确定" withOtherButton:nil];
            alert.isBackClick = YES;
            [alert show];
        }
        
        NSDictionary *dataDic = responseObject[@"const"];
        
//        _quesTypeDic = dataDic[@"FaultType"];
//        _questionType = [dataDic[@"FaultType"] allValues];
        _questionArr = responseObject[@"fault"];
        _questionType = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"fault"]) {
            [_questionType addObject:dic[@"DX_TITLE"]];
        }
        
        _aroudSpeedDic = dataDic[@"FriendsInternet"];
        _aroudSpeedArr = [_aroudSpeedDic allValues];
        
        _netStyleDic = dataDic[@"AccessWay"];
        _netStyleArr = [_netStyleDic allValues];
        
        _deviceTypeDic = dataDic[@"InternetTermina"];
        _deviceTypeArr = [_deviceTypeDic allValues];

        _quetionZoneDicArr = responseObject[@"area"];
        _questionZoneArr = [NSMutableArray array];
        for (NSDictionary *dic in _quetionZoneDicArr) {
            [_questionZoneArr addObject:dic[@"CA_NAME"]];
        }
        [ProgressHUD dismiss];
        [self initSubViews];
        
        if (_repairModel) {
            _nextBtn.backgroundColor = Base_Orange;
            _nextBtn.userInteractionEnabled = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];

    }];

}

- (void)initSubViews{

    //注册通知的方法监听三个文本输入框的值
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(checkAllPut) name:UITextFieldTextDidChangeNotification object:self.zoneTextField];
//    [center addObserver:self selector:@selector(checkAllPut) name:UITextFieldTextDidChangeNotification object:self.descripTextView];
    [center addObserver:self selector:@selector(checkAllPut) name:UITextViewTextDidChangeNotification object:self.descripTextView];

    _deviceSelectView = [[SingleSelectView alloc] init];
    _deviceSelectView.titleArr = _deviceTypeArr;
    _deviceSelectView.delegate = self;
    
    _netTypeSelectView = [[SingleSelectView alloc] init];
    _netTypeSelectView.delegate = self;
    _netTypeSelectView.titleArr = _netStyleArr;

    _arountSelectView = [[SingleSelectView alloc] init];
    _arountSelectView.delegate = self;
    _arountSelectView.titleArr = _aroudSpeedArr;
    
    _zoneTextField = [[UITextField alloc] init];
    _zoneTextField.layer.borderColor  = Base_Color3.CGColor;
    _zoneTextField.layer.borderWidth = 0.5;
//    _zoneTextField.layer.cornerRadius = 5;
    _zoneTextField.placeholder = @"请输入故障区域或宿舍号";
    _zoneTextField.font = Title_Font;

    _descripTextView = [[UITextView alloc] init];
    _descripTextView.text = TextViewPlaceHolder;
    _descripTextView.textColor = [UIColor lightGrayColor];
    _descripTextView.delegate = self;
    _descripTextView.frame = CGRectMake(12, 40, kScreenWidth-24, 100);
    _descripTextView.layer.borderWidth= 0.5;
    _descripTextView.layer.borderColor = Base_Color3.CGColor;
    _descripTextView.layer.cornerRadius = 5;
    
    

    
    _zoneSelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_zoneSelBtn setTitle:@"请选择区域" forState:UIControlStateNormal];
    _zoneSelBtn.layer.borderColor = Base_Color3.CGColor;
    _zoneSelBtn.layer.borderWidth = 0.5;
    _zoneSelBtn.titleLabel.font = Title_Font;
    [_zoneSelBtn setTitleColor:Color_Black forState:UIControlStateNormal];
    [_zoneSelBtn addTarget:self action:@selector(zonePopShow:) forControlEvents:UIControlEventTouchUpInside];
    
    _buildSelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buildSelBtn setTitle:@"请选择楼号" forState:UIControlStateNormal];
    _buildSelBtn.layer.borderColor = Base_Color3.CGColor;
    _buildSelBtn.layer.borderWidth = 0.5;
    _buildSelBtn.titleLabel.font = Title_Font;
    [_buildSelBtn setTitleColor:Color_Black forState:UIControlStateNormal];
    [_buildSelBtn addTarget:self action:@selector(buildPopShow:) forControlEvents:UIControlEventTouchUpInside];
    
    _quetionListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_quetionListBtn setTitle:@"请选择您的故障现象" forState:UIControlStateNormal];
    _quetionListBtn.layer.borderColor = Base_Color3.CGColor;
    _quetionListBtn.layer.borderWidth = 0.5;
    _quetionListBtn.titleLabel.font = Title_Font;
    [_quetionListBtn setTitleColor:Color_Black forState:UIControlStateNormal];
    [_quetionListBtn addTarget:self action:@selector(questionListPopShow:) forControlEvents:UIControlEventTouchUpInside];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.layer.cornerRadius = 5;
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn setBackgroundColor:Base_Color3];
    [_nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn.userInteractionEnabled = NO;
    
    
    if (_repairModel) {
        [_quetionListBtn setTitle:_repairModel.questionType forState:UIControlStateNormal];
        [_deviceSelectView btnSelectWithTitle:[_deviceTypeDic objectForKey:_repairModel.deviceTypeKey]];
        [_netTypeSelectView btnSelectWithTitle:[_netStyleDic objectForKey:_repairModel.netStyleKey]];
        [_arountSelectView btnSelectWithTitle:[_aroudSpeedDic objectForKey:_repairModel.aroundFriendKey]];
        [_zoneSelBtn setTitle:_repairModel.areaAddress forState:UIControlStateNormal];
        [_buildSelBtn setTitle:_repairModel.buildAddress forState:UIControlStateNormal];

        _zoneTextField.text = _repairModel.detailAddress;
        _descripTextView.text = _repairModel.faultDes;
        
    }
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    [footerView addSubview:_nextBtn];
    _nextBtn.frame = CGRectMake(0, 0, kScreenWidth-60, 40);
    _nextBtn.center = footerView.center;
    UIImageView *mastView = [[UIImageView alloc] init];
    [mastView setImage:[UIImage imageNamed:@"cs_mustInput"]];
    UILabel *mastLabel = [[UILabel alloc] init];
    mastLabel.font = [UIFont systemFontOfSize:10];
    mastLabel.textColor = [UIColor grayColor];
    mastLabel.text = @"为必填项";
    [footerView addSubview:mastView];
    [footerView addSubview:mastLabel];
    
    mastView.sd_layout
    .leftEqualToView(_nextBtn)
    .topSpaceToView(_nextBtn,12)
    .widthIs(4)
    .heightIs(4);
    
    mastLabel.sd_layout
    .leftSpaceToView(footerView,35)
    .topSpaceToView(_nextBtn,5)
    .widthIs(120)
    .heightIs(20);
    
    _mainTableView.tableFooterView = footerView;
    [_mainTableView reloadData];
}

- (void)nextBtnAction:(UIButton *)sender{
    if ([_descripTextView.text isEqualToString:TextViewPlaceHolder]) {
        _descripTextView.text = @"";
    }

    if (_selZoneNum<0) {
        _areaAddKey = _repairModel.areaAddKey;
    }else{
        _areaAddKey = _quetionZoneDicArr[_selZoneNum][@"CA_ID"];
    }
    
    if (_selBuildNum<0) {
        _buildAddKey = _repairModel.buildAddKey;
    }else{
        _buildAddKey = _questionBuildDicArr[_selBuildNum][@"SHDID"];
    }
    
    if (_selQuesNum<0) {
        _questionTypeKey = _repairModel.questionTypeKey;
    }else{
        _questionTypeKey = _questionArr[_selQuesNum][@"DX_ID"];
    }
    
    NSDictionary *dic = @{
                          @"deviceType":[_deviceTypeDic allKeysForObject:[_deviceTypeArr objectAtIndex:[_deviceSelectView getSelectIndex]]][0],
                          @"accessFunction":[_netStyleDic allKeysForObject:[_netStyleArr objectAtIndex:[_netTypeSelectView getSelectIndex]]][0],
                          @"netAround":[_aroudSpeedDic allKeysForObject:[_aroudSpeedArr objectAtIndex:[_arountSelectView getSelectIndex]]][0],
                          @"faultArea":_areaAddKey,
                          @"faultFloor":_buildAddKey,
                          @"faultRoom":_zoneTextField.text,
                          @"faultAppearance":_questionTypeKey,
                          @"faultDes":_descripTextView.text,
                          };
    RepairUserInfoViewController *vc = [[RepairUserInfoViewController alloc] init];
    vc.repairInfoDic = dic;
    vc.repairModel = _repairModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:TextViewPlaceHolder]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text length]<1) {
        textView.text = TextViewPlaceHolder;
        textView.textColor = [UIColor lightGrayColor];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }

    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _titleArr[indexPath.row];
    cell.textLabel.font = Title_Font;
    
    UIImageView *mastView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 6, 6)];
    [mastView setImage:[UIImage imageNamed:@"cs_mustInput"]];
    if (indexPath.row != 4 && indexPath.row != 6) {
        [cell.contentView addSubview:mastView];
    }
    
    if (indexPath.row==5) {
        _quetionListBtn.frame = CGRectMake(100, 5, 200, 30);
        [cell.contentView addSubview:_quetionListBtn];
    }else if (indexPath.row==0){
        _deviceSelectView.frame = CGRectMake(100, 7, 200, 30);
        [cell.contentView addSubview:_deviceSelectView];
    }else if (indexPath.row == 1){
        _netTypeSelectView.frame  = CGRectMake(100, 7, 200, 30);
        [cell.contentView addSubview:_netTypeSelectView];
    }else if (indexPath.row == 2){
        _arountSelectView.frame = CGRectMake(120, 7, 200, 30);
        [cell.contentView addSubview:_arountSelectView];
    }else if (indexPath.row == 3){
        _zoneSelBtn.frame = CGRectMake(100, 7, 90, 30);
        [cell.contentView addSubview:_zoneSelBtn];
        _buildSelBtn.frame = CGRectMake(200, 7, 90, 30);
        [cell.contentView addSubview:_buildSelBtn];
    }else if (indexPath.row == 4){
        _zoneTextField.frame = CGRectMake(100, 7, 200, 30);
        [cell.contentView addSubview:_zoneTextField];
    }else if (indexPath.row == 6){
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 150, 40)];
        titleLabel.text = @"故障补充描述:";
        titleLabel.font = Title_Font;
        [cell.contentView addSubview:titleLabel];
        
        [cell.contentView addSubview:_descripTextView];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 6) {
        return 150;
    }else{
        return 44;
    }
}

- (void)checkAllPut{//

    _zoneTextField.text = [_zoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (([_deviceSelectView getSelectIndex]>-1 && [_netTypeSelectView getSelectIndex]>-1 && [_arountSelectView getSelectIndex]>-1 && _selQuesNum>-1 && [_zoneTextField hasText] && _selBuildNum > -1 && _selZoneNum > -1 )|| (_repairModel && [_zoneTextField hasText])) {
        _nextBtn.backgroundColor = Base_Orange;
        _nextBtn.userInteractionEnabled = YES;
    }else{
        _nextBtn.backgroundColor = Base_Color3;
        _nextBtn.userInteractionEnabled = NO;
    }
    
//    _nextBtn.userInteractionEnabled = YES;

}

- (void)selectView:(SingleSelectView *)view didSelectAtIndex:(NSInteger)index{
    [self checkAllPut];
}


- (void)zonePopShow:(UIButton *)sender{
    WEAKSELF;
    TePopList *pop = [[TePopList alloc] initWithListDataSource:_questionZoneArr withTitle:@"选择区域" withSelectedBlock:^(NSInteger select) {
        _selZoneNum = select;
        [weakSelf loadBuildInfo];
        [_zoneSelBtn setTitle:_questionZoneArr[select] forState:UIControlStateNormal];
        [_buildSelBtn setTitle:@"请选择楼号" forState:UIControlStateNormal];
        _selBuildNum = -1;
    }];
    [pop selectIndex:_selZoneNum];
    pop.isAllowBackClick = YES;
    [pop show];//
}

- (void)loadBuildInfo{
    WEAKSELF;
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getFloorInfoByArea",@"areaId":_quetionZoneDicArr[_selZoneNum][@"CA_ID"]} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _questionBuildArr = [NSMutableArray array];
        _questionBuildDicArr = responseObject[@"data"];
        for (NSDictionary *dic in responseObject[@"data"]) {
            [_questionBuildArr addObject:dic[@"SHDNAME"]];
        }
        
        //楼号自动选择列表中第一个
        [_buildSelBtn setTitle:_questionBuildArr[0] forState:UIControlStateNormal];
        _selBuildNum = 0;
        
        [weakSelf checkAllPut];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        _questionBuildArr = [NSMutableArray array];
    }];
}

- (void)buildPopShow:(UIButton *)sender{
    WEAKSELF;
    TePopList *pop = [[TePopList alloc] initWithListDataSource:_questionBuildArr withTitle:@"选择楼号" withSelectedBlock:^(NSInteger select) {
        _selBuildNum = select;
        [_buildSelBtn setTitle:_questionBuildArr[select] forState:UIControlStateNormal];
        [weakSelf checkAllPut];
    }];
    pop.isAllowBackClick = YES;
    [pop selectIndex:_selBuildNum];

    [pop show];//questionListPopShow
}

- (void)questionListPopShow:(UIButton *)sender{
    WEAKSELF;
    TePopList *pop = [[TePopList alloc] initWithListDataSource:_questionType withTitle:@"选择故障现象" withSelectedBlock:^(NSInteger select) {
        _selQuesNum = select;
        [_quetionListBtn setTitle:_questionType[select] forState:UIControlStateNormal];
        [weakSelf checkAllPut];
    }];
    [pop selectIndex:_selQuesNum];
    pop.isAllowBackClick = YES;
    [pop show];//
}

#pragma mark XGAlertView delegate
- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title{
    [self.navigationController popViewControllerAnimated:YES];
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
