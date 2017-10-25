//
//  QueryFundCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/8/11.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "QueryFundCell.h"
#import "SDAutoLayout.h"

@implementation QueryFundCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *bgView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    
    _iconImageView = ({
        UIImageView *view = [UIImageView new];
        view;
    });
    
    _nameLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = Title_Font;
        view;
    });
    
    _valueLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = Title_Font;
        view;
    });
    
    [self.contentView addSubview:bgView];
    [bgView sd_addSubviews:@[_iconImageView, _nameLabel, _valueLabel]];
    
    bgView.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .bottomSpaceToView(self.contentView, 0);
    
    _iconImageView.sd_layout
    .centerYEqualToView(bgView)
    .leftSpaceToView(bgView,10)
    .heightIs(20)
    .widthIs(20);
    
    _nameLabel.sd_layout
    .centerYEqualToView(bgView)
    .leftSpaceToView(_iconImageView,10)
    .heightIs(21)
    .widthIs(80);
    
    _valueLabel.sd_layout
    .centerYEqualToView(bgView)
    .leftSpaceToView(_nameLabel,10)
    .heightIs(21)
    .widthIs(200);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
