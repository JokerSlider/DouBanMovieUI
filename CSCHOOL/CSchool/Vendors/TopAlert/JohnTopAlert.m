//
//  JohnTopAlert.m
//  顶部提示框
//
//  Created by YuanQuanTech on 2016/11/11.
//  Copyright © 2016年 John Lai. All rights reserved.
//

#import "JohnTopAlert.h"
#import "UIView+UIViewController.h"
#import "YYText.h"
#import "XMNChatTextParser.h"
#import "XGExpressionManager.h"
#import "HQXMPPChatRoomManager.h"
#import "ValidateObject.h"
//#define Height  64+30
//#define addHeight  40

@interface JohnTopAlert ()

@property (nonatomic,strong) UILabel *alertLB;

@property (nonatomic,weak) UIImageView *pointIMGV;

@property (nonatomic,weak) YYLabel *pointLB;

@property (nonatomic,weak) UILabel *pointLA;//小标题

@property (nonatomic,assign)int  height;

@property (nonatomic,assign)int addHeight;
@end

@implementation JohnTopAlert

- (instancetype)init{
    if (self = [super init]) {
        if ([[ValidateObject getDeviceName] isEqualToString:@"iPhone X"]) {
            self.height =64+30;
            self.addHeight = 40;
        }else{
            self.height =64;
            self.addHeight = 0;
        }
        
        self.frame = CGRectMake(0, -64,[UIScreen mainScreen].bounds.size.width, self.height);
        [UIView transitionWithView:self duration:0.25 options:0 animations:^{
            self.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2,32);
        } completion:^(BOOL finished) {
            [self performSelector:@selector(removeAlert) withObject:nil afterDelay:self.alertShowTime];
        }];

        [self createAlert];
        [self addGesture];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];

    }
    return self;
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeAlert];
    
}
#pragma mark 添加上滑手势
-(void)addGesture
{
    UISwipeGestureRecognizer *swipeGestureRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [self addGestureRecognizer:swipeGestureRecognizer];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [self addGestureRecognizer:singleTapGestureRecognizer];

}
#pragma mark 处理手势
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    [self removeAlert];
}
#pragma mark  点击手势
-(void)singleTap
{
    [self removeAlert];
    //点击弹窗点击手势
    if (self.delegate) {
        [self.delegate tapAlertViewBySingle];
    }
    
}
#pragma mark - 基础设置
- (void)createAlert{
    //设置提示图
    self.backgroundColor = RGB(0, 128, 255);
    UIImageView *alertIMGV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13+self.addHeight, 14, 14)];
    [self addSubview:alertIMGV];
    self.pointIMGV = alertIMGV;
    
    /*
    //设置提示信息
    YYLabel *alertMsg = [[YYLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(alertIMGV.frame) + 10, 20 +(self.frame.size.height - 20 - 42) / 2, self.frame.size.width - CGRectGetMaxX(alertIMGV.frame) - 30, 42)];
    alertMsg.textColor = [UIColor whiteColor];
    alertMsg.textAlignment = NSTextAlignmentLeft;
    alertMsg.font = [UIFont systemFontOfSize:14.0f];
    alertMsg.numberOfLines = 2;
    alertMsg.displaysAsynchronously = YES;
    alertMsg.lineBreakMode = NSLineBreakByWordWrapping;
    alertMsg.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:alertMsg];
    self.pointLB = alertMsg;
    //   提示  小标题
    UILabel *alertTitle  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(alertIMGV.frame)+14,10, self.frame.size.width - CGRectGetMaxX(alertIMGV.frame) - 30, 20)];
    alertTitle.textColor = [UIColor whiteColor];
    alertTitle.textAlignment = NSTextAlignmentLeft;
    alertTitle.font = [UIFont systemFontOfSize:12.0f];
    alertTitle.numberOfLines =1;
    [self addSubview:alertTitle];
    self.pointLA = alertTitle;
    //解析表情
    XMNChatTextParser *parser = [[XMNChatTextParser alloc] init];
    parser.emoticonMapper = [XGExpressionManager sharedManager].nomarImageMapper;
    parser.emotionSize = CGSizeMake(18.f, 18.f);
    parser.alignFont = [UIFont systemFontOfSize:16.f];
    parser.alignment = YYTextVerticalAlignmentBottom;
    self.pointLB.textParser = parser;
    */
    //设置提示信息
    YYLabel *alertMsg = [[YYLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(alertIMGV.frame) + 14, 18+self.addHeight, self.frame.size.width - CGRectGetMaxX(alertIMGV.frame) - 30, 42)];
    alertMsg.textColor = [UIColor whiteColor];
    alertMsg.textAlignment = NSTextAlignmentLeft;
    alertMsg.font = [UIFont systemFontOfSize:14.0f];
    alertMsg.numberOfLines = 2;
    alertMsg.displaysAsynchronously = YES;
    alertMsg.lineBreakMode = NSLineBreakByWordWrapping;
    alertMsg.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:alertMsg];
    self.pointLB = alertMsg;
    //   提示  小标题
    UILabel *alertTitle  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(alertIMGV.frame)+14,10+self.addHeight, self.frame.size.width - CGRectGetMaxX(alertIMGV.frame) - 30, 20)];
    alertTitle.textColor = [UIColor whiteColor];
    alertTitle.textAlignment = NSTextAlignmentLeft;
    alertTitle.font = [UIFont systemFontOfSize:13.0f];
    alertTitle.numberOfLines =1;
    [self addSubview:alertTitle];
    self.pointLA = alertTitle;
    //解析表情
    XMNChatTextParser *parser = [[XMNChatTextParser alloc] init];
    parser.emoticonMapper = [XGExpressionManager sharedManager].nomarImageMapper;
    parser.emotionSize = CGSizeMake(18.f, 18.f);
    parser.alignFont = [UIFont systemFontOfSize:16.f];
    parser.alignment = YYTextVerticalAlignmentBottom;
    self.pointLB.textParser = parser;
    

    
}

#pragma mark - 根据外部调用个性化显示
- (void)setAlertBgColor:(UIColor *)alertBgColor{
    self.backgroundColor = alertBgColor;
}
#pragma mark  -  调整字颜色
-(void)setAlertTextColor:(UIColor *)alertTextColor
{
    _alertTextColor = alertTextColor;
    self.pointLA.textColor = _alertTextColor;
    self.pointLB.textColor = _alertTextColor;
}
- (void)showAlertMessage:(NSString *)msg andTitle:(NSString *)title alertType:(MessageType)type{
    //设置textView 解析表情
  
    self.pointLB.text = msg;
    self.pointLA.text = title;
    if ([title isEqualToString:@""]) {
        CGRect frame = CGRectMake(10, 20 +(self.frame.size.height - 40)/ 2+self.addHeight , 20, 20);
        self.pointIMGV.frame = frame;
    }
    if (type == SuccessAlert) {
        self.pointIMGV.image = [UIImage imageNamed:@"bannertips_success"];
    }
    if (type == FailedAlert) {
        self.pointIMGV.image = [UIImage imageNamed:@"bannertips_warning"];
    }
}

#pragma mark -  展示提示框
- (void)alertShow{
    [UIView animateWithDuration:1.0f
                          delay:0
         usingSpringWithDamping:0.3f
          initialSpringVelocity:6.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.center = CGPointMake(self.center.x, 32);
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark - 移除提示框
- (void)removeAlert{
    [UIView transitionWithView:self duration:0.25 options:0 animations:^{
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2,-32);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
