//
//  TodayStepCell.m
//  CSchool
//
//  Created by mac on 17/4/12.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "TodayStepCell.h"
#import "UIView+SDAutoLayout.h"

@implementation TodayStepCell
{
    UIView *_stepView;
    UILabel *_subTitle;
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createPersonTodayStep];
    }
    return self;
}
-(void)createPersonTodayStep
{
    _stepView = ({
        UIView *view = [UIView new];
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = Base_Color2.CGColor;
        view;
    });
    
    UILabel *title=({
        UILabel *view = [UILabel new];
        view.text = @"今日步数";
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:15.0f];
        view;
    });
    
    _subTitle =({
        UILabel *view = [UILabel new];
        view.text = @"0步";
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:15.0f];
        view;
    });
    [self.contentView sd_addSubviews:@[_stepView]];
    [_stepView sd_addSubviews:@[title,_subTitle]];
    _stepView.sd_layout.leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).topSpaceToView(self.contentView,05).heightIs(40);
    title.sd_layout.leftSpaceToView(_stepView,1).widthIs(60).heightIs(20).topSpaceToView(_stepView,10);
    _subTitle.sd_layout.rightSpaceToView(_stepView,1).widthIs(60).heightIs(20).topSpaceToView(_stepView,10);
    CGSize size = [title boundingRectWithSize:CGSizeMake(0, 20)];
    title.sd_layout.widthIs(size.width);
    [self setupAutoHeightWithBottomView:_subTitle bottomMargin:50];
}

-(void)setModel:(SportModel *)model
{
    _model = model;
    _subTitle.text =[NSString stringWithFormat:@"%@步",model.UMISTEPNUMBER?model.UMISTEPNUMBER:@"0"];
    CGSize size = [_subTitle boundingRectWithSize:CGSizeMake(0, 20)];
    _subTitle.sd_layout.widthIs(size.width);
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
