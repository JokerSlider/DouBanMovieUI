//
//  MaketInputTableViewCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/10/11.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MaketInputTableViewCell.h"
#import "SDAutoLayout.h"

@implementation MaketInputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    _titleLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Black;
        view;
    });
    
    _textField = ({
        UITextField *view = [UITextField new];
        view.font = Title_Font;
        view.textAlignment = NSTextAlignmentRight;
        view;
    });
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_textField];
    
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView,14)
    .topSpaceToView(self.contentView,5)
    .bottomSpaceToView(self.contentView,5)
    .widthIs(150);
    
    _textField.sd_layout
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,5)
    .bottomSpaceToView(self.contentView,5)
    .widthIs(150);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
