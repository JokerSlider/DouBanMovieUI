//
//  ExamListTableViewCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/6/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ExamListTableViewCell.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "NSDate+Extension.h"

@implementation ExamListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name" : @"KCM",
             @"type" : @"KSMC",
             @"time" : @"KSSJMS",
             @"address" : @"JSMC",
             @"xuefen":@"XF"};
}

- (void)setTime:(NSString *)time{
    _time = time;
    NSString *timeStr = [time substringToIndex:10];
    NSDate *finalDate = [NSDate dateWithString:timeStr format:@"yyyy-MM-dd"];
    NSUInteger dayAgo = [finalDate daysAgo];
    
    NSDate *earlierDate = [finalDate earlierDate:[NSDate date]];
    
    if ([earlierDate isEqualToDate:[NSDate date]]) {
        _status = [NSString stringWithFormat:@"倒计时：%lu天",(unsigned long)dayAgo];
    }else{
        _status = @"已结束";
    }
}

@end


@implementation ExamListTableViewCell
{
    UILabel *_nameLabel;
    UILabel *_typeLabel;
    UILabel *_timeLabel;
    UILabel *_addressabel;
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
        view.font = Title_Font;
        view.textColor = Color_Black;
        view;
    });
    
    _typeLabel  = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Gray;
        view;
    });
    
    _statusLabel  = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Base_Orange;
        view.textAlignment = NSTextAlignmentRight;
        view;
    });
    
    _timeLabel  = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = Color_Gray;
        view;
    });
    
    _addressabel  = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = Color_Gray;
        view;
    });
    
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_typeLabel];
    [self.contentView addSubview:_statusLabel];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_addressabel];
    
    _nameLabel.sd_layout
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10)
    .heightIs(30)
    .widthIs(200);
    
    _statusLabel.sd_layout
    .topEqualToView(_nameLabel)
    .rightSpaceToView(self.contentView,5)
    .widthIs(100)
    .heightIs(30);
    
    _typeLabel.sd_layout
    .topSpaceToView(_nameLabel,0)
    .leftSpaceToView(self.contentView,10)
    .widthIs(200)
    .heightIs(25);
    
    _timeLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .widthIs(250)
    .topSpaceToView(_typeLabel,5)
    .heightIs(25);
    
    _addressabel.sd_layout
    .leftEqualToView(_timeLabel)
    .rightEqualToView(_timeLabel)
    .topSpaceToView(_timeLabel,0)
    .heightRatioToView(_timeLabel,1);
    
    [self setupAutoHeightWithBottomView:_addressabel bottomMargin:0];
    
}

- (void)setModel:(ExamListModel *)model{
    _model = model;
    _nameLabel.text = [NSString stringWithFormat:@"%@ (%@分)",model.name,model.xuefen];
    _typeLabel.text = model.type;
    _addressabel.text = [NSString stringWithFormat:@"考试地点：%@",_model.address];
    _timeLabel.text = [NSString stringWithFormat:@"考试时间：%@",_model.time];
    
    NSString *timeStr = [model.time substringToIndex:10];
    NSDate *finalDate = [NSDate dateWithString:timeStr format:@"yyyy-MM-dd"];
    int dayAgo = [finalDate daysAgo];
    
    NSDate *earlierDate = [finalDate earlierDate:[NSDate date]];
    
//    if ([earlierDate isEqualToDate:[NSDate date]]) {
    if (dayAgo < 0) {
        model.status = [NSString stringWithFormat:@"倒计时：%d天",-dayAgo+1];
    }else if (dayAgo == 0){
        model.status = [NSString stringWithFormat:@"倒计时：%d天",-dayAgo];
    }else{
        model.status = @"已结束";
    }
    
    _statusLabel.text = model.status;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
