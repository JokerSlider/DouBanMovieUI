//
//  IdCodeView.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/13.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "IdCodeView.h"
#import "UIView+SDAutoLayout.h"
#import <UIImageView+WebCache.h>
#import "BaseGMT.h"
#import <JSONKit.h>
#import "NetworkCore.h"
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface IdCodeView()<UITextFieldDelegate>

@end

@implementation IdCodeView
{
    
    UIButton *_statusBtn;
    UIImageView *_idCodeImageView;
    UIButton *_changeBtn;
    UIActivityIndicatorView *_activity;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    [self setup];
}

- (void)setup{
//    self.width = LayoutWidthCGFloat(310);
//    self.height = 30;
    self.backgroundColor = [UIColor whiteColor];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(CodeTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:_textField];
    [center addObserver:self selector:@selector(CodetextFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:_textField];
    [center addObserver:self selector:@selector(CodetextFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:_textField];
    
    
    _contentView = [[UIView alloc] init];
    _contentView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _contentView.layer.cornerRadius = 5;
    _contentView.layer.borderWidth = 1;
    [self addSubview:_contentView];
    
    _textField = ({
        UITextField *view = [UITextField new];
        view.delegate = self;
        [view setAutocorrectionType:UITextAutocorrectionTypeNo];
        [view setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        view.keyboardType = UIKeyboardTypeASCIICapable;
//        view.borderStyle = UITextBorderStyleRoundedRect;
        view;
    });
    
    _statusBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"cs_errorView1"] forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"cs_correctView"] forState:UIControlStateSelected];
        [view addTarget:self action:@selector(clearText:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    _activity = ({
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];;
        view.hidden = YES;
        [view setHidesWhenStopped:YES];
        view;
    });
    
    _idCodeImageView = ({
        UIImageView *view = [UIImageView new];
//        [view sd_setImageWithURL:URL_IdCodeImage];
        view;
    });
    
    _changeBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeSystem];
        [view setTitle:@"换一个" forState:UIControlStateNormal];
        [view setTitleColor:Title_Color1 forState:UIControlStateNormal];
        view.titleLabel.font = Title_Font;
        [view addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    [_contentView addSubview:_textField];
    [_contentView addSubview:_statusBtn];
    [_contentView addSubview:_activity];
    [self addSubview:_idCodeImageView];
    [self addSubview:_changeBtn];

    _changeBtn.sd_layout
    .rightSpaceToView(self,0)
    .topSpaceToView(self,0)
    .widthIs(LayoutWidthCGFloat(60))
    .heightRatioToView(self,1);
    
    _idCodeImageView.sd_layout
    .rightSpaceToView(_changeBtn,5)
    .topEqualToView(_changeBtn)
    .widthIs(LayoutWidthCGFloat(60))
    .heightRatioToView(self,1);
    
    _contentView.sd_layout
    .leftSpaceToView(self,0)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0)
    .rightSpaceToView(_idCodeImageView,5);

    _textField.sd_layout
    .leftSpaceToView(_contentView,10)
    .topSpaceToView(_contentView,0)
    .bottomSpaceToView(_contentView,0)
    .rightSpaceToView(_statusBtn,5);

    _statusBtn.sd_layout
    .rightSpaceToView(_contentView,10)
    .widthIs(20)
    .heightIs(20)
    .centerYEqualToView(_contentView);

    _activity.sd_layout
    .rightEqualToView(_statusBtn)
    .centerYEqualToView(_statusBtn)
    .widthRatioToView(_statusBtn,1)
    .heightRatioToView(_statusBtn,1);
    
    [self changeImageAction:nil];
    
    _statusBtn.hidden = YES;
}

- (void)CodeTextFieldDidChange:(NSNotification *)notice{
    if (![notice.object isEqual:_textField]) {
        return;
    }
    if ([_textField.text length]<4) {
        [_activity stopAnimating];
        _activity.hidden = YES;
//        _statusBtn.hidden = NO;
        _statusBtn.selected = NO;
        _statusBtn.userInteractionEnabled = YES;
    }
    if ([_textField.text length] == 4) {
//        [_textField resignFirstResponder];
        [self checkIdCode];
    }
    
}

- (void)CodetextFieldDidBeginEditing:(NSNotification *)notice{
    if (![notice.object isEqual:_textField]) {
        return;
    }
    if (!_notAuto) {
        [UIView animateWithDuration:.3 animations:^{
            self.superview.centerY -= 50;
        }];
    }
}

- (void)CodetextFieldDidEndEditing:(NSNotification *)notice{
    if (![notice.object isEqual:_textField]) {
        return;
    }
    if (!_notAuto) {
        [UIView animateWithDuration:.3 animations:^{
            self.superview.centerY += 50;
        }];
    }
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSCharacterSet *cs;
//    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
//    
//    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
//    
//    BOOL canChange = [string isEqualToString:filtered];
//    
//    return self.textField.text.length>=5?NO: canChange;
//    
//}

//校验验证码****************
- (void)checkIdCode{
    
    _activity.hidden = NO;
    [_activity startAnimating];
    _statusBtn.hidden = YES;
    
    //向服务器发送一个post
    NSString *check = [NSString stringWithFormat:@"%@",self.textField.text];
    
    NSString *rid = @"validateChkNum";
    
    NSDictionary *params = @{
                             @"rid" :rid,
                             @"chkNum" : check,
                             };
    
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"msg"] isEqualToString:@"成功匹配验证码"]) {
            //验证成功
            [_activity stopAnimating];
            _statusBtn.hidden = NO;
            _statusBtn.selected = YES;
            _statusBtn.userInteractionEnabled = NO;
            _textField.userInteractionEnabled = NO;
            if (_delegate && [_delegate respondsToSelector:@selector(idCodeView:didInputSuccessCode:)]) {
                [_delegate idCodeView:self didInputSuccessCode:_textField.text];
            }
        }else{
            [_activity stopAnimating];
            _statusBtn.hidden = NO;
            _statusBtn.selected = NO;
            _statusBtn.userInteractionEnabled = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [_activity stopAnimating];
        _statusBtn.hidden = NO;
        _statusBtn.selected = NO;
        _statusBtn.userInteractionEnabled = YES;
    }];
    
}

- (void)changeImageAction:(UIButton *)sender{
    
//    NSString *urlString = [NSString stringWithFormat:@"%@?rid=%@",[AppUserIndex GetInstance].API_URL,string];
    
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    UIImage *image = [[UIImage alloc] initWithData:data];
//    [_idCodeImageView setImage:image];
    if (self.delegate && [self.delegate respondsToSelector:@selector(idCodeView:didChangeCode:)]) {
        [self.delegate idCodeView:self didChangeCode:@""];
    }
    
    _textField.userInteractionEnabled = YES;
    _textField.text = @"";
    _activity.hidden = YES;
//    _statusBtn.hidden = NO;
    _statusBtn.selected = NO;
    _statusBtn.userInteractionEnabled = YES;
    _statusBtn.hidden = YES;
    
    AppUserIndex *app = [AppUserIndex GetInstance];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSString *urlString = [NSString stringWithFormat:@"%@?rid=getChkNum&schoolCode=%@&clientOSType=ios&clientVerNum=%@",app.API_URL,app.schoolCode,[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data!=NULL) {
            UIImage *image = [[UIImage alloc] initWithData:data];
            
            [_idCodeImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
            
        }
    });

}

- (void)clearText:(UIButton *)sender{
    _statusBtn.hidden = YES;
    _textField.text = @"";
}

@end
