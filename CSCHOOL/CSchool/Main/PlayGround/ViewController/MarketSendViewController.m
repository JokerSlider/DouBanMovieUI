//
//  MarketSendViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/10/11.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MarketSendViewController.h"
#import "MarketDesCell.h"
#import "MarketTitleCell.h"
#import "MaketInputTableViewCell.h"
#import "UITextView+Placeholder.h"
#import "SDAutoLayout.h"
#import "UIButton+BackgroundColor.h"
#import "MarketTypeCell.h"
#import "ValidateObject.h"
#import "RxWebViewController.h"
#import "XGAlertView.h"
#import "UIViewController+BackButtonHandler.h"

@interface MarketSendViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL isHaveDian;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSMutableDictionary *cellDictionary;
@property (nonatomic, retain) NSMutableArray *dataArray;

@property (nonatomic, retain) NSArray *typeArray;//商品类型数组
@property (nonatomic, retain) NSArray *priceTypeArray;//价格类型数组
@property (nonatomic, copy) NSString *goodType; //商品类型
@property (nonatomic, copy) NSString *priceType; //价格类型

@property (nonatomic, assign) BOOL isMianyi; //是否为面议(YES：不显示价格一行)
@end

@implementation MarketSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _mainTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _mainTableView.showsVerticalScrollIndicator = NO;
    _cellDictionary = [NSMutableDictionary dictionary];
    [self titleGet];
    _dataArray = [NSMutableArray array];
    _cellDictionary = [NSMutableDictionary dictionary];
    
    _priceType = @"0";
    
    if ([_module isEqualToString:@"2"] || [_module isEqualToString:@"3"]) {
        [self loadTypeInfo];
    }

    [self createTableFooterView];
}

-(BOOL)navigationShouldPopOnBackButton{
    XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"是否放弃编辑？" WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
    alert.tag = 1012;
    [alert show];
    return NO;
}

- (void)titleGet{
    if ([_module isEqualToString:@"1"]) {
        if ([_reltype isEqualToString:@"1"]) {
            self.navigationItem.title = @"失物发布";
        }else{
            self.navigationItem.title = @"招领发布";
        }
    }else if ([_module isEqualToString:@"2"]){
        if ([_reltype isEqualToString:@"1"]) {
            self.navigationItem.title = @"商品发布";
        }else{
            self.navigationItem.title = @"求购发布";
        }
    }else if ([_module isEqualToString:@"3"]){
        if ([_reltype isEqualToString:@"1"]) {
            self.navigationItem.title = @"招聘发布";
        }else{
            self.navigationItem.title = @"求职发布";
        }
    }
}

