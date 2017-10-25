//
//  MyPublishCell.m
//  CSchool
//
//  Created by mac on 16/10/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MyPublishCell.h"
#import "UIView+SDAutoLayout.h"
#import "FindLoseModel.h"
#import "UILabel+stringFrame.h"
#import "CustomizedPaddingLabel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyPublishCell()

@end
@implementation MyPublishCell
{
    UILabel *_titleLabel;
    NSArray *_imageViewsArray;
    UILabel *_addressLabel;//地点
    UILabel *_pushTimeLabel;
    CustomizedPaddingLabel *_tagLabel;//标签
    UILabel *_priceLabel;//价格
    UILabel *_nameLabel;//姓名
    UIImageView *_photoView;//头像
    UIView *_sepView;//分割线
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _titleLabel =({
        UILabel *view = [UILabel new];
        view.textColor = [UIColor darkGrayColor];
        view.font = Title_Font;
        view;
    });
    _addressLabel = ({
        UILabel *view = [UILabel new];
        view.font = Small_TitleFont;
        view.textColor = Color_Gray;
        view.text = @"";
        view.font = Small_TitleFont;

        view;
    });
    _tagLabel = ({
        CustomizedPaddingLabel *view = [CustomizedPaddingLabel new];
        view.layer.borderWidth = 0.5;
        view.layer.cornerRadius = 3;
        view.layer.borderColor = [UIColor purpleColor].CGColor;
        view.textColor = [UIColor purpleColor];
        view.font = Small_TitleFont;
        view;
    });
    _picContainerView = [PhotoBroswerView new];
    
    _priceLabel =({
        UILabel *view = [UILabel new];
        view.textColor = [UIColor redColor];
        view.text = @"";
        view.font = Title_Font;
        view;
    });
    _photoView = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"list_head"];
        view.clipsToBounds = YES;
        view.layer.cornerRadius =35/2;
        view;
    });
    _nameLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.text = @"";
        view.font = Title_Font;
        view;
    });
    
    _sepView = ({
        UIView *view = [UIView new];
        view.backgroundColor =  Base_Color2;
        view;
    });
    //三个按钮
    _dropMenu =({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.layer.cornerRadius = 3;
        view.layer.borderColor = Base_Orange.CGColor;
        view.layer.borderWidth = 1;
        view.titleLabel.font = Small_TitleFont;
        [view setTitleColor:Base_Orange forState:UIControlStateNormal];
        [view setTitleColor:Base_Orange forState:UIControlStateSelected];
        view;
    });
    
    _editMenu = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.layer.cornerRadius = 3;
        view.layer.borderColor = Base_Orange.CGColor;
        view.layer.borderWidth = 1;
        [view setTitle:@"编辑" forState:UIControlStateNormal];
        [view setTitleColor:Base_Orange forState:UIControlStateNormal];
        view.titleLabel.font = Small_TitleFont;
        view;
    });
    _deletMenu = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.layer.cornerRadius = 3;
        view.layer.borderColor = [UIColor redColor].CGColor;
        view.layer.borderWidth = 1;
        //设置字体大小
        view.titleLabel.font = Small_TitleFont;
        [view setTitle:@"删除" forState:UIControlStateNormal];
        [view setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        view;
    });

    _dropNoticeView  = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"dropView"];
        view.userInteractionEnabled = YES;
        view;
    });
    UIView *contentView = self.contentView;
    [contentView sd_addSubviews:@[_sepView,_priceLabel,_addressLabel,_picContainerView,_titleLabel,_photoView,_nameLabel,_dropMenu,_editMenu,_deletMenu,_dropNoticeView ]];
    [_titleLabel addSubview:_tagLabel];
    // 设置等宽的子view
    self.contentView.sd_equalWidthSubviews = _imageViewsArray;
    CGFloat margin = 15;
    _photoView.sd_layout.leftSpaceToView(contentView,margin).topSpaceToView(contentView,margin).heightIs(35).widthIs(35);
    _nameLabel.sd_layout.leftSpaceToView(_photoView,5).topEqualToView(_photoView).heightIs(15).widthIs(44);
    _addressLabel.sd_layout.leftEqualToView(_nameLabel).topSpaceToView(_nameLabel,5).heightIs(15).widthIs(200);
    _priceLabel.sd_layout.rightSpaceToView(contentView,margin).topSpaceToView(contentView,margin).heightIs(15).widthIs(200);
    
    _tagLabel.sd_layout.
    leftSpaceToView(_titleLabel,0)
    .topSpaceToView(_titleLabel,margin+20)
    .widthIs(50).heightIs(15);
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(_photoView,margin/2)
    .rightSpaceToView(contentView, margin/2).heightIs(30).autoHeightRatio(0);
    
    _picContainerView.sd_layout
    .leftEqualToView(_titleLabel);
    
    _deletMenu.sd_layout.rightSpaceToView(contentView,margin).bottomSpaceToView(contentView,5).widthIs(50).heightIs(20);
    _editMenu.sd_layout.rightSpaceToView(_deletMenu,margin).bottomEqualToView(_deletMenu).widthIs(50).heightIs(20);
    _dropMenu.sd_layout.rightSpaceToView(_editMenu,margin).bottomEqualToView(_deletMenu).widthIs(50).heightIs(20);
    
    _sepView.sd_layout
    .leftSpaceToView(contentView,margin)
    .bottomSpaceToView(_deletMenu,5)
    .rightSpaceToView(contentView,margin)
    .heightIs(0.5);
    
    _tagLabel.layer.borderColor =_tagLabel.textColor.CGColor;
    
    _dropNoticeView.sd_layout.rightSpaceToView(_priceLabel,20).topEqualToView(_priceLabel).widthIs(60).heightIs(35);
}

