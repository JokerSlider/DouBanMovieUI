//
//  OrderNewBusViewController.m
//  CSchool
//
//  Created by mac on 17/8/29.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OrderNewBusViewController.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "BusChoseModel.h"
#import "NewBusChoseCell.h"
#import "NSDate+Extension.h"
@interface OrderNewBusViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)UILabel *noticeLabel;

@property (nonatomic,strong)NSMutableArray *keyArr;
@property (nonatomic,strong)NSMutableDictionary *valueDic;


@property (nonatomic,strong)NSMutableArray *totalArr;
@property (nonatomic,strong)NSMutableArray *modelArr;
@property (nonatomic,strong )BusChoseModel *dataModel;


@property (nonatomic,assign)BOOL   isChanged;//是否修改了信息

@end

@implementation OrderNewBusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提交信息";
//#warning 记得注释掉
//    [AppUserIndex GetInstance].yanzhengPhoneArray = @[@"18306442957",@"1596410245",@"13173001909"];
    [self createView];
    //默认没有改变
    _isChanged   = NO;
    
    if (_isEdit) {
        [self loadOldData];
    }else{
        BusChoseModel *model = [BusChoseModel new];
        model.travel_type = @"请选择交通工具";
        model.beginAddr   = @"请输入发车地点";
        model.endAddr     = @"请选择终到站";
        model.expectArrive = @"请选择到站时间";
        model.telphone    = @"请选择手机号";
        model.peerNum    = @"请输入同行人数";
        model.bz         = @"请输入备注信息";
        [self loadData:model andDic:nil];
    }
}
-(void)createView
{
    self.view.backgroundColor = Base_Color2;
    self.noticeLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(244,86,50);
        view.font = [UIFont systemFontOfSize:12.0];
        view.text = @"温馨提示：填写的手机号一定是录取通知书中所包含的三张电话卡中的号码。\r*为必填项，请不要漏填哦~";
        view;
    });
    [self.view addSubview:self.noticeLabel];
    self.noticeLabel.sd_layout .leftSpaceToView(self.view,14).rightSpaceToView(self.view,14).topSpaceToView(self.view,6).autoHeightRatio(0);
    [self.noticeLabel updateLayout];
    NSLog(@"%f",self.noticeLabel.size.height);
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,0, 0) style:UITableViewStyleGrouped];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.noticeLabel,6).widthIs(kScreenWidth).heightIs(kScreenHeight-64);
}
#pragma mark  获取已经填写的信息。
-(void)loadOldData
{
    _valueDic = [NSMutableDictionary dictionary];
    [ProgressHUD show:@"正在加载..."];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"searchTravelInfo",@"userid":stuNum} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        BusChoseModel *model = [BusChoseModel new];
        NSArray *sourceArr = responseObject[@"data"];
        NSDictionary *dic = [sourceArr firstObject];//有且只有一个值
        [model yy_modelSetWithDictionary:dic];
        //默认值
        [self loadData:model andDic:dic];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
        [self showErrorViewLoadAgain:@"获取信息失败,请点击重新去取!"];
    }];
}