- (void)loadTypeInfo{
    NSString *type = ([_module isEqualToString:@"2"])?@"1":@"2";
    //加载类型信息 
    NSDictionary *commitDic = @{
                                @"rid":@"getTypeByModule",
                                @"module":_module,
                                @"type":type
                                };
    _typeArray = [NSArray array];
    [NetworkCore requestPOST:APP_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _typeArray = responseObject[@"data"];
        _dataArray = [NSMutableArray array];
        _cellDictionary = [NSMutableDictionary dictionary];
        [_mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}

#pragma mark TableView delegate&datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if ([_cellDictionary objectForKey:indexPath]) {
        //这里，如果创建过，字典里将存在，则不用重建，解决单元格服用数据丢失的问题
        return [_cellDictionary objectForKey:indexPath];
    }else if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [[MarketTitleCell alloc] init];
            MarketTitleCell *newCell = (MarketTitleCell *)cell;
            [_dataArray addObject:newCell.textFiled];
            
            if (_model.title) {
                newCell.textFiled.text = _model.title;
            }
            
        }else if (indexPath.row ==1){
            cell = [[MarketDesCell alloc] init];
            MarketDesCell *newCell = (MarketDesCell *)cell;
            NSString *placeHolder = @"";
            switch ([_module integerValue]) {
                case 1:
                    placeHolder = @"描述一下你的物品吧";
                    break;
                case 2:
                    placeHolder = @"描述一下你的宝贝吧";
                    break;
                case 3:
                    placeHolder = @"描述一下你的需求吧";
                    break;
                    
                default:
                    break;
            }
            newCell.textView.placeholder = placeHolder;
            [_dataArray addObject:newCell.textView];
            [_dataArray addObject:newCell.selImageView];
            
            if (_model.txtInfo) {
                newCell.textView.text = _model.txtInfo;
            }
            
            if (_model.thumblicArray && _model.thumblicArray.count >0) {
                NSMutableArray *imageListArray = [NSMutableArray array];
                NSMutableArray *ImageIdArray = [NSMutableArray array];
                for (NSDictionary *dic in _model.thumblicArray) {
                    [imageListArray addObject:[dic[@"URL"] stringByReplacingOccurrencesOfString:@"/thumb" withString:@""]];
                    [ImageIdArray addObject:dic[@"ID"]];
                }
                newCell.selImageView.imageIdArray = ImageIdArray;
                [newCell.selImageView addImageWithUrl: imageListArray];
            }
        }
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            cell = [[MarketTypeCell alloc] init];
            MarketTypeCell *newCell = (MarketTypeCell *)cell;
            newCell.titleLabel.text = @"结算方式";
            newCell.typeArray = _typeArray;
            newCell.typeBlock = ^(MarketTypeCell *cell,NSInteger index){
                if (index>=0) {
                    [cell.typeBtn setTitle:_typeArray[index][@"CINAME"] forState:UIControlStateNormal];
                    cell.typeBtn.selected = YES;
                    _priceType = _typeArray[index][@"CIID"];
                    
                    if ([_typeArray[index][@"CINAME"] isEqualToString:@"面议"]) {
                        _isMianyi = YES;
                    }else{
                        _isMianyi = NO;
                    }
                    [_mainTableView reloadData];
                }
                
            };
            
            if (_model.priceType) {
                //                newCell.textField.text = _model.tagName;
                [newCell.typeBtn setTitle:_model.priceType forState:UIControlStateNormal];
                newCell.typeBtn.selected = YES;
                _priceType = [NSString stringWithFormat:@"%@",_model.priceTypeId];
            }
        }else if (indexPath.row == 1) {
            cell = [[MaketInputTableViewCell alloc] init];
            MaketInputTableViewCell *newCell = (MaketInputTableViewCell *)cell;
            newCell.titleLabel.text = @"价格";
            if ([_module isEqualToString:@"3"]) {
                newCell.titleLabel.text = @"工资待遇";
            }
            newCell.textField.placeholder = @"请输入价格";
            newCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
            newCell.textField.tag = 903;
            newCell.textField.delegate = self;
            [_dataArray addObject:newCell.textField];
            
            if (_model.price) {
                newCell.textField.text = _model.price;
            }
            
        }else if (indexPath.row == 2){
            cell = [[MarketTypeCell alloc] init];
            MarketTypeCell *newCell = (MarketTypeCell *)cell;
            newCell.titleLabel.text = @"分类";
            newCell.typeArray = _typeArray;
            newCell.typeBlock = ^(MarketTypeCell *cell,NSInteger index){
                if (index>=0) {
                    [cell.typeBtn setTitle:_typeArray[index][@"CINAME"] forState:UIControlStateNormal];
                    cell.typeBtn.selected = YES;
                    _goodType = _typeArray[index][@"CIID"];
                }
            };
            if (_model.tagName) {
//                newCell.textField.text = _model.tagName;
                [newCell.typeBtn setTitle:_model.tagName forState:UIControlStateNormal];
                newCell.typeBtn.selected = YES;
                _goodType = [NSString stringWithFormat:@"%@",_model.tagID];
            }
            
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            cell = [[MaketInputTableViewCell alloc] init];
            MaketInputTableViewCell *newCell = (MaketInputTableViewCell *)cell;
            newCell.titleLabel.text = @"手机号码";
            newCell.textField.placeholder = @"请输入手机号码";
            newCell.textField.keyboardType = UIKeyboardTypePhonePad;

            newCell.textField.tag = 902;
            newCell.textField.delegate = self;
            if (_model.AUIPHONE) {
                newCell.textField.text = _model.AUIPHONE;
            }
            [_dataArray addObject:newCell.textField];

        }else if (indexPath.row == 1){
            cell = [[MaketInputTableViewCell alloc] init];
            MaketInputTableViewCell *newCell = (MaketInputTableViewCell *)cell;
            newCell.titleLabel.text = @"微信号码";
            newCell.textField.placeholder = @"请输入微信号码";
            
            if (_model.AUIWEIXIN) {
                newCell.textField.text = _model.AUIWEIXIN;
            }
            [_dataArray addObject:newCell.textField];

        }else if (indexPath.row == 2){
            cell = [[MaketInputTableViewCell alloc] init];
            MaketInputTableViewCell *newCell = (MaketInputTableViewCell *)cell;
            newCell.titleLabel.text = @"QQ号码";
            newCell.textField.placeholder = @"请输入QQ号码";
            newCell.textField.tag = 901;
            newCell.textField.delegate = self;
            newCell.textField.keyboardType = UIKeyboardTypeNumberPad;

            if (_model.AUIQQ) {
                newCell.textField.text = _model.AUIQQ;
            }
            [_dataArray addObject:newCell.textField];
        }
    }
    [_cellDictionary setObject:cell forKey:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 240;
    }
    
    if ([_module isEqualToString:@"1"] && indexPath.section == 1) {
        return 0;
    }else if ([_module isEqualToString:@"3"]){
        if (indexPath.section == 1 && indexPath.row == 2) {
            return 0;
        }
        
        if (indexPath.section == 1 && indexPath.row == 1) {
            if (_isMianyi) {
                return 0;
            }else{
                return 44;
            }
        }
    }
    
    if (![_module isEqualToString:@"3"]){
        if (indexPath.section == 1 && indexPath.row == 0) {
            return 0;
        }
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([_module isEqualToString:@"1"] && section == 1) {
        return 0;
    }
    return 10;
}

