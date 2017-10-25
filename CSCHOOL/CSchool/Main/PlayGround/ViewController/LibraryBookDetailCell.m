//
//  LibraryBookDetailCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/12/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "LibraryBookDetailCell.h"
#import "SDAutoLayout.h"

@implementation LibraryBookDetailModel


@end

@implementation LibraryBookDetailCell
{
    UILabel *_titleLabel;
    UILabel *_detailLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.contentView.backgroundColor = RGB(245, 245, 245);
    _titleLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(85, 85, 85);
        view.font = [UIFont boldSystemFontOfSize:14];
        view;
    });
    
    _detailLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(85, 85, 85);
        view.font = [UIFont systemFontOfSize:14];
        view;
    });
    
    [self.contentView sd_addSubviews:@[_titleLabel, _detailLabel]];
    
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView,14)
    .topSpaceToView(self.contentView,17)
    .widthIs(78)
    .autoHeightRatio(0);
    
    _detailLabel.sd_layout
    .leftSpaceToView(_titleLabel,24)
    .topSpaceToView(self.contentView,17)
    .rightSpaceToView(self.contentView,15)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_detailLabel bottomMargin:10];

}

- (void)setModel:(LibraryBookDetailModel *)model{
    _model = model;
    _titleLabel.text = model.title;
    _detailLabel.text = model.detail;
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
