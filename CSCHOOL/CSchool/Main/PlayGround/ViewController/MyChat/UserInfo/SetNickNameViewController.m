//
//  SetNickNameViewController.m
//  CSchool
//
//  Created by mac on 17/3/4.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "SetNickNameViewController.h"
#import "UIView+SDAutoLayout.h"
#import "HQXMPPManager.h"
#import "UIView+UIViewController.h"
#import "NSString+HTML.h"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@interface SetNickNameViewController ()
@property (nonatomic,strong)UITextField *noteTxtInputV;
@property (nonatomic,strong)UIScrollView *mainScrollview;

@end

@implementation SetNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
}
-(void)createView
{
    UIButton *sendRequest = [UIButton buttonWithType:UIButtonTypeCustom];
    sendRequest.frame = CGRectMake(0, 0, 40, 30);
    [sendRequest addTarget:self action:@selector(sendRequest:) forControlEvents:UIControlEventTouchUpInside];
    [sendRequest setTitle:@"完成" forState:UIControlStateNormal];
    [sendRequest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *customBar = [[UIBarButtonItem alloc]initWithCustomView:sendRequest];
    self.navigationItem.rightBarButtonItem = customBar;

    
    self.title = @"详细资料";
    self.view.backgroundColor = Base_Color2;
    self.mainScrollview  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.mainScrollview];
    UIView *footerView =({
        UIView *view  = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    UILabel *setNoticeL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.text = @"为朋友设置备注";
        view.textColor = RGB(153, 153, 153);
        view;
    });
    _noteTxtInputV = ({
        UITextField *view = [UITextField new];
        view.placeholder = @"备注名";
        view.font = [UIFont systemFontOfSize:12.0];
        view.textColor = RGB(85, 85, 85);
        view.borderStyle = UITextBorderStyleNone;
        view.returnKeyType = UIReturnKeyDone;
        view;
    });
    
    UIView *secLineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.userInteractionEnabled = YES;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = Color_Gray.CGColor;
        view;
    });
    UIView *lastLine = ({
        UIView *view = [UIView new];
        view.backgroundColor = RGB(219, 219, 219);
        view.userInteractionEnabled = YES;
        view;
    });
    [self.mainScrollview  addSubview:footerView];
    footerView.sd_layout.leftSpaceToView(self.mainScrollview,0).rightSpaceToView(self.mainScrollview,0).topSpaceToView(self.mainScrollview,0).bottomSpaceToView(self.mainScrollview,0);
    [footerView sd_addSubviews:@[setNoticeL,secLineView,lastLine]];
    [secLineView addSubview:_noteTxtInputV];
    setNoticeL.sd_layout.leftSpaceToView(footerView,0).topSpaceToView(footerView,50).widthIs(120).heightIs(14);
    secLineView.sd_layout.leftSpaceToView(footerView,-5).topSpaceToView(setNoticeL,20).widthIs(kScreenWidth+10).heightIs(32);
    _noteTxtInputV.sd_layout.leftSpaceToView(secLineView,10).topSpaceToView (secLineView,1).widthIs(kScreenWidth+10).heightIs(30);
//    lastLine.sd_layout.leftSpaceToView(footerView,0).topSpaceToView(secLineView,30).widthIs(kScreenWidth).heightIs(1);

}
-(void)sendRequest:(UIButton *)sender
{
    if (_noteTxtInputV.text.length == 0) {
        [JohnAlertManager showFailedAlert:@"请输入备注！" andTitle:@"提示"];
        return;
    }  //发送好友请求
    
    if ([self stringContainsEmoji:_noteTxtInputV.text]) {
        [JohnAlertManager showFailedAlert:@"暂不支持表情，请重新设置" andTitle:@"提示"];
        
        return;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSArray *groupArray  = [NSArray array];
        NSString *groupName =self.groupName?self.groupName:@"我的好友";
        groupName = [groupName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        groupArray = @[groupName];

        NSString *nickName = _noteTxtInputV.text ;

        [[HQXMPPManager shareXMPPManager].roster addUser:_jid withNickname:nickName groups:groupArray subscribeToPresence:NO];
        if (_setNickNameSucessBlock) {
            _setNickNameSucessBlock(_noteTxtInputV.text);
        }
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];

    });
}

#pragma mark 检查是否有表情
- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    return returnValue;
}
#pragma clang diagnostic pop

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
