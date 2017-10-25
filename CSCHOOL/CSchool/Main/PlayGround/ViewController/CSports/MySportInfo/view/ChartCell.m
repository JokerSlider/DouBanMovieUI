//
//  ChartCell.m
//  CSchool
//
//  Created by mac on 17/4/12.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "ChartCell.h"
#import "UIView+SDAutoLayout.h"
#import "SHLineGraphView.h"
#import "SHPlot.h"
@interface ChartCell()
@property (nonatomic,strong)UISegmentedControl *segmentedControl;
@property (nonatomic,strong)NSMutableArray *xArray;
@property (nonatomic,strong)NSMutableArray *yArray;
@end
@implementation ChartCell
{
    SHLineGraphView *_lineGraph;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}
-(void)createView
{
    
    [self createSegmentView];
    [self createChartView];
}

#pragma mark 创建分段选择器
-(void)createSegmentView
{
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"周",@"月",@"年",nil];
    self.segmentedControl  = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    self.segmentedControl.frame = CGRectMake(0,0, 0, 0);
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.tintColor = RGB(219, 219, 219);
    [self.segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:14.0],NSFontAttributeName,nil];
    [self.segmentedControl setTitleTextAttributes:dic forState:UIControlStateSelected];
    NSDictionary *noseDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:14.0],NSFontAttributeName,nil];
    [self.segmentedControl setTitleTextAttributes:noseDic forState:UIControlStateNormal];
    [self.contentView addSubview:self.segmentedControl];
    self.segmentedControl.sd_layout.leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).heightIs(36).topSpaceToView(self.contentView,10);
}
-(void)setUserID:(NSString *)userID
{
    _userID = userID;
    [self loadData:@"1"];

}
#pragma mark 获取表视图数据
-(void)loadData:(NSString *)state
{
    //（1周 2月 3年)
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL  parameters:@{@"rid":@"getPersonSportChartDetail",@"userid":self.userID,@"state":state} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        NSArray *xOriginArr = responseObject[@"data"][@"xAxis"];
        NSArray *yOriginArr = responseObject[@"data"][@"series"];
        NSArray *xAxis  ;
        NSArray *yAxis;
        for (NSDictionary *dic in yOriginArr) {
            yAxis = dic[@"data"];
            NSLog(@"%@",yAxis);
        }
        for (NSDictionary *dic in xOriginArr) {
            xAxis = dic[@"data"];
        }
        self.xArray = [NSMutableArray array];
        self.yArray = [NSMutableArray array];
        for (int i=0; i<xAxis.count; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSNumber *myNumber = [NSNumber numberWithInt:i+1];
            [dic setValue:xAxis[i] forKey:myNumber.description];
            [self.xArray addObject:dic];
        }
        for (int i = 0; i<yAxis.count; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSNumber *myNumber = [NSNumber numberWithInt:i+1];
            [dic setValue:yAxis[i] forKey:myNumber.description];
            [self.yArray addObject:dic];
            
        }
        NSLog(@"%@",self.yArray);
        
        [self reloadChartView:self.xArray andYarray:self.yArray];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [JohnAlertManager showFailedAlert:@"获取报表数据失败" andTitle:@"提示"];
    }];
}

#pragma mark 初始化表视图
-(void)createChartView
{
    
    NSArray *xArr = @[
                      @{ @1 :  @"周一" },
                      @{ @2 :  @"周二" },
                      @{ @3 :  @"周三" },
                      @{ @4 :  @"周四" },
                      @{ @5 :  @"周五" },
                      @{ @6 :  @"周六" },
                      @{ @7 :  @"周日" },
                      ];
    NSArray *yArr = @[
                      @{ @1 : @0 },
                      @{ @2 : @0 },
                      @{ @3 : @0 },
                      @{ @4 : @0 },
                      @{ @5 : @0 },
                      @{ @6 : @0 },
                      @{ @7 : @0 },
                      ];
    
    [self reloadChartView:xArr andYarray:yArr];
}
-(void)reloadChartView:(NSArray *)xArray andYarray:(NSArray *)yArray
{
    if ([self.contentView.subviews containsObject:_lineGraph]) {
        [_lineGraph removeFromSuperview];
    }
    NSMutableArray *titleArr = [NSMutableArray array];
    for (int i = 0; i<yArray.count; i++) {
        NSDictionary *dic = yArray[i];
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSNumber *numer = obj;
            [titleArr addObject:numer.description];
        }];
        
    }
    //initate the graph view
    _lineGraph = [[SHLineGraphView alloc] initWithFrame:CGRectMake(0, 0,  kScreenWidth , kScreenHeight/2)];
    [self.contentView addSubview:_lineGraph];
    _lineGraph.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(self.segmentedControl,20).rightSpaceToView(self.contentView,14).heightIs(175);
//    [self.contentView setupAutoHeightWithBottomView:_lineGraph bottomMargin:20];
    
    NSDictionary *_themeAttributes = @{
                                       kXAxisLabelColorKey : RGB(0, 0, 0),
                                       kXAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],
                                       kYAxisLabelColorKey : RGB(0, 0, 0),
                                       kYAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],
                                       kYAxisLabelSideMarginsKey : @35,
                                       kPlotBackgroundLineColorKye : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4]
                                       };
    _lineGraph.themeAttributes = _themeAttributes;
    int maxValue = [[titleArr valueForKeyPath:@"@max.floatValue"] intValue];

    if (maxValue<=10000) {
        maxValue = maxValue +1000;
    }else{
        maxValue = maxValue+10000;
    }
    NSNumber *maxNum = [NSNumber numberWithInt:maxValue];
    
    _lineGraph.yAxisRange = maxNum;//y轴最大值
    _lineGraph.yAxisSuffix = @"步";
    
    _lineGraph.xAxisValues = xArray;
    //create a new plot object that you want to draw on the `_lineGraph`
    SHPlot *_plot1 = [[SHPlot alloc] init];
    _plot1.plottingValues = yArray;
    
    
    _plot1.plottingPointsLabels = titleArr;
    NSDictionary *_plotThemeAttributes = @{
                                           kPlotFillColorKey : [UIColor colorWithRed:0.47 green:0.75 blue:0.78 alpha:0.5],
                                           kPlotStrokeWidthKey : @2,
                                           kPlotStrokeColorKey : RGB(51, 204, 153),
                                           kPlotPointFillColorKey : RGB(51, 204, 153),
                                           kPlotPointValueFontKey : [UIFont fontWithName:@"TrebuchetMS" size:18],
                                           kYAxisLabelFontKey :[UIFont systemFontOfSize:6.0],
                                           kXAxisLabelColorKey :RGB(0, 0, 0),
                                           };
    
    _plot1.plotThemeAttributes = _plotThemeAttributes;
    _lineGraph.yAxisSuffix = @"(步)";//y轴单位
    _lineGraph.startYAxisRange = @(0);//初始位置
    
    [_lineGraph addPlot:_plot1];
    [_lineGraph setupTheView];
}
#pragma mark 切换报表数据
-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)segMentControl
{
    [self loadData:[NSString stringWithFormat:@"%ld",(long)segMentControl.selectedSegmentIndex+1]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
