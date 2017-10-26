//
//  MainViewController.m
//  HeadSlipeAnimation
//
//  Created by mac on 17/8/21.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "MainViewController.h"
#import <YYModel.h>
#import "CustomerNav.h"
#import "UIScrollView+VORefresh.h"
#import "DouBNetCore.h"
#import "HomeMainCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "KVOHeaderView.h"
#import "MovieInfoViewController.h"
#import "UIButton+Size.h"
#import "iBeaconObject.h"
//#import "ZWAdView.h"
#define WEAKSELF   typeof(self) __weak weakSelf = self

#define CATEGORY  @[@"正在热映",@"即将上映",@"热门",@"美食",@"生活",@"设计感",@"家居",@"礼物",@"阅读",@"运动健身",@"旅行户外"]
#define FONTMAX 15.0
#define FONTMIN 14.0
#define PADDING 15.0  //标签之间的间距


@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,NavBtnDelegate>

//@property (nonatomic,strong)UITableView *tableView;


//@property (nonatomic,strong)ZWAdView *loopSroView;
@property (nonatomic,copy)NSString *currenURL;

@property (nonatomic,strong) UIImageView *imageView;//图片

@property (nonatomic,strong) UIImageView  *locationimage;//图片

@property (nonatomic,strong) UILabel  *location;//图片


@property (nonatomic,assign) CGRect originFrame;

@property (nonatomic,assign) CGRect segOriginFrame;

@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong)KVOHeaderView *navHeadView;

@property (nonatomic,assign)int  page;

@property (nonatomic,strong)NSMutableArray *modelArr;

@property (nonatomic,strong)NSMutableArray *dataArr;//

@property (nonatomic,copy) NSString *cityName;//城市名称

//存放TableView
@property (nonatomic, strong) UIScrollView *segmentScrollView;

@property (nonatomic, strong) UIImageView *currentSelectedItemImageView;

@property (nonatomic, strong) UIScrollView *bottomScrollView;
//存放button
@property(nonatomic,strong)NSMutableArray *titleButtons;
//记录上一个button
@property (nonatomic, strong) UIButton *previousButton;
//存放控制器
@property(nonatomic,strong)NSMutableArray *controlleres;
//当前展示的table
@property (nonatomic, strong) UITableView *currentTableView;

//存放TableView
@property(nonatomic,strong)NSMutableArray *tableViews;

//记录上一个偏移量
@property (nonatomic, assign) CGFloat lastTableViewOffsetY;

@property (nonatomic,strong)iBeaconObject *iBeaconObj;

@property (nonatomic,strong)HomeMainModel *locationModel;

