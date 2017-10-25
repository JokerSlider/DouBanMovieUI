//
//  MuKeCell.m
//  CSchool
//
//  Created by mac on 16/11/5.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MuKeCell.h"
#import "UIView+SDAutoLayout.h"
#import "MukeModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UILabel+stringFrame.h"
@implementation MuKeCell
{
    UIImageView *_muKeIcon;//课程图标
    UILabel     *_mukeName;//课程名
    UILabel     *_muKeStartTime;
    UILabel     *_muKeEndTime;
    UILabel     *_muKePNum;//参与人数

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
    _muKeIcon = ({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleToFill;
        view.image = [UIImage imageNamed:@"placdeImage"];
        view;
    });
    _mukeName = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view;
    });
    _muKeStartTime = ({
        UILabel *view = [UILabel new];
        view.textColor =RGB(64,170, 59);
        view.text = @"开始时间";
        view.font = Small_TitleFont;
        view;
    });
    _muKeEndTime = ({
        UILabel *view = [UILabel new];
        view.textColor =RGB(64,170, 59);
        view.text = @"结束时间";
        view.font = Small_TitleFont;
        view;
    });
    _muKePNum = ({
        UILabel *view = [UILabel new];
        view.textColor = Base_Orange;
        view.font = Small_TitleFont;
        view;
    });
    UIView *contentView = self.contentView;
    [contentView sd_addSubviews:@[_muKeIcon,_mukeName,_muKeStartTime,_muKeEndTime,_muKePNum]];
    
    _muKeIcon.sd_layout.leftSpaceToView(contentView,0).topSpaceToView(contentView,5).bottomSpaceToView(contentView,5).widthIs((kScreenWidth-14)*1/2);
    _mukeName.sd_layout.leftSpaceToView(_muKeIcon,5).topSpaceToView(contentView,5).heightIs(20).widthIs(kScreenWidth*1/2-5);
    _muKeStartTime.sd_layout.leftEqualToView(_mukeName).topSpaceToView(_mukeName,6).heightIs(20).widthIs(200);
    _muKeEndTime.sd_layout.leftEqualToView(_mukeName).topSpaceToView(_muKeStartTime,6).heightIs(20).widthIs(200);
    _muKePNum.sd_layout.leftEqualToView(_mukeName).topSpaceToView(_muKeEndTime,5).heightIs(20).widthIs(200);
    
    [self setupAutoHeightWithBottomView:_muKePNum bottomMargin:0];

}
-(void)setModel:(MukeModel *)model
{
    _model = model;
    _mukeName.text = model.name;
    [_muKeIcon sd_setImageWithURL:[NSURL URLWithString:model.ctImgUrl] placeholderImage:[UIImage imageNamed:@"placdeImage"]];
    _muKeStartTime.text =[NSString stringWithFormat:@"开始时间:%@",[self timeString:model.ctStartTime]];
    _muKeEndTime.text =[NSString stringWithFormat:@"结束时间:%@",[self timeString:model.ctEndTime]];
    _muKePNum.text = [NSString stringWithFormat:@"已有%@人参加",model.enrollCount];
    
//    CGSize size = [_mukeName boundingRectWithSize:CGSizeMake(0, 15)];
//    _mukeName.sd_layout.widthIs(size.width);
//    size = [_muKeStartTime boundingRectWithSize:CGSizeMake(0, 15)];
//    _muKeStartTime.sd_layout.widthIs(size.width);
//    size = [_muKeEndTime boundingRectWithSize:CGSizeMake(0, 15)];
//    _muKeEndTime.sd_layout.widthIs(size.width);
//    size = [_muKePNum boundingRectWithSize:CGSizeMake(0, 15)];
//    _muKePNum.sd_layout.widthIs(size.width);
    
    
}
-(NSString *)timeString:(NSString *)timeStamp
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
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
