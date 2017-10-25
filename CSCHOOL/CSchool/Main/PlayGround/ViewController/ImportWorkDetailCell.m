//
//  ImportWorkDetailCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/9/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ImportWorkDetailCell.h"
#import "SDAutoLayout.h"

@implementation ImportWorkDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"month" : @"JHYF",
             @"plan" : @"JHNR",
             @"jindu" : @"JDNR",
             @"percent" : @"JDBFB"
             };
}

@end

@implementation ImportWorkDetailCell
{
    UILabel *_monthLabel;
    UILabel *_planTitleLabel;
    UILabel *_planLabel;
    UILabel *_jinduTitleLabel;
    UILabel *_jinduLabel;
    UILabel *_percentTitleLabel;
    UILabel *_percentLabel;
    UIProgressView *_progressView;
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

    _monthLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = Color_Black;
        view;
    });
    
    _planTitleLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = RGB(2, 2, 2);
        view.text = @"本月计划";
        view;
    });
    
    _jinduTitleLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = RGB(2, 2, 2);
        view.text = @"本月进度";
        view;
    });
    
    _percentTitleLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = RGB(2, 2, 2);
        view.text = @"进度完成的百分比";
        view;
    });
    
    _planLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = RGB(66, 66, 66);
        view;
    });
    
    _jinduLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = RGB(66, 66, 66);
        view;
    });
    
    _percentLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:9];
        view.textColor = RGB(66, 66, 66);
//        view.hidden = YES
        view;
    });
    
    _progressView = ({
        UIProgressView *view = [[UIProgressView alloc] init];
        view.progressTintColor = RGB(242,177,1);
        view.trackTintColor = RGB(219, 219, 219);
//        [view setProgressViewStyle:UIProgressViewStyleBar];
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3);
        view.transform = transform;
        view;
    });
    
//    _statusLabel = ({
//        UILabel *view = [UILabel new];
//        view.font = [UIFont systemFontOfSize:9];
//        view.textColor = RGB(66, 66, 66);
//        view;
//    });
    
    UIView *lineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        view;
    });
    
    [self.contentView sd_addSubviews:@[_monthLabel, _planLabel, _jinduLabel, _planTitleLabel, _jinduTitleLabel, _progressView, _percentLabel, _percentTitleLabel, lineView]];
    
    _monthLabel.sd_layout
    .leftSpaceToView(self.contentView, 18)
    .rightSpaceToView(self.contentView,3)
    .heightIs(15)
    .topSpaceToView(self.contentView, 13);
    
    lineView.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView,0)
    .topSpaceToView(_monthLabel, 13)
    .heightIs(1);
    
    _planTitleLabel.sd_layout
    .leftSpaceToView(self.contentView, 18)
    .topSpaceToView(lineView, 14)
    .widthIs(52)
    .heightIs(12);
    
    _planLabel.sd_layout
    .leftSpaceToView(_planTitleLabel, 17)
    .topEqualToView(_planTitleLabel)
    .rightSpaceToView(self.contentView, 22)
    .autoHeightRatio(0);
    
    _jinduTitleLabel.sd_layout
    .leftSpaceToView(self.contentView, 18)
    .topSpaceToView(_planLabel, 17)
    .widthIs(52)
    .heightIs(12);
    
    _jinduLabel.sd_layout
    .leftSpaceToView(_jinduTitleLabel, 17)
    .topEqualToView(_jinduTitleLabel)
    .rightSpaceToView(self.contentView, 22)
    .autoHeightRatio(0);
    
    _percentTitleLabel.sd_layout
    .leftEqualToView(_planTitleLabel)
    .topSpaceToView(_jinduLabel, 18)
    .widthIs(100)
    .heightIs(12);
    
    _percentLabel.sd_layout
    .leftSpaceToView(_percentTitleLabel,23)
    .topSpaceToView(_jinduLabel, 15)
    .rightSpaceToView(self.contentView, 54)
    .heightIs(8);
    
    _progressView.sd_layout
    .leftSpaceToView(_percentTitleLabel,23)
    .rightSpaceToView(self.contentView, 54)
    .topSpaceToView(_percentTitleLabel,0)
    .heightIs(3);
    
//    CGAffineTransform transform = CGAffineTransformMakeScale(17.0f, 100);
//    _progressView.transform = transform;
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:bottomView];
    
    bottomView.sd_layout
    .topSpaceToView(_percentTitleLabel,10)
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .heightIs(15);
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:0];

}

- (void)setModel:(ImportWorkDetailModel *)model{
    if (!model.percent) {
        model.percent = @"0";
    }
    
    _model = model;
    _monthLabel.text = [NSString stringWithFormat:@"计划月份：%@月",model.month];
    _planLabel.text = model.plan;
    _jinduLabel.text = model.jindu;
    
    if ([model.percent isEqualToString:@"lt50"]) {
        //设置百分百进度条
        _progressView.progress = 30.0/100.00;
        _percentLabel.text = @"50%以下";
    }else if ([model.percent isEqualToString:@"gt50"]){
        //设置百分百进度条
        _progressView.progress = 60.0/100.00;
        _percentLabel.text = @"50%以上，但未完成";
    }else if ([model.percent isEqualToString:@"100"]){
        //设置百分百进度条
        _progressView.progress = [model.percent floatValue]/100.00;
        _percentLabel.text = @"100%完成";
    }else{
        //设置百分百进度条
        _progressView.progress = [model.percent floatValue]/100.00;
        _percentLabel.text = [NSString stringWithFormat:@"%@%%",model.percent];
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
