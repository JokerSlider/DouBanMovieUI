//
//  LibraryBottomCell.m
//  CSchool
//
//  Created by mac on 16/12/26.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "LibraryBottomCell.h"
#import "UIView+SDAutoLayout.h"
#import "UILabel+stringFrame.h"
#import "UILabel+stringFrame.h"
#import <SDWebImage/UIImageView+WebCache.h>
#define MyFont [UIFont systemFontOfSize:12.0f]

@implementation LibraryBottomCell
{
    UILabel *_bookName;
    UILabel *_authorName;//累计借阅量
    UILabel *_orderNum;//当前借阅量
  
    UIImageView *_photoImageV;//头像
    
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
    _photoImageV = ({
        UIImageView *view = [UIImageView new];
        view.image  = [UIImage imageNamed:@"rentou"];
        view.clipsToBounds = YES;
        view.layer.cornerRadius = 25;
        view;
    });
    _bookName = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(85, 85, 85);
        view.text = @"";
        view.font = [UIFont systemFontOfSize:15];
        view;
    });
    _authorName = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(153, 153, 153);
        view.text = @"累计借阅量:";
        view.font = MyFont;
        view;
    });
    _orderNum = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(153, 153, 153);
        view.text = @"当前借阅量:";
        view.font = MyFont;
        view;
    });
    _listNum = ({
        UIImageView *view = [UIImageView new];
        view.image  = [UIImage imageNamed:@"flower1"];
        view;
    });
    UIView *contentView = self.contentView;
    [contentView sd_addSubviews:@[_bookName,_orderNum,_authorName,_listNum,_photoImageV]];
    _photoImageV.sd_layout.leftSpaceToView(contentView,12).topSpaceToView(contentView,10).widthIs(50).heightIs(50);
    _bookName.sd_layout.leftSpaceToView(_photoImageV,11).topSpaceToView(contentView,10).heightIs(15).widthIs(kScreenWidth-70);
    _authorName.sd_layout.leftEqualToView(_bookName).topSpaceToView(_bookName,5).heightIs(15).widthIs(kScreenWidth-70);
    _orderNum.sd_layout.leftEqualToView(_bookName).topSpaceToView(_authorName,5).heightIs(15).widthIs(100);
    _listNum.sd_layout.rightSpaceToView(contentView,margin).topSpaceToView(contentView,5).widthIs(30).heightIs(30);
    [self setupAutoHeightWithBottomView:_orderNum bottomMargin:5];

}
-(void)setModel:(LibiraryModel *)model
{
    _bookName.text = [NSString stringWithFormat:@"%@",model.NAME];
    _authorName.text = [NSString stringWithFormat:@"累计借阅量:%@",model.TOTAL_LEND_QTY];
    _orderNum.text = [NSString stringWithFormat:@"当前借阅量:%@",model.NOW_LEND_QYT];
    NSString *breakString =@"/thumb";
    NSString *photoUrl = [model.TXDZ stringByReplacingOccurrencesOfString:breakString withString:@""];
    [_photoImageV sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"rentou"]];
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
