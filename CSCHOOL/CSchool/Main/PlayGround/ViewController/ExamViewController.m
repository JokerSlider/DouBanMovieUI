//
//  ExamViewController.m
//  CSchool
//
//  Created by mac on 16/4/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ExamViewController.h"
#import "UIView+SDAutoLayout.h"
#import "InfoTabViewCell.h"
#import "ExamModel.h"
#import <MJRefresh.h>
#import "WillTableViewCell.h"
@interface ExamViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITextField *chooseTermText;
    UIButton *chooseBtn;
    UITableView *termTabv;
    UITableView *infoTabv;
    NSMutableArray *termArray;
    //存放正在进行的考试的数据
    NSMutableArray *DoingExamInfoArr;
    //存放还未安排的考试数据
    NSMutableArray *WillExamInfoArr;
    //存放已经考完的考试数据
    NSMutableArray *DoneExamInfoArr;
    NSMutableArray *termNum;
    
    UIView *backV;
    BOOL isShow;
    UIView *grayBgView;//遮罩层
    NSInteger  _selectTermCellNum;//选中的学期
      BOOL _hadSelected;
}
@end
@implementation ExamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //选择学期  默认为-1（默认为最后一个学期）
    self.title = @"考试查询";
    _chooseTerm = -1;
    _selectTermCellNum = -1;
    [self loadDataAfter];
    [self createUI];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}
