//
//  ChooseTypeViewController.m
//  CSchool
//
//  Created by mac on 16/8/1.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ChooseTypeViewController.h"
#import "UIView+SDAutoLayout.h"
#import "ChooseTypeViewController.h"
#import "NSDate+Extension.h"
#import "SalaryModel.h"

//#define cellHeight  50
//#define salaryHeight 35
@interface ChooseTypeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *_backView;
    //点击次数  添加button的个数
    int  _clcikNum;
    //点击后显示的btn
    UIButton *_chooseBtn;
    //列表的数据源
    NSMutableArray *_chooseArr;
    //存放点击单元格行数的index
    NSMutableArray *_indexPathArr;
    //点击单元格后下一步的数据源
    NSMutableArray *_data;
    //元数据
    NSArray * _OringinData;
    //分组图标
    NSArray *_sectionTittleArr;
    //工资图标
    NSArray *_salarImageArr;
    
    NSArray *_lastSectionImageArr;
    NSMutableArray *sectionKeyArr;
    NSMutableArray *sectionValueArr;

    int   cellHeight;


}
@property (nonatomic ,strong)UITableView *tableView;
@end

@implementation ChooseTypeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    [self loadData];
    [self loadBaseData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}
//加载基础数据
-(void)loadBaseData
{
    _clcikNum = 0;
    _indexPathArr = [NSMutableArray array];
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    _backView.backgroundColor = [UIColor lightGrayColor];
    if (_chooseType==SalaryType) {
        cellHeight = 35;
    }else{
        cellHeight = 50;
    }
}
//加载网络数据
-(void)loadData
{
    [ProgressHUD show:@"正在加载..."];
    _chooseArr = [NSMutableArray array];
    _data = [NSMutableArray array];
    _OringinData = [NSArray array];
    AppUserIndex *user = [AppUserIndex GetInstance];
    switch (_chooseType) {
        case TimeType:
        {
            [NetworkCore requestPOST:user.API_URL parameters:@{@"rid":@"getTimeRanges",@"bookid":_bookid} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                [ProgressHUD dismiss];
                _OringinData = responseObject[@"data"];
                for (NSDictionary *dic in _OringinData) {
                    [_data addObject:dic];
                    NSString *weekDay = [self weekDaywithDateString:dic[@"DAYS"]];
                    weekDay = [NSString stringWithFormat:@"%@  %@",dic[@"DAYS"],weekDay];
                    [_chooseArr addObject:weekDay];
                }
                [self.tableView reloadData];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                [ProgressHUD showError:error[@"msg"]];
            }];
        
        }
            break;
            
            case InvoiceYype:
        {
            [NetworkCore requestPOST:user.API_URL parameters:@{@"rid":@"getAccountType"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                [ProgressHUD dismiss];
                
                _OringinData = responseObject[@"data"];
                _data = [NSMutableArray arrayWithArray:_OringinData];
                _chooseArr = [NSMutableArray array];
                for (NSDictionary *dic in _data) {
                    [_chooseArr addObject:dic[@"RTNAME"]];
                }
                [self.tableView reloadData];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                [ProgressHUD showError:error[@"msg"]];
            }];
        }
            break;
            //查询工资
            case SalaryType:
        {
            _sectionTittleArr = @[@"该月工资",@"基本工资",@"绩效工资",@"补贴工资",@"代扣工资",@"其他"];
            _salarImageArr = @[@[@"yingPay",@"factSalary"],@[@"postPay",@"xinJIPay"],@[@"Basicperformance",@"award"],@[@"homePay",@"wuyePay",@"otherSubs",@"otherSubs"],@[@"wuyePay",@"xinJIPay",@"medicare",@"personTaxes",@"factSalary",@"jmFactor",@"personTaxes",@"otherSubs"]];
            sectionKeyArr  =[NSMutableArray array];
            sectionValueArr = [NSMutableArray array];
            AppUserIndex *user = [AppUserIndex GetInstance];
            [NetworkCore requestPOST:user.API_URL  parameters:@{@"rid":@"getAccountInfo",@"userid":user.salaryUserName,@"password":user.salaryPWD} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                [ProgressHUD dismiss];
                _OringinData = responseObject[@"data"];
                _data = [NSMutableArray arrayWithArray:_OringinData];
                _chooseArr = [NSMutableArray array];
//                for (NSDictionary *dic in _data) {
//                    SalaryModel *model = [[SalaryModel alloc]init];
//                    [model yy_modelSetWithDictionary:dic];
//                    [_chooseArr addObject:model];
//                }
                for (NSDictionary *dic in _data) {
                    NSString *title = [NSString stringWithFormat:@"%@月",dic[@"月份"]];
                    [_chooseArr addObject: title];
                }
                if (_chooseArr.count==0) {
                    [self showErrorViewLoadAgain:@"网络出小差了~"];
                }
                [self.tableView reloadData];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                [self showErrorViewLoadAgain:error[@"msg"]];

            }];
        }
            break;
            
        default:
            break;
    }
}
//创建view
-(void)createView{
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
    self.tableView =({
        UITableView *view = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        view.delegate = self;
        view.dataSource = self;
        view.tag = 0;
        view ;
    });
    _backView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.leftSpaceToView(self.view,0).bottomSpaceToView(self.view,0).topSpaceToView(self.view,0).rightSpaceToView(self.view,0);
    switch (_chooseType) {
        case SalaryType:
        {
            [self navigationShouldPopOnBackButton];
        }
            break;
            
        default:
            break;
    }
}
-(BOOL)navigationShouldPopOnBackButton
{
    switch (_chooseType) {
        case SalaryType:
        {
        if (_clcikNum>0) {
            [self chooseSelected:_chooseBtn];
            return NO;
            }
        }
            break;
            case InvoiceYype:
        {
            if (_clcikNum>0) {
                _chooseBtn.tag =_clcikNum-1;
                NSLog(@"%ld",(long)_chooseBtn.tag);
                [self chooseSelected:_chooseBtn];
                return NO;
                }
        }
            break;
            case TimeType:
        {
        if (_clcikNum>0) {
            [self chooseSelected:_chooseBtn];
            return NO;
        }
        }
            break;
        default:
            return YES;
            break;
    }
    return YES;
}
/**
 *  将时间戳转化为mm:hh的字符串
 *
 *  @param date 日期
 *
 *  @return 返回时间字符串
 */
