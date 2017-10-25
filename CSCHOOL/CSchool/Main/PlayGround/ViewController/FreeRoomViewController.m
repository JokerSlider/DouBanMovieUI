//
//  FreeRoomViewController.m
//  XGCourse
//
//  Created by 左俊鑫 on 16/4/14.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "FreeRoomViewController.h"
#import "NSDate+Extension.h"
#import "UIView+SDAutoLayout.h"
#import <MJRefresh.h>
#import "XJComboBoxView.h"
#import "CourseManager.h"
#import "TePopList.h"
#import "CourseViewController.h"

@interface FreeRoomViewController ()<UIScrollViewDelegate, XJComboBoxViewDelegate>
{
    UILabel *_timeLabel;
    XJComboBoxView *comboBox;
    UIButton *floorSelBtn;
    UIButton *beforBtn;
}
@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UIScrollView *titleScrollView;

@property (nonatomic, strong) UIScrollView *subTitleScrollView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, assign) NSInteger countNum;

@property (nonatomic, strong) NSArray *allDataArray; //存放所有教室信息

@property (nonatomic, strong) NSArray *emptyDataArray; //存放空教室信息

@property (nonatomic, strong) NSString *floorSelStr; //选择的层层

@property (nonatomic, strong) UILabel *noneInfoLabel; //层层没有信息显示label

@property (nonatomic, strong) NSDate *startDate;

@end

@implementation FreeRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [NSString stringWithFormat:@"%@教室概况",_buildName];

    self.view.backgroundColor = [UIColor whiteColor];

    _floorSelStr = @"1";
    
    if ([_requestTimeStr length]>1) {
        NSString *str = _requestTimeStr;
        NSTimeInterval second2 = [str doubleValue];
        NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:second2];
        _startDate = date3;
    }else{
        _startDate = [NSDate date];
    }
    
    [self createViews];

    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [comboBox hiddenList];
}

- (void)createViews{
    
    _mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.delegate = self;
    _mainScrollView.bounces = NO;
    _mainScrollView.tag = 1001;
    
//    _mainScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];

    [self.view addSubview:_mainScrollView];
    
    _titleScrollView = [[UIScrollView alloc] init];
    _titleScrollView.delegate = self;
    _titleScrollView.tag = 1002;
    _titleScrollView.scrollEnabled = NO;
    [self.view addSubview:_titleScrollView];
    
    _subTitleScrollView = [[UIScrollView alloc] init];
    _subTitleScrollView.delegate = self;
    _subTitleScrollView.tag = 1003;
    _subTitleScrollView.scrollEnabled = NO;
    [self.view addSubview:_subTitleScrollView];
    
    _headerView = [UIView new];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerView];
    
    UIImageView *titleImageView = [[UIImageView alloc] init];
    [titleImageView setImage:[UIImage imageNamed:@"fr_title"]];
    titleImageView.layer.borderWidth = .5;
    titleImageView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;;
    [self.view addSubview:titleImageView];
    
    UILabel *noticeLabel = ({
        UILabel *view = [UILabel new];
        view.text = @"本功能旨在方便学生更好的选择教室上自习，由于数据同步有延时，教室情况请以实际为准。";
        view.font = Title_Font;
        view.numberOfLines = 0;
        view.textColor = Color_Gray;
        view;
    });
    
    [self.view addSubview:noticeLabel];
    
    _headerView.sd_layout
    .leftSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(35);
    
    titleImageView.sd_layout
    .leftSpaceToView(self.view,0)
    .topSpaceToView(_headerView,0)
    .heightIs(40)
    .widthIs(28);
    
    _titleScrollView.sd_layout
    .leftSpaceToView(self.view,28)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(_headerView,0)
    .heightIs(40);
    
    _subTitleScrollView.sd_layout
    .leftSpaceToView(self.view,0)
    .topSpaceToView(_titleScrollView,0)
    .bottomSpaceToView(self.view,0)
    .widthIs(28);
    
    _mainScrollView.sd_layout
    .leftSpaceToView(_subTitleScrollView,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(_titleScrollView,0)
    .bottomSpaceToView(noticeLabel,0);
    
    noticeLabel.sd_layout
    .leftSpaceToView(_subTitleScrollView,0)
    .rightSpaceToView(self.view,0)
    .heightIs(40)
    .bottomSpaceToView(self.view,0);
    
    _noneInfoLabel = [UILabel new];
    _noneInfoLabel.text = @"该楼层暂无教室信息";
    _noneInfoLabel.font = [UIFont boldSystemFontOfSize:14];
    _noneInfoLabel.textColor = Color_Gray;
    _noneInfoLabel.frame = CGRectMake(0, 0, 200, 30);
    _noneInfoLabel.textAlignment = NSTextAlignmentCenter;
    _noneInfoLabel.center = self.view.center;
    _noneInfoLabel.hidden = YES;
    [self.view addSubview:_noneInfoLabel];
    
    [self addDate];
}

