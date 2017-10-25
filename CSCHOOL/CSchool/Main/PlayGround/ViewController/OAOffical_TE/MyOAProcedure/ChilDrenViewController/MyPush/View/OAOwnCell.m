//
//  OAOwnCell.m
//  CSchool
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OAOwnCell.h"
#import "OAOwnCellView.h"
#import "YLButton.h"
#import "UIView+SDAutoLayout.h"
#import "OAMonitorViewController.h"
#import "UIView+UIViewController.h"
#import "NSDate+Extension.h"
@implementation OAOwnCell
{
    OAOwnCellView *_dureNameL;
    OAOwnCellView *_timeL;//发起时间
    OAOwnCellView *_pushPerson;//发起人
    OAOwnCellView *_stateL;//状态
    OAOwnCellView *_wordShetSL;//状态

    OAOwnCellView *_currentPerson;
    
    YLButton      *_noticeL;//提示Lable;
    UIView        *_lineView;//横线
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    _dureNameL = [OAOwnCellView new];
    _timeL     = [OAOwnCellView new];
    _pushPerson= [OAOwnCellView new];
    _stateL    = [OAOwnCellView new];
    _currentPerson =[OAOwnCellView new];
    _wordShetSL = [OAOwnCellView new];//工单状态
    _noticeL = ({
        YLButton * view = [YLButton buttonWithType:UIButtonTypeCustom];
        view.titleLabel.font = [UIFont systemFontOfSize:11];
        [view setTitleColor:RGB(237, 120, 14) forState:UIControlStateNormal];
        view.enabled = NO;
        view.imageRect = CGRectMake(0, 3, 13, 13);
        view.titleRect = CGRectMake(25, 0, 300, 20);
        view.frame = CGRectMake(kScreenWidth * 0.5 - 80, 100, 300, 40);
        view;
    });
    _lineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = RGB(220, 220, 220);
        view;
    });
    
    UIView *contenView = self.contentView;
    
    [self.contentView sd_addSubviews:@[_dureNameL,_timeL,_pushPerson,_stateL,_currentPerson,_noticeL,_wordShetSL,_lineView]];
    _dureNameL.sd_layout.leftSpaceToView(contenView,0).topSpaceToView(contenView,16).rightSpaceToView(contenView,0).heightIs(14);
    
    _pushPerson.sd_layout.leftSpaceToView(contenView,0).topSpaceToView(_dureNameL,16).rightSpaceToView(contenView,0).heightIs(14);

    _currentPerson.sd_layout.leftSpaceToView(contenView,0).topSpaceToView(_pushPerson,16).rightSpaceToView(contenView,0).heightIs(14);

    _timeL.sd_layout.leftSpaceToView(contenView,0).topSpaceToView(_currentPerson,16).rightSpaceToView(contenView,0).heightIs(14);
    
    _stateL.sd_layout.leftSpaceToView(contenView,0).topSpaceToView(_timeL,16).rightSpaceToView(contenView,0).heightIs(14);
    
    _wordShetSL.sd_layout.leftSpaceToView(contenView,0).topSpaceToView(_stateL,16).rightSpaceToView(contenView,0).heightIs(14);

    _noticeL.sd_layout.leftSpaceToView(contenView,14).topSpaceToView(_wordShetSL,8).widthIs(100).heightIs(12);
    
    _lineView.sd_layout.leftSpaceToView(contenView,6).rightSpaceToView(contenView,6).heightIs(0.01).topSpaceToView(_noticeL,16);
    
    
    [self setupAutoHeightWithBottomView:_lineView bottomMargin:10];
}