@end
//1920 × 1080
static CGFloat ratio = 1000/714;
static CGFloat headViewHeight = 160.f;
@implementation MainViewController

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    [self initIBeacon];
    [[ToolMannger shareInstance] startLocation];

}
#pragma mark 获取地理位置
-(void )loadLoctionName
{
    [[ToolMannger shareInstance] showProgressView];

    [ToolMannger shareInstance].loctationBlock = ^(NSArray *objArr,NSArray *locationNameArr){
        NSString *locationName = [locationNameArr componentsJoinedByString:@""];
        self.location.text = locationName;
//        self.location.text  = @"济南市历下区经十路8000号龙奥金座";
        CGSize  size = [self.location boundingRectWithSize:CGSizeMake(0, 20)];
        self.location.sd_layout.widthIs(size.width);
        self.cityName = [locationNameArr firstObject]?[locationNameArr firstObject]:@"北京";
        [self loadDataWithURL:self.currenURL];
    };

}
-(void)loadDataWithURL:(NSString *)url
{

    
    [DouBNetCore requestNewPOST:url parameters:@{@"city": self.cityName,@"start":@(self.page),@"count":Message_Num} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [[ToolMannger shareInstance]dissmissProgressView];
        
        _dataArr= [NSMutableArray array];
        NSArray *dataArray = responseObject[@"subjects"];
        if (_page == 0) {
            _modelArr = [NSMutableArray array];
            if (dataArray.count==0) {
                [self.currentTableView reloadData];
                [self.currentTableView.topRefresh endRefreshing];
                [JohnAlertManager showFailedAlert:@"无搜索结果" andTitle:@""];
                return ;
            }
        }
        for (NSDictionary *dic in dataArray) {
            HomeMainModel   *model = [[HomeMainModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_dataArr addObject:model];
        }
        [_modelArr addObjectsFromArray:_dataArr];
        //撤销的放到最后显示
        
        [self.currentTableView reloadData];
        [self.currentTableView.topRefresh endRefreshing];
        if (dataArray.count<[Message_Num intValue]) {
            if (_page>=0) {
                [self.currentTableView.bottomRefresh endRefreshing];
                return;
            }
        }
        [self.currentTableView.bottomRefresh endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [[ToolMannger shareInstance]dissmissProgressView];
        [JohnAlertManager showFailedAlert:error[@"msg"] andTitle:@""];
        [self.currentTableView.topRefresh endRefreshing];
        [self.currentTableView.bottomRefresh endRefreshing];
    }];

}
-(void)createView
{
    self.page = 0;
    //底部tableview
    self.titleButtons = [[NSMutableArray alloc] initWithCapacity:CATEGORY.count];
    self.controlleres = [[NSMutableArray alloc] initWithCapacity:CATEGORY.count];
    self.tableViews = [[NSMutableArray alloc] initWithCapacity:CATEGORY.count];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.title = @"豆瓣生活";
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenWidth*ratio)];
    self.imageView.image = [UIImage imageNamed:@"headimage.jpg"];
    self.originFrame = self.imageView.frame;
    [self.view addSubview:self.imageView];

    self.locationimage = ({
        UIImageView *view = [UIImageView new];
        view.frame = CGRectMake(0, KscreenWidth*ratio-headViewHeight-25, 20, 20);
        [view setImage:[UIImage imageNamed:@"locitonInfo"]];
        view;
    });
    [self.view addSubview:self.locationimage];
    
    self.location = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:11];
        view.textColor = [UIColor whiteColor];
        view.frame = CGRectMake(20, KscreenWidth*ratio-headViewHeight-25, 20, 20);
        view;
    });
    [self.view addSubview:self.location];
    [self.view addSubview:self.bottomScrollView];
    self.navHeadView = ({
        KVOHeaderView *view = [[KVOHeaderView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 64)];
        view.backgroundColor = [UIColor clearColor];
        view.tableViews =self.tableViews;
        view.delegate = self;
        view;
    });
    [self.view addSubview:self.navHeadView];
    [self.view addSubview:self.segmentScrollView];


//    self.navHeadView = [[KVOHeaderView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 64)];
//    self.navHeadView.backgroundColor = [UIColor clearColor];
//    self.navHeadView.tableViews =self.tableViews;
//    self.navHeadView.delegate = self;
//    [self.view addSubview:self.navHeadView];
    
    
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KscreenWidth,KscreenHeight-64) style:UITableViewStylePlain];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.backgroundColor = [UIColor clearColor];
//    self.tableView.showsVerticalScrollIndicator = NO;
//    self.tableView.tableFooterView = [UIView new];
//    [self.view addSubview:self.tableView];
    
