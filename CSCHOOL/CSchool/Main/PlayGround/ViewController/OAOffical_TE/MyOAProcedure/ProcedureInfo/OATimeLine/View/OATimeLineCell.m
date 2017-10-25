
//
//  OATimeLineCell.m
//  CSchool
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OATimeLineCell.h"
#import "OAOwnCellView.h"
#import "NSDate+Extension.h"
#import "UIView+SDAutoLayout.h"
#import "UIColor+HexColor.h"
#import "WIFISIgnToolManager.h"
#import "UIColor+HexColor.h"
#import "ASProgressPopUpView.h"
@interface  OATimeLineCell()<ASProgressPopUpViewDataSource>
@end

@implementation OATimeLineCell
{
    OAOwnCellView *_timeL;
    OAOwnCellView *_pushPerson;//发起人// 或者是处理人
    OAOwnCellView *_nextPerson;//下一级处理人
    OAOwnCellView *_stateL;//状态
    OAOwnCellView *_suggesstionL;//审批意见
    OAOwnCellView *_recordTime;
    ASProgressPopUpView *_progressView;//进度条
    UILabel        *_noticeTimeL;//用时展示
    UILabel *_cicleL;//圆圈
    UIView *_lineView;//竖线
    
    UILabel *_newsNotice;//最新提示语
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}
//创建视图
-(void)createView
{
    _cicleL = ({
        UILabel *view = [UILabel new];
        view.layer.cornerRadius =23/2;
        view.clipsToBounds = YES;
        view.textAlignment = NSTextAlignmentCenter;
        view.backgroundColor =[UIColor clearColor];
        view.layer.borderColor =Base_Orange.CGColor;
        view.layer.borderWidth = 0.7;
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = Base_Orange;
        view;
    });
   _lineView = ({
        UIView *view = [UIView new];
        view.backgroundColor =Base_Color2;
        view;
    });
    _newsNotice = ({
        UILabel *view = [UILabel new];
        view.text = @"该流程有最新进展！";
        view.font = [UIFont systemFontOfSize:11.0];
        view.textColor = [UIColor redColor];
        view;
    });
    
    UIView *backView =({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor  = RGB(216, 198, 182).CGColor;
        view.layer.borderWidth = 1;
        view.layer.cornerRadius = 2;
        view;
    });
    [self.contentView sd_addSubviews:@[_cicleL,_lineView,backView,_newsNotice]];

    _cicleL.sd_layout.leftSpaceToView(self.contentView,13+3/2).topSpaceToView(self.contentView,5).widthIs(23).heightIs(23);
    _lineView.sd_layout.leftSpaceToView(self.contentView,26).topSpaceToView(_cicleL,6).bottomSpaceToView(self.contentView,3).widthIs(1.5);
    _newsNotice.sd_layout.leftSpaceToView(_cicleL,20).topSpaceToView(self.contentView,12.5).rightSpaceToView(self.contentView,0).heightIs(15);
    backView.sd_layout.leftSpaceToView(_lineView,20).topSpaceToView(_cicleL,10).rightSpaceToView(self.contentView,13);
    
    _progressView = ({
        ASProgressPopUpView *view = [[ASProgressPopUpView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-20-13)/4, 7)];
//        view.progressColor = [UIColor greenColor];
        view.progress = 0;
        view.font = [UIFont systemFontOfSize:11.0];
        view.popUpViewAnimatedColors = @[[UIColor greenColor]];
        view.dataSource = self;
        [view showPopUpViewAnimated:NO];
        view.backgroundColor = Base_Color2;
        view;
    });
    
    _noticeTimeL = ({
        UILabel *view = [UILabel new];
        view.textColor = Base_Orange;
        view.textAlignment = NSTextAlignmentRight;
        view.font = [UIFont systemFontOfSize:12.0];
        view;
    });
    _suggesstionL = [OAOwnCellView new];//意见
    _timeL     = [OAOwnCellView new];//发起时间
    _pushPerson= [OAOwnCellView new];//发起人// 或者是处理人
    _stateL    = [OAOwnCellView new];//状态
    _nextPerson = [OAOwnCellView new];//下一级处理人
    _recordTime = [OAOwnCellView new];//处理处理用时
    _timeL.titleColor = _pushPerson.titleColor = _stateL.titleColor = _nextPerson.titleColor = _recordTime.titleColor = Color_Gray;
    _suggesstionL.titleColor = [UIColor redColor];
    
    [backView sd_addSubviews:@[_suggesstionL,_timeL,_pushPerson,_stateL,_nextPerson,_suggesstionL,_recordTime,_progressView]];
    _timeL.sd_layout.leftSpaceToView(backView,0).topSpaceToView(backView,15/2).rightSpaceToView(backView,0).heightIs(12);
    _pushPerson.sd_layout.leftSpaceToView(backView,0).topSpaceToView(_timeL,15/2).rightSpaceToView(backView,0).heightIs(12);
    _nextPerson.sd_layout.leftSpaceToView(backView,0).topSpaceToView(_pushPerson,15/2).rightSpaceToView(backView,0).heightIs(12);
    _recordTime.sd_layout.leftSpaceToView(backView,0).topSpaceToView(_nextPerson,15/2).widthIs(100).heightIs(12);//
    _stateL.sd_layout.leftSpaceToView(backView,0).topSpaceToView(_recordTime,15/2).rightSpaceToView(backView,0).heightIs(12);//
    _suggesstionL.sd_layout.leftSpaceToView(backView,0).topSpaceToView(_stateL,15/2).rightSpaceToView(backView,0).autoHeightRatio(0);
    _progressView.sd_layout.rightSpaceToView(backView,14).topSpaceToView(_nextPerson, 15).heightIs(7).widthIs((kScreenWidth-20-13)/4);