-(void)loadData:(BusChoseModel *)deafultModel andDic:(NSDictionary *)defaultDic{
    _keyArr = [NSMutableArray array];
    _modelArr = [NSMutableArray array];
    _valueDic = [NSMutableDictionary dictionary];

    NSArray *firtArr  = @[
                     @{
                         @"fieldLable":@"交通工具",
                         @"fieldType":@"select",
                         @"filedName":@"travel_type",
                         @"isMust":@"1",
                         @"value":deafultModel.travel_type,//@"请选择交通工具"  占位字符串，
                         @"filedSubTitle":defaultDic[@"travel_type"]?defaultDic[@"travel_type"]:@""//默认值
                        },
                     @{
                         @"fieldLable":@"发车地点",
                         @"fieldType":@"text",
                         @"filedName":@"beginAddr",
                         @"isMust":@"1",
                         @"value":deafultModel.beginAddr,//@"请输入发车地点"
                         @"filedSubTitle":defaultDic[@"beginAddr"]?defaultDic[@"beginAddr"]:@""
                         },
                     @{
                         @"fieldLable":@"终到站",
                         @"fieldType":@"select",
                         @"filedName":@"endAddr",
                         @"isMust":@"1",
                         @"value":deafultModel.endAddr,//@"请选择终到站"
                         @"filedSubTitle":defaultDic[@"endAddr"]?defaultDic[@"endAddr"]:@""
                         },
                     @{
                         @"fieldLable":@"到站时间",
                         @"fieldType":@"dateTime",
                         @"filedName":@"expectArrive",
                         @"isMust":@"1",
                         @"value":deafultModel.expectArrive,//@"请选择到站时间"
                         @"filedSubTitle":defaultDic[@"expectArrive"]? [NSDate tranlateOldTimeString:defaultDic[@"expectArrive"] withOldFormat:@"yyyy-MM-dd HH:mm:ss" andNewformat:@"yyyy-MM-dd HH:mm"] :@""//改变时间格式
                         }
                     
                     ];
    NSArray *secArr   = @[
                     @{
                         @"fieldLable":@"联系方式",
                         @"fieldType":@"mutiselect",
                         @"filedName":@"telphone",
                         @"isMust":@"1",
                         @"value":deafultModel.telphone,//@"请选择联系方式"
                         @"filedSubTitle":defaultDic[@"telphone"]?defaultDic[@"telphone"]:@""

                         },
                     @{
                         @"fieldLable":@"同行人数",
                         @"fieldType":@"number",
                         @"filedName":@"peerNum",
                         @"isMust":@"1",
                         @"value":deafultModel.peerNum,//@"请输入同行人数"
                         @"filedSubTitle":defaultDic[@"peerNum"]?defaultDic[@"peerNum"]:@""
                         }
                     ];
  NSArray *thirdArr = @[
                        @{
                            @"fieldLable":@"备注信息",
                            @"fieldType":@"text",
                            @"filedName":@"bz",
                            @"isMust":@"0",
                            @"value":deafultModel.bz,//@"请输入备注信息"
                            @"filedSubTitle":defaultDic[@"bz"]?defaultDic[@"bz"]:@""

                         }
                     ];

    NSMutableArray *firtSecArr = [NSMutableArray array];
    NSMutableArray *secSecArr = [NSMutableArray array];
    NSMutableArray *thirdSecArr = [NSMutableArray array];
    self.totalArr = [NSMutableArray array];
    NSArray *array = [AppUserIndex GetInstance].yanzhengPhoneArray;
    NSMutableArray *phoneNumArr = [NSMutableArray array];
    for (int i = 0; i<array.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:array[i] forKey:@"ta_name"];
        [dic setValue:@(i) forKey:@"ta_id"];
        [phoneNumArr addObject:dic];
    }
    self.dataModel = [BusChoseModel new];
    self.dataModel.sj =[NSArray arrayWithArray:phoneNumArr];

    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL  parameters:@{@"rid":@"getTravelDictionary",@"userid":stuNum} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        [self.dataModel yy_modelSetWithDictionary:responseObject[@"data"]];
        
        for (NSDictionary *dic in firtArr) {
            BusChoseModel *model = [BusChoseModel new];
            
            [model yy_modelSetWithDictionary:dic];
            if ([model.filedName isEqualToString:@"beginAddr"]&&self.dataModel.cf_address) {
                [_valueDic setValue:self.dataModel.cf_address forKey:@"beginAddr"];
                model.value = self.dataModel.cf_address;
            }
            [firtSecArr addObject:model];
        }
        for (NSDictionary *dic in secArr) {
            BusChoseModel *model = [BusChoseModel new];
            [model yy_modelSetWithDictionary:dic];
            [secSecArr  addObject:model];
        }
        for (NSDictionary *dic in thirdArr) {
            BusChoseModel *model = [BusChoseModel new];
            [model yy_modelSetWithDictionary:dic];
            [thirdSecArr addObject:model];
        }
        [_totalArr addObject:firtSecArr];
        [_totalArr addObject:secSecArr];
        [_totalArr addObject:thirdSecArr];
        if (_isEdit&&defaultDic) {
            [self setDeafultValue:defaultDic withKeyArr:@[@"travel_type",@"peerNum",@"expectArrive",@"beginAddr",@"telphone",@"bz",@"endAddr"]];

        }
        
        [self.mainTableView reloadData];
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [JohnAlertManager showFailedAlert:@"网络错误" andTitle:@"提示"];
    }];
}
-(void)setDeafultValue:(NSDictionary *)dic withKeyArr:(NSArray *)keyArr
{
    for (NSString *key in keyArr) {
        if ([key isEqualToString:@"travel_type"]) {
            /*
            NSString *value = [self getIDByString:dic[key]];
            [_valueDic setValue:value forKey:key];
             */
            NSString *value = dic[@"type_id"];
            [_valueDic setValue:value forKey:key];

        }else if ([key isEqualToString:@"endAddr"]){
            NSString *value = dic[@"end_address_id"];

            //NSString *value = [self getIDByString:dic[key]];
            [_valueDic setValue:value forKey:key];
        }else{
            [_valueDic setValue:dic[key] forKey:key];
            
        }
    }
}
#pragma mark  根据汉字获取ID
-(NSString *)getIDByString:(NSString *)inputNum
{
    NSString *ID ;
    NSArray *travel_typeArr = self.dataModel.c_type;
    NSArray *endAddr_typeArr = self.dataModel.address;
    for (NSDictionary *dic in travel_typeArr) {
        BusChoseModel *model = [BusChoseModel new];
        [model yy_modelSetWithDictionary:dic];
        if ([model.ta_name isEqualToString:inputNum]) {
            ID =  model.ta_id;
        }
        if (ID) {
            NSLog(@"%@",ID);
            return ID;
        }
    }
    for (NSDictionary *dic in endAddr_typeArr) {
        BusChoseModel *model = [BusChoseModel new];
        [model yy_modelSetWithDictionary:dic];
        if ([model.ta_name isEqualToString:inputNum]) {
            ID =  model.ta_id;
        }
        
    }
    return ID;
    
}


