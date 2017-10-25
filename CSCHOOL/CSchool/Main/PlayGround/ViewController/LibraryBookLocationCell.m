//
//  LibraryBookLocationCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/12/28.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "LibraryBookLocationCell.h"
#import "SDAutoLayout.h"
#import <YYModel.h>

@implementation LibraryBookLocationModel


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"stationName" : @"LOCATION_NAME",
             @"suoshuNum" : @"CALL_NO",
             @"tiaomaNum" : @"BAR_CODE",
             };
}

- (void)setBOOK_STAT_CODE:(NSString *)BOOK_STAT_CODE{
    _BOOK_STAT_CODE = BOOK_STAT_CODE;
    if ([_statusDic objectForKey:_BOOK_STAT_CODE]) {
        _statusInfo = [_statusDic objectForKey:_BOOK_STAT_CODE];
    }else{
        _statusInfo = @"";
    }
}

@end

@implementation LibraryBookLocationCell
{
    UILabel *_nameLabel;
    UILabel *_suoshuLabel;
    UILabel *_tiaomaLabel;
    UILabel *_statusLabel;
    
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
        view.textColor = RGB(85, 85, 85);
        view.font = [UIFont boldSystemFontOfSize:14];
        view;
    });
    
    _suoshuLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(85, 85, 85);
        view.font = [UIFont systemFontOfSize:12];
        view;
    });
    
    _tiaomaLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(85, 85, 85);
        view.font = [UIFont systemFontOfSize:12];
        view;
    });
    
    _statusLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(85, 85, 85);
        view.font = [UIFont boldSystemFontOfSize:14];
        view.textAlignment = NSTextAlignmentRight;
        view;
    });
    
    [self.contentView sd_addSubviews:@[_nameLabel, _suoshuLabel, _tiaomaLabel, _statusLabel]];
    
    _nameLabel.sd_layout
    .leftSpaceToView(self.contentView,13)
    .topSpaceToView(self.contentView,12)
    .widthIs(300)
    .heightIs(14);
    
    _suoshuLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .rightSpaceToView(self.contentView,5)
    .topSpaceToView(_nameLabel,11)
    .heightIs(12);
    
    _tiaomaLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .rightEqualToView(_suoshuLabel)
    .topSpaceToView(_suoshuLabel,7)
    .heightIs(12);
    
    _statusLabel.sd_layout
    .topEqualToView(_nameLabel)
    .rightSpaceToView(self.contentView,10)
    .widthIs(100)
    .autoHeightRatio(0);
    
    
}

- (void)setModel:(LibraryBookLocationModel *)model{
    _nameLabel.text = model.stationName;
    _statusLabel.text = model.statusInfo;
    _suoshuLabel.text = [NSString stringWithFormat:@"索书号：%@",model.suoshuNum];
    _tiaomaLabel.text = [NSString stringWithFormat:@"条码号：%@",model.tiaomaNum];
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
