  //
//  AutoWebViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/8/17.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "AutoWebViewController.h"
#import "AutoFitWebView.h"

@interface AutoWebViewController ()
@property (nonatomic, strong) AutoFitWebView *mainWebView;
@end

@implementation AutoWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
//        self.navigationItem.title = @"这里是标题";
    if (_commitDic) {
        [self loadData];
    }

}

- (void)loadData{
    WEAKSELF;
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:_commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject valueForKeyPath:_valueForKeyPath ]) {
            [weakSelf loadHtmlString:[responseObject valueForKeyPath:_valueForKeyPath ]];
            if (_titleForKeyPath) {
                weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:_titleForKeyPath]];
            }
        }else{
//            [self showErrorView:@"还没有数据呢。"];
            [weakSelf showErrorView:@"还没有数据呢。" andImageName:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];

    }];
}

- (void)createViews{
    WEAKSELF;
    _mainWebView = [[AutoFitWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    _mainWebView.getTitleBlock = ^(NSString *title){
        if (title.length > 0) {
            weakSelf.navigationItem.title = title;
        }
    };
    [self.view addSubview:_mainWebView];
}

- (void)loadHtmlString:(NSString *)htmlStr{
    if ([htmlStr isKindOfClass:[NSString class]]) {
        [_mainWebView loadHtmlString:htmlStr];
    }else{
//        [self showErrorView:@"还没有数据呢。"];
        [self showErrorView:@"还没有数据呢。" andImageName:nil];

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