#pragma mark  Delegate   datatSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _totalArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else if (section==1){
        return 2;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    BusChoseModel *model = _totalArr[indexPath.section][indexPath.row];
    if (indexPath.section==0&&indexPath.row==0) {
        model.content = self.dataModel.c_type;
    }else if (indexPath.section==0&&indexPath.row==2){
        model.content = self.dataModel.address;
    }else if (indexPath.section==1&&indexPath.row==0){
        model.content = self.dataModel.sj;
    }
    
    static NSString *cellID = @"BusChoseCell";
    NewBusChoseCell   *cell =[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[NewBusChoseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.inputText.tag =[[NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row] intValue];
    
    cell.selectEndBlock = ^(NSString *text,NSString *ID,NSInteger index){
        _isChanged  =  YES;

        NSLog(@"输入的字符串:%@,下标:%ld,ID:%@",text,(long)index,ID);
        NSString *key = model.filedName;
        
        if ([_keyArr containsObject:key]) {
            [_valueDic removeObjectForKey:key];
            if ([key isEqualToString:@"travel_type"]||[key isEqualToString:@"endAddr"]) {
                [_valueDic setValue:ID forKey:key];
                
            }else{
                [_valueDic setValue:text forKey:key];
            }
        }else{
            [_keyArr addObject:key];
            if ([key isEqualToString:@"travel_type"]||[key isEqualToString:@"endAddr"]) {
                [_valueDic setValue:ID forKey:key];
                
            }else{
                [_valueDic setValue:text forKey:key];
            }
        }
        
    };
    return cell;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
/*设置标题尾的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 200;
    }
    return 8;
}
/*设置标题脚的名称*/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor redColor];
    return headView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==2) {
        UIView  *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        UIButton *pushBtn = ({
            UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
            view.backgroundColor = Base_Orange;
            view.layer.cornerRadius = 5;
            [view setTitle:@"提交" forState:UIControlStateNormal];
            [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            view.titleLabel.font = [UIFont systemFontOfSize:17];
            [view addTarget:self action:@selector(pushMessage) forControlEvents:UIControlEventTouchUpInside];
            view;
        });
        
        UILabel *noticeL = ({
            UILabel *view = [UILabel new];
            view.font = [UIFont systemFontOfSize:11];
            view.textColor = RGB(244, 86, 50);
            view.text = @"提交成功后请等待，一天内请尽量不要多次重复提交表单，以免不能正常乘坐班车。";
            view;
        });
        [backView sd_addSubviews:@[pushBtn,noticeL]];
        pushBtn.sd_layout.leftSpaceToView(backView,12).rightSpaceToView(backView,12).heightIs(41).topSpaceToView(backView,35);
        noticeL.sd_layout.leftEqualToView(pushBtn).topSpaceToView(pushBtn,10).rightSpaceToView(backView,14).autoHeightRatio(0);
        return backView;
  
    }
    return nil;
}
//高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        return 50;
    }
    
    return 50;
    
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark  提交信息
/*
 travel_type    出行类型 1 火车 2 汽车 3 飞机 4 自驾 5 其他  c_type
 expectArrive  时间戳，预计到达时间
 beginAddr     出发地
 endAddr       目的地  address
 trainNum      车次
 peerNum       同行人数
 telphone      联系电话    sj
 bz            备注信息
 */