-(NSString *)timeStr:(long )date
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *strDate = [dateFormatter stringFromDate:confromTimesp];
    return strDate;
}
/**
 *  获取该天是周几
 *
 *  @param date 传入的日期
 *
 *  @return 返回星期几 的字符串
 */
-(NSString *)weekDaywithDateString:(NSString *)date
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* inputDate = [inputFormatter dateFromString:date];
    NSString *weekDay = [NSDate dayFromWeekday:inputDate];
    return  weekDay;
}
/**
 *  创建btn
 *
 *  @param indexPath 插入的行
 */
-(void)createBtn:(NSIndexPath *)indexPath
{
    AppUserIndex *user = [AppUserIndex GetInstance];
    //===================================时间选择的请求=======================================//
    switch (_chooseType) {
        case TimeType:
        {
            if (_clcikNum==0) {
                [NetworkCore requestPOST:user.API_URL parameters:@{@"rid":@"getBooktimeWithdate",@"bookid":_bookid,@"timedate":_data[indexPath.row][@"DAYS"]} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                    [ProgressHUD dismiss];
                    //取出原始时间 具体的时间
                    _OringinData = responseObject[@"data"];
                    _chooseArr = [NSMutableArray array];
                    for (NSDictionary *dic in _OringinData) {
                        long  time = [dic[@"S_TIME"] longLongValue];
                        [_chooseArr addObject:[self timeStr:time]];
                    }
                    [self.tableView reloadData];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                    [ProgressHUD showError:error[@"msg"]];
                }];
                if ((_chooseArr.count!=0)) {
                    _clcikNum++;
                    [self addButton:_clcikNum withIndexPath:indexPath];
                }else{
                    [ProgressHUD showError:@"获取详细时间失败"];
                }
            }
            //=======判断点击的次数来决定是继续添加button  还是选择完成============//
            else{
                [self pushOrPopMethod:self withDataDictionary:_OringinData[indexPath.row]];
            }
        }
            break;
            case InvoiceYype:
        {
            int i = [_data[indexPath.row][@"RTTYPE"] intValue];
            if (i==0) {
                NSMutableArray *replaceData = _data;
                _data = _data[indexPath.row][@"CHILDREN"];
                if (_data.count==0) {
                    [ProgressHUD showError:@"暂无此类预约保报销类型"];
                    _data = replaceData;
                    return;
                }
                _clcikNum++;
                [_indexPathArr addObject:indexPath];
                [self addButton:_clcikNum withIndexPath:indexPath];
            }else{
                [self pushOrPopMethod:self withDataDictionary:_data[indexPath.row]];
            }
        }
            break;
        case SalaryType:
        {
            if (_clcikNum==0) {
                _clcikNum++;
                [_indexPathArr addObject:indexPath];
                [self addButton:_clcikNum withIndexPath:indexPath];
            }
        }
        break;
        default:
            break;
    }
    self.tableView.tableHeaderView= _backView;
    [self.tableView reloadData];
}
#pragma  mark 私有方法
/**
 *  将工资详情数组分组
 */
