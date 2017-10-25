
//
//  JobRecuritCell.m
//  CSchool
//
//  Created by mac on 17/1/3.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JobRecuritCell.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

@implementation JobModel
/*
 @property (nonatomic,copy)NSString *jobTitle;
 @property (nonatomic,copy)NSString *jobTime;
 @property (nonatomic,copy)NSString *content;//
 @property (nonatomic,copy)NSString *releaseDepart;
 @property (nonatomic,copy)NSString *attchment;
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"jobTitle":@"title",
             @"jobTime":@"releaseTime",
             @"newsId":@"id",
             @"content":@"content",
             @"releaseDepart":@"releaseDepart",
             @"attchment":@"attchment"
             };
}
@end

@implementation JobRecuritCell
{
    UILabel *_titleLabel;
    UILabel *_timeLabel;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return  self;
}
-(void)setupView
{
    _titleLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15.0f];
        view.textColor = Color_Black;
        view;
    });
    _timeLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12.0f];
        view.textColor = Color_Gray;
        view;
    });
    UIView *contentView = self.contentView;
    [contentView sd_addSubviews:@[_titleLabel,_timeLabel]];
    _titleLabel.sd_layout.leftSpaceToView(contentView,7).topSpaceToView(contentView,7).widthIs(kScreenWidth-14).heightIs(15);
    _timeLabel.sd_layout.leftSpaceToView(contentView,7).topSpaceToView(_titleLabel,15).widthIs(200).heightIs(15);
    [self setupAutoHeightWithBottomView:_timeLabel bottomMargin:7];
}
-(void)setModel:(JobModel *)model
{
    _timeLabel.text = model.jobTime;
    _titleLabel.text = model.jobTitle;
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
