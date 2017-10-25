//
//  QuestionDetailNewViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/7/8.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "QuestionDetailNewViewController.h"
#import "CallRepairViewController.h"

@interface QuestionDetailNewViewController ()<XGAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *repairBtn;
@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;

@property (nonatomic,copy) NSString *baseUrl;

@end

@implementation QuestionDetailNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"详情";
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _doneBtn.frame = CGRectMake(0, 1, kScreenWidth/2, 40);
    _repairBtn.frame = CGRectMake(kScreenWidth/2+1, 1, kScreenWidth/2, 40);
}

- (IBAction)doneBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)repairBtnAction:(UIButton *)sender {
    CallRepairViewController *vc = [[CallRepairViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)loadData
{
    [ProgressHUD show:@"正在努力加载..."];
    WEAKSELF;
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getCommonFaultById", @"commonFaultId":_questionId} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject[@"data"][0];
        
        self.baseUrl = dic[@"CF_DESCRIPTION"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [weakSelf loadFIle];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
        [self showErrorViewLoadAgain:error[@"msg"]];
        
    }];
}
-(void)faliureAlert
{
    static int i = 0;
    if (i>2) {
        i=0;
        [self showErrorView:@"我搞不定了,切换网络试试" andImageName:nil];
    }else{
        XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"网络开小差了" withContent:@"刷新试试？" WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
        alert.delegate =self;
        alert.tag = 1000;
        [alert show];
    }
    i++;
    
}

#pragma XgAlrtDelete
- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title;
{
    if (view.tag==1000) {
        [self loadData];
    }
}
-(void)loadFIle
{
    [self.mainWebView loadHTMLString:self.baseUrl baseURL:nil];
}
- (void)loadString:(NSString *)str
{
    NSString *urlStr = str;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.mainWebView loadRequest:request];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    [ProgressHUD dismiss];
}
#pragma UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //拦截网页图片  并修改图片大小
    NSString *webString = [NSString stringWithFormat:@"var script = document.createElement('script');"
                           "script.type = 'text/javascript';"
                           "script.text = \"function ResizeImages() { "
                           "var myimg,oldwidth;"
                           "var maxwidth=%f;" //缩放系数
                           "for(i=0;i <document.images.length;i++){"
                           "myimg = document.images[i];"
                           "if(myimg.width > maxwidth){"
                           "oldwidth = myimg.width;"
                           "myimg.width = maxwidth;"
                           "}"
                           "}"
                           "}\";"
                           "document.getElementsByTagName('head')[0].appendChild(script);",[UIScreen mainScreen].bounds.size.width-10];
    [webView stringByEvaluatingJavaScriptFromString:webString];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    [ProgressHUD dismiss];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error   {
    [ProgressHUD dismiss];
    XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"网络开小差了" withContent:@"刷新试试？" WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
    alert.delegate =self;
    [alert show];
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
