//
//  FinanceStepViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/8/2.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "FinanceStepViewController.h"
#import "AutoFitWebView.h"
#import "SDAutoLayout.h"
#import "XGAlertView.h"
#import "FinanceAddViewController.h"
#import "UIButton+BackgroundColor.h"
#import "UIViewController+BackButtonHandler.h"

@interface FinanceStepViewController ()<UIWebViewDelegate>
{
    UIButton *_nextButton;
}

@property (weak, nonatomic) IBOutlet AutoFitWebView *mainWebView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger selIndex; //当前的坐标（第几部，0开始）
@end

@implementation FinanceStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    self.navigationItem.title = @"报销资料准备";
    [self creatViews];
    [self loadData];
}

-(BOOL)navigationShouldPopOnBackButton{
    //类目：点击返回键，所查看的步数不是第一步的话，则返回上一步，否则，返回上一个页面。
    if (_selIndex >0) {
        _selIndex--;
        [_mainWebView loadHtmlString:_dataArray[_selIndex][@"RSCONTENT"]];
        return NO;
    }
    return YES;
}

- (void)creatViews{
    
    
    _mainWebView.delegate = self;
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = Title_Font;
    cancelButton.backgroundColor = RGB(255,224,52);
    [cancelButton setBackgroundColor:RGB(242,205,0) forState:UIControlStateHighlighted];
    cancelButton.sd_cornerRadius = @(5);
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:cancelButton];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextButton.titleLabel.font = Title_Font;
    _nextButton.backgroundColor = Base_Orange;
    [_nextButton setBackgroundColor:RGB(213,116,11) forState:UIControlStateHighlighted];
    _nextButton.sd_cornerRadius = @(5);
    [_nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_nextButton];
    
    cancelButton.sd_layout
    .leftSpaceToView(_bottomView,10)
    .topSpaceToView(_bottomView,5)
    .widthIs(kScreenWidth/2-20)
    .heightIs(40);
    
    _nextButton.sd_layout
    .rightSpaceToView(_bottomView,10)
    .topSpaceToView(_bottomView,5)
    .widthIs(kScreenWidth/2-20)
    .heightIs(40);
}

- (void)loadData{
    NSLog(@"%@",_typeDic);
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getStandardBytypeid",@"typeid":_typeDic[@"RTID"]} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [self hiddenErrorView];
        _dataArray = responseObject[@"data"];
        if (_dataArray.count == 0) {
            [self showErrorView:responseObject[@"msg"] andImageName:nil];
            [self.view bringSubviewToFront:_bottomView];
        }else{
            if (_dataArray.count == 1) {
                [_nextButton setTitle:@"材料齐全，添加" forState:UIControlStateNormal];
                if (_isDetail) {
                    [_nextButton setTitle:@"完成" forState:UIControlStateNormal];
                }
            }
            [_mainWebView loadHtmlString:_dataArray[0][@"RSCONTENT"]];
        }
        _selIndex = 0;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];

    }];
}

- (void)nextButtonAction:(UIButton *)sender{
    
    _selIndex++;
    if (_selIndex<_dataArray.count) {
        [_mainWebView loadHtmlString:_dataArray[_selIndex][@"RSCONTENT"]];
        
        if (_selIndex == _dataArray.count-1) {
            [_nextButton setTitle:@"材料齐全，添加" forState:UIControlStateNormal];
            if (_isDetail) {
                [_nextButton setTitle:@"完成" forState:UIControlStateNormal];
            }
        }
        
    }else{
        
        if (_isDetail) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        _selIndex--;
        XGAlertView *alert = [[XGAlertView alloc] initWithTitle:@"请输入票据的张数" withUnit:@"张" click:^(NSString *index) {
            
            if ((index.length <1)|| [index integerValue]<1) {
                [ProgressHUD showError:@"请输入大于0的数字"];
                return ;
            }
            
            if ([index integerValue] > 10000) {
                [ProgressHUD showError:@"票据数量过多！"];
                return ;
            }
            
            
            //时间过长不予处理
            if (([index intValue] * [_typeDic[@"RTPROCESSINGTIME"] intValue]) > 120) {
                XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"当前票据数量过多，请到窗口进行办理。" WithCancelButtonTitle:@"确定" withOtherButton:nil];
                [alert show];
                return;
            }
            
            
            NSString *indexString = [NSString stringWithFormat:@"%ld",[index integerValue]];
            BOOL isFind = NO;
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([[vc class] isEqual:[FinanceAddViewController class]]) {
                    isFind = YES;
        
                    FinanceAddViewController *finanVc = (FinanceAddViewController *)vc;
                    
                    [finanVc addNewDataDic:@{@"RTNAME":_typeDic[@"RTNAME"],@"RRNUMBER":indexString, @"RTID":_typeDic[@"RTID"], @"RTPROCESSINGTIME":_typeDic[@"RTPROCESSINGTIME"]}];
                    [self.navigationController popToViewController:vc animated:NO];
                }
            }
            
            if (!isFind) {
                FinanceAddViewController *vc = [[FinanceAddViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                [vc addNewDataDic:@{@"RTNAME":_typeDic[@"RTNAME"],@"RRNUMBER":indexString, @"RTID":_typeDic[@"RTID"], @"RTPROCESSINGTIME":_typeDic[@"RTPROCESSINGTIME"]}];
            }
            
        }];
        [alert show];
    }
 
}

- (void)cancelButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
