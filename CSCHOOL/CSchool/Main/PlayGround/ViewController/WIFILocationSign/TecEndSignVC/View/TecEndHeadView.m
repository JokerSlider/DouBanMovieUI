//
//  TecEndHeadView.m
//  CSchool
//
//  Created by mac on 17/6/29.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "TecEndHeadView.h"
#import "UIView+SDAutoLayout.h"
@implementation TecEndHeadView
{
    UILabel *_duePeoNum;
    UILabel *_actualPeoNum;//实到人数
    UILabel *_leavePeoNum;//请假人数
    UILabel *_ratePeoNum;//缺勤人数
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
//
-(void)createView
{
    self.backgroundColor = RGB(247, 247, 247);
    _duePeoNum =({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(40, 40, 40);
//        view.text = 
        view;
    });
    
    _actualPeoNum =({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(40, 40, 40);
        view;
    });
    
    _leavePeoNum =({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(40, 40, 40);
        view;
    });
    
    _ratePeoNum =({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(40, 40, 40);
        view;
    });

    [self sd_addSubviews:@[_duePeoNum,_actualPeoNum,_leavePeoNum,_ratePeoNum]];
     
    _duePeoNum.sd_layout.leftSpaceToView(self,44).topSpaceToView(self,15).widthIs(100).heightIs(15);
    _actualPeoNum.sd_layout.rightSpaceToView(self,44).topSpaceToView(self,15).widthIs(100).heightIs(15);
    _leavePeoNum.sd_layout.leftEqualToView(_duePeoNum).topSpaceToView(_duePeoNum,12).widthIs(100).heightIs(15);
    _ratePeoNum.sd_layout.rightEqualToView(_actualPeoNum).topEqualToView(_leavePeoNum).widthIs(100).heightIs(15);

}
-(void)setModel:(WIFICellModel *)model
{
    _model = model;
    _duePeoNum.text =[NSString stringWithFormat:@"应到人数: %@人",model.yd_count];
    _actualPeoNum.text =[NSString stringWithFormat:@"实到人数:%@人",model.sd_count];
    _leavePeoNum.text =[NSString stringWithFormat:@"请假人数:%@人",model.qj_count];
    _ratePeoNum.text = [NSString stringWithFormat:@"缺勤人数:%@人", model.wd_count];
    
    CGSize size = [_duePeoNum boundingRectWithSize:CGSizeMake(0, 15)];
    _duePeoNum.sd_layout.widthIs(size.width);
    size = [_actualPeoNum boundingRectWithSize:CGSizeMake(0, 15)];
    _actualPeoNum.sd_layout.widthIs(size.width);
    size = [_leavePeoNum boundingRectWithSize:CGSizeMake(0, 15)];
    _leavePeoNum.sd_layout.widthIs(size.width);
    size = [_ratePeoNum boundingRectWithSize:CGSizeMake(0, 15)];
    _ratePeoNum.sd_layout.widthIs(size.width);
}
@end