//    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, headViewHeight)];
//    headView.backgroundColor = [UIColor clearColor];
//    self.tableView.tableHeaderView = headView;
//    
//    
//    [self.tableView addTopRefreshWithTarget:self action:@selector(topRefreshing)];
//    [self.tableView addBottomRefreshWithTarget:self action:@selector(bottomRefreshing)];
//
//    CGRect frame = self.tableView.bottomRefresh.bounds;
//    frame.size.width /= 4;
//    self.tableView.bottomRefresh.progressView = [[UIProgressView alloc] initWithFrame:frame];
//    [self.tableView.bottomRefresh setRefreshText:nil forRefreshState:VORefreshStatePulling];
    
    _modelArr = [NSMutableArray new];
    self.currenURL = API_HOST;
    [self loadLoctionName];

}
#pragma marl  lazy
-(UIScrollView *)bottomScrollView {
    
    if (!_bottomScrollView) {
        _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
        _bottomScrollView.delegate = self;
        _bottomScrollView.pagingEnabled = YES;
        
        for (int i = 0; i<CATEGORY.count; i++) {
            self.backView = [[UIView alloc]initWithFrame:CGRectMake(KscreenWidth * i, headViewHeight+64+40, KscreenWidth, KscreenWidth*ratio-headViewHeight)];
            self.backView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:self.backView];
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(KscreenWidth * i, 64+40, KscreenWidth,KscreenHeight-64-40) style:UITableViewStylePlain];
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, headViewHeight)];
            headView.backgroundColor = [UIColor clearColor];
            tableView.tableHeaderView = headView;
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.backgroundColor = [UIColor clearColor];
            tableView.showsVerticalScrollIndicator = NO;
            tableView.tableFooterView = [UIView new];
            [tableView addTopRefreshWithTarget:self action:@selector(topRefreshing)];
            [tableView addBottomRefreshWithTarget:self action:@selector(bottomRefreshing)];
            CGRect frame = self.currentTableView.bottomRefresh.bounds;
            frame.size.width /= 4;
            tableView.bottomRefresh.progressView = [[UIProgressView alloc] initWithFrame:frame];
            [tableView.bottomRefresh setRefreshText:nil forRefreshState:VORefreshStatePulling];
            
            [self.bottomScrollView addSubview:tableView];
            [self.controlleres addObject:tableView];
            [self.tableViews addObject:tableView];
            
            NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
            [tableView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
            
        }
        
        self.currentTableView = self.tableViews[0];
        self.bottomScrollView.contentSize = CGSizeMake(self.controlleres.count * KscreenWidth, 0);
        
    }
    return _bottomScrollView;
}

- (UIScrollView *)segmentScrollView {
    
    if (!_segmentScrollView) {
        
        _segmentScrollView =  [[UIScrollView alloc]initWithFrame:CGRectMake(0,  headViewHeight+64, KscreenWidth, 40)];
        _segOriginFrame = _segmentScrollView.frame;
        [_segmentScrollView addSubview:self.currentSelectedItemImageView];
        _segmentScrollView.showsHorizontalScrollIndicator = NO;
        _segmentScrollView.showsVerticalScrollIndicator = NO;
        _segmentScrollView.backgroundColor = [UIColor whiteColor];
        NSInteger btnoffset = 0;
        
        
        for (int i = 0; i<CATEGORY.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:CATEGORY[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:FONTMIN];
            CGSize size = [UIButton sizeOfLabelWithCustomMaxWidth:KscreenWidth systemFontSize:FONTMIN andFilledTextString:CATEGORY[i]];
            float originX =  i? PADDING*2+btnoffset:PADDING;
            btn.frame = CGRectMake(originX, 14, size.width, size.height);
            btnoffset = CGRectGetMaxX(btn.frame);
            
            
            btn.titleLabel.textAlignment = NSTextAlignmentLeft;
            [btn addTarget:self action:@selector(changeSelectedItem:) forControlEvents:UIControlEventTouchUpInside];
            [_segmentScrollView addSubview:btn];
            
            [self.titleButtons addObject:btn];
            
            //contentSize 等于按钮长度叠加
            //默认选中第一个按钮
            if (i == 0) {
                
                btn.selected = YES;
                _previousButton = btn;
                
                _currentSelectedItemImageView.frame = CGRectMake(PADDING, self.segmentScrollView.frame.size.height - 2, btn.frame.size.width, 2);
            }
        }
        
        _segmentScrollView.contentSize = CGSizeMake(btnoffset+PADDING, 25);
    }
    
    return _segmentScrollView;
}

- (UIImageView *)currentSelectedItemImageView {
    if (!_currentSelectedItemImageView) {
        _currentSelectedItemImageView = [[UIImageView alloc] init];
        _currentSelectedItemImageView.image = [UIImage imageNamed:@"nar_bgbg"];
    }
    return _currentSelectedItemImageView;
}

