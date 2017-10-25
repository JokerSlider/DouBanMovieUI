//
//  PhotoMsgCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/10/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PhotoMsgCell.h"
#import <YYText.h>
#import "SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PhotoMsgModel
/**
 *  @property (nonatomic, copy) NSString *;
 
 @property (nonatomic, copy) NSString *;
 
 @property (nonatomic, copy) NSString *;
 
 @property (nonatomic, copy) NSString *;
 */

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"headerUrl":@"txdz",
             @"name":@"nc",
             @"content":@"pwe_content",
             @"createTime":@"pwe_createtime",
             @"msgId":@"pwe_id"
             };
}

- (void)setCreateTime:(NSString *)createTime{
    //格式化日期类
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZZ"];
    
    //通过字符串转换为date
    NSDate *date = [df dateFromString:createTime];

    
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    //将日期按照格式化日期类转换为字符串
    NSString *str2 = [df1 stringFromDate:date];

    _createTime = str2;
}

@end

@implementation PhotoMsgCell
{
    UIImageView *_headerImageView;
    UILabel *_nameLabel;
    UILabel *_contentLabel;
    UILabel *_timeLabel;
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
        view.textColor = RGB(61, 134, 216);
        view.font = [UIFont systemFontOfSize:15];
        view;
    });
    
    _contentLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(51, 51, 51);
        view.font = [UIFont systemFontOfSize:14];
        view;
    });
    
    _timeLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(153, 153, 153);
        view.font = [UIFont systemFontOfSize:12];
        view.textAlignment =  NSTextAlignmentRight;
        view;
    });
    
    [self.contentView sd_addSubviews:@[_headerImageView, _nameLabel, _contentLabel, _timeLabel]];
    
    _headerImageView.sd_layout
    .leftSpaceToView(self.contentView, 14)
    .topSpaceToView(self.contentView,10)
    .widthIs(40)
    .heightIs(40);
    
    _headerImageView.sd_cornerRadius = @(20);
    
    _nameLabel.sd_layout
    .topEqualToView(_headerImageView)
    .leftSpaceToView(_headerImageView,10)
    .heightIs(15)
    .widthIs(200);
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_nameLabel,8)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    
    _timeLabel.sd_layout
    .topSpaceToView(self.contentView, 13)
    .rightSpaceToView(self.contentView,5)
    .widthIs(200)
    .heightIs(9);
    
    [self setupAutoHeightWithBottomView:_contentLabel bottomMargin:10];

}

- (void)setModel:(PhotoMsgModel *)model{
    _model = model;
    _nameLabel.text = model.name;
    _contentLabel.text = model.content;
    _timeLabel.text = model.createTime;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_model.headerUrl] placeholderImage:PlaceHolder_Image];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
