//
//  IndexNewsCell.m
//  CSchool
//
//  Created by 左俊鑫 on 17/1/11.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "IndexNewsCell.h"
#import "SDAutoLayout.h"


@implementation IndexNewsCellModel

/*
 
 @property (nonatomic, copy) NSString *;
 
 @property (nonatomic, copy) NSString *;
 
 @property (nonatomic, copy) NSString *;
 
 @property (nonatomic, copy) NSString *;
 
 @property (nonatomic, copy) NSString *; //订单或者照片编号
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"appID" : @"OUT_AIID",
             @"time" : @"OUT_PWBCREATETIME",
             @"content" : @"OUT_REMIND",
             @"showName" : @"OUT_AINAME",
             @"detailID":@"OUT_PWBID",
             @"openURL":@"OUT_URL"
             };
}


@end

@implementation IndexNewsCell
{
    UIImageView *_headerImageView;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_contentLabel;
    UIButton *_viewBtn;
    UIView *_bootomView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    _headerImageView = ({
        UIImageView *view = [UIImageView new];
        view;
    });
    
    _nameLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(85, 85, 85);
        view;
    });
    
    _timeLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = RGB(153, 153, 153);
        view;
    });
    
    _contentLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(85, 85, 85);
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });
    
    _viewBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeSystem];
        [view setTitle:@"立即查看" forState:UIControlStateNormal];
        view.userInteractionEnabled = NO;
        view;
    });
    
    UIView *lineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        view;
    });
    
    _bootomView = ({
        UIView *view = [UIView new];
        view.backgroundColor =RGB(247, 247, 247);
        view;
    });
    
    [self.contentView sd_addSubviews:@[_headerImageView, _nameLabel, _timeLabel, _contentLabel, _viewBtn, lineView, _bootomView]];
    
    _headerImageView.sd_layout
    .leftSpaceToView(self.contentView, 13)
    .topSpaceToView(self.contentView, 10)
    .widthIs(30)
    .heightIs(30);
    
    _nameLabel.sd_layout
    .leftSpaceToView(_headerImageView, 11)
    .topEqualToView(_headerImageView)
    .heightIs(14)
    .rightSpaceToView(self.contentView,10);
    
    _timeLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .bottomEqualToView(_headerImageView)
    .heightIs(9)
    .rightEqualToView(_nameLabel);
    
    _contentLabel.sd_layout
    .leftSpaceToView(self.contentView, 40)
    .rightSpaceToView(self.contentView,40)
    .topSpaceToView(_headerImageView,16)
    .autoHeightRatio(0);
    
    lineView.sd_layout
    .leftSpaceToView(self.contentView,12)
    .rightSpaceToView(self.contentView,12)
    .topSpaceToView(_contentLabel,16)
    .heightIs(0.5);
    
    _viewBtn.sd_layout
    .leftSpaceToView(self.contentView,5)
    .rightSpaceToView(self.contentView,5)
    .heightIs(30)
    .topSpaceToView(lineView,0);

    _bootomView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .topSpaceToView(_viewBtn,0)
    .heightIs(10);
}

- (void)setModel:(IndexNewsCellModel *)model{
    _model = model;
    if (_model.appID) {
        NSInteger ai_id = [_model.appID integerValue]-1;
        [_headerImageView setImage:[UIImage imageNamed:[AppUserIndex GetInstance].iconIDArray[ai_id]]];
    }
    _nameLabel.text = _model.showName;
    _timeLabel.text = _model.time;
    _contentLabel.text = _model.content;
    [self setupAutoHeightWithBottomView:_viewBtn bottomMargin:10];

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
