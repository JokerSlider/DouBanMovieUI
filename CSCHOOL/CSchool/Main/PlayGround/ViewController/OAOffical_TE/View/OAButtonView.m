//
//  OAButtonView.m
//  CSchool
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OAButtonView.h"
#import "UIView+SDAutoLayout.h"
#import "LY_CircleButton.h"
#import "YLButton.h"
#import "UIView+UIViewController.h"
#import "MyOAProcedureController.h"
#import "OAProdureInfoController.h"
@implementation OAButtonView
{
    YLButton *_funcBtn;

    LY_CircleButton *_badgeV;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)createView
{
    _funcBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    _funcBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_funcBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _funcBtn.imageRect = CGRectMake(25, 0, 30, 30);
    _funcBtn.titleRect = CGRectMake(0, 35, 80, 20);
    _funcBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _funcBtn.frame = CGRectMake(0, 0, 80, 60);

    [_funcBtn addTarget:self action:@selector(openVC:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_funcBtn];
    
    _badgeV  = [[LY_CircleButton alloc]initWithFrame:CGRectMake(_funcBtn.frame.size.width, _funcBtn.frame.origin.y-10, 8, 8)];
    _badgeV.maxDistance = 30;
    [_badgeV setBackgroundColor:[UIColor redColor]];
    _badgeV.layer.cornerRadius = _badgeV.bounds.size.width*0.5;
    _badgeV.titleLabel.font = [UIFont systemFontOfSize:9.0];
    [_badgeV setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _badgeV.layer.cornerRadius = _badgeV.bounds.size.height*0.5;
    _badgeV.layer.masksToBounds = YES;
    [_badgeV addButtonAction:^(id sender) {
        NSLog(@"点击了红色按钮!!!!!!");
        
    }];
    [self addSubview:_badgeV];
    _badgeV.sd_layout.leftSpaceToView(_funcBtn,-34).bottomSpaceToView(_funcBtn, -2).widthIs(16).heightIs(10);
    _badgeV.layer.cornerRadius = _badgeV.bounds.size.height*0.5;

}
-(void)setModel:(OAModel *)model
{
    _model = model;
    [_badgeV setTitle:model.badgeValue forState:UIControlStateNormal];
    if ([model.badgeValue integerValue]==0||model.badgeValue.length==0||![model.isNotice isEqualToString:@"1"]) {
        _badgeV.hidden = YES;
    }else if ([model.badgeValue intValue]>99) {
        _badgeV.sd_layout.widthIs(20).heightIs(10);
        [_badgeV setTitle:@"99+" forState:UIControlStateNormal];
    }else if ([model.badgeValue integerValue]<10){
        _badgeV.sd_layout.widthIs(13).heightIs(13);
        _badgeV.layer.cornerRadius = _badgeV.bounds.size.height*0.5;
    }

    
    switch ([model.tag intValue]) {
        case 101:
            model.imgName = @"OA_daiban";
            break;
        case 102:
            model.imgName = @"OA_guanli";
            break;
        case 103:
            model.imgName = @"OA_myOA";
            break;
            
        default:
            break;
    }
    
    [_funcBtn setTitle:model.title forState:UIControlStateNormal];
    [_funcBtn setImage:[UIImage imageNamed:model.imgName] forState:UIControlStateNormal];
    _funcBtn.tag = [model.tag integerValue];
}
-(void)openVC:(YLButton *)sender{
    NSLog(@"%ld",sender.tag);
    if (sender.tag == 101) {
        [self openShenpi];
    }else if (sender.tag == 103){
        [self openMyOffical];
    }else{
        [self openMyManagerVC];
    }
}
/*
 NSArray *titleArr = @[@"我发起的流程",@"我审批的流程",@"我管理的流程"];

 */
-(void)openMyManagerVC
{
    MyOAProcedureController   *vc = [[MyOAProcedureController alloc]init];
    vc.sliderName = @"我管理的流程";

    [self.viewController.navigationController  pushViewController:vc animated:YES];
}
//打开我的审批
-(void)openShenpi
{
    MyOAProcedureController   *vc = [[MyOAProcedureController alloc]init];
    vc.sliderName = @"我审批的流程";
    [self.viewController.navigationController  pushViewController:vc animated:YES];
}
//打开我的办公
-(void)openMyOffical
{
    MyOAProcedureController *vc = [[MyOAProcedureController alloc]init];
    vc.sliderName = @"我发起的流程";
    [self.viewController.navigationController pushViewController:vc animated:YES];
}


@end
