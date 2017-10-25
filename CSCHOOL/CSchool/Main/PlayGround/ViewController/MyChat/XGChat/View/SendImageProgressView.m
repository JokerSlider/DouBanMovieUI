//
//  SendImageProgressView.m
//  CSchool
//
//  Created by mac on 17/8/25.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "SendImageProgressView.h"
#import "UIView+SDAutoLayout.h"

@implementation SendImageProgressView
{
    UILabel *_noticeL;
}

+ (SendImageProgressView *)shared
{
    static dispatch_once_t once = 0;
    static SendImageProgressView *progressHUD;
    dispatch_once(&once, ^{ progressHUD = [[SendImageProgressView alloc] init]; });
    return progressHUD;
}

- (id)init
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    [self createNoticeView];
    return self;
}

-(void)createNoticeView
{
    self.backgroundColor = RGB_Alpha(60, 174, 255, 0.8);//RGB(230,120,12)RGB(60, 174, 255)

    _noticeL = ({
        UILabel *view = [UILabel new];
        view.textColor = [UIColor whiteColor];
        view.font = [UIFont systemFontOfSize:11];
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });
    [self addSubview:_noticeL];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeAlert:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
    _noticeL.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).widthIs(kScreenWidth).heightIs(25);
}
#pragma mark - 移除提示框
- (void)removeAlertSelf:(NSString *)word{
    _noticeL.text = word;

    [UIView transitionWithView:self duration:2 options:0 animations:^{
        self .center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2,-25);
    } completion:^(BOOL finished) {
        [self  removeFromSuperview];
    }];
}
-(void)showView:(NSString *)word onView:(UIView *)superView
{
    [superView addSubview:self];
    _noticeL.text = word;
    self.frame = CGRectMake(0,-25,[UIScreen mainScreen].bounds.size.width, 25);
    [UIView transitionWithView:self duration:0.25 options:0 animations:^{
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2,25/2);
    } completion:^(BOOL finished) {
        
    }];

}
-(void)showProgress:(NSString *)word{
    _noticeL.text = word;
}
+(void)show:(NSString *)word onView:(UIView *)superView{
    [[self shared] showView:word onView:superView];

}
+(void)removeAlert:(NSString *)word{
    [[self shared] removeAlertSelf:word];
}

+(void)showString:(NSString *)word{
    [[self shared]showProgress:word];
}


@end