-(void)pushMessage
{
    [self.view endEditing:YES];
    NSString *travel_type = @"";
    NSString *expectArrive = @"";
    NSString *beginAddr = @"";
    NSString *endAddr = @"";
    NSString *trainNum = @"";
    NSString *peerNum = @"";
    NSString *telphone = @"";
    NSString *bz = @"";
    
    
    BusChoseModel *model = [BusChoseModel new];
    [model yy_modelSetWithDictionary:_valueDic];
    travel_type = model.travel_type;
    expectArrive =[NSDate tranlateDateString:model.expectArrive andFormatStr:@"YYYY-MM-dd HH:mm:ss"];//odel.expectArrive;
    beginAddr = model.beginAddr;
    endAddr = model.endAddr;
    trainNum = @"g320";
    peerNum = model.peerNum;
    telphone = model.telphone;
    bz = model.bz;
    if (travel_type.length==0 || expectArrive.length == 0 || beginAddr.length ==0 || endAddr.length == 0 || peerNum.length==0 || telphone.length ==0) {
        [JohnAlertManager showFailedAlert:@"请将信息填全" andTitle:@"提示"];
        return;
    }
    NSLog(@"%@",_valueDic);
    [_valueDic setValue:@"addOrUpdateTravelForStudent" forKey:@"rid"];
    [_valueDic setValue:stuNum forKey:@"userid"];
    [_valueDic removeObjectForKey:@"expectArrive"];
    [_valueDic setValue:@"ios" forKey:@"trainNum"];
    [_valueDic setValue:[NSDate tranlateDateString:model.expectArrive andFormatStr:@"YYYY-MM-dd HH:mm:ss"] forKey:@"expectArrive"];
    if (_isEdit) {
        [_valueDic setValue:@"1" forKey:@"state"];
    }else{
        [_valueDic setValue:@"0" forKey:@"state"];
        
    }
    if (!_isChanged) {
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });

        return;
    }
    [ProgressHUD show:@"正在提交..."];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:_valueDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        [JohnAlertManager showFailedAlert:responseObject[@"msg"] andTitle:@"提示"];
        BOOL isSuccess  = [responseObject[@"data"][@"add_or_update_t_student_trip_info"] boolValue];
        if (isSuccess) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UserHaveAddMessage" object:nil];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
        [JohnAlertManager showFailedAlert:@"提交失败,请重新提交" andTitle:@"提示"];

    }];
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
