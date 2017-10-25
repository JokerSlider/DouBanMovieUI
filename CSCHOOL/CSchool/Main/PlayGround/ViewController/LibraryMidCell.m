//
//  LibraryMidCell.m
//  CSchool
//
//  Created by mac on 16/12/26.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "LibraryMidCell.h"
#import "UIView+SDAutoLayout.h"
#import "UILabel+stringFrame.h"
#import "UILabel+stringFrame.h"
#define MyFont [UIFont systemFontOfSize:12.0f]
@implementation LibraryMidCell
{
    UILabel *_bookName;
    UILabel *_authorName;//作者
    UILabel *_orderNum;//借阅次数
    UIImageView *_listNum;//排行
    
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
    CGFloat margin = 15;
    _bookName = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(85, 85, 85);
        view.text = @"";
        view.font = [UIFont systemFontOfSize:15.0f];
        view;
    });
    _authorName = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(153, 153, 153);
        view.text = @"作者:";
        view.font = MyFont;
        view;
    });
    _orderNum = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(153, 153, 153);
        view.text = @"借阅次数:";
        view.font = MyFont;
        view;
    });
    _listNum = ({
        UIImageView *view = [UIImageView new];
        view.image  = [UIImage imageNamed:@"flower1"];
        view;
    });
    UIView *contentView = self.contentView;
    [contentView sd_addSubviews:@[_bookName,_orderNum,_authorName,_listNum]];
    _bookName.sd_layout.leftSpaceToView(contentView,15).topSpaceToView(contentView,5).heightIs(15).widthIs(kScreenWidth-70);
    _authorName.sd_layout.leftEqualToView(_bookName).topSpaceToView(_bookName,5).heightIs(15).widthIs(kScreenWidth-70);
    _orderNum.sd_layout.leftEqualToView(_bookName).topSpaceToView(_authorName,5).heightIs(15).widthIs(100);
    _listNum.sd_layout.rightSpaceToView(contentView,margin).topSpaceToView(contentView,3).widthIs(30).heightIs(30);
    [self setupAutoHeightWithBottomView:_orderNum bottomMargin:5];
}
-(void)setModel:(LibiraryModel *)model
{
    _model  = model;
    _bookName.text = [NSString stringWithFormat:@"%@",model.bookName];
    _authorName.text = [NSString stringWithFormat:@"作者:%@",model.authorName];
    _orderNum.text = [NSString stringWithFormat:@"借阅次数:%@",model.NUM];
    
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
