//
//  HelpListTableViewCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/19.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "HelpListTableViewCell.h"
#import "UIView+SDAutoLayout.h"

@implementation HelpListModel



@end

@implementation HelpListTableViewCell
{
    UILabel *_titleLabel;
    UILabel *_contentLabel;
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
        view.font = Title_Font;
        view;
    });
    
    _contentLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = [UIColor grayColor];
        view.numberOfLines = 4;
        view;
    });
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_contentLabel];
    
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10)
    .heightIs(30);
    
    _contentLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .rightEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel,5)
    .heightIs(65);
    
    [self setupAutoHeightWithBottomView:_contentLabel bottomMargin:10];
}

- (void)setModel:(HelpListModel *)model
{
    _model = model;
    _titleLabel.text = model.title;
    _contentLabel.text = model.content;
}

@end