-(void)sepPayArr
{
    sectionValueArr = [NSMutableArray array];
    sectionKeyArr = [NSMutableArray array];
    NSDictionary *dic = (NSDictionary *)_chooseArr;

    /*
                 _lastSectionImageArr = @[@"yingPay",@"factSalary",@"postPay",@"xinJIPay",@"Basicperformance",@"award",@"homePay",@"wuyePay",@"otherSubs",@"otherSubs",@"wuyePay",@"xinJIPay",@"medicare",@"personTaxes",@"factSalary",@"jmFactor",@"personTaxes",@"otherSubs"];
     */
    SalaryModel *model = [[SalaryModel alloc]init];
    [model yy_modelSetWithDictionary:dic];
        
    model.yingFaSalary = model.yingFaSalary?model.yingFaSalary:@"0";
    model.shiFaSalary = model.shiFaSalary?model.shiFaSalary:@"0";
    model.gangWeiSalary = model.gangWeiSalary?model.gangWeiSalary:@"0";
    model.xinJiSalary = model.xinJiSalary?model.xinJiSalary:@"0";
    model.jiChuJixiao = model.jiChuJixiao?model.jiChuJixiao:@"0";
    model.jiangLiJiXiao = model.jiangLiJiXiao?model.jiangLiJiXiao:@"0";
    model.zhuFangBuTie  =model.zhuFangBuTie?model.zhuFangBuTie:@"0";
    model.wuYeBuTie = model.wuYeBuTie?model.wuYeBuTie:@"0";
    model.qiTaBuTie1 = model.qiTaBuTie1?model.qiTaBuTie1:@"0";
    model.qiTaBuTie2 = model.qiTaBuTie2?model.qiTaBuTie2:@"0";
    model.gongJiJin = model.gongJiJin?model.gongJiJin:@"0";
    model.yangLaobaoXian = model.yangLaobaoXian?model.yangLaobaoXian:@"0";
    model.yiLiaoBaoxian = model.yiLiaoBaoxian?model.yiLiaoBaoxian:@"0";
    model.shuiQianKouKuan = model.shuiQianKouKuan?model.shuiQianKouKuan:@"0";
    model.jiShuiGongzi  =model.jiShuiGongzi?model.jiShuiGongzi:@"0";
    model.geShuiJianMian = model.geShuiJianMian?model.geShuiJianMian:@"0";
    model.geRenSuodeShui =model.geRenSuodeShui?model.geRenSuodeShui :@"0";
    model.qiTaKou = model.qiTaKou?model.qiTaKou:@"0";
    

    [sectionKeyArr addObject:@[@"应发工资:",@"实发工资:"]];
    [sectionValueArr addObject:@[model.yingFaSalary,model.shiFaSalary]];
    [sectionKeyArr addObject:@[@"岗位工资:",@"薪级工资:"]];
    [sectionValueArr addObject:@[model.gangWeiSalary,model.xinJiSalary]];
    
    [sectionKeyArr addObject:@[@"基础绩效:",@"奖励绩效:"]];
    [sectionValueArr addObject:@[model.jiChuJixiao,model.jiangLiJiXiao]];
    
    [sectionKeyArr addObject:@[@"住房补贴:",@"物业补贴:",@"其他补1:",@"其他补2:"]];
    [sectionValueArr addObject:@[model.zhuFangBuTie,model.wuYeBuTie,model.qiTaBuTie1,model.qiTaBuTie2]];
    
    [sectionKeyArr addObject:@[@"公积金:",@"养老保险:",@"医疗保险:",@"税前扣款:",@"计税工资:",@"个税减免系数:",@"个人所得税:",@"其他扣:"]];
    [sectionValueArr addObject:@[model.gongJiJin,model.yangLaobaoXian,model.yiLiaoBaoxian,model.shuiQianKouKuan,model.jiShuiGongzi,model.geShuiJianMian,model.geRenSuodeShui,model.qiTaKou]];
    
    NSMutableArray *newKeyArr = [NSMutableArray array];
    NSMutableArray *newValueArr = [NSMutableArray array];
    NSArray *salaryTotalArr = dic[@"data"];
    for (NSString *obj in salaryTotalArr) {
        NSArray *sepArr = [obj componentsSeparatedByString:@"="];
        [newKeyArr addObject:[sepArr firstObject]];
        [newValueArr addObject:[sepArr lastObject]];
    }
    [sectionKeyArr addObject:newKeyArr];
    [sectionValueArr addObject:newValueArr];
    _lastSectionImageArr  = @[@"yingPay",@"factSalary",@"postPay",@"xinJIPay",@"Basicperformance",@"award",@"homePay",@"wuyePay",@"otherSubs",@"otherSubs",@"wuyePay",@"xinJIPay",@"medicare",@"personTaxes",@"factSalary",@"jmFactor",@"personTaxes",@"otherSubs"];
    

    [self.tableView reloadData];
    
}
/**
 *  根据点击的单元格添加button
 *
 *  @param Num       点击的次数
 *  @param IndexPath 点击的单元格行数
 */
