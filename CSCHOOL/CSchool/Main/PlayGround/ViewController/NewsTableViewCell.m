//
//  NewsTableViewCell.m
//  CSchool
//
//  Created by mac on 16/6/24.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "UIView+SDAutoLayout.h"
#import "UILabel+stringFrame.h"

@interface NewsTableViewCell()
{
    UILabel *_timeLabel;
}
@end
@implementation NewsTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}
-(void)createView
{
    self.title = ({
        UILabel *label = [UILabel new];
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label.font =[UIFont fontWithName:@ "Arial-BoldMT"  size:(15.0)];;
        label.font = Title_Font;
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = Color_Black;
        label;
    });
        self.time = ({
        UILabel *label = [UILabel new];
        label.font = Title_Font;
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = Color_Gray;
        label;
    });
    _newsLabel = ({
        UILabel *label = [UILabel new];
        label.font =[UIFont fontWithName:@ "Marker Felt" size:12];;

        label.textColor = [UIColor redColor];
        label.text = @"new";
        label.layer.cornerRadius = 5;
        label;
    });
    _timeLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"发布日期:";
        label.font = Title_Font;
        label.textColor = Color_Gray;
        label;
    });
    [self.contentView addSubview:_title];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_time];
    [self.contentView addSubview:_newsLabel];
    
    //    _beniftTitle.sd_layout.leftSpaceToView(_priceTitle,0).centerYEqualToView(priceLabel).autoHeightRatio(0).maxWidthIs(kScreenWidth-160).widthIs(20);

    _title.sd_layout.
    topSpaceToView(self.contentView,5).
    heightIs(18).
    leftSpaceToView(self.contentView,10).
    maxHeightIs(kScreenWidth-40).widthIs(20);
    
    _time.sd_layout.
    leftSpaceToView(_timeLabel,0).
    topSpaceToView(_title,10).
    widthIs(150).
    heightIs(18);
    
    _newsLabel.sd_layout.
    leftSpaceToView(_title,0).
    bottomSpaceToView(_title,-10).
    heightIs(15).
    widthIs(40);
    
    _timeLabel.sd_layout.
    leftEqualToView(_title).
    widthIs(60).
    heightIs(18).
    topSpaceToView(_title,10);
}
-(void)setTime:(UILabel *)time
{
    _time = time;
}
-(void)setTitle:(UILabel *)title
{
    _title = title;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.newsLabel.hidden) {
        //没new的
        CGSize size=[self.title boundingRectWithSize:CGSizeMake(0, 18)];
        self.title.sd_layout.widthIs(size.width).maxWidthIs(kScreenWidth-40);
    }else
    {
        //没new的
        CGSize size=[self.title boundingRectWithSize:CGSizeMake(0, 18)];
        self.title.sd_layout.widthIs(size.width).maxWidthIs(kScreenWidth-40);
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