- (void)createBuildView{
    [_mainScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_titleScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_subTitleScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSInteger num = _allDataArray.count;
    NSInteger row = 12;
    
//    CourseManager *manager = [[CourseManager alloc] init];
//    NSArray *courseNumArr = [[manager getCourseNum] componentsSeparatedByString:@","];
    
    CGFloat labelWith = 60;
    CGFloat labelHeight = 40;
    
    _mainScrollView.contentSize = CGSizeMake(_allDataArray.count*labelWith, 12*40);
    _subTitleScrollView.contentSize = CGSizeMake(30, _allDataArray.count*labelWith);
    _titleScrollView.contentSize = CGSizeMake(_allDataArray.count*labelWith, 30);

    NSMutableDictionary *classInfoDic = [NSMutableDictionary dictionary];
    
    for (int i=0; i<row; i++) {
        for (int j=0; j<num; j++) {
            //设置行
            if (i==0) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(j*labelWith, 0, labelWith, labelHeight)];
                label.text = _allDataArray[j][@"JASH"];
                if ([_floorSelStr isEqualToString:@"-99"]) {
                    label.text = _allDataArray[j][@"JSMC"];
                }
                
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:12];
                label.layer.borderWidth = 0.5;
                label.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
                label.textColor = Color_Black;
                label.numberOfLines = 0;
                [_titleScrollView addSubview:label];
                
                [classInfoDic setObject:@(j) forKey:_allDataArray[j][@"JASH"]];
            }
            //设置列
            if (j==0) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, i*labelHeight, 28, labelHeight)];
                label.text = [NSString stringWithFormat:@"%d",i+1];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:12];
                label.layer.borderWidth = 0.5;
                label.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
                label.textColor = Color_Black;
                [_subTitleScrollView addSubview:label];
            }
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(j*labelWith, i*labelHeight, labelWith, labelHeight);
            
            [button setTitle:@"空闲" forState:UIControlStateNormal];
            [button setTitleColor:Base_Orange forState:UIControlStateNormal];
            button.tag = (i+1)*10000+j;

            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
            [button addTarget:self action:@selector(roomSelect:) forControlEvents:UIControlEventTouchUpInside];
            [_mainScrollView addSubview:button];
            
        }
    }
    
    for (int i=0; i<_emptyDataArray.count; i++) {
        NSInteger row = [classInfoDic[_emptyDataArray[i][@"JASH"]] integerValue];
        NSInteger num = [_emptyDataArray[i][@"JC"] integerValue];
        UIButton *button = [[UIButton alloc] init];
        button = [_mainScrollView viewWithTag:10000*(num)+ row];
        
        [button setTitle:@"占用" forState:UIControlStateNormal];
        [button setTitleColor:Color_Gray forState:UIControlStateNormal];
        
    }
}

- (void)roomSelect:(UIButton *)sender{
    NSInteger row = sender.tag%10000;
    NSDictionary *dic = _allDataArray[row];
    CourseViewController *vc = [[CourseViewController alloc] init];
    vc.roomNum = dic[@"JASH"];
    [self.navigationController pushViewController:vc animated:YES];
//    NSLog(@"%@",dic);
}

- (void)loadData{
    NSDictionary *commitDic = @{
                                @"rid":@"getEmployClassroom",
                                @"buildNo":_buildNoStr,
                                @"requesttime":_requestTimeStr,
                                @"floor":_floorSelStr
                                };
    [ProgressHUD show:nil];

    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [self hiddenErrorView];
        if ([responseObject[@"allClassroom"] isKindOfClass: [NSArray class]]) {
            _allDataArray = responseObject[@"allClassroom"];
            _emptyDataArray = responseObject[@"emptyClassroom"];
            
        }else{
            _allDataArray = [NSArray array];
            _emptyDataArray = [NSArray array];
        }
        
        if (_allDataArray.count == 0) {
            _noneInfoLabel.hidden = NO;
        }else{
            _noneInfoLabel.hidden = YES;
        }
        [self createBuildView];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];
        [self.view bringSubviewToFront:_headerView];
    }];
}

