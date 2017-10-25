//
//  AutoFitWebView.m
//  CSchool
//
//  Created by 左俊鑫 on 16/8/2.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "AutoFitWebView.h"

@interface AutoFitWebView ()<UIWebViewDelegate>
@end

@implementation AutoFitWebView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)loadHtmlString:(NSString *)htmlStr{
    
//    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
//    self.scalesPageToFit=YES;
    
//    self.multipleTouchEnabled=YES;
    
//    self.userInteractionEnabled=YES;
    
    [ProgressHUD show:nil];
    //加载请求的时候忽略缓存
//   NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];//缓存处理
    
    [self loadHTMLString:htmlStr baseURL:nil];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //拦截网页图片  并修改图片大小
    NSString *webString = [NSString stringWithFormat:@"var script = document.createElement('script');"
                           "script.type = 'text/javascript';"
                           "script.text = \"function ResizeImages() { "
                           "var myimg,oldwidth,oldheight;"
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
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (_getTitleBlock) {
        _getTitleBlock(theTitle);
    }
    [ProgressHUD dismiss];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
