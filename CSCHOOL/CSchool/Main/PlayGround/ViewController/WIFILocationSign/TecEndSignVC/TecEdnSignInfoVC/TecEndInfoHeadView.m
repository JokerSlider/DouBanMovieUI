//
//  TecEndInfoHeadView.m
//  CSchool
//
//  Created by mac on 17/6/29.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "TecEndInfoHeadView.h"
#import "UIView+SDAutoLayout.h"
@implementation TecEndInfoHeadView
{
    UILabel *_stuNum;
    UILabel *_stuName;
    UILabel *_className;
    UILabel *_courseName;
    UILabel *_totalL;
    
    UILabel *_duePeoNum;//出勤人数
    UILabel *_actualPeoNum;//缺勤人数
    UILabel *_leavePeoNum;//迟到人数
    UILabel *_ratePeoNum;//请假人数
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
    _stuNum = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(85, 85, 85);
//        view.
        view;
    });
    _stuName = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(85, 85, 85);
        //        view.
        view;
    });
    _className = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(85, 85, 85);
        //        view.
        view;
    });
    _courseName = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(85, 85, 85);
        //        view.
        view;
    });
    _totalL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(85, 85, 85);
        view.text = @"出勤统计:";
        view;
    });
    _duePeoNum = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(85, 85, 85);
        //        view.
        view;
    });
    _actualPeoNum = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(85, 85, 85);
        //        view.
        view;
    });
    _leavePeoNum = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(85, 85, 85);
        //        view.
        view;
    });
    _ratePeoNum = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(85, 85, 85);
        //        view.
        view;
    });
    [self sd_addSubviews:@[_stuNum,_stuName,_className,_courseName,_totalL,_duePeoNum,_actualPeoNum,_leavePeoNum,_ratePeoNum]];
    
    _stuNum.sd_layout.leftSpaceToView(self,15).topSpaceToView(self,28).heightIs(15).rightSpaceToView(self,0);
    _stuName.sd_layout.leftSpaceToView(self,15).topSpaceToView(_stuNum,28).heightIs(15).rightSpaceToView(self,0);
    _className.sd_layout.leftSpaceToView(self,15).topSpaceToView(_stuName,28).heightIs(15).rightSpaceToView(self,0);
    _courseName.sd_layout.leftSpaceToView(self,15).topSpaceToView(_className,28).heightIs(15).rightSpaceToView(self,0);
    CGSize size = [_totalL boundingRectWithSize:CGSizeMake(0, 12)];
    _totalL.sd_layout.leftSpaceToView(self,15).topSpaceToView(_courseName,28).heightIs(15).widthIs(size.width);
    
    //出勤
    _duePeoNum.sd_layout.leftSpaceToView(_totalL,15).topEqualToView(_totalL).widthIs(50).heightIs(15);
    _actualPeoNum.sd_layout.leftSpaceToView(_duePeoNum,15).topEqualToView(_totalL).widthIs(50).heightIs(15);
    _leavePeoNum.sd_layout.leftSpaceToView(_actualPeoNum,15).topEqualToView(_totalL).widthIs(50).heightIs(15);
    _ratePeoNum.sd_layout.leftSpaceToView(_leavePeoNum,15).topEqualToView(_totalL).widthIs(50).heightIs(15);
    
}
-(void)setModel:(WIFICellModel *)model
{
    _model = model;
    _stuNum.text = [NSString stringWithFormat:@"学号:         %@",model.yhbh];
    _stuName.text = [NSString stringWithFormat:@"姓名:         %@",model.xm];
    _className.text = [NSString stringWithFormat:@"班级:         %@",model.bjm ];
    _courseName.text = [NSString stringWithFormat:@"课程:         %@",model.kcmc ];
    
    _duePeoNum.text = [NSString stringWithFormat:@"出勤(%@)",model.ok_count];
    _actualPeoNum.text = [NSString stringWithFormat:@"缺勤(%@)",model.no_count];
    _leavePeoNum.text = [NSString stringWithFormat:@"补签(%@)",model.bq_count];
//    _ratePeoNum.text = [NSString stringWithFormat:@"请假(%@)",model.ratePeoNum];
    
    CGSize size = [_duePeoNum boundingRectWithSize:CGSizeMake(0, 15)];
    _duePeoNum.sd_layout.widthIs(size.width);
    size =  [_actualPeoNum boundingRectWithSize:CGSizeMake(0, 15)];
    _actualPeoNum.sd_layout.widthIs(size.width);
    size = [_leavePeoNum boundingRectWithSize:CGSizeMake(0, 15)];
    _leavePeoNum.sd_layout.widthIs(size.width);
    size = [_ratePeoNum boundingRectWithSize:CGSizeMake(0, 15)];
    _ratePeoNum.sd_layout.widthIs(size.width);
    

}
@end
