//
//  HaveReturnCell.m
//  CSchool
//
//  Created by mac on 16/12/28.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "HaveReturnCell.h"
#import "UIView+SDAutoLayout.h"
#import "LibiraryModel.h"
#import "UILabel+stringFrame.h"
#import "CalenderObject.h"

@implementation HaveReturnCell
{
    UILabel *_bookName;//书名
    UILabel *_authorName;//作者
    UILabel *_pushofficeName;//出版社
    UILabel *_orderTime;//借书时间
    UILabel *_orderState;//状态


}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
-(void)setup
{
    _bookName = ({
        UILabel *view = [UILabel new];
        view.text = @"心理学";
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = Color_Black;
        view;
    });
    _authorName = ({
        UILabel *view = [UILabel new];
        view.text = @"作者                ";
        view.font = Title_Font;
        view.textColor = Color_Gray;
        view;
    });
    _pushofficeName = ({
        UILabel *view = [UILabel new];
        view.text = @"出版社            ";
        view.font = Title_Font;
        view.textColor = Color_Gray;
        view;
    });
    
    _orderTime = ({
        UILabel *view = [UILabel new];
        view.text = @"借书时间         ";
        view.font = Title_Font;
        view.textColor = Color_Gray;
        view;
    });
    _orderState = ({
        UILabel *view = [UILabel new];
        view.text = @"状态                已归还";
        view.font = Title_Font;
        view.textColor = Color_Gray;
        view;
    });
    [self.contentView sd_addSubviews:@[_bookName,_authorName,_pushofficeName,_orderTime,_orderState]];
    UIView *contentView = self.contentView;
    _bookName.sd_layout.leftSpaceToView(contentView,15).topSpaceToView(contentView,10).widthIs(kScreenWidth-20).heightIs(15);
    _authorName.sd_layout.leftEqualToView(_bookName).topSpaceToView(_bookName,6).widthIs(kScreenWidth-20).heightIs(15);
    _pushofficeName.sd_layout.leftEqualToView(_bookName).topSpaceToView(_authorName,6).widthIs(kScreenWidth).heightIs(15);
    _orderTime.sd_layout.leftEqualToView(_bookName).topSpaceToView(_pushofficeName,6).widthIs(kScreenWidth).heightIs(15);
    _orderState.sd_layout.leftEqualToView(_bookName).topSpaceToView(_orderTime,6).widthIs(kScreenWidth).heightIs(15);
    [self setupAutoHeightWithBottomView:_orderState bottomMargin:10];
}
-(void)setModel:(LibiraryModel *)model
{
    _model = model;
    _bookName.text =[NSString stringWithFormat:@"%@", model.bookName];
    _authorName.text =[NSString stringWithFormat:@"作者                %@",model.authorName];
    NSString *orderTime = [self dateString:model.orderTime];
    _orderTime.text = [NSString stringWithFormat:@"借书时间         %@",orderTime];
    _pushofficeName.text = [NSString stringWithFormat:@"出版社            %@",model.publishOfficeName];

//    CGSize size=[_bookName boundingRectWithSize:CGSizeMake(0, 15)];
//    _bookName.sd_layout.widthIs(size.width);
//    size = [_authorName boundingRectWithSize:CGSizeMake(0, 15)];
//    _authorName.sd_layout.widthIs(size.width);
  CGSize  size = [_pushofficeName boundingRectWithSize:CGSizeMake(0, 15)];
    _pushofficeName.sd_layout.widthIs(size.width);
    
    size = [_orderTime boundingRectWithSize:CGSizeMake(0, 15)];
    _orderTime.sd_layout.widthIs(size.width);
    size = [_orderState boundingRectWithSize:CGSizeMake(0, 15)];
    _orderState.sd_layout.widthIs(size.width);
}
-(NSString *)dateString:(NSString *)date
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"Asia/Beijing"]];
    [inputFormatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:date];
    
    [inputFormatter setLocale:[NSLocale currentLocale]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [inputFormatter stringFromDate:inputDate];
    return str;
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
