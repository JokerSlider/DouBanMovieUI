//
//  WebViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/6/21.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UINavigationBarDelegate,XGAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    _mainWebView.backgroundColor = [UIColor whiteColor];
    _mainWebView.scalesPageToFit = YES;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self loadString:_requestUrl];
        
    });

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)backAction:(UIButton *)sender {
    //返回按钮，如果网页可以返回上一级，则返回，否则页面消失pop回去
    if ([_mainWebView canGoBack]) {
      [_mainWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)loadString:(NSString *)str
{
    // 1. URL 定位资源,需要资源的地址
    NSString *urlStr = str;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. 发送请求给服务器
    [_mainWebView loadRequest:request];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    [ProgressHUD dismiss];
    
    
}
#pragma UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [ProgressHUD show:@"正在加载"];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    _titleLabel.text = [_mainWebView  stringByEvaluatingJavaScriptFromString:@"document.title"];
//    self.title = [self.mainWebView  stringByEvaluatingJavaScriptFromString:@"document.title"];
    [ProgressHUD dismiss];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error   {
    
    [ProgressHUD dismiss];
    XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"网络开小差了" withContent:@"刷新试试？" WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
    alert.delegate =self;
    [alert show];

}
#pragma XgAlrtDelete
- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title;
{
    if ([title isEqualToString:@"网络开小差了"]) {
        [self loadString:_requestUrl];
        
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
