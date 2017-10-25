//
//  SendMessageView.m
//  CSchool
//
//  Created by mac on 17/3/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "SendMessageView.h"
#import "UIView+SDAutoLayout.h"
@interface    SendMessageView()<UITextFieldDelegate>
@end
@implementation SendMessageView
{
    UITextField *_mainTxt;
    UIButton    *_sendMsg;//发送弹幕按钮
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void)createView
{
    self.backgroundColor =RGB_Alpha(255, 255, 255, 0.4);
//    [UIColor colorWithRed:255 green:255 blue:255 alpha:0.4];
    self.userInteractionEnabled = YES;
    _mainTxt = ({
        UITextField *view = [UITextField new];
        view.returnKeyType = UIReturnKeySend;//变为搜索按钮
        view.delegate = self;
        view.borderStyle = UITextBorderStyleNone;
        view.layer.cornerRadius = 2.0;
        view.layer.borderColor = RGB(156, 156, 156).CGColor;
        view.clipsToBounds = YES;
        view.backgroundColor = RGB_Alpha(255, 255, 255, 0.4);
        UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.origin.x,view.frame.origin.y,10.0, view.frame.size.height)];
        view.leftView = blankView;
        view.leftViewMode =UITextFieldViewModeAlways;
        view;
    });
    _sendMsg = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"发送" forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
       NSMutableParagraphStyle *style = [_mainTxt.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    style.minimumLineHeight = _mainTxt.font.lineHeight - (_mainTxt.font.lineHeight - [UIFont systemFontOfSize:14.0].lineHeight) /2.0;
    _mainTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 在这说点什么吧..."
                                                                 attributes:@{
                                                                              NSForegroundColorAttributeName: RGB(96, 96, 96),
                                                                              NSFontAttributeName : [UIFont systemFontOfSize:12.0],
                                                                              NSParagraphStyleAttributeName : style
                                                                              }];

    [self sd_addSubviews:@[_mainTxt,_sendMsg]];
    _sendMsg.sd_layout.rightSpaceToView(self,13).topSpaceToView(self,13).widthIs(30).heightIs(15);
    _mainTxt.sd_layout.leftSpaceToView(self,10).heightIs(30).bottomSpaceToView(self,5).rightSpaceToView(_sendMsg,6);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification" object:_mainTxt];
}
#pragma mark 发送消息
-(void)sendMessage:(UIButton *)sendr
{
    if (_mainTxt.text.length==0) {
        [ProgressHUD showError:@"请输入内容后发送!"];
        return ;
    }else if (_mainTxt.text.length)
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL  parameters:@{@"rid":@"sendBarrageMsg",@"userid":[AppUserIndex GetInstance].role_id,@"content":_mainTxt.text} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if (_sendDanMuMessageSuccessblock) {
            _sendDanMuMessageSuccessblock(_mainTxt.text);
        }
        _mainTxt.text  = @"";
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [JohnAlertManager showFailedAlert:@"发送弹幕失败!" andTitle:@"错误"];
    }];
}
#pragma mark  TextViewDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMessage:nil];
    return YES;
}
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > 20)
        {
            
            [ProgressHUD showError:@"最多输入20个字!"];
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:20];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:20];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 20)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:_mainTxt];
}
@end
