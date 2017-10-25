//
//  OfficeReleaseTableViewCell.m
//  CSchool
//
//  Created by mac on 16/9/10.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "OfficeReleaseTableViewCell.h"
#import "UIView+SDAutoLayout.h"
#import "UILabel+stringFrame.h"

@implementation OfficeReleaseTableViewCell
{

}
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
        label.font =[UIFont fontWithName:@ "Arial-BoldMT"  size:(17.0)];;
        label.font = Title_Font;
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = Color_Black;
        label;
    });
    self.time = ({
        UILabel *label = [UILabel new];
        label.font = Small_TitleFont;
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
        label.text = @"发布时间:";
        label.font = Title_Font;
        label.textColor = Color_Gray;
        label;
    });
    _depatalLabel = ({
        UILabel *view = [UILabel new];
        view.text  = @"发布部门:";
        view.font = Title_Font;
        view.textColor = Color_Gray;
        view;
    });
    [self.contentView addSubview:_title];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_time];
    [self.contentView addSubview:_newsLabel];
    [self.contentView addSubview:_depatalLabel];
    //    _beniftTitle.sd_layout.leftSpaceToView(_priceTitle,0).centerYEqualToView(priceLabel).autoHeightRatio(0).maxWidthIs(kScreenWidth-160).widthIs(20);
    
    _title.sd_layout.
    topSpaceToView(self.contentView,5).
    heightIs(18).
    leftSpaceToView(self.contentView,15).
    maxHeightIs(kScreenWidth-40).widthIs(20);

    _newsLabel.sd_layout.
    leftSpaceToView(_title,0).
    bottomSpaceToView(_title,-10).
    heightIs(15).
    widthIs(40);
    
    _depatalLabel.sd_layout.leftEqualToView(_title).topSpaceToView(_title,10).heightIs(18).widthIs(kScreenWidth-5);
    _timeLabel.sd_layout.leftEqualToView(_title).topSpaceToView(_depatalLabel,10).heightIs(18).widthIs(60);
    _time.sd_layout.leftSpaceToView(_timeLabel,0).topEqualToView(_timeLabel).heightIs(18).widthIs(kScreenWidth-55);
    
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