//    _noticeTimeL.sd_layout.rightEqualToView(_progressView).bottomSpaceToView(_progressView,2).widthIs(100).heightIs(10);
    [backView setupAutoHeightWithBottomView:_suggesstionL bottomMargin:17];
    [self setupAutoHeightWithBottomView:backView bottomMargin:5];
}
-(void)setModel:(OAModel *)model
{
    _model = model;

    _cicleL.text = model.cellNum;
    //最后一条数据
    if ([model.cellNum isEqualToString:model.totalCount]) {
        _lineView.hidden  = YES;
        _suggesstionL.titleColor = [UIColor redColor];//意见
        _timeL.titleColor = Color_Black;//发起时间
        _pushPerson.titleColor = Color_Black;//发起人// 或者是处理人
        _stateL   .titleColor =Color_Black;//状态
        _nextPerson .titleColor = Color_Black;//下一级处理人
        _recordTime.titleColor = Color_Black;//处理处理用时
        _newsNotice.hidden = NO;
    }else{
        _newsNotice.hidden = YES;
    

    }
    if ([model.cellNum isEqualToString:@"1"]) {
        model.title = @"发起人";
        model.subTitle =model.xm;
        model.imgName = @"OA_proceUser";
        _pushPerson.model = model;
        model.title = @"发起时间";
        model.subTitle  = [[WIFISIgnToolManager shareInstance]tranlateDateString:model.create_time withDateFormater:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ" andOutFormatter:@"yyyy-MM-dd HH:mm"];
        model.imgName = @"OA_time";
        _timeL.model = model;

    
    }else {
        NSLog(@"%@",model.create_time);
        model.title = @"处理人";
        model.subTitle = model.xm;
        model.imgName = @"OA_danqgianUser";
        _pushPerson.model = model;
        model.title = @"处理时间";
        model.subTitle  =[[WIFISIgnToolManager shareInstance]tranlateDateString:model.create_time withDateFormater:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ" andOutFormatter:@"yyyy-MM-dd HH:mm"];
        model.imgName = @"OA_time";
        _timeL.model = model;
      
    }
    
    if(![model.cellNum isEqualToString:model.totalCount]) {//&&![model.cellNum isEqualToString:@"1"]
        _cicleL.sd_layout.leftSpaceToView(self.contentView,13+11/2+1).topSpaceToView(self.contentView,5).widthIs(15).heightIs(15);
        _cicleL.font = [UIFont systemFontOfSize:10];
        _cicleL.layer.cornerRadius = 15/2;
        _cicleL.layer.borderColor =Color_Gray.CGColor;
        _cicleL.textColor = Color_Gray;
        [_cicleL updateLayout];
    }
    
    model.title = @"下级处理人";
    model.subTitle = model.users;
    model.imgName = @"OA_danqgianUser";
    _nextPerson.model = model;
    NSArray *stateArr = @[@"通过",@"不通过",@"退回",@"节点跳转",@"未知"];
    model.title = @"处理状态";
    int index =0;
    if (model.oh_state) {
        index = [model.oh_state intValue]-1;
    }else{
        index = 3;
    }
    if (index<0) {
        index=3;
    }
    model.subTitle = stateArr[index];
    model.imgName = @"OA_shenState";
    _stateL.model = model;
    
    model.title = @"处理用时";
    CGFloat  minute = [model.last_time floatValue];
    //3小时以内为绿色,3-8小时为黄色,8-12小时为橙色,12小时以上为红色
    _progressView.progress = minute/12.00;
    if (minute<=3.00) {
        _progressView.popUpViewAnimatedColors = @[[UIColor colorWithHexString:@"#1db702"]];

//        _progressView.progressColor = [UIColor colorWithHexString:@"#1db702"];
//        _noticeTimeL.textColor = [UIColor colorWithHexString:@"#1db702"];
    }else if (minute>3.00&&minute<=8.00){
        _progressView.popUpViewAnimatedColors = @[[UIColor colorWithHexString:@"#F7B824"]];
//
//        _progressView.progressColor = [UIColor colorWithHexString:@"#F7B824"];
//        _noticeTimeL.textColor =[UIColor colorWithHexString:@"#F7B824"];

    }else if (minute>8.00&&minute<=12){
        _progressView.popUpViewAnimatedColors = @[ [UIColor colorWithHexString:@"#FF5722"]];
//        _progressView.progressColor = [UIColor colorWithHexString:@"#FF5722"];

    }else{
        _progressView.popUpViewAnimatedColors = @[ [UIColor redColor]];
        if (minute>12&&minute<=24) {
            _progressView.progress = 0.85;
        }else if (minute>24&&minute<=72){
            _progressView.progress = 0.90;

        }else if (minute>=72){
            _progressView.progress = 0.98;
        }
    }
    model.subTitle = @"   ";//用进度条标示
    model.imgName = @"OA_time";
    
    _recordTime.model = model;
    
    model.title = @"审批意见";
    model.subTitle = model.oh_descrite?model.oh_descrite:@"无";
    model.imgName = @"index_OffRelease";
    _suggesstionL.model = model;
}
// <ASProgressPopUpViewDataSource> is entirely optional
// it allows you to supply custom NSStrings to ASProgressPopUpView
- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    CGFloat  minute = [_model.last_time floatValue];
    if (minute<1&&minute>0) {
        NSString *min = [NSString stringWithFormat:@"%0.1f",minute*60];
        NSLog(@"分钟时间--------------%@",min);
        return [NSString stringWithFormat:@"%@分钟",min];
    }
    return [NSString stringWithFormat:@"%d小时",(int)minute];
}

/* by default ASProgressPopUpView precalculates the largest popUpView size needed
 * it then uses this size for all values and maintains a consistent size
 * if you want the popUpView size to adapt as values change then return 'NO'
 */
- (BOOL)progressViewShouldPreCalculatePopUpViewSize:(ASProgressPopUpView *)progressView;
{
    return NO;
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
