//
//  LibarySearchCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/12/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "LibarySearchCell.h"
#import "SDAutoLayout.h"

@implementation LibarySearchCell
{
    UILabel *_nameLabel;
    UILabel *_authorLabel;
    UILabel *_publickLabel;
    UILabel *_tiaomaLabel;
    UILabel *_haveNumLabel;
    UILabel *_canRentLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    _nameLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:15];
        view;
    });
    
    _authorLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(119, 119, 119);
        view.font = [UIFont systemFontOfSize:12];
        view;
    });
    
    _publickLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(119, 119, 119);
        view.font = [UIFont systemFontOfSize:12];
        view;
    });
    
    _tiaomaLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(119, 119, 119);
        view.font = [UIFont systemFontOfSize:12];
        view;
    });
    
    _haveNumLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(119, 119, 119);
        view.font = [UIFont systemFontOfSize:12];
        view;
    });
    
    _canRentLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(119, 119, 119);
        view.font = [UIFont systemFontOfSize:12];
        view;
    });
    
    [self.contentView sd_addSubviews:@[_nameLabel, _authorLabel, _publickLabel, _tiaomaLabel, _haveNumLabel, _canRentLabel]];
    
    _nameLabel.sd_layout
    .leftSpaceToView(self.contentView,13)
    .topSpaceToView(self.contentView,12)
    .heightIs(15)
    .rightSpaceToView(self.contentView,5);
    
    _authorLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_nameLabel,11)
    .heightIs(12)
    .rightEqualToView(_nameLabel);
    
    _publickLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_authorLabel,11)
    .heightIs(12)
    .rightEqualToView(_nameLabel);
    
    _tiaomaLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_publickLabel,11)
    .heightIs(12)
    .rightEqualToView(_nameLabel);
 
    _haveNumLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_tiaomaLabel,11)
    .heightIs(12)
    .rightEqualToView(_nameLabel);
    
    _canRentLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_haveNumLabel,11)
    .heightIs(12)
    .rightEqualToView(_nameLabel);
    
    [self setupAutoHeightWithBottomView:_canRentLabel bottomMargin:10];

}

- (void)setModel:(LibraryBookModel *)model{
    _model = model;
    _nameLabel.text = model.bookName;
    _authorLabel.text = [NSString stringWithFormat:@"作者：%@",model.author];
    _publickLabel.text = [NSString stringWithFormat:@"出版社：%@",model.publicName];
    _tiaomaLabel.text = [NSString stringWithFormat:@"索书号：%@",model.suoshuNum];
    _haveNumLabel.text = [NSString stringWithFormat:@"馆藏副本：%@",model.haveNum];
    _canRentLabel.text = [NSString stringWithFormat:@"可借副本：%@",model.canrentNum];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
