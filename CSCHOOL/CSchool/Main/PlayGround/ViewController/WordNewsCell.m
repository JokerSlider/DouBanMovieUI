//
//  WordNewsCell.m
//  CSchool
//
//  Created by mac on 17/1/17.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "WordNewsCell.h"
#import "NewsPhotoBroweer.h"
#import "CustomizedPaddingLabel.h"
#import "UILabel+stringFrame.h"
#import "UIView+SDAutoLayout.h"
#import <YYModel.h>
@implementation WorldNewsModel
/*
 @property (nonatomic,copy)NSString *TITLE;
 @property (nonatomic,copy)NSString *SOURCE;//信息来源
 @property (nonatomic,copy)NSString *ARTICLEURL;//URL 详情
 @property (nonatomic,copy)NSString *PUBLISHTIME;//发布时间
 @property (nonatomic,copy)NSString *CREATETIME;//创建时间
 @property (nonatomic,copy)NSString *SHOWTiIME;//显示时间
 @property (nonatomic,copy)NSString *READCOUNT;//站内浏览次数
 @property (nonatomic, strong) NSArray *PHOTOURL;//缩略图  IRIURL
 @property (nonatomic, strong) NSArray *GROUPNAME;//tag
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"TITLE":@"TITLE",
             @"SOURCE":@"SOURCE",
             @"ARTICLEURL":@"ARTICLEURL",
             @"PUBLISHTIME":@"PUBLISHTIME",
             @"CREATETIME":@"CREATETIME",
             @"SHOWTIME":@"SHOWTIME",
             @"READCOUNT":@"READCOUNT",
             @"PHOTOURL":@"PHOTOURL",
             @"GROUPNAME":@"GROUPNAME"
             };
}



@end




@implementation WordNewsCell
{
    UILabel  *_newsTitle;//新闻标题
    CustomizedPaddingLabel *_tagLabel;//标签
    NewsPhotoBroweer *_picContainerView;
    UILabel *_timeLabel;
    UILabel *_lookNum;//浏览量
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupview];
    }
    return self;
}
-(void)setupview
{
    _newsTitle = ({
        UILabel *view = [UILabel new];
        view.text = @"";
        view.font = [UIFont systemFontOfSize:16.0f];
        view.textColor = RGB(30, 30, 30);
        view;
    });
    _picContainerView = [[NewsPhotoBroweer alloc]init];
    
    _tagLabel =({
        CustomizedPaddingLabel *view = [CustomizedPaddingLabel new];
        view.layer.borderWidth = 0.5;
        view.layer.cornerRadius = 3;
        view.layer.borderColor = [UIColor orangeColor].CGColor;
        view.textColor = [UIColor orangeColor];
        view.font = Small_TitleFont;
        view.text = @"";
        view;
    });
    _timeLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.text = @"";
        view.textColor = Color_Gray;
        view;
    });
    _lookNum = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.text = @"";
        view.hidden = YES;
        view.textColor = Color_Gray;
        view;
    });
    [self.contentView sd_addSubviews:@[_newsTitle,_picContainerView,_tagLabel,_timeLabel,_lookNum]];
    UIView *contentView = self.contentView;
    _newsTitle.sd_layout.leftSpaceToView(contentView,13).rightSpaceToView(contentView,22).autoHeightRatio(0).topSpaceToView(contentView,10);
    
    _picContainerView.sd_layout
    .leftEqualToView(_newsTitle);
    
    _tagLabel.sd_layout.leftEqualToView(_newsTitle).topSpaceToView(_picContainerView,10).widthIs(50).heightIs(20);
    _lookNum.sd_layout.leftSpaceToView(_tagLabel,21).topEqualToView(_tagLabel).widthIs(150).heightIs(20);
    _timeLabel.sd_layout.rightSpaceToView(contentView,15).topEqualToView(_tagLabel).widthIs(100).heightIs(20);
    [self setupAutoHeightWithBottomView:_tagLabel bottomMargin:5];
}
-(void)setModel:(WorldNewsModel *)model
{
    CGFloat picContainerTopMargin = 0;
    NSMutableArray *photourl = [NSMutableArray array];
    for (NSDictionary *dic in model.PHOTOURL) {
        [photourl addObject:dic[@"PATH"]];
    }
    _picContainerView.picArray = photourl;
    if (model.PHOTOURL.count!=0) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_newsTitle, picContainerTopMargin);

    _tagLabel.text = [NSString stringWithFormat:@"%@",model.GROUPNAME];
    CGSize size=[_tagLabel boundingRectWithSize:CGSizeMake(0, 20)];
    _tagLabel.layer.borderColor =_tagLabel.textColor.CGColor;
    _tagLabel.sd_layout.widthIs(size.width+6);
    
    _newsTitle.text = [NSString stringWithFormat:@"%@",model.TITLE];
    size = [_newsTitle boundingRectWithSize:CGSizeMake(0, 20)];

    _timeLabel.text = model.SHOWTIME;
    size = [_timeLabel boundingRectWithSize:CGSizeMake(0, 20)];
    _timeLabel.sd_layout.widthIs(size.width);
    _lookNum.text = [NSString stringWithFormat:@"%@浏览",model.READCOUNT];
    size = [_lookNum boundingRectWithSize:CGSizeMake(0, 20)];
    _lookNum.sd_layout.widthIs(size.width);
    
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
