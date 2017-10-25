//
//  OfficalEndCell.m
//  CSchool
//
//  Created by mac on 17/8/22.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OfficalEndCell.h"
#import "UIView+SDAutoLayout.h"

@implementation OfficalEndCell
{
    UILabel *_titleL;
    UIImageView *_deImage;//部门图标
    UIImageView *_timeImage;//时间图标
    UILabel *_depatalLabel;
    UILabel *_timeLabel;
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
    _titleL = ({
        UILabel *view  = [UILabel new];
        view.font = [UIFont systemFontOfSize:15.0f];
        view.lineBreakMode = NSLineBreakByTruncatingTail;
        view.textColor = Color_Black;
        view;
    });
    _deImage = ({
        UIImageView *view = [UIImageView new];
        
        view.image = [UIImage imageNamed:@"APR"];
        view;
    });
    _timeImage = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"OA_time"];
        view;
    });
    _depatalLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:13.0f];
        view.textColor = Color_Gray;
        view;
    });
    _timeLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:13.0f];
        view.textColor = Color_Gray;
        view;
    });
    [self.contentView sd_addSubviews:@[_titleL,_depatalLabel,_timeLabel,_deImage,_timeImage]];
    
    _titleL.sd_layout.leftSpaceToView(self.contentView,14).rightSpaceToView(self.contentView,14).topSpaceToView(self.contentView,15).heightIs(14);
    _deImage.sd_layout.leftSpaceToView(self.contentView,14).widthIs(16).heightIs(16).topSpaceToView(_titleL,16);
    _depatalLabel.sd_layout.leftSpaceToView(_deImage,10).topSpaceToView(_titleL,16).rightSpaceToView(self.contentView,14).heightIs(14);
    _timeImage.sd_layout.leftSpaceToView(self.contentView,14).topSpaceToView(_depatalLabel,16).widthIs(16).heightIs(16);
    _timeLabel.sd_layout.leftSpaceToView(_timeImage,10).topSpaceToView(_depatalLabel,16).rightSpaceToView(self.contentView,14).heightIs(14);
//    [self setupAutoHeightWithBottomView:_timeLabel bottomMargin:16];
    
}
-(void)setModel:(OfficalSearchModel *)model
{
    _model = model;
    _titleL.text = model.title;
    NSString *departMent = [NSString stringWithFormat:@"发布部门:          %@",model.releaseDepart];
    _depatalLabel.text = departMent;
    NSString *time = [NSString stringWithFormat:@"发布时间:          %@",model.releaseTime];
    _timeLabel.text = time;
    
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
