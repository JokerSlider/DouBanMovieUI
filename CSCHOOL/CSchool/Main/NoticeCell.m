//
//  NoticeCell.m
//  CSchool
//
//  Created by mac on 16/8/24.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "NoticeCell.h"
#import "UIView+SDAutoLayout.h"
@implementation NoticeCell
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}
-(void)createView{
    _noticeLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor =Base_Orange;
        view.numberOfLines = 0;
        view;
    });
    
    [self.contentView addSubview:_noticeLabel];
    
    _noticeLabel.sd_layout
    .leftSpaceToView(self.contentView,15)
    .rightSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,15)
    .autoHeightRatio(0);
    [self setupAutoHeightWithBottomView:_noticeLabel bottomMargin:10];
}
-(void)setModel:(PackageModel *)model
{
    _model = model;
    _noticeLabel.text =model.remark;
}

@end
