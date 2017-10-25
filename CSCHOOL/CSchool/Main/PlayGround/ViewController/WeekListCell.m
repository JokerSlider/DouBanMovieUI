//
//  WeekListCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/9/8.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "WeekListCell.h"
#import "SDAutoLayout.h"

@implementation WeekListCell
{
    UIImageView *_iconImageView;
    UILabel *_titleLabel;
    UILabel *_subTitleLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    _iconImageView = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"meeting_meetingIcon"];
        view;
    });
    
    _titleLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = Color_Black;
        view.text = @"这里是标题";
        view;
    });
    
    _subTitleLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = Color_Gray;
        view.text = @"2016.9.15-2011.2.12";
        view;
    });
    
    [self.contentView sd_addSubviews:@[_iconImageView, _titleLabel, _subTitleLabel]];
    
    _iconImageView.sd_layout
    .leftSpaceToView(self.contentView,16)
    .topSpaceToView(self.contentView,16)
    .widthIs(30)
    .heightIs(30);
    
    _titleLabel.sd_layout
    .leftSpaceToView(_iconImageView,16)
    .topSpaceToView(self.contentView,14)
    .rightSpaceToView(self.contentView,3)
    .heightIs(15);
    
    _subTitleLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .rightEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel,9)
    .heightIs(12);
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    NSArray *titleArr = [dataDic[@"title"] componentsSeparatedByString:@"（"];
    if (titleArr.count == 2) {
        _titleLabel.text = titleArr[0];
        _subTitleLabel.text = [titleArr[1] stringByReplacingOccurrencesOfString:@"）" withString:@""];
    }else if (titleArr.count == 3){
        _titleLabel.text = [NSString stringWithFormat:@"%@（%@",titleArr[0], titleArr[2]];
        _subTitleLabel.text = [titleArr[1] stringByReplacingOccurrencesOfString:@"）" withString:@""];
    }else{
        _titleLabel.text = titleArr[0];
    }
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