#pragma mark 加载数据
-(void)loadDataAfter
{
    [ProgressHUD show:@"正在加载考试信息..." ];
    if (!isShow) {
        [UIView animateWithDuration:0.333 animations:^{
            isShow = NO;
            termTabv.frame = CGRectMake(0, 35, self.view.frame.size.width, 0);
        } completion:^(BOOL finished) {
        }];
    }
    //加载网络数据，这里用本地数据代替
    [self loadExamData];
}
-(void)loadExamData
{
    termArray = [NSMutableArray array];
    termNum = [NSMutableArray array];
    //根据考试状态存入不同数组
    DoingExamInfoArr = [NSMutableArray array];
    WillExamInfoArr = [NSMutableArray array];
    DoneExamInfoArr = [NSMutableArray array];
    
    NSString *coursePath;
    coursePath = [[NSBundle mainBundle] pathForResource:@"exam" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:coursePath];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if ([[dict objectForKey:@"status"]isEqualToString:@"8000"]) {
        [ProgressHUD showSuccess:@"加载完成"];
        //数据请求成功
        NSArray *data = [dict objectForKey:@"data"];
        NSMutableArray *examSource =[NSMutableArray array];
        termNum = [NSMutableArray array];
        for (NSDictionary *dic in data) {
            [termArray addObject:dic[@"termName"]];
            [termNum addObject:dic[@"term"]];
            [examSource addObject:dic[@"data"]];
        }
        for (int i = 0; i<termNum.count; i++) {
            int termNumber;
            if (_chooseTerm==-1) {
                termNumber=[termNum[i] intValue];

            }else{
            
                termNumber = _chooseTerm;
            }
            //根据学期将不同学期的考试课存入数组
            if (DoingExamInfoArr.count!=0||WillExamInfoArr.count!=0||DoneExamInfoArr.count!=0) {
                [DoingExamInfoArr removeAllObjects];
                [WillExamInfoArr removeAllObjects];
                [DoneExamInfoArr removeAllObjects];
            }
            for (NSDictionary *fDic in examSource[termNumber]) {
                NSString *examState = [fDic objectForKey:@"examIsEnd"];
                if ([examState isEqualToString:@"0"]) {
                    [DoingExamInfoArr addObject:fDic];
                }else if ([examState isEqualToString:@"1"])
                {
                    [DoneExamInfoArr addObject:fDic];
                }else if([examState isEqualToString:@"-1"])
                {
                    [WillExamInfoArr addObject:fDic];
                }
            }
        }
        [infoTabv reloadData];
        [termTabv reloadData];
    }
    if ([[dict objectForKey:@"status"]isEqualToString:@"8003"]) {
        [self showErrorView:@"" andImageName:nil];
        [ProgressHUD showError:@"加载考试讯息失败"];
         chooseBtn.enabled = NO;
        XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"查询失败" withContent:@"暂未查询到相应考试讯息" WithCancelButtonTitle:@"确定" withOtherButton:nil];
        [alert show];
    }
    [infoTabv.mj_header endRefreshing];
}
#pragma mark 创建UI
-(void)createUI
{
    UIImageView *backImageV = [UIImageView new];
    UILabel *subTitle  = [UILabel new];
    UIView *textView = [UIView new];
    backV =({
        backV= [UIView new];
        backV.backgroundColor =Base_Color2;
        backV.layer.borderWidth = 0.5;
        backV.layer.borderColor = Base_Color2.CGColor;
        backV;
    });
    grayBgView= ({
        grayBgView = [UIView new];
        grayBgView.backgroundColor = [UIColor blackColor];
        grayBgView.alpha = 0.5;
        grayBgView.hidden = YES;
        grayBgView;
    });
    termTabv = ({
        termTabv = [UITableView new];
        termTabv.frame = CGRectMake(0, 35, self.view.frame.size.width, 0);
        termTabv.delegate = self;
        termTabv.dataSource = self;
        termTabv.backgroundColor = [UIColor whiteColor];
        termTabv.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, termTabv.bounds.size.width, 1)];
        termTabv;
    });
    subTitle=({
        subTitle.font = Title_Font;
        subTitle.textAlignment = NSTextAlignmentCenter;
        subTitle.text = @"选择学期:";
        subTitle.textColor = Color_Black;
        subTitle;
    });
    chooseTermText =({
        chooseTermText = [UITextField new];
        chooseTermText.placeholder = @"请选择学期";
        chooseTermText.font = Title_Font;
        chooseTermText.delegate = self;
        chooseTermText.textColor = Color_Gray;
        [chooseTermText setBorderStyle:UITextBorderStyleLine];
        chooseTermText.layer.borderColor = [UIColor blackColor].CGColor;
        chooseTermText;
    });
    infoTabv=({
        infoTabv = [UITableView new];
        infoTabv.delegate = self;
        infoTabv.dataSource = self;
        [infoTabv setBackgroundView:backImageV];
        infoTabv.separatorStyle = UITableViewCellSelectionStyleBlue;
        if ([infoTabv respondsToSelector:@selector(setSeparatorInset:)]) {
            [infoTabv setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([infoTabv respondsToSelector:@selector(setLayoutMargins:)])  {
            [infoTabv setLayoutMargins:UIEdgeInsetsZero];
        }
        infoTabv;
    });
    
    chooseBtn = ({
        chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseBtn.selected = NO;
        isShow = NO;
        [chooseBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        [chooseBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateSelected];
        [chooseBtn addTarget:self action:@selector(chooseTerm:) forControlEvents:UIControlEventTouchUpInside];
        chooseBtn;
    });
    
    [self.view  addSubview:backV];
    [infoTabv addSubview:backImageV];
    [chooseTermText addSubview:textView];
    [textView addSubview:chooseBtn];
    [backV addSubview:subTitle];
    [backV addSubview:chooseTermText];
    [self.view addSubview:infoTabv];
    [grayBgView addSubview:termTabv];
    [self.view addSubview:grayBgView];

    grayBgView.sd_layout.
    leftSpaceToView(self.view,0).
    topSpaceToView(self.view,35).
    rightSpaceToView(self.view,0).
    bottomSpaceToView(self.view,0);
    
    backV.sd_layout.
    leftSpaceToView(self.view,0).
    topSpaceToView(self.view,0).
    rightSpaceToView(self.view,0).
    heightIs(LayoutHeightCGFloat(35));

    backImageV.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    subTitle.sd_layout.
    leftSpaceToView(backV,50).
    topSpaceToView(backV,5).
    widthIs(LayoutWidthCGFloat(70)).
    heightIs(25);
    
    chooseTermText.sd_layout.
    leftSpaceToView(subTitle,0).
    topSpaceToView(backV,5).
    widthIs(LayoutWidthCGFloat(170)).
    heightIs(25);
    textView.frame = chooseTermText.bounds;
    
    chooseBtn.sd_layout.
    rightSpaceToView(textView,0).
    topSpaceToView(textView,0).
    widthIs(25).
    heightIs(25);
    
    infoTabv.sd_layout.
    leftSpaceToView(self.view,0).
    topSpaceToView(backV,0).
    rightSpaceToView(self.view,0).
    bottomSpaceToView(self.view,0);
    
    UITapGestureRecognizer *tap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTerm:)];
    tap.numberOfTapsRequired = 1;
    [infoTabv addGestureRecognizer:tap];
    UITapGestureRecognizer *tapTextFiesd  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTerm:)];
    tapTextFiesd.numberOfTapsRequired = 1;
    [chooseTermText  addGestureRecognizer:tapTextFiesd];
    UITapGestureRecognizer *tapgrayView  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTerm:)];
    tapTextFiesd.numberOfTapsRequired = 1;
    [grayBgView addGestureRecognizer:tapgrayView];
    //下拉刷新
    infoTabv.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataAfter)];
}
/**
 *  选择学期按钮点击事件
 *
 *  @param sender sender
 */