#pragma mark
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
    
    UITableView *tableView = (UITableView *)object;
    
    
    if (!(self.currentTableView == tableView)) {
        return;
    }
    
    if (![keyPath isEqualToString:@"contentOffset"]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    int index =(int)[self.tableViews indexOfObject:self.currentTableView];

    CGFloat tableViewoffsetY = tableView.contentOffset.y;
    
    self.lastTableViewOffsetY = tableViewoffsetY;
    
    if ( tableViewoffsetY>=0 && tableViewoffsetY<=headViewHeight) {
        
        self.segmentScrollView.frame = CGRectMake(0, headViewHeight+64-tableViewoffsetY, KscreenWidth, 40);
        self.backView.frame = CGRectMake(index*KscreenWidth,  self.segmentScrollView.frame.origin.y+40, KscreenWidth, KscreenWidth*ratio-headViewHeight);

    }else if( tableViewoffsetY < 0){
        self.segmentScrollView.frame = CGRectMake(0,headViewHeight+64-tableViewoffsetY, KscreenWidth, 40);
        self.backView.frame = CGRectMake(index*KscreenWidth,  self.segmentScrollView.frame.origin.y+40, KscreenWidth, KscreenWidth*ratio-headViewHeight);
    }else if (tableViewoffsetY > headViewHeight){
        
        self.segmentScrollView.frame = CGRectMake(0, 64, KscreenWidth, 40);
    }
}



#pragma  mark - 选项卡点击事件

-(void)changeSelectedItem:(UIButton *)currentButton{

    _previousButton.selected = NO;
    currentButton.selected = YES;
    _previousButton = currentButton;
    
    NSInteger index = [self.titleButtons indexOfObject:currentButton];
    
    self.currentTableView  = self.tableViews[index];
    for (UITableView *tableView in self.tableViews) {
        
        if ( self.lastTableViewOffsetY>=0 &&  self.lastTableViewOffsetY<=200) {
            
            tableView.contentOffset = CGPointMake(0,  self.lastTableViewOffsetY);
            
        }else if(self.lastTableViewOffsetY < 0){
            
            tableView.contentOffset = CGPointMake(0, 0);
            
        }else if ( self.lastTableViewOffsetY > 200){
            
            tableView.contentOffset = CGPointMake(0, 200);
        }
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        if (index == 0) {
            
            self.currentSelectedItemImageView.frame = CGRectMake(PADDING, self.segmentScrollView.frame.size.height - 2,currentButton.frame.size.width, 2);
            [self loadDataWithURL:API_HOST];
        }else{
            
            [self loadDataWithURL:API_HOST2];

            UIButton *preButton = self.titleButtons[index - 1];
            
            float offsetX = CGRectGetMinX(preButton.frame)-PADDING*2;
            
            [self.segmentScrollView scrollRectToVisible:CGRectMake(offsetX, 0, self.segmentScrollView.frame.size.width, self.segmentScrollView.frame.size.height) animated:YES];
            
            self.currentSelectedItemImageView.frame = CGRectMake(CGRectGetMinX(currentButton.frame), self.segmentScrollView.frame.size.height-2, currentButton.frame.size.width, 2);
        }
        self.bottomScrollView.contentOffset = CGPointMake(KscreenWidth *index, 0);
        
    }];
}
#pragma mark   加载数据
- (void)topRefreshing{
    self.page =1;
    [self loadDataWithURL:self.currenURL];
}

- (void)bottomRefreshing{
    // 模拟加载延迟
    self.page  = self.page + [Message_Num intValue];
    [self loadDataWithURL:self.currenURL];
}