#pragma mark
-(void)setModel:(OAModel *)model
{
    /*
     oi_id 工单编号
     fi_id流程编号
     fi_name流程名称
     node_id 当前节点编号
     ni_name 当前节点名称
     create_time申请时间
     oi_state 工单状态 0  暂存  1 未审批 2 审批中 3 审批完成 4 退回
     new_time 最新审批时间
     yhbh 用户编号
     xm  姓名
     spxm 审批人姓名
     sp_state 审批状态 1 待审批 2 已审批
     */
    _model = model;
    model.title = @"流程名称:";
    model.imgName = @"OA_proName";
    model.subTitle = model.fi_name;

    _dureNameL.model = model;
    model.title = @"发起时间:";
    model.imgName = @"OA_time";
    
    
    model.subTitle =[NSDate dateTranlateStringFromTimeString:model.create_time andformatterString:@"yyyy-MM-dd HH:mm"];
    _timeL.model = model;
    
    if ([model.segmentName isEqualToString:@"我发起的流程"]) {
        model.title = @"工单状态:";
        model.imgName = @"OA_gongdanState";
        NSArray *oi_stateArr = @[@"暂存",@"未审批",@"审批中",@"审批完成",@"退回"];
        int  index = [model.oi_state intValue];
        model.subTitle = oi_stateArr[index];
        _wordShetSL.model = model;
        
        model.title = @"审批状态:";
        model.imgName = @"OA_shenState";
        if ([model.sp_state isEqualToString:@"1"]) {
            model.subTitle = @"未审批";
        }else{
            model.subTitle = @"已审批";
        }
        _stateL.model = model;
        
        model.title = @"当前审批人:";
        model.imgName = @"OA_danqgianUser";
        model.subTitle = model.spxm.length!=0?model.spxm:@"无";
        _pushPerson.model = model;
        
        [_noticeL setImage:[UIImage imageNamed:@"OA_jinduNotice"] forState:UIControlStateNormal];
        [_noticeL setTitle:model.noticeWord forState:UIControlStateNormal];
        _currentPerson.sd_layout.heightRatioToView(_stateL,0);
        _timeL.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(_pushPerson,16).rightSpaceToView(self.contentView,0).heightIs(14);
        _noticeL.sd_layout.leftSpaceToView(self.contentView,14).topSpaceToView(_wordShetSL,0).widthIs(100).heightIs(12);
        [_timeL updateLayout];
        [_noticeL updateLayout];
        [_currentPerson updateLayout];
        if (model.noticeWord.length==0) {
            _noticeL.hidden = YES;
            _lineView.sd_layout.leftSpaceToView(self.contentView,6).rightSpaceToView(self.contentView,6).heightIs(0.01).topSpaceToView(_wordShetSL,10);
            [_lineView updateLayout];
        }
    }else if ([model.segmentName isEqualToString:@"我审批的流程"]){
        model.title = @"审批状态:";
        model.imgName = @"OA_shenState";
        if ([model.sp_state isEqualToString:@"1"]) {
            _stateL.titleColor = [UIColor redColor];
            model.subTitle = @"未审批";
        }else{
            _stateL.titleColor = Color_Black;
            model.subTitle = @"已审批";
        }
        
        _stateL.model = model;
        
        model.title = @"工单状态:";
        model.imgName = @"OA_gongdanState";
        NSArray *oi_stateArr = @[@"暂存",@"未审批",@"审批中",@"审批完成",@"退回"];
        int  index = [model.oi_state intValue];
        model.subTitle = oi_stateArr[index];
        _wordShetSL.model = model;

        
        model.title = @"流程发起人:";
        model.imgName = @"OA_proceUser";
        model.subTitle = model.xm;
        _pushPerson.model = model;
        if ([model.sp_state isEqualToString:@"1"]) {
            model.noticeWord = @"提示:请尽快对该流程进行审批！";
        }
        [_noticeL setImage:[UIImage imageNamed:@"OA_notice"] forState:UIControlStateNormal];
        [_noticeL setTitle:model.noticeWord forState:UIControlStateNormal];

        _currentPerson.sd_layout.heightRatioToView(_stateL,0);
        _noticeL.sd_layout.leftSpaceToView(self.contentView,14).topSpaceToView(_wordShetSL,0).widthIs(100).heightIs(12);
        _timeL.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(_pushPerson,16).rightSpaceToView(self.contentView,0).heightIs(14);
        [_noticeL updateLayout];
        [_timeL updateLayout];
        [_currentPerson updateLayout];
        
        if (model.noticeWord.length==0) {
            _noticeL.hidden = YES;
            _lineView.sd_layout.leftSpaceToView(self.contentView,6).rightSpaceToView(self.contentView,6).heightIs(0.01).topSpaceToView(_wordShetSL,10);
            [_lineView updateLayout];
        }else{
            _noticeL.hidden = NO;
            _lineView.sd_layout.leftSpaceToView(self.contentView,6).rightSpaceToView(self.contentView,6).heightIs(1).topSpaceToView(_noticeL,15);
            [_lineView updateLayout];
        }
    }else if([model.segmentName isEqualToString:@"我管理的流程"]){
        model.title = @"工单状态:";
        model.imgName = @"OA_gongdanState";
        NSArray *oi_stateArr = @[@"暂存",@"未审批",@"审批中",@"审批完成",@"退回"];
        int  index = [model.oi_state intValue];
        model.subTitle = oi_stateArr[index];
        _wordShetSL.model = model;
        
        model.title = @"审批状态:";
        model.imgName = @"OA_shenState";
        if ([model.sp_state isEqualToString:@"1"]) {
            model.subTitle = @"未审批";
        }else{
            model.subTitle = @"已审批";
        }
        _stateL.model = model;

        
        model.title = @"流程发起人:";
        model.imgName = @"OA_proceUser";
        model.subTitle = model.xm;
        _pushPerson.model = model;
        
        model.title = @"当前审批人";
        model.imgName = @"OA_danqgianUser";
        model.subTitle = model.spxm.length!=0?model.spxm:@"无";
        _currentPerson.model = model;
        _noticeL.sd_layout.heightIs(0).widthIs(0);
        _timeL.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(_currentPerson,16).rightSpaceToView(self.contentView,0).heightIs(14);
        _lineView.sd_layout.leftSpaceToView(self.contentView,6).rightSpaceToView(self.contentView,6).heightIs(0.01).topSpaceToView(_wordShetSL,10);
        [_timeL updateLayout];
        [_noticeL updateLayout];
        [_lineView updateLayout];
    }

    
    [_noticeL setTitle:model.noticeWord forState:UIControlStateNormal];
    CGSize size = [_noticeL.titleLabel boundingRectWithSize:CGSizeMake(0, 12)];
    _noticeL.sd_layout.widthIs(_noticeL.imageView.bounds.size.width + size.width+50);
    
//    [self rejectIsHaveMoniterBtn];

}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