-(void)chooseTerm:(UIButton *)sender
{
    if (!isShow) {
        [self.view addSubview:termTabv];
        [UIView animateWithDuration:0.333 animations:^{
            termTabv.frame = CGRectMake(0, 35, self.view.frame.size.width, 200);
            isShow = YES;
            grayBgView.hidden=NO;
        }];
    }else{
        [UIView animateWithDuration:0.333 animations:^{
            isShow = NO;
            termTabv.frame = CGRectMake(0, 35, self.view.frame.size.width, 0);
            grayBgView.hidden = YES;
        } completion:^(BOOL finished) {
        }];
    }
    chooseBtn.selected= !chooseBtn.selected;
}
/**
 *  将时间戳转化为时间
 *
 *  @param dateString 输入的时间戳字符串
 *
 *  @return 返回的标准时间的字符串
 */
-(NSString *)ChangeTodateString:(NSString *)dateString
{
    NSTimeInterval time=[dateString doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}
#pragma mark   UITableviewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //分组数 也就是section数
    if ([tableView isEqual:infoTabv]) {
        return 3;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([tableView isEqual:infoTabv]) {
        if (section==0) {
            return  DoingExamInfoArr.count;
        }else if (section==1){
            return WillExamInfoArr.count;
        }else if(section==2)
        {
            return DoneExamInfoArr.count;
        }
    }else{
    return termArray.count;
    }
    return 0;
}

#pragma mark 第section组显示的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:infoTabv]) {
        if (section==0) {
            return nil;
        }else if (section==1){
            return @"待安排的考试";
        }else if(section==2){
            return @"已结束的考试";
        }
    }
    return nil;
}
/**
 *  设置分组的名称
 *
 *  @param tableView tableview
 *  @param section   组数
 *
 *  @return 返回view
 */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:infoTabv]) {
        if (section == 1)
            
        {
            
            UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake((tableView.bounds.size.width-200), 0, 200, 30)];
            title.text=@"待安排的考试";
            title.font = [UIFont systemFontOfSize:12];
            title.textAlignment = NSTextAlignmentCenter;
            title.backgroundColor=Base_Color2;
            title.textColor = Color_Gray;
            return title ;
            
        }else if (section==2)
        {
            UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake((tableView.bounds.size.width-200), 0, 200, 30)];
            title.text=@"已结束的考试";
            title.font = [UIFont systemFontOfSize:12];
            title.textAlignment = NSTextAlignmentCenter;
            title.backgroundColor=Base_Color2;
            title.textColor = Color_Gray;
            return title ;
            
            
        }
        return nil;

    }
    return nil;
   }

