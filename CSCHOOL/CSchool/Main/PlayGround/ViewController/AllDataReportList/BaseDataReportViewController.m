//
//  BaseDataReportViewController.m
//  CSchool
//
//  Created by mac on 17/4/26.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseDataReportViewController.h"
#define ReportBaseUrl  @"http://123.233.121.17:15100/"
@import WebKit;

@interface BaseDataReportViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *mainWebView;
@end

@implementation BaseDataReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mainWebView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    self.mainWebView.layer.borderWidth = 0;
    self.mainWebView.delegate = self;
    self.mainWebView.allowsInlineMediaPlayback = YES;
//    self.mainWebView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏
//    [self.mainWebView sizeToFit];
    [self.view addSubview:self.mainWebView];
    [self loadData];
}
-(void)loadData
{
    switch (_dataType) {
        case 0:
//            self.title = @"一卡通统计报表";
            [self loadOneCardDataReportWithPortType:@"3"];//1,周 2，月 3，年
            break;
        case 1:
//            self.title = @"个人偏科情况统计";
            [self loadPersonScorePort];
            break;
        case 2:
//            self.title = @"个人成绩，上网，借阅 变化统计";

            [self loadPersonNetDataPort];
            break;
        case 3:
//            self.title = @"班级消费统计";
            [self loadYearCostDataPortwithYear:@"2017"];
            break;
        case 4:
//            self.title = @"个人消费统计";

            [self loadPersonCostDataReport];
            break;
        case 5:
//            self.title = @"贫困生排名";
            [self loadNeesStudentListDataReportType:@"rank"];//贫困生排名（雷达图）(rank - 数据统计  actual - 值统计  score - 个人成绩排行)
            break;
        case 6:
//            self.title = @"个人位置";
            [self loadLocation];
            break;
        default:
            break;
    }
}
#pragma  mark  加载一卡通消费页面
-(void)loadLocation{
    NSString *baserUrl = [NSString stringWithFormat:@"%@location.php?deviceId=867993024867762&schoolCode=%@&begintime=@""&endtime=@""",ReportBaseUrl,[AppUserIndex GetInstance].schoolCode];
    NSURL *url = [NSURL URLWithString:baserUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.mainWebView loadRequest:request];
}
-(void)loadOneCardDataReportWithPortType:(NSString *)type{
    NSString *baserUrl = [NSString stringWithFormat:@"%@charts/echartsStuForOneCard.php?userid=201511101102&schoolCode=%@&type=%@",ReportBaseUrl,[AppUserIndex GetInstance].schoolCode,type];
    NSURL *url = [NSURL URLWithString:baserUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.mainWebView loadRequest:request];
}
#pragma  mark 个人偏科情况统计
-(void)loadPersonScorePort
{
    NSString *baserUrl = [NSString stringWithFormat:@"%@charts/echartsStuForPartSec.php?userid=%@&schoolCode=%@",ReportBaseUrl,[AppUserIndex GetInstance].role_id,[AppUserIndex GetInstance].schoolCode];
    NSURL *url = [NSURL URLWithString:baserUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.mainWebView loadRequest:request];
}
#pragma mark 个人成绩，上网，借阅 变化统计
-(void)loadPersonNetDataPort
{
    NSString *baserUrl = [NSString stringWithFormat:@"%@charts/echartsStuForInfo.php?userid=%@&schoolCode=%@",ReportBaseUrl,[AppUserIndex GetInstance].role_id,[AppUserIndex GetInstance].schoolCode];
    NSURL *url = [NSURL URLWithString:baserUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.mainWebView loadRequest:request];
}
#pragma  mark 按年度划分班级消费统计（散点图）
-(void)loadYearCostDataPortwithYear:(NSString *)year
{
    NSString *baserUrl = [NSString stringWithFormat:@"%@charts/echartsStuForScatter.php?year=%@&&schoolCode=%@",ReportBaseUrl,year,[AppUserIndex GetInstance].schoolCode];
    NSURL *url = [NSURL URLWithString:baserUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.mainWebView loadRequest:request];
}
#pragma  mark 个人消费统计（饼图）
-(void)loadPersonCostDataReport
{
    NSString *baserUrl = [NSString stringWithFormat:@"%@charts/echartsStuForPie.php?schoolCode=%@&userid=%@",ReportBaseUrl,[AppUserIndex GetInstance].schoolCode,[AppUserIndex GetInstance].role_id];
    NSURL *url = [NSURL URLWithString:baserUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.mainWebView loadRequest:request];
}
#pragma mark 贫困生排名（雷达图）(rank - 数据统计  actual - 值统计  score - 个人成绩排行)
-(void)loadNeesStudentListDataReportType:(NSString *)type
{
    NSString *baserUrl = [NSString stringWithFormat:@"%@charts/echartsStuForRadar.php?schoolCode=%@&userid=%@&type=%@",ReportBaseUrl,[AppUserIndex GetInstance].schoolCode,[AppUserIndex GetInstance].role_id,type];
    NSURL *url = [NSURL URLWithString:baserUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.mainWebView loadRequest:request];
}
#pragma mark 获取贫困生统计信息
//-(void)loadNeedsStudentInfo
//{
//
//    NSString *baserUrl = [NSString stringWithFormat:@"%@charts/echartsStuForRadar.php?schoolCode=%@&userid=%@&type=%@",ReportBaseUrl,[AppUserIndex GetInstance].schoolCode,[AppUserIndex GetInstance].role_id,type];
//    NSURL *url = [NSURL URLWithString:baserUrl];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.mainWebView loadRequest:request];
// 
//}
#pragma UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [ProgressHUD show:@"正在加载"];
}

//-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    [ProgressHUD dismiss];
//}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error   {
    
    [ProgressHUD dismiss];
    XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"网络开小差了" withContent:@"刷新试试？" WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
    alert.delegate =self;
    [alert show];
    
}
//Java代码
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [ProgressHUD dismiss];
    //修改服务器页面的meta的值
    NSString *script = [NSString stringWithFormat: @"var script = document.createElement('script');"
                        "script.type = 'text/javascript';"
                        "script.text = \"function ResizeImages() { "
                        "var myimg;"
                        "var maxwidth=%f;" //屏幕宽度
                        "for(i=0;i <document.images.length;i++){"
                        "myimg = document.images[i];"
                        "myimg.height = maxwidth / (myimg.width/myimg.height);"
                        "myimg.width = maxwidth;"
                        "}"
                        "}\";"
                        "document.getElementsByTagName('p')[0].appendChild(script);",kScreenWidth];
    
    //添加JS
    [webView stringByEvaluatingJavaScriptFromString:script];
    
    //添加调用JS执行的语句
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
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
