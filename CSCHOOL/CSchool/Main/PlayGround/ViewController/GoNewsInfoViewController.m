//
//  GoNewsInfoViewController.m
//  CSchool
//
//  Created by mac on 17/1/21.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "GoNewsInfoViewController.h"

@interface GoNewsInfoViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@end

@implementation GoNewsInfoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Base_Color2;
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.webView.scalesPageToFit = YES;
    [self.webView sizeToFit];
    [self.view addSubview:self.webView];
    
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
    self.webView.delegate=self;
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
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error   {
    [ProgressHUD dismiss];
    
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