#pragma mark UITableviewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:infoTabv]) {
        static NSString *firstIdenfitier = @"examInfocell";
        static NSString *secondidenfitier = @"willExamCell";
        InfoTabViewCell * Infocell = [tableView dequeueReusableCellWithIdentifier:firstIdenfitier];
        WillTableViewCell * willexamCell =[tableView dequeueReusableCellWithIdentifier:secondidenfitier];
        if (willexamCell==nil) {
            willexamCell = [[[NSBundle mainBundle]loadNibNamed:@"WillTableViewCell" owner:self options:nil]lastObject];
        }
        if (Infocell == nil)
        {
            Infocell = [[[NSBundle mainBundle]loadNibNamed:@"InfoTabViewCell" owner:self options:nil]lastObject];
        }
        //正在进行的考试
        if (indexPath.section==0) {
            if (DoingExamInfoArr.count!=0) {
                ExamModel *model;
                NSMutableArray *examNamearray = [NSMutableArray array];
                NSMutableArray *scoreArray = [NSMutableArray array];
                NSMutableArray *examMethodArr = [NSMutableArray array];
                NSMutableArray *examStateArr = [NSMutableArray array];
                NSMutableArray *examAddressArr = [NSMutableArray array];
                NSMutableArray *examTimeArr = [NSMutableArray array];
                NSMutableArray *examIsEndArr = [NSMutableArray array];
                for (NSDictionary *fdic in DoingExamInfoArr) {
                    model = [[ExamModel alloc]initWithDic:fdic];
                    [examNamearray addObject:model.examName];
                    [scoreArray addObject:model.score];
                    [examMethodArr addObject:model.examMethod];
                    [examStateArr addObject:model.examState];
                    [examAddressArr addObject:model.examAddress];
                    [examTimeArr addObject:model.examTime ];
                    [examIsEndArr addObject:model.examIsEnd];
                }
                Infocell.examState.textColor = Base_Orange;
                Infocell.examName.text =examNamearray[indexPath.row];
                Infocell.score.text= [NSString stringWithFormat:@"(%@分)",scoreArray[indexPath.row]];
                Infocell.examMethod.text=examMethodArr[indexPath.row];
                Infocell.examState.text=examStateArr[indexPath.row];
                Infocell.examTime.text = [self ChangeTodateString:examTimeArr[indexPath.row]];
                Infocell.examAdddress.text = examAddressArr[indexPath.row];
                Infocell.examIsEnd = examIsEndArr[indexPath.row];
                Infocell.backgroundColor =[UIColor clearColor];
                Infocell.selectionStyle = UITableViewCellSelectionStyleNone;
                return Infocell;
            }
        }
        //未安排的课程
        else if (indexPath.section==1) {
            if (WillExamInfoArr.count!=0) {
                ExamModel *model;
                NSMutableArray *examNamearray = [NSMutableArray array];
                NSMutableArray *scoreArray = [NSMutableArray array];
                NSMutableArray *examMethodArr = [NSMutableArray array];
                NSMutableArray *examStateArr = [NSMutableArray array];
                NSMutableArray *examAddressArr = [NSMutableArray array];
                NSMutableArray *examTimeArr = [NSMutableArray array];
                NSMutableArray *examIsEndArr = [NSMutableArray array];
                for (NSDictionary *fdic in WillExamInfoArr) {
                    model = [[ExamModel alloc]initWithDic:fdic];
                    [examNamearray addObject:model.examName];
                    [scoreArray addObject:model.score];
                    [examMethodArr addObject:model.examMethod];
                    [examStateArr addObject:model.examState];
                    [examAddressArr addObject:model.examAddress];
                    [examTimeArr addObject:model.examTime ];
                    [examIsEndArr addObject:model.examIsEnd];
                }
                willexamCell.wiiExamName.text =examNamearray[indexPath.row];
                willexamCell.willExamScore.text= [NSString stringWithFormat:@"(%@分)",scoreArray[indexPath.row]];
                willexamCell.willExamMethod.text=examMethodArr[indexPath.row];
                willexamCell.willExamState.text=examStateArr[indexPath.row];
                willexamCell.backgroundColor =[UIColor clearColor];
                willexamCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return willexamCell;

            }
        }
        //已经结束的课程
        else{
            if (DoneExamInfoArr.count!=0) {
                ExamModel *model;
                NSMutableArray *examNamearray = [NSMutableArray array];
                NSMutableArray *scoreArray = [NSMutableArray array];
                NSMutableArray *examMethodArr = [NSMutableArray array];
                NSMutableArray *examStateArr = [NSMutableArray array];
                NSMutableArray *examAddressArr = [NSMutableArray array];
                NSMutableArray *examTimeArr = [NSMutableArray array];
                NSMutableArray *examIsEndArr = [NSMutableArray array];
                for (NSDictionary *fdic in DoneExamInfoArr) {
                    model = [[ExamModel alloc]initWithDic:fdic];
                    [examNamearray addObject:model.examName];
                    [scoreArray addObject:model.score];
                    [examMethodArr addObject:model.examMethod];
                    [examStateArr addObject:model.examState];
                    [examAddressArr addObject:model.examAddress];
                    [examTimeArr addObject:model.examTime ];
                    [examIsEndArr addObject:model.examIsEnd];
                }
                Infocell.examName.textColor = Color_Gray;
                Infocell.score.textColor = Color_Gray;
                Infocell.examName.text =examNamearray[indexPath.row];
                Infocell.score.text= [NSString stringWithFormat:@"(%@分)",scoreArray[indexPath.row]];
                Infocell.examMethod.text=examMethodArr[indexPath.row];
                Infocell.examState.text=examStateArr[indexPath.row];
                Infocell.examTime.text = [self ChangeTodateString:examTimeArr[indexPath.row]];
                Infocell.examAdddress.text = examAddressArr[indexPath.row];
                Infocell.examIsEnd = examIsEndArr[indexPath.row];
                Infocell.backgroundColor =[UIColor clearColor];
                Infocell.selectionStyle = UITableViewCellSelectionStyleNone;
                return Infocell;
            }
        }
    }
    //选学期的表
    else if ([tableView isEqual:termTabv]){
    static NSString * showUserInfoCellIdentifier = @"ShowUserInfoCell";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:showUserInfoCellIdentifier];
                UIImageView *seletImage = [[UIImageView alloc]initWithFrame:CGRectMake(cell.contentView.bounds.size.width-20, 10, 20, 20)];
        seletImage.image = [UIImage imageNamed:@"ico_make"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:showUserInfoCellIdentifier];
        cell.textLabel.text=termArray[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = Title_Font;
        cell.backgroundColor = [UIColor clearColor];
        //添加对号
        if (indexPath.row==_selectTermCellNum&&_hadSelected) {
            cell.backgroundColor = Base_Color2;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = [UIColor redColor];
            [cell.contentView  addSubview:seletImage];
        }
        return cell;
    }
    return nil;
}
#pragma mark UITableviewdelegate&UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:infoTabv]) {
        if (indexPath.section==0) {
            return 102;
        }
        if (indexPath.section==1) {
            return 30;
        }
        return 102;
    }
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:infoTabv]) {
        return;
    }else{
    chooseTermText.text = termArray[indexPath.row];
    chooseBtn.selected= !chooseBtn.selected;
    int termnum=[termNum[indexPath.row] intValue];
    _chooseTerm = termnum;
    if (!isShow) {
        [self.view addSubview:termTabv];
        [UIView animateWithDuration:0.333 animations:^{
            termTabv.frame = CGRectMake(0, 35, self.view.frame.size.width, 200);
            isShow=YES;
            grayBgView.hidden = NO;
        }];
    }else{
        [UIView animateWithDuration:0.333 animations:^{
            termTabv.frame = CGRectMake(0, 35, self.view.frame.size.width, 0);
            isShow = NO;
            grayBgView.hidden = YES;
        } completion:^(BOOL finished) {
        }];
    }
    _selectTermCellNum = indexPath.row;
    if (!_hadSelected) {
            _hadSelected = YES;
            [termTabv reloadData];
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_selectTermCellNum inSection:0];
            
            [termTabv selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        [self loadDataAfter];
    }
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return  NO;
}
#pragma mark UIScrollViewDelegate
/**
 *  重写这个代理方法就行了，利用contentOffset这个属性改变frame
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < 0) {
//        tabHeaderV.frame = CGRectMake(offsetY/2, offsetY, termTabv.bounds.size.width- offsetY, 1- offsetY);  // 修改头部的frame值就行了
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
