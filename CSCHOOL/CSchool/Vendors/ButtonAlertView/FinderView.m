//
//  FinderView.m
//  CPopView
//
//  Created by mac on 17/1/10.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "FinderView.h"
#import "LY_CircleButton.h"
#import "UIView+SDAutoLayout.h"
//#define marginX 30 //左右边距
//#define marginY 40 //上下间距
//#define Row     55 //水平间距
@implementation FinderView
{
    LY_CircleButton *_badgeV;
    NSMutableArray *_bgdgeViewArr;//角标数组
}

-(instancetype)initWithFrame:(CGRect)frame andImageArr:(NSArray *)images
{
    if (self = [super initWithFrame:frame]) {
        [self loadView:images];
        self.backgroundColor = RGB(198, 198, 198);
        self.layer.cornerRadius = 7;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleFuncMessage:) name:AllFunctionNotication object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeAllFunction:) name:RemoveFunctionNotication object:nil];

    }
    return self;
}
-(void)loadView:(NSArray *)imgs
{
    _bgdgeViewArr = [NSMutableArray array];
    CGFloat Width = self.frame.size.width;
    CGFloat marginX = 5;//左右边距
    CGFloat marginY = 5; //上下间距
    CGFloat Row    =5;//水平间距
    CGFloat itemW  = (Width-2*Row-marginX*2)/3.0;
    CGFloat itemH =  (Width-2*Row-marginX*2)/3.0;
    NSInteger minCount = imgs.count;
    if (imgs.count>9) {
        minCount = 9;
    }
    for (int i=0 ; i<minCount; i++) {
        UIView *item = [[UIView alloc] init];
        item.frame = CGRectMake(marginX +(Row+itemW)*(i%3), (itemH+marginY)*(i/3)+6, itemW, itemH);
        
        [self addSubview:item];
        UIImageView *img = [UIImageView new ];
        NSDictionary *imageDic = imgs[i];
        NSInteger iconId = [imageDic[@"ai_id"] integerValue]-1;
        AppUserIndex *user = [AppUserIndex GetInstance];
       


        _badgeV =  [[LY_CircleButton alloc]initWithFrame:CGRectMake(img.frame.origin.x+10+img.frame.size.width, img.frame.origin.y, 5, 5)];
        _badgeV.maxDistance = 30;
        _badgeV.hidden = YES;
        [_badgeV setTitle:@"" forState:UIControlStateNormal];
        [_badgeV setBackgroundColor:[UIColor redColor]];
        _badgeV.layer.cornerRadius = _badgeV.bounds.size.width*0.5;
        _badgeV.titleLabel.font = [UIFont systemFontOfSize:9.0];
        [_badgeV setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _badgeV.layer.cornerRadius = _badgeV.bounds.size.height*0.5;
        _badgeV.layer.masksToBounds = YES;
        _badgeV.tag = iconId;
        [_badgeV addButtonAction:^(id sender) {
            NSLog(@"点击了红色按钮!!!!!!");
            
        }];
        [item  addSubview:_badgeV];

        if (user.iconIDArray.count > iconId) {
 
#ifdef isNewVer
            img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_new",user.iconIDArray[iconId]]];
#else
            img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",user.iconIDArray[iconId]]];
#endif
        }
        img.frame = CGRectMake(0, 0, itemW-2, itemW-2);
        img.layer.masksToBounds = YES;
        img.layer.cornerRadius = (itemW-2)/2;
        [item addSubview:img];
    
        [_bgdgeViewArr addObject:_badgeV];
        
    }
}
#pragma mark 处理全功能图
//处理全功能推送
-(void)handleFuncMessage:(NSNotification*)note
{
    NSDictionary *dict=[note object];
    if (dict==nil) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        for (LY_CircleButton *view in _bgdgeViewArr) {
            if (view.tag == [dict[@"funcID"] intValue]) {
                [_badgeV setTitle:@"" forState:UIControlStateNormal];
                view.hidden = NO;
                view.opaque = YES;
                
            }
        }
        
    });
    
}
#pragma mark   移除全功能角标
-(void)removeAllFunction:(NSNotification*)note
{
    NSDictionary *dict=[note object];
    dispatch_async(dispatch_get_main_queue(), ^{
        for (LY_CircleButton *view in _bgdgeViewArr) {
            if (view.tag == [dict[@"funcID"] intValue]) {
                view.hidden = YES;
                view.opaque = NO;
                [self layoutSubviews];
            }
        }
    });
}
@end