//创建底部视图
- (void)createTableFooterView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    view.frame = CGRectMake(0, 0, kScreenWidth, 150);
    
    UILabel *mustPutLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:10];
        view.textColor = Base_Orange;
        view.text = @"*手机号码必填";
        view;
    });
    
    UIButton *sendButton = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.backgroundColor = Base_Orange;
        view.layer.cornerRadius = 5.0;
        [view setBackgroundColor:Color_Hilighted forState:UIControlStateHighlighted];
        if (_model) {
            [view setTitle:[NSString stringWithFormat:@"确认修改"] forState:UIControlStateNormal];
        }else{
            [view setTitle:[NSString stringWithFormat:@"确认发布"] forState:UIControlStateNormal];
        }
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    UIButton *agreeBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"点击确认发布即代表同意" forState:UIControlStateNormal];
        [view setTitleColor:Color_Black forState:UIControlStateNormal];
//        [view setImage:[UIImage imageNamed:@"unchose1"] forState:UIControlStateNormal];
//        [view setImage:[UIImage imageNamed:@"chose1"] forState:UIControlStateSelected];
//        [view addTarget:self action:@selector(infoCheck:) forControlEvents:UIControlEventTouchUpInside];
        view.titleLabel.font = Small_TitleFont;
        [view setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        view.titleLabel.textAlignment = NSTextAlignmentRight;
        view.selected = YES;
        view;
    });
    UIButton *infoBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"《发布者相关协议》" forState:UIControlStateNormal];
        [view setTitleColor:Base_Orange forState:UIControlStateNormal];
        [view setTitleColor:Base_Color3 forState:UIControlStateHighlighted];
        view.titleLabel.font = Small_TitleFont;
        view.titleLabel.textAlignment = NSTextAlignmentLeft;
        [view addTarget:self action:@selector(infoAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    [view sd_addSubviews:@[mustPutLabel, sendButton, agreeBtn, infoBtn]];
    
    mustPutLabel.sd_layout
    .topSpaceToView(view,7)
    .leftSpaceToView(view,14)
    .widthIs(126)
    .heightIs(12);
    
    sendButton.sd_layout
    .leftSpaceToView(view,12)
    .rightSpaceToView(view,12)
    .topSpaceToView(mustPutLabel,26)
    .heightIs(41);
    
    agreeBtn.sd_layout
    .leftSpaceToView(view,40)
    .topSpaceToView(sendButton,17)
    .heightIs(13)
    .widthIs(140);
    
    infoBtn.sd_layout
    .leftSpaceToView(agreeBtn,-15)
    .topEqualToView(agreeBtn)
    .heightIs(13)
    .widthIs(123);
    
    _mainTableView.tableFooterView = view;
}
//判断输入字符是否全为空格  
-(BOOL )isEmpty:(NSString *) str {
    if (!str) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}
- (void)sendAction:(UIButton *)sender{
    NSLog(@"%@",_dataArray);
    XGImageSelView *view = _dataArray[2];
    //如果全是空格的话  也认为标题为空
    if ([self isEmpty:[self translate:_dataArray[0]]]) {
        [ProgressHUD showError:@"标题不能为空"];
        return;
    }
    if ([[self translate:_dataArray[0]] isEqualToString:@""]) {
        [ProgressHUD showError:@"标题不能为空"];
        return;
    }
    
    if ([_module isEqualToString:@"1"]) {
        _goodType = @"1";
    }else if ([_module isEqualToString:@"3"]){
        _goodType = @"2";
    }
    
    if (!_goodType) {
        [ProgressHUD showError:@"请选择分类"];
        return;
    }
    
    if ([[self translate:_dataArray[4]]isEqualToString:@""]) {
        [ProgressHUD showError:@"手机号不能为空"];
        return;
    }
    
    if (![[self translate:_dataArray[4]]isEqualToString:@""]) {
        if (![ValidateObject validateMobile:[self translate:_dataArray[4]]]) {
            [ProgressHUD showError:@"请输入正确的电话号码"];
            return;
        }
    }
    
    
    XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"由于您的账户已实名认证，请您不要发布虚假信息 ，不要发布淫秽色情暴力信息，不要违反相关法律，否则后果自负，发布即表示同意《发布者相关协议》。" WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
    alert.tag = 1011;
    [alert show];
    
    
}

- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSString *)translate:(id)obj{
    if ([obj isKindOfClass:[UITextView class]] || [obj isKindOfClass:[UITextField class]]) {
        if ([obj valueForKey:@"text"]) {
            return [obj valueForKey:@"text"]?[obj valueForKey:@"text"]:@"";
        }
    }

    return @"";
}

