//
//  ImportWorkListCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/9/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ImportWorkListCell.h"
#import "SDAutoLayout.h"

@implementation ImportWorkListModel
/**
 *  @property (nonatomic, copy) NSString *;
 @property (nonatomic, copy) NSString *;
 @property (nonatomic, copy) NSString *;
 @property (nonatomic, copy) NSString *;
 *
 *workType; //工作类别 2017-05-10新增
 @property (nonatomic, copy) NSString *helpDepart
 *  @return
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"title" : @"GZMC",
             @"status" : @"GZZTDMMS",
             @"depart" : @"DWBZMC",
             @"workId" : @"WID",
             @"workName" : @"GZMC",
             @"workType":@"GZLB",
             @"helpDepart":@"XTBM"
             };
}

@end

@implementation ImportWorkListCell
{
    UILabel *_titleLabel;
    UILabel *_statusLabel;
    UILabel *_departLabel;
    UIImageView *_statusImageView;
    UIImageView *_departImageView;
    
    UIImageView *_wokeTypeImageView;
    UIImageView *_helpDepartImageView;
    UILabel *_wokeTypeLabel;
    UILabel *_helpDepartLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    _titleLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:16];
        view.textColor = Color_Black;
        view;
    });
    
    _statusLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = RGB(66, 66, 66);
        view;
    });
    
    _departLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = RGB(66, 66, 66);
        view;
    });
    
    _statusImageView = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"import_zhuangtai"];
        view;
    });
    
    _departImageView = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"import_bumen"];
        view;
    });
    
    
    _wokeTypeImageView = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"import_fen"];
        view;
    });
    
    _helpDepartImageView = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"import_bu"];
        view;
    });
    
    _wokeTypeLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = RGB(66, 66, 66);
        view;
    });
    
    _helpDepartLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = RGB(66, 66, 66);
        view;
    });
    
    
    [self.contentView sd_addSubviews:@[_titleLabel, _statusLabel, _departLabel, _statusImageView, _departImageView, _wokeTypeImageView, _helpDepartImageView, _wokeTypeLabel, _helpDepartLabel]];
    
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView,18)
    .topSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView,10)
    .heightIs(16);
    
    _statusImageView.sd_layout
    .leftSpaceToView(self.contentView,18)
    .topSpaceToView(_titleLabel,10)
    .widthIs(14)
    .heightIs(14);
    
    _statusLabel.sd_layout
    .leftSpaceToView(_statusImageView,5)
    .topSpaceToView(_titleLabel,12)
    .rightSpaceToView(self.contentView,5)
    .heightIs(12);
    
    _departImageView.sd_layout
    .leftSpaceToView(self.contentView,18)
    .topSpaceToView(_statusImageView,5)
    .widthIs(14)
    .heightIs(14);
    
    _departLabel.sd_layout
    .leftSpaceToView(_departImageView,5)
    .topSpaceToView(_statusLabel,6)
    .rightSpaceToView(self.contentView,5)
    .heightIs(12);
    
    _helpDepartImageView.sd_layout
    .leftSpaceToView(self.contentView,18)
    .topSpaceToView(_departLabel,5)
    .widthIs(14)
    .heightIs(14);
    
    _helpDepartLabel.sd_layout
    .leftSpaceToView(_helpDepartImageView, 5)
    .topSpaceToView(_departLabel,6)
    .rightSpaceToView(self.contentView,5)
    .autoHeightRatio(0);
    
    _wokeTypeImageView.sd_layout
    .leftSpaceToView(self.contentView,18)
    .topSpaceToView(_helpDepartLabel,5)
    .widthIs(14)
    .heightIs(14);
    
    _wokeTypeLabel.sd_layout
    .leftSpaceToView(_wokeTypeImageView, 5)
    .topSpaceToView(_helpDepartLabel,6)
    .rightSpaceToView(self.contentView,5)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_wokeTypeLabel bottomMargin:10];
}

- (void)setModel:(ImportWorkListModel *)model{
    _model = model;
    
    _titleLabel.text = model.title;
    _statusLabel.text = [NSString stringWithFormat:@"当前状态：%@",model.status];
    _departLabel.text = [NSString stringWithFormat:@"牵头部门：%@",model.depart];
    _helpDepartLabel.text = [NSString stringWithFormat:@"协办部门：%@",model.helpDepart];
    _wokeTypeLabel.text = [NSString stringWithFormat:@"工作类别：%@",model.workType];

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
