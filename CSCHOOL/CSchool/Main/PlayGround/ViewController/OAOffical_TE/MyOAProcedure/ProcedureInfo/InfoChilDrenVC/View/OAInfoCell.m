//
//  OAInfoCell.m
//  CSchool
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OAInfoCell.h"
#import "UIView+SDAutoLayout.h"
@implementation OAInfoCell
{
    UILabel *_titleL;
    UILabel *_subtitlL;//副标题
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    _titleL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:14];
        view.textColor = RGB(85, 85, 85);
        view;
    });
    
    _subtitlL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:14];
        view.textColor = RGB(85, 85, 85);
        view.textAlignment = NSTextAlignmentRight;
        view;
    });
    
    UIView *contentView = self.contentView;
    
    [self.contentView sd_addSubviews:@[_titleL,_subtitlL]];
    _titleL.sd_layout.leftSpaceToView(contentView,14).topSpaceToView(contentView,7.5).widthIs(100).heightIs(15);
    _subtitlL.sd_layout.leftSpaceToView(_titleL,30).topEqualToView(_titleL).autoHeightRatio(0).rightSpaceToView(contentView,20);
    [self setupAutoHeightWithBottomView:_subtitlL bottomMargin:10];
    
}

-(void)setModel:(OAModel *)model
{
    _model = model;
    _titleL.text = model.colume_description;
    
    CGSize size = [_titleL boundingRectWithSize:CGSizeMake(0, 15)];
    _titleL.sd_layout.widthIs(size.width);
    
    _subtitlL.text = model.o_value;
    
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
