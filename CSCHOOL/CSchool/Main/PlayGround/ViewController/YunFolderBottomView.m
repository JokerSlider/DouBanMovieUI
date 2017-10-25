//
//  YunFolderBottomView.m
//  CSchool
//
//  Created by 左俊鑫 on 2017/6/2.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "YunFolderBottomView.h"
#import "SDAutoLayout.h"
#import "XGAlertView.h"
#import "XGWebDavManager.h"
#import "LEOWebDAVMakeCollectionRequest.h"
#import "LEOWebDAVClient.h"
#import "UIView+UIViewController.h"
#import "YunFolderViewController.h"
#import "XGWebDavUploadManager.h"

@implementation YunFolderBottomView
{
    UIButton *_leftButton;
    UIButton *_rightButton;
    LEOWebDAVClient *_currentClient;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];;
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:lineView];
    
    _leftButton = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [view setTitle:@"新建文件夹" forState:UIControlStateNormal];
        [view setTitleColor:Color_Black forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:15];
        view.sd_cornerRadius = @(5);
        view.layer.borderWidth = .5;
        view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        [view addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    _rightButton = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.titleLabel.font = [UIFont systemFontOfSize:15];
        [view setTitle:@"选定" forState:UIControlStateNormal];
        [view setTitleColor:Base_Orange forState:UIControlStateNormal];
        [view addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        view.sd_cornerRadius = @(5);
        view.layer.borderWidth = .5;
        view.layer.borderColor = Base_Orange.CGColor;
        view;
    });
    
    [self sd_addSubviews:@[_leftButton, _rightButton]];
    
    _leftButton.sd_layout
    .leftSpaceToView(self,10)
    .centerYEqualToView(self)
    .widthIs((kScreenWidth-25)/2)
    .heightIs(31);
    
    _rightButton.sd_layout
    .rightSpaceToView(self,10)
    .leftSpaceToView(_leftButton,10)
    .topEqualToView(_leftButton)
    .heightRatioToView(_leftButton,1)
    .widthRatioToView(_leftButton,1);
}

- (void)leftBtnAction:(UIButton *)sender{
    WEAKSELF;
    XGAlertView *alert = [[XGAlertView alloc] initWithTitle:@"请输入文件夹名称" withUnit:@"" click:^(NSString *index){
        NSString *newFolder=[[XGWebDavUploadManager shareUploadManager].currentPath stringByAppendingPathComponent:index];
        [weakSelf addMakeCollectionRequest:newFolder];
    }];
    alert.textField.keyboardType = UIKeyboardTypeDefault;
    alert.textField.placeholder = @"文件夹名称";
    //    [alert.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [alert show];
    
    if (_leftClickBlock) {
        _leftClickBlock();
    }
}

- (void)rightBtnAction:(UIButton *)sender{
    

    
    if (_rightClickBlock) {
        _rightClickBlock();
    }
}


- (void)setLeftButtonTitle:(NSString *)title{
    [_leftButton setTitle:title forState:UIControlStateNormal];
}

- (void)setRightButtonTitle:(NSString *)title{
    [_rightButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark 新建文件夹请求
-(void)setupClient
{
    
    _currentClient=[[LEOWebDAVClient alloc] initWithRootURL:[NSURL URLWithString:[XGWebDavManager sharWebDavmManager].url]
                                                andUserName:[XGWebDavManager sharWebDavmManager].userName
                                                andPassword:[XGWebDavManager sharWebDavmManager].password];
}

-(void)addMakeCollectionRequest:(NSString *)newName
{
    if (_currentClient==nil) {
        [self setupClient];
    }
    LEOWebDAVMakeCollectionRequest *makeCollectionReq=[[LEOWebDAVMakeCollectionRequest alloc] initWithPath:newName];
    [makeCollectionReq setDelegate:self];
    
    [_currentClient enqueueRequest:makeCollectionReq];
}

#pragma mark - LEOWebDAV delegate
- (void)request:(LEOWebDAVRequest *)aRequest didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",[error description]);
    [ProgressHUD showError:[error description] Interaction:YES];
}

- (void)request:(LEOWebDAVRequest *)aRequest didSucceedWithResult:(id)result
{
    YunFolderViewController *vc = (YunFolderViewController *)self.viewController;
    [vc reloadData];
}

@end
