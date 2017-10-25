
//
//  SuggesstionViewController.m
//  CSchool
//
//  Created by mac on 16/9/7.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "SuggesstionViewController.h"
#import "UIView+SDAutoLayout.h"
#import "JYZTextView.h"

@interface SuggesstionViewController ()<UITextViewDelegate,XGAlertViewDelegate>
{
    JYZTextView *_textView;
}
@property(nonatomic,strong )UIScrollView *mainScrollView;
@property(strong, nonatomic)UILabel * firNumLabel;
@property(nonatomic,copy)UITextField *phoneNumTxt;
@property (nonatomic,copy)UIButton *pushBtn;
@end

@implementation SuggesstionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];

}

-(void)createView
{
    self.view.backgroundColor = Base_Color2;
    self.navigationItem.title = @"意见与反馈";
    _mainScrollView = ({
        UIScrollView *view = [UIScrollView new];
        view.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
        view;
    });
    
    _textView = [[JYZTextView alloc]initWithFrame:CGRectMake(5, 10, kScreenWidth-10, 200)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:14.f];
    _textView.textColor = [UIColor blackColor];
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.tag = 1000;
    _textView.placeholder = @"亲，您遇到什么问题或有任何建议，请告知我们，我们倍感荣幸！(必填)";
    
   
    _phoneNumTxt = ({
        UITextField *view = [UITextField new];
        view.placeholder = @"请在这留下您的联系方式（选填）";
        view.borderStyle = UITextBorderStyleRoundedRect;
        view.font =Title_Font;
        view;
    });
    
    _pushBtn = ({
        UIButton *view  = [UIButton buttonWithType:UIButtonTypeCustom];
        view.backgroundColor = Base_Orange;
        view.layer.cornerRadius = 5;
        [view setTitle:@"确认提交" forState:UIControlStateNormal];
        [view addTarget:self action:@selector(pushMessage:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    [self.mainScrollView addSubview:_phoneNumTxt];
    [self.view addSubview:_mainScrollView];
    [self.mainScrollView addSubview:_textView];
    [self.mainScrollView addSubview:_pushBtn  ];
    _pushBtn.sd_layout.leftSpaceToView(self.mainScrollView,20).rightSpaceToView(self.mainScrollView,20 ).heightIs(40).topSpaceToView(_phoneNumTxt,50);
    _mainScrollView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    _phoneNumTxt.sd_layout.leftSpaceToView(self.mainScrollView,-5).topSpaceToView(_textView,10).rightSpaceToView(self.mainScrollView,-5).heightIs(50);
    _textView.sd_layout.leftSpaceToView(self.mainScrollView,-5).rightSpaceToView(self.mainScrollView,-5).heightIs(220).topSpaceToView(self.mainScrollView,0);
}
#pragma mark 私有方法
-(void)pushMessage:(UIButton *)sender
{
    AppUserIndex *user = [AppUserIndex GetInstance];
    if ([self isEmpty:_textView.text]) {
        [ProgressHUD showError:@"请输入您的意见与建议"];
        return;
    }
    [ProgressHUD show:@"正在提交..."];

    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL  parameters:@{@"content":_textView.text,@"phone":_phoneNumTxt.text,@"account":user.accountId,@"rid":@"addFeedbackInfo"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:responseObject[@"msg"] WithCancelButtonTitle:@"确定" withOtherButton:nil];
        alert.delegate =self;
        [alert show];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD show:@"非常感谢"];
    }];
}
/*@"检查文本是否全为空格"*/
- (BOOL) isEmpty:(NSString *) str {
    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}
#pragma mark xgalert
- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark textField的字数限制
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag==1000) {
        NSInteger wordCount = textView.text.length;
        self.firNumLabel.text = [NSString stringWithFormat:@"%ld/100",(long)wordCount];
    }
}
#pragma mark 超过100字不能输入
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.tag==1000) {
        if (range.location>=100)
        {
            return  NO;
        }
        else
        {
            return YES;
        }
        
    }
    return NO;
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