-(void)addButton:(int)Num withIndexPath:(NSIndexPath *)IndexPath
{
    
    _chooseBtn  = ({
         _chooseBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _chooseBtn.layer.borderWidth = 0.1;
        _chooseBtn.layer.borderColor = Base_Color2.CGColor;
        _chooseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _chooseBtn.tag = _clcikNum-1;
        _chooseBtn.backgroundColor =[self getColorBysenderId:_chooseBtn.tag];
        [_chooseBtn setTitleColor:Base_Orange forState:UIControlStateNormal];
        [_chooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [_chooseBtn addTarget:self action:@selector(chooseSelected:) forControlEvents:UIControlEventTouchUpInside];
        //==========================================该方法只能由选择时间和选择报销类型执行==================工资查询界面需要重新赋值
        NSString *title;
        NSMutableString *string = [[NSMutableString alloc]initWithString:@""];
        for (int i = 1; i<_clcikNum; i++) {
            [string  appendString: @"    "];
            string = string;
        }
        title = [NSString stringWithFormat:@"%@%@",string,_chooseArr[IndexPath.row]];
        [_chooseBtn setTitle:title forState:UIControlStateNormal];
         _chooseBtn;
    });
        [_backView addSubview:_chooseBtn];
        //=============================重新初始化数组、按钮frame、背景view的frame==========================//
    _chooseArr =[NSMutableArray array];
    _chooseBtn.frame = CGRectMake(0, cellHeight*(_clcikNum-1), kScreenWidth, cellHeight);
    _backView.frame = CGRectMake(0, 0, kScreenWidth, cellHeight*_clcikNum);
    //根据类型区分不同的请求
    switch (_chooseType) {
        case TimeType:
        {
            
        }
            break;
        case InvoiceYype:
        {

            for (NSDictionary *dic in _data) {
                [_chooseArr addObject:dic[@"RTNAME"]];
            }
        }
            break;
            case SalaryType:
        {
            UIImageView *rightV =({
                UIImageView *view = [UIImageView new];
                view.image = [UIImage imageNamed:@"accessory.png"];
                view;
            });
            UIImageView *leftImagV = ({
                UIImageView *view = [UIImageView new];
                view.image = [UIImage imageNamed:@"sectionSep.png"];
                view;
            });
            [_chooseBtn addSubview:rightV];
            [_chooseBtn addSubview:leftImagV];
            rightV.sd_layout.rightSpaceToView(_chooseBtn,20).topSpaceToView(_chooseBtn,(cellHeight-15)/2).heightIs(15).widthIs(7);
            leftImagV.sd_layout.leftSpaceToView(_chooseBtn,20).topSpaceToView(_chooseBtn,(cellHeight-15)/2).heightIs(15).widthIs(2);
            _chooseArr = _data[IndexPath.row];
            _chooseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            _chooseBtn.frame = CGRectMake(0, cellHeight*(_clcikNum-1), kScreenWidth, cellHeight);
            _backView.frame = CGRectMake(0, 0, kScreenWidth, cellHeight*_clcikNum);
            _chooseBtn.backgroundColor =Base_Color2;
            [_chooseBtn setTitleColor:Color_Black forState:UIControlStateNormal];
            _chooseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [_chooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
            [self sepPayArr];
        }
            break;
        default:
            break;
    }
}
/**
 *  返回按钮颜色
 *
 *  @param tag 控件的tag
 *
 *  @return 返回颜色
 */
-(UIColor *)getColorBysenderId:(NSInteger )tag
{
    if (tag==0) {
        return [UIColor lightGrayColor];
    }
    return Base_Color2;
}
/**
 *  移除相应控件 并展示对应控件的数据
 *
 *  @param sender 相应控件的tag值
 */
-(void)chooseSelected:(UIButton *)sender
{
    _chooseArr = [NSMutableArray array];
    //===========================移除时间cell=============================//
    switch (_chooseType) {
        case TimeType:
        {
            //处理展示的数据 chooseArr
            if (sender.tag==0) {
                for (NSDictionary *dic in _data) {
                    NSString *weekDay = [self weekDaywithDateString:dic[@"DAYS"]];
                    weekDay = [NSString stringWithFormat:@"%@  %@",dic[@"DAYS"],weekDay];
                    [_chooseArr addObject:weekDay];
                }
            }
            _clcikNum--;
            //重新赋值数据源  此时的data盛放的是上一层的数据
            _OringinData = _data;
            _backView.frame = CGRectMake(0, 0, kScreenWidth, cellHeight*(sender.tag));
        }
            break;
            case InvoiceYype:
        {
        
            //处理展示的数据 chooseArr
            if (sender.tag==0) {
                for (NSDictionary *dic in _OringinData) {
                    [_chooseArr addObject:dic[@"RTNAME"]];
                }
            }else{
//                NSLog(@"%ld",sender.tag);
                //先找到父节点  再循环找子节点
                NSIndexPath *indexPath = _indexPathArr[0];
                NSMutableArray *replaceData = _OringinData[indexPath.row][@"CHILDREN"];
                for (int i = 0; i<sender.tag; i++) {
                    _chooseArr = [NSMutableArray array];
                    for (NSDictionary *chilDrenDic in replaceData) {
                        [_chooseArr addObject:chilDrenDic[@"RTNAME"]];
                    }
                    replaceData = replaceData[i][@"CHILDREN"];
                }
            }
            //处理下一步要添加的数据  处理无序删除按钮和有序删除按钮
            if (sender.tag>0) {
                //先找到父节点  再循环找子节点
                NSIndexPath *indexPath = _indexPathArr[0];
                NSMutableArray *NextData = _OringinData[indexPath.row][@"CHILDREN"];
                for (int i = 0; i<sender.tag; i++) {
                    _data = [NSMutableArray array];
                    for (NSDictionary *chilDrenDic in NextData) {
                        [_data addObject:chilDrenDic];
                    }
                    NextData = NextData[i][@"CHILDREN"];
                }
            }else if(sender.tag==0){
                _data = [NSMutableArray arrayWithArray:_OringinData];
            }
            
            if (sender.tag>0) {
                int i = 0;
                for (UIButton *btn in _backView.subviews) {
                    if (btn.tag>=sender.tag) {
                        [btn removeFromSuperview];
                        i++;
                    }
                }
                for (int j=0; j<i; j++) {
                    [_indexPathArr removeObjectAtIndex:i-j];
                }
                _clcikNum = _clcikNum-(int)i;
                _backView.frame  = CGRectMake(0, 0, kScreenWidth, cellHeight*_clcikNum);

            }else{
                int j = 0;
                for (int i =0; i<=_clcikNum-1; i++) {
                    j++;
                    [_indexPathArr removeObjectAtIndex:_clcikNum-1-i];
                }
                _backView.frame = CGRectMake(0, 0, kScreenWidth, cellHeight*(sender.tag));
                if (sender.tag==0) {
                    _clcikNum = _clcikNum-j;
                }else{
                _clcikNum = _clcikNum--;
                }
            }
        }
            break;
            case SalaryType:
        {
            //处理展示的数据 chooseArr
            if (sender.tag==0) {
                for (NSDictionary *dic in _data) {
                    NSString *title = [NSString stringWithFormat:@"%@月",dic[@"月份"]];
                    [_chooseArr addObject: title];
                }
            }
            _clcikNum--;
            [_indexPathArr removeObjectAtIndex:_clcikNum];
            //重新赋值数据源  此时的data盛放的是上一层的数据
            _OringinData = _data;
            _backView.frame = CGRectMake(0, 0, kScreenWidth, cellHeight*(sender.tag));
        }
            break;
        default:
            break;
    }
    //返回键 返回上一级
    if (sender.tag==0) {
        for (UIButton *btn in _backView.subviews) {
            [btn removeFromSuperview];
        }
    }else{
        for (UIButton *btn in _backView.subviews) {
            if (btn.tag>=sender.tag) {
                [btn removeFromSuperview];
            }
        }
    
    }
    self.tableView.tableHeaderView = _backView;
    [self.tableView reloadData];
}
#pragma mark   delegate
/**
 *  代理方法  在外部实现是push  还是pop
 */
-(void)pushOrPopMethod:(UIViewController *)vc withDataDictionary:(NSDictionary *)dic
{
    if (self.ChooseDelegate) {
        [_ChooseDelegate pushOrPopMethod:vc withDataDictionary:dic];
    }
}
#pragma  mark UITabDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (_chooseType) {
        case SalaryType:
        {
            if (_clcikNum==0) {
                return 1;
            }
            return _sectionTittleArr.count;
        }
            break;
        default:
            return 1;
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (_chooseType) {
        case TimeType:
        {
            return _chooseArr.count;

        }
            break;
            case InvoiceYype :
        {
            return _chooseArr.count;

        }
            break;
            case SalaryType:
        {
            if (_clcikNum==0) {
                return _chooseArr.count;
            }
            return [sectionKeyArr[section] count];

            
        }
            break;
        default:
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"BXCell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (_chooseType) {
        case TimeType:
        {
            if (_clcikNum!=0) {
                cell.accessoryType =UITableViewCellAccessoryNone;
            }
            NSString *title;
            NSMutableString *string = [[NSMutableString alloc]initWithString:@""];
            for (int i = 0; i<_clcikNum; i++) {
                [string  appendString: @"     "];
                string = string;
            }
            title = [NSString stringWithFormat:@"%@%@",string,_chooseArr[indexPath.row]];
            cell.textLabel.text  = title;

        }
            break;
        case InvoiceYype :
        {
            NSString *title;
            NSMutableString *string = [[NSMutableString alloc]initWithString:@""];
            for (int i = 0; i<_clcikNum; i++) {
                [string  appendString: @"    "];
                string = string;
            }
            title = [NSString stringWithFormat:@"%@%@",string,_chooseArr[indexPath.row]];
            cell.textLabel.text  = title;
        }
            break;
        case SalaryType:
        {
            if (_clcikNum==0) {
                cell.textLabel.text  =[NSString stringWithFormat:@"%@份工资",_chooseArr[indexPath.row]];

            }else{
                cell.textLabel.font = [UIFont  fontWithName:@"Arial Rounded MT Bold" size:14];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = sectionKeyArr[indexPath.section][indexPath.row];//
                NSArray *tokeArr = sectionKeyArr[indexPath.section];
                if (indexPath.section==_sectionTittleArr.count-1) {
                    if (tokeArr.count<=_lastSectionImageArr.count) {
                        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",_lastSectionImageArr[indexPath.row]]];

                    }else{
                        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[_lastSectionImageArr lastObject]]];
                    }

                }else{
                    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",_salarImageArr[indexPath.section][indexPath.row]]];

                }
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",sectionValueArr[indexPath.section][indexPath.row]];

                }

        }
            break;
        default:
            break;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_chooseType) {
        case SalaryType:
        {
            if (_clcikNum==0) {
                return 50;
            }
            return cellHeight;
        }
            break;
            
        default:
            return  50;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (_chooseType) {
        case SalaryType:
        {
            if (_clcikNum!=0) {
                if (section==0) {
                    return 0;
                }
                else{
                return 15;
                }
            }
        }
            break;
            
        default:
            break;
    }
       return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (_chooseType) {
        case SalaryType:
        {
            if (_clcikNum!=0) {
                return 10;
            }
        }
            break;
            
        default:
            break;
    }
    return 0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (_chooseType) {
        case SalaryType:
        {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];//创建一个视图
            
            UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 2, 10)];
            
            UIImage *image = [UIImage imageNamed:@"sectionSep.png"];
            
            [headerImageView setImage:image];
            
            [headerView addSubview:headerImageView];
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 3, 150, 20)];
            
            headerLabel.backgroundColor = [UIColor whiteColor];
            
            headerLabel.font = [UIFont boldSystemFontOfSize:13.0];
            
            headerLabel.textColor = Color_Gray;
            
            headerLabel.text = _sectionTittleArr[section];
            
            [headerView addSubview:headerLabel];
            
            UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, headerLabel.bounds.size.height, kScreenWidth, 0.3)];
            lineView.backgroundColor = Base_Color3;
            [headerView addSubview:lineView];
            
            return headerView;

        }
            break;
            
        default:
            return nil;
            break;
    }
}
#pragma  mark tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self createBtn:indexPath];
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
