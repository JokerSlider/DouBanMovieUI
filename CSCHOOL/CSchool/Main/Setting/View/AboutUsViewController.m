//
//  AboutUsViewController.m
//  CSchool
//
//  Created by mac on 16/2/3.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "AboutUsViewController.h"
#import "XGAlertView.h"

@interface AboutUsViewController ()<UIWebViewDelegate ,XGAlertViewDelegate>

@end

@implementation AboutUsViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
     self.webView.scalesPageToFit = YES;
    self.webView.delegate=self;
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self loadString:self.baseUrl];
    });
}
-(void)loadFIle
{
    [self.webView loadHTMLString:self.baseUrl baseURL:nil];
}
- (void)loadString:(NSString *)str
{
    NSString *urlStr = str;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
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
                           "myimg.height = myimg.height * (maxwidth/oldwidth);"
                           "}"
                           "}"
                           "}\";"
                           "document.getElementsByTagName('head')[0].appendChild(script);",[UIScreen mainScreen].bounds.size.width-15];
    [webView stringByEvaluatingJavaScriptFromString:webString];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    self.navigationItem.title = [self.webView  stringByEvaluatingJavaScriptFromString:@"document.title"];
    [ProgressHUD dismiss];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error   {
    [ProgressHUD dismiss];
//    XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"网络开小差了" withContent:@"刷新试试？" WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
//    alert.tag = 0;
//    alert.delegate =self;
//    [alert show];

}
#pragma XgAlrtDelete
- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title;
{
    if (view.tag==0) {
        [self loadString:self.baseUrl];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
