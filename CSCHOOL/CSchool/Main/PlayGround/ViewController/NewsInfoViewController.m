//
//  NewsInfoViewController.m
//  CSchool
//
//  Created by mac on 16/6/29.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "NewsInfoViewController.h"
#import "UIView+SDAutoLayout.h"
#import "UILabel+stringFrame.h"
@interface NewsInfoViewController ()<UIWebViewDelegate,XGAlertViewDelegate>
{
    UIView *_topView;
    NSString *_REDIRECT_URL;
}
@property (nonatomic,strong) UILabel *authorNameL;
@property (nonatomic,strong) UILabel *news_sourceL;
@property (nonatomic,strong) UILabel *infoTitleLabeL;
@property (strong, nonatomic)  UIWebView *newsWebView;

@end

@implementation NewsInfoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loaNewsInfodData];
    [self createView];
}
/**
 *  创建视图
 */
-(void)createView
{
    UILabel *authorL;
    UILabel *sourceL;
    
    authorL = ({
        UILabel *label = [UILabel new];
        label.text = @"作者:";
        label.font = Title_Font;
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = Color_Gray;
        label;
    });
    sourceL = ({
        UILabel *label = [UILabel new];
        label.text = @"来源:";
        label.font = Title_Font;
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = Color_Gray;
        label;
    });
    _topView =({
        UIView *view = [UIView new];
        view.backgroundColor = self.view.backgroundColor;
        view;
    });
    _authorNameL = ({
        UILabel *label = [UILabel new];
        label.font = Title_Font;
        label.textColor = Color_Gray;
        label.text = @"加载中...";
        label.textAlignment = NSTextAlignmentLeft;
        label;
    });
    _news_sourceL = ({
        UILabel *label = [UILabel new];
        label.font = Title_Font;
        label.textColor = Color_Gray;
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [NSString stringWithFormat:@"暂无 %@",_newsinfotime];
        label;
    });
    _infoTitleLabeL = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        [label setNumberOfLines:0];
        label.textColor = [UIColor blackColor];
        label.text = _infoTitle;
        label;
    });
    _newsWebView=({
        _newsWebView = [UIWebView new];
        self.newsWebView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
        self.newsWebView.delegate=self;
        [_newsWebView sizeToFit];
        self.newsWebView.backgroundColor = [UIColor whiteColor];
        _newsWebView;
    });
    [self.view addSubview:_topView];
    [_topView addSubview:_authorNameL];
    [_topView addSubview:_news_sourceL];
    [_topView addSubview:authorL];
    [_topView addSubview:sourceL];
    [_topView addSubview: _infoTitleLabeL];
    [self.view addSubview:_newsWebView];
    //页面布局
    _topView.sd_layout.topSpaceToView(self.view,0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(90);
    _infoTitleLabeL.sd_layout.leftSpaceToView(_topView,5).topSpaceToView(_topView,5).rightSpaceToView(_topView,5).heightIs(60);
    
    authorL.sd_layout.leftSpaceToView(_topView,15).topSpaceToView(_infoTitleLabeL,0).widthIs(40).heightIs(20);
    _authorNameL.sd_layout.leftSpaceToView(authorL,0).topEqualToView(authorL).widthIs(90).heightIs(20).bottomSpaceToView(_topView,5).maxWidthIs(90);
    
    sourceL.sd_layout.leftSpaceToView(_authorNameL,10).topEqualToView(authorL).widthIs(40).heightIs(20);
    
    _news_sourceL.sd_layout.leftSpaceToView(sourceL,0).topEqualToView(authorL).heightIs(20).rightSpaceToView(_topView,5);
    
    _newsWebView.sd_layout.topSpaceToView(_topView,0).leftSpaceToView(self.view,5).rightSpaceToView(self.view,5).bottomSpaceToView(self.view,0);
}
/**
 *  加载数据
 */
-(void)loaNewsInfodData
{
    [ProgressHUD show:@"正在加载..."];
    WEAKSELF;
    AppUserIndex *user =[ AppUserIndex GetInstance];
    [NetworkCore requestPOST:user.API_URL parameters:@{@"rid":@"showNewsById",@"uid":_newsID} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject[@"data"];
        [ProgressHUD dismiss];
        if (dic[@"AUTHOR"]) {
            _authorNameL.text = [NSString stringWithFormat:@"%@",dic[@"AUTHOR"]];
            CGSize size=[_authorNameL boundingRectWithSize:CGSizeMake(0, 20)];
    
            _authorNameL.sd_layout.widthIs(size.width).maxWidthIs(90);

        }else{
            _authorNameL.text = [NSString stringWithFormat:@"暂无"];
        }
        if (dic[@"TREE_NODE_NAME"]) {
            _news_sourceL.text = [NSString stringWithFormat:@"%@   %@",dic[@"TREE_NODE_NAME"],_newsinfotime];
        }else{
            _news_sourceL.text = [NSString stringWithFormat:@"暂无  %@",_newsinfotime];
        }
        self.baseUrl =[dic objectForKey:@"NEWS_INFO"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [weakSelf  loadFIle];
        });
        //针对新闻详情是重定向的页面
        if ([dic[@"ISSETURL"]isEqualToString:@"1"]) {
            if (dic[@"REDIRECT_URL"]) {
                XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:[NSString stringWithFormat:@"将通过safari浏览器访问以下网站%@",dic[@"REDIRECT_URL"]]  WithCancelButtonTitle:@"确定访问" withOtherButton:@"取消访问"];
                alert.tag = 1001;
                alert.delegate = self;
                _REDIRECT_URL=dic[@"REDIRECT_URL"];
                [alert show];
            }else{
                [self showErrorViewLoadAgain:@"点击下方按钮重新加载!"];
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD show:[error objectForKey:@"msg"]];
        [self showErrorViewLoadAgain:[error objectForKey:@"msg"]];
        
    }];
}
#pragma mark 私有方法
-(void)loadData
{
    [self loaNewsInfodData];
}
#pragma XgAlrtDelete
- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title;
{
    if (view.tag==1000) {
        [self loadData];
    }else if (view.tag==1001){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_REDIRECT_URL]];
    }
}
-(void)loadFIle
{
    UIFont *font = [UIFont systemFontOfSize:16];

    NSString* htmlString = [NSString stringWithFormat:@"<span style=\"font-family: %@!important; font-size: %i\">%@</span>",
                            font.fontName,
                            (int) font.pointSize,
                            self.baseUrl];
    [self.newsWebView loadHTMLString:htmlString baseURL:nil];
}
- (void)loadString:(NSString *)str
{
    NSString *urlStr = str;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.newsWebView loadRequest:request];
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
                           "myimg.height = myimg.height * (maxwidth/oldwidth);"
                           "}"
                           "}"
                           "}\";"
                           "document.getElementsByTagName('head')[0].appendChild(script);",[UIScreen mainScreen].bounds.size.width-10];
    [webView stringByEvaluatingJavaScriptFromString:webString];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'"];//修改百分比即可
    
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