- (void)infoAction:(UIButton *)sender{
    RxWebViewController* vc = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:WEB_URL_HELP(@"PublisherAgreement.html")]];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title{
    
    if (view.tag == 1011) {
        NSString *rid = @"addReleaseInfo";
        if (_model) {//如果是编辑
            rid = @"updReleaseInfo";
        }
        
        XGImageSelView *selView = _dataArray[2];
        
        NSDictionary *infoDic = @{
                                  @"rid":rid,
                                  @"username":[AppUserIndex GetInstance].role_id,
                                  @"reltitle":[self translate:_dataArray[0]],
                                  @"relcontent":[self translate:_dataArray[1]],
                                  @"relprice":[self translate:_dataArray[3]],
                                  @"relcontacts":[[AppUserIndex GetInstance].role_username length]>0?[AppUserIndex GetInstance].role_username:@"某某某",
                                  @"reladdress":[AppUserIndex GetInstance].schoolName,
                                  @"relstatus":@"2", //1:下架 2：热卖
                                  @"reltype":_reltype?_reltype:_model.infoType,//1:卖 2：买
                                  @"goodtype":_goodType,
                                  @"relphone":[self translate:_dataArray[4]],
                                  @"relqq":[self translate:_dataArray[6]],
                                  @"relwechat":[self translate:_dataArray[5]],
                                  @"photourls":[selView.imageIdArray componentsJoinedByString:@","],
                                  @"module":_module,
                                  @"priceUnit":_priceType
                                  };
        
        NSMutableDictionary *commitDic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
        if (_model) {
            [commitDic setObject:_model.ID forKey:@"relid"];
        }
        
        [NetworkCore requestPOST:APP_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            [ProgressHUD showSuccess:@"发布成功"];
            if (_sendSucessBlock) {
                _sendSucessBlock(_reltype);
            }
            [self performSelector:@selector(popVC) withObject:nil afterDelay:0.5];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            [ProgressHUD showError:error[@"msg"]];
        }];
    }else if (view.tag == 1012){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 901 || textField.tag == 902) {
        return [self validateNumber:string];
    }else if (textField.tag == 903){
        
        if ([textField.text rangeOfString:@"."].location == NSNotFound) {
            isHaveDian = NO;
        }
        if ([string length] > 0) {
            
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
                
                //首字母不能为0和小数点
                if([textField.text length] == 0){
                    if(single == '.') {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
//                    if (single == '0') {
//                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
//                        return NO;
//                    }
                }
                
                //输入的字符是否是小数点
                if (single == '.') {
                    if(!isHaveDian)//text中还没有小数点
                    {
                        isHaveDian = YES;
                        return YES;
                        
                    }else{
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }else{
                    if (isHaveDian) {//存在小数点
                        
                        //判断小数点的位数
                        NSRange ran = [textField.text rangeOfString:@"."];
                        if (range.location - ran.location <= 2) {
                            return YES;
                        }else{
                            return NO;
                        }
                    }else{
                        return YES;
                    }
                }
            }else{//输入的数据格式不正确
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
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