- (void)addDate{
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = Title_Font;
    _timeLabel.textColor = Base_Orange;
    [_headerView addSubview:_timeLabel];
    
    _timeLabel.text = [NSDate formatYMD:_startDate];

    UIButton *afterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [afterBtn setImage:[UIImage imageNamed:@"chooseRight"] forState:UIControlStateNormal];
    [afterBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    afterBtn.tag = 101;
    [_headerView addSubview:afterBtn];
    _headerView.backgroundColor = Base_Color2;
    beforBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [beforBtn setImage:[UIImage imageNamed:@"chooseLeft"] forState:UIControlStateNormal];
    [beforBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    beforBtn.tag = 102;
    [_headerView addSubview:beforBtn];
    
    _timeLabel.sd_layout
    .centerXEqualToView(_headerView)
    .centerYEqualToView(_headerView)
    .heightRatioToView(_headerView,1)
    .widthIs(80);
    
    afterBtn.sd_layout
    .leftSpaceToView(_timeLabel,0)
    .topEqualToView(_timeLabel)
    .heightRatioToView(_timeLabel,1)
    .widthIs(50);
    
    beforBtn.sd_layout
    .rightSpaceToView(_timeLabel,0)
    .topEqualToView(_timeLabel)
    .heightRatioToView(_timeLabel,1)
    .widthIs(50);
    
    floorSelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [floorSelBtn setBackgroundColor:[UIColor whiteColor]];
    floorSelBtn.frame = CGRectMake(kScreenWidth-80, 2, 70, 30);
    [floorSelBtn setTitle:@"1层" forState:UIControlStateNormal];
    [floorSelBtn setTitleColor:Color_Gray forState:UIControlStateNormal];
    
    [floorSelBtn addTarget:self action:@selector(floorSelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    floorSelBtn.layer.borderColor = [UIColor grayColor].CGColor;
    floorSelBtn.layer.borderWidth = 0.5;
    floorSelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    floorSelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [floorSelBtn setTitleColor:Color_Gray forState:UIControlStateNormal];
    
    [_headerView addSubview:floorSelBtn];
    
    if ([_timeLabel.text isEqualToString:[NSDate formatYMD:[NSDate date]]]) {
        beforBtn.hidden = YES;
    }else{
        beforBtn.hidden = NO;
    }
}

- (void)floorSelAction:(UIButton *)sender{
    NSMutableArray *floorArr = [NSMutableArray array];
    for (int i = 1; i<=_floorNum; i++) {
        [floorArr addObject:[NSString stringWithFormat:@"%d层",i]];
    }
    [floorArr addObject:@"其他楼层"];
    WEAKSELF;
    TePopList *pop = [[TePopList alloc] initWithListDataSource:floorArr withTitle:@"选择楼层" withSelectedBlock:^(NSInteger select) {
        if (select == floorArr.count-1) {
            _floorSelStr = @"-99";
            [floorSelBtn setTitle:@"其他" forState:UIControlStateNormal];
        }else{
            _floorSelStr = [NSString stringWithFormat:@"%ld",select+1];
            [floorSelBtn setTitle:[NSString stringWithFormat:@"%@层",_floorSelStr] forState:UIControlStateNormal];
        }
        
        [weakSelf loadData];
    }];
    [pop selectIndex:[_floorSelStr integerValue]-1];
    pop.isAllowBackClick = YES;
    [pop show];
}

- (void)btnClick:(UIButton *)sender{
    if (sender.tag==101) {
        _countNum++;
    }else if (sender.tag == 102){
        _countNum--;
    }
    
    NSDate *tempDate = [NSDate dateAfterDate:_startDate day:_countNum];
    _timeLabel.text = [NSDate formatYMD:tempDate];
    
    if ([_timeLabel.text isEqualToString:[NSDate formatYMD:[NSDate date]]]) {
        beforBtn.hidden = YES;
    }else{
        beforBtn.hidden = NO;
    }
    
    int timer = [tempDate timeIntervalSince1970];
    _requestTimeStr = [NSString stringWithFormat:@"%d",timer ];
    
    [self loadData];
}


#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [comboBox hiddenList];

    if (scrollView.tag == 1001) {

        _titleScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, _titleScrollView.contentOffset.y);
        _subTitleScrollView.contentOffset = CGPointMake(_subTitleScrollView.contentOffset.x, scrollView.contentOffset.y);
    }

}

#pragma mark ComboBoxView delegate
-(void)comboBoxView:(XJComboBoxView *)comboBoxView didSelectRowAtValueMember:(NSString *)valueMember displayMember:(NSString *)displayMember{
    
    
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
