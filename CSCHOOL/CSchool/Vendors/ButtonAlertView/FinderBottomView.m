//
//  FinderBottomView.m
//  CPopView
//
//  Created by mac on 17/1/10.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "FinderBottomView.h"
#import "UIView+SDAutoLayout.h"
#import "UILabel+stringFrame.h"
#import "FinderView.h"
#import "ButtonAlertView.h"
#import "UIView+UIViewController.h"
//#import <QuartzCore/QuartzCore>
#define  ItewW  60

@interface  FinderBottomView() <ButtonAlertViewSelectDelegate>
@property (nonatomic,strong) NSArray *dataArray;//
@property (nonatomic,assign) int     selectFInderIndex;//选择的文件夹
@end
@implementation FinderBottomView

-(instancetype)initWithFrame:(CGRect)frame withIconArr:(NSArray *)dataArr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self loadViewFindernumIconDicArr:dataArr];
        _dataArray = dataArr;
        [self addShadowView];

    }
    return self;
}
-(void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
}
-(void)addShadowView
{
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];  //按钮边缘颜色
    self.layer.shadowColor = [UIColor blackColor].CGColor; //按钮阴影颜色
    self.layer.shadowOffset = CGSizeMake(0,3); //按钮阴影偏移量
    self.layer.shadowOpacity = 1.5; // 阴影的透明度，默认是0   范围 0-1 越大越不透明}
}
//加载视图  //文件夹的数量  每个文件夹中图标的数量  标题名称

-(void)loadViewFindernumIconDicArr:(NSArray *)iconArr{
    CGFloat margin = 5;
    UIScrollView *mainScroView = [UIScrollView new];
    [self addSubview:mainScroView];
    mainScroView.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).topSpaceToView(self,0).bottomSpaceToView(self,0);
        for (int i = 0 ; i< iconArr.count; i++) {
        
        NSDictionary *fileDic = iconArr[i];
        
        UIView *item = [[UIView alloc] init];
        item.frame = CGRectMake((25+65)*i+20, 10, ItewW, ItewW+12);
        if (iconArr.count==1) {
            item.frame = CGRectMake((kScreenWidth-ItewW)/2, 10, ItewW, ItewW+12);
        }
        [mainScroView addSubview:item];
        //底部标签
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, ItewW+margin, ItewW, 12)];
        label.text = fileDic[@"ag_name"];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = Color_Gray ;
        [item addSubview:label];
        //UILabel 宽度自适应
        CGSize  size = [label boundingRectWithSize:CGSizeMake(0, 12)];
        label.sd_layout.widthIs(size.width);
            NSArray *iconmuArr =fileDic[@"sds_coded"];

            FinderView *img = [[FinderView alloc ]initWithFrame:CGRectMake(0, margin, ItewW, ItewW)andImageArr:iconmuArr];
            img.layer.masksToBounds = YES;
            [item addSubview:img];
            label.sd_layout.centerXIs(img.centerX);
            [mainScroView setupAutoContentSizeWithRightView:item rightMargin:15];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = item.bounds;
            button.tag =1000+i;
            //弹出的对应item的点击事件
            [button addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [item addSubview:button];
    }
}

-(void)itemBtnClick:(UIButton *)sender
{
    int index = (int)(sender.tag-1000);
    _selectFInderIndex = index;
    NSDictionary *fileDic = _dataArray[index];
    NSArray *iconmuArr =fileDic[@"sds_coded"];
    UIWindow *window  = [UIApplication sharedApplication].keyWindow;
    ButtonAlertView *popView = [[ButtonAlertView alloc]initWithwithIconArr:iconmuArr];
    popView.fileName = fileDic[@"ag_name"];
    [window addSubview:popView];
    popView.delegate = self;
    AppUserIndex *user = [AppUserIndex GetInstance];
    if (user.funcMsgArr.count>0) {
        for (NSDictionary *dic in user.funcMsgArr) {
            if ([dic[@"msgNum"] isEqualToString:@"remove"]) {
                NSNotification *allFuncNote = [[NSNotification alloc]initWithName:RemoveFunctionNotication object:dic userInfo:nil];
                [popView removeAllFunction:allFuncNote];
            }else{
                NSNotification *allFuncNote = [[NSNotification alloc]initWithName:AllFunctionNotication object:dic userInfo:nil];
                [popView handleFuncMessage:allFuncNote];

            }
        }
    }
    
    [popView show];

}
#pragma mark 打开已经打开的文件夹
-(void)openFinderViewSelected
{
    NSDictionary *fileDic = _dataArray[_selectFInderIndex];
    NSArray *iconmuArr =fileDic[@"sds_coded"];
    UIWindow *window  = [UIApplication sharedApplication].keyWindow;
    ButtonAlertView *popView = [[ButtonAlertView alloc]initWithwithIconArr:iconmuArr];
    popView.fileName = fileDic[@"ag_name"];
    [window addSubview:popView];
    popView.delegate = self;
    AppUserIndex *user = [AppUserIndex GetInstance];
    if (user.funcMsgArr.count>0) {
        for (NSDictionary *dic in user.funcMsgArr) {
            if ([dic[@"msgNum"] isEqualToString:@"remove"]) {
                NSNotification *allFuncNote = [[NSNotification alloc]initWithName:RemoveFunctionNotication object:dic userInfo:nil];
                [popView removeAllFunction:allFuncNote];
            }else{
                NSNotification *allFuncNote = [[NSNotification alloc]initWithName:AllFunctionNotication object:dic userInfo:nil];
                [popView handleFuncMessage:allFuncNote];
                
            }
        }
    }
    [popView show];
}

#pragma ButtonAlertViewDelegate
-(void)itemDidSelected:(UIButton *)sender
{
    if (self.delegate) {
        self.isOpen = YES;
        [self.delegate itemDidSelectedIconSlectIndex:sender];
    }
    
}
-(void)dissFromSuperMainScroView
{
    if (self.delegate) {
        self.isOpen = NO;
    }
}

@end
