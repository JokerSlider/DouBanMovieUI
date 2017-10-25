//
//  OfficalInfoViewController.m
//  CSchool
//
//  Created by mac on 16/9/8.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "JobMessageInfoViewController.h"
#import "UIView+SDAutoLayout.h"
#import "JhtLoadDocViewController.h"
#import "UILabel+stringFrame.h"
#import "JobRecuritCell.h"
#define cellHeight 40
@interface JobMessageInfoViewController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,XGAlertViewDelegate>
{
    NSString *_REDIRECT_URL;
    NSMutableArray *fileNameArr;//附件数组
    NSArray *fileArr;//附件名
    UIView *topView;
    
}
@property (nonatomic,strong)UILabel *titleLabel;//标题
@property (nonatomic,strong)UILabel *deparMentLbel;//发布部门
@property (nonatomic,strong)UILabel *timeLabel;//时间
@property (strong, nonatomic)  UIWebView *newsWebView;
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,copy)NSString *baseUrl;

@end

@implementation JobMessageInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createView];
    [self loadData];
    [self addObserverForWebViewContentSize];
}

-(void)createView
{
    self.navigationItem.title = @"详情";
    
    topView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    _titleLabel = ({
        UILabel *view = [UILabel new];
        view.text = @"标题:";
        view.numberOfLines =0;
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });
    _newsWebView=({
        UIWebView *view = [UIWebView new];
        view.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
        view.delegate=self;
        [view sizeToFit];
        view.backgroundColor = [UIColor whiteColor];
        view.scrollView.contentInset = UIEdgeInsetsMake(110, 0, 0, 0);
        view;
    });
    _mainTableView = ({
        UITableView *view = [UITableView new];
        view.delegate =self;
        view.dataSource =self;
        view.tableFooterView = [UIView new];
        view;
    });
    _deparMentLbel= ({
        UILabel *view = [UILabel new];
        view.text = @"发布部门:";
        view.textAlignment = NSTextAlignmentLeft;
        view.textColor = Color_Gray;
        view.font = Title_Font;
        view;
    });
    _timeLabel = ({
        UILabel *view = [UILabel new];
        view.text = @"发布时间:";
        view.textAlignment = NSTextAlignmentLeft;
        view.textColor = Color_Gray;
        view.font = Title_Font;
        view;
    });
    
    
    [topView sd_addSubviews:@[_timeLabel,_titleLabel,_deparMentLbel]];
    [self.view sd_addSubviews:@[_newsWebView]];
    [_newsWebView.scrollView addSubview:topView];
    topView.sd_layout.leftSpaceToView(_newsWebView.scrollView,0).heightIs(110).widthIs(kScreenWidth).topSpaceToView(_newsWebView.scrollView,-110);
    
    _titleLabel.sd_layout.leftSpaceToView(topView,10).topSpaceToView(topView,15).widthIs(kScreenWidth-10).autoHeightRatio(0);
    _deparMentLbel.sd_layout.leftEqualToView(_titleLabel).topSpaceToView(_titleLabel,20).widthIs((kScreenWidth-20)/2).heightIs(30);
    _timeLabel.sd_layout.leftSpaceToView(_deparMentLbel,0).topEqualToView(_deparMentLbel).widthIs((kScreenWidth-20)/2).heightIs(30);
    
    _newsWebView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
}
-(void)loadData
{
    fileNameArr = [NSMutableArray array];
    fileArr = [NSMutableArray array];
    [ProgressHUD show:@"正在加载..."];
    WEAKSELF;
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL   parameters:@{@"rid":@"showRecruitInfoById",@"uid":_newsID} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSArray *countArr = responseObject[@"data"];
        if (countArr.count==0) {
            [self showErrorViewLoadAgain:@"暂无详情信息"];
            return ;
        }
        JobModel *model=[[JobModel alloc]init];
        [model yy_modelSetWithDictionary:responseObject[@"data"]];

        self.baseUrl = model.content;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [weakSelf  loadFIle];
        });
        _titleLabel.text = model.jobTitle;
        _timeLabel.text  =[NSString stringWithFormat:@"发布时间:%@",model.jobTime];
        _deparMentLbel.text =[NSString stringWithFormat:@"发布部门:%@",model.releaseDepart];
        fileArr =responseObject[@"attchment"];
        if (fileArr.count!=0) {
            for (NSDictionary *dic in fileArr) {
                [fileNameArr addObject:dic[@"attachName"]];
            }
        }
        [self.mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD show:[error objectForKey:@"msg"]];
        [self showErrorViewLoadAgain:[error objectForKey:@"msg"]];
        
    }];
    
}
//移除监听
-(void)dealloc
{
    [self removeObserverForWebViewContentSize ];
}
#pragma mark AddObservirw
- (void)addObserverForWebViewContentSize{
    [self.newsWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
}
- (void)removeObserverForWebViewContentSize{
    [self.newsWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self layoutCell];
}
//设置footerView的合理位置
- (void)layoutCell{
    //取消监听，因为这里会调整contentSize，避免无限递归
    [self removeObserverForWebViewContentSize];
    CGSize contentSize = self.newsWebView.scrollView.contentSize;
    _mainTableView.userInteractionEnabled = YES;
    _mainTableView.tag = 99999;
    _mainTableView.backgroundColor = [UIColor redColor];
    
    if ([self.baseUrl length] == 0) {
        contentSize = CGSizeMake(kScreenWidth, 100);
    }
    //没new的
    _mainTableView.frame = CGRectMake(0, contentSize.height, kScreenWidth, cellHeight*fileNameArr.count);
    [self.newsWebView.scrollView addSubview:_mainTableView];
    self.newsWebView.scrollView.contentSize = CGSizeMake(contentSize.width,cellHeight*fileNameArr.count+contentSize.height);
    [self addObserverForWebViewContentSize];
}

//解决分割线不到左边界的问题
-(void)viewDidLayoutSubviews {
    if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.mainTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark UITableViewDelegateOrDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fileArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idef = @"offciceReleaseInfoCell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idef];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:idef];
    }
    cell.textLabel.font = Small_TitleFont;
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.text =fileNameArr[indexPath.row];
    cell.textLabel.numberOfLines=0;
    cell.backgroundColor = Base_Color2;
    cell.imageView.image = [UIImage imageNamed:@"fujian"];
    cell.imageView.contentMode = UIViewContentModeCenter;
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return cellHeight;
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //添加打开第三方附件---添加附件连接
    //    fileArr
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *url =fileArr[indexPath.row][@"attachAddress"];
    url =[url stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([url isEqualToString:@""]||[url isEqual:[NSNull null]]) {
        [ProgressHUD show:@"链接文件不存在"];
        return;
    }
    
    JhtFileModel *fileModel = [[JhtFileModel alloc] init];
    fileModel.fileId = fileArr[indexPath.row][@"attachId"];
    fileModel.vFileName = fileArr[indexPath.row][@"attachName"];
    fileModel.url = url;
    fileModel.fileName = fileArr[indexPath.row][@"attachName"];
    fileModel.vFileId = fileArr[indexPath.row][@"attachId"];
    fileModel.contentType = @"application/octet-stream";
    NSArray  * array= [url componentsSeparatedByString:@"."];
    fileModel.fileType = [array lastObject];
    
    JhtLoadDocViewController *load = [[JhtLoadDocViewController alloc] init];
    JhtFileModel *model = fileModel;
    load.titleStr = model.fileName;
    load.currentFileModel = model;
    [self.navigationController pushViewController:load animated:YES];
}
#pragma mark 私有方法
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
    [self.newsWebView loadHTMLString:self.baseUrl baseURL:nil];
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

#pragma marr webViewDataSource

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '85%'"];//修改百分比即可
    [ProgressHUD dismiss];
    
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error   {
    [ProgressHUD dismiss];
    
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