#pragma mark  ScrollviewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView ==self.bottomScrollView) {
        int index =  scrollView.contentOffset.x/scrollView.frame.size.width;
        
        UIButton *currentButton = self.titleButtons[index];
        _previousButton.selected = NO;
        currentButton.selected = YES;
        _previousButton = currentButton;
        
        
        self.currentTableView  = self.tableViews[index];
        for (UITableView *tableView in self.tableViews) {
            
            if ( self.lastTableViewOffsetY>=0 &&  self.lastTableViewOffsetY<=200) {
                
                tableView.contentOffset = CGPointMake(0,  self.lastTableViewOffsetY);
                
            }else if(  self.lastTableViewOffsetY < 0){
                
                tableView.contentOffset = CGPointMake(0, 0);
                
            }else if ( self.lastTableViewOffsetY > 200){
                
                tableView.contentOffset = CGPointMake(0, 200);
            }
            
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            if (index == 0) {
                
                self.currentSelectedItemImageView.frame = CGRectMake(PADDING, self.segmentScrollView.frame.size.height - 2,currentButton.frame.size.width, 2);
                [self loadDataWithURL:API_HOST];

            }else{
                [self loadDataWithURL:API_HOST2];

                UIButton *preButton = self.titleButtons[index - 1];
                
                float offsetX = CGRectGetMinX(preButton.frame)-PADDING*2;
                
                [self.segmentScrollView scrollRectToVisible:CGRectMake(offsetX, 0, self.segmentScrollView.frame.size.width, self.segmentScrollView.frame.size.height) animated:YES];
                
                self.currentSelectedItemImageView.frame = CGRectMake(CGRectGetMinX(currentButton.frame), self.segmentScrollView.frame.size.height-2, currentButton.frame.size.width, 2);
            }
            
        }];

    
    
    }else{
    
        CGFloat yOffSet = scrollView.contentOffset.y;
        //改变导航栏颜色
        //上滑 移动
        if (yOffSet>0) {
            self.imageView.frame = ({
                CGRect  frame = self.imageView.frame;
                frame.origin.y = self.originFrame.origin.y -yOffSet;
                frame;
            });
        }
        //下拉  放大
        else{
            self.imageView.frame = ({
                CGRect frame = self.imageView.frame;
                frame.size.height = self.originFrame.size.height - yOffSet;
                frame.size.width = frame.size.height/ratio;
                frame.origin.x = self.originFrame.origin.x - (frame.size.width - self.originFrame.size.width)/2;
                frame;
            });
            self.segmentScrollView.frame = ({
                CGRect frame = self.segmentScrollView.frame;
                frame.size.height = self.originFrame.size.height - yOffSet;
                frame.size.width = frame.size.height/ratio;
                frame.origin.x = self.originFrame.origin.x - (frame.size.width - self.originFrame.size.width)/2;
                frame;

            });
           
        }
    }
    
}
#pragma mark  NavDlegate
-(void)leftBtnAction:(UIButton *)sender
{
    NSLog(@"点击了左侧按钮");
    [self.iBeaconObj stopScanIbeacon];
}

-(void)rightBtnAction:(UIButton *)sendr
{
    NSLog(@"点击了右侧按钮");
    
    [self.iBeaconObj startScanIbeacon];
}

#pragma mark  UITableview  delegate  datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"movielistCell";
    HomeMainCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[HomeMainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.model = _modelArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
    Class currentClass = [HomeMainCell class];
    HomeMainModel *model = [HomeMainModel new];
    return [self.currentTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
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
#pragma mark  点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self uploadMessageFromDic:self.locationModel];
//    //r
//    return;
    HomeMainModel *model = _modelArr[indexPath.row];
    NSLog(@"%@",model)
    MovieInfoViewController *vc = [MovieInfoViewController new];
    vc.ID = model.movieID;
    
    [self.navigationController pushViewController:vc  animated:YES];
}
-(void)initIBeacon
{
    // Do any additional setup after loading the view, typically from a nib.
    _iBeaconObj = [[iBeaconObject alloc]init];
    WEAKSELF;
    _iBeaconObj.editSucessBlock = ^(NSDictionary *IBeaconDic){
        HomeMainModel *model = [[HomeMainModel alloc ]init];
        [model yy_modelSetWithDictionary:IBeaconDic];
        weakSelf.locationModel = model;
    };
    
    
}

//上传数据
-(void)uploadMessageFromDic:(HomeMainModel *)model
{
    NSDictionary *dic = @{
                          @"rid":@"addBluetoothLocation",
                          @"userid":model.userid,
                          @"uuid":model.uuid,
                          @"major":model.major,
                          @"minor":model.minor,
                          @"proximity":model.proximity,
                          @"accuracy":model.accuracy,
                          @"rssi":model.rssi,
                          @"distance":model.distance,
                          @"schoolCode":model.schoolCode
                          
                          };
    [DouBNetCore requestNewPOST:@"http://123.233.121.17:15100/index.php" parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [JohnAlertManager showSuccessAlert:responseObject[@"msg"] andTitle:@"提示"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [JohnAlertManager showSuccessAlert:error[@"msg"] andTitle:@"提示"];

    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