- (void)setModel:(FindLoseModel *)model
{
    _model = model;
    [_dropMenu setTitle:@"撤销" forState:UIControlStateNormal];
    [_dropMenu setTitle:@"重新发布" forState:UIControlStateSelected];
    if ([model.state isEqualToString:@"2"]) {
        _dropMenu.selected = NO;
        _dropMenu.layer.borderColor = Base_Orange.CGColor;
        _dropNoticeView.hidden = !_dropMenu.selected;
    }else{
        _dropMenu.selected = YES;
        _dropMenu.layer.borderColor = Base_Orange.CGColor;
        _dropNoticeView.hidden =!_dropMenu.selected;
    }
    
    //失物招领
    if ([model.type isEqualToString:@"1"]) {
        _priceLabel.text = @"";
    }else if([model.type isEqualToString:@"3"]){
        _priceLabel.text =model.price?[NSString stringWithFormat:@"%@元/%@",model.price,model.priceType]:@"";
        if ([model.priceType isEqualToString:@"面议"]) {
            _priceLabel.text =model.price?[NSString stringWithFormat:@"面议"]:@"";
        }
    }else{
        _priceLabel.text =model.price?[NSString stringWithFormat:@"￥%@",model.price]:@"";
    }

    CGSize size=[_priceLabel boundingRectWithSize:CGSizeMake(0, 15)];
    _priceLabel.sd_layout.widthIs(size.width);
    //缩略图
    
    NSString *breakString =[NSString stringWithFormat:@"/%@",model.thumb];
    _picContainerView.breakString = breakString;
    _picContainerView.picArray = model.thumblicArray;
    CGFloat picContainerTopMargin = 0;
    if (model.thumblicArray.count) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_titleLabel, picContainerTopMargin);
    
    [self setupAutoHeightWithBottomView:_picContainerView bottomMargin:40];
    NSString *time = [self dateString:model.releaseTime];
    _addressLabel.text =[NSString stringWithFormat:@"%@  %@",model.addressName,time];
    size=[_addressLabel boundingRectWithSize:CGSizeMake(0, 15)];
    _addressLabel.sd_layout.widthIs(size.width);
    //功能类型 来决定标签的显示与隐藏
    if ([model.type isEqualToString:@"2"]) {
        if (model.tagName.length==0) {
            _tagLabel.hidden = YES;
        }else{
            _tagLabel.hidden = NO;
        }
    }else{
        _tagLabel.hidden = YES;
        
    }
    //------------------------------ 标签 ---------------------------//

    _tagLabel.text = [NSString stringWithFormat:@"%@",model.tagName];
    size=[_tagLabel boundingRectWithSize:CGSizeMake(0, 15)];
    _tagLabel.sd_layout.widthIs(size.width+6);
    _tagLabel.textColor = [self getTagColor:model.tagID];
    _tagLabel.layer.borderColor =_tagLabel.textColor.CGColor;

    NSString *title;
    NSMutableString *string = [[NSMutableString alloc]initWithString:@""];
    if (_tagLabel.text.length!=0) {
        for (int i = 0; i<=_tagLabel.text.length; i++) {
            [string  appendString: @"   "];
            string = string;
        }
        title = [NSString stringWithFormat:@"%@%@",string,model.title];
        _titleLabel.text  = title;
        _tagLabel.sd_layout.topSpaceToView(_titleLabel,0);
    }else{
        _titleLabel.text = model.title;
    }
    //姓名 取第一个姓
    NSString *Name =model.name;
    if ([Name isEqualToString:@"某某某"]||[Name isEqualToString:@""]) {
        _nameLabel.text = [NSString stringWithFormat:@"%@",model.nickName]; // 暂时注释掉
        size = [_nameLabel boundingRectWithSize:CGSizeMake(0, 15)];
        _nameLabel.sd_layout.widthIs(size.width);
    }else{
        if (Name.length>0) {
            Name = [Name substringToIndex:1];//
            Name = [NSString stringWithFormat:@"%@同学",Name];
            _nameLabel.text = Name; // 暂时注释掉
            size = [_nameLabel boundingRectWithSize:CGSizeMake(0, 15)];
            _nameLabel.sd_layout.widthIs(size.width);
        }
    }
    //---------------------------头像----------------------//
    NSString *photoUrl = [model.photoImageUrl stringByReplacingOccurrencesOfString:breakString withString:@""];
    [_photoView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"list_head"]];
}

-(UIColor *)getTagColor:(NSString *)tagName
{
    if ([tagName isEqualToString:@"生活用品"]) {
        return RGB(255, 119, 83);
    }else if ([tagName isEqualToString:@"电子产品"]){
        return RGB(22, 176, 247);
    }else if ([tagName isEqualToString:@"学习用品"]){
        return RGB(90, 159, 81);
    }else{
        return RGB(35, 98, 192);
    }
    
    return [UIColor purpleColor];
}
-(NSString *)dateString:(NSString *)date
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"Asia/Shanghai"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:date];
    
    [inputFormatter setLocale:[NSLocale currentLocale]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
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
