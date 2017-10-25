//
//  FindLose2Cell.m
//  CSchool
//
//  Created by mac on 16/10/9.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "FindLose2Cell.h"
#import "UIView+SDAutoLayout.h"
#import "FindLoseModel.h"
#import "UILabel+stringFrame.h"
#import "CustomizedPaddingLabel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FindLose2Cell()
@property (nonatomic,strong) PhotoBroswerView *picContainerView;
@end
@implementation FindLose2Cell
{
    UILabel *_titleLabel;
    NSArray *_imageViewsArray;
    UILabel *_addressLabel;//地点
    UILabel *_pushTimeLabel;
    CustomizedPaddingLabel *_tagLabel;//标签
    UILabel *_priceLabel;//价格
    UILabel *_nameLabel;//姓名
    UIImageView *_photoView;//头像
    
    CustomizedPaddingLabel *_typeTag;//类型标签
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
    _titleLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = [UIColor darkGrayColor];
        view.font = Title_Font;
        view;
    });
    _addressLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Gray;
        view.text = @"地址暂无";
        view.font = Small_TitleFont;
        view;
    });
    _tagLabel = ({
        CustomizedPaddingLabel *view =[CustomizedPaddingLabel new];
        view.layer.borderWidth = 0.5;
        view.layer.cornerRadius = 3;
        view.font = Small_TitleFont;
        view;
    });
    _typeTag= ({
        CustomizedPaddingLabel *view =[CustomizedPaddingLabel new];
        view.layer.borderWidth = 0.5;
        view.layer.cornerRadius = 3;
        view.layer.borderColor = [UIColor purpleColor].CGColor;
        view.textColor = [UIColor purpleColor];
        view.font = Small_TitleFont;
        view;
    });
    _picContainerView = [PhotoBroswerView new];
    _priceLabel = ({
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
    UIView *contentView = self.contentView;
    [_titleLabel addSubview:_tagLabel];
    [_titleLabel addSubview:_typeTag];
    [contentView sd_addSubviews:@[_priceLabel,_addressLabel,_titleLabel,_picContainerView,_photoView,_nameLabel]];
// 设置等宽的子view
    CGFloat margin = 15;
    _photoView.sd_layout.leftSpaceToView(contentView,margin).topSpaceToView(contentView,margin).heightIs(35).widthIs(35);
    _nameLabel.sd_layout.leftSpaceToView(_photoView,5).topEqualToView(_photoView).heightIs(15).widthIs(44);
    _addressLabel.sd_layout.leftEqualToView(_nameLabel).topSpaceToView(_nameLabel,5).heightIs(15).widthIs(200);
    _priceLabel.sd_layout.rightSpaceToView(contentView,margin).topSpaceToView(contentView,margin).heightIs(15).widthIs(200);
    
    _typeTag.sd_layout.
    leftSpaceToView(_titleLabel,0)
    .topSpaceToView(_titleLabel,margin+10)
    .widthIs(52).heightIs(15);
    
    _tagLabel.sd_layout.
    leftSpaceToView(_typeTag,1)
    .topSpaceToView(_titleLabel,margin+10)
    .widthIs(50).heightIs(15);
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(_photoView,margin/2)
    .rightSpaceToView(contentView, margin/2).heightIs(30).autoHeightRatio(0);
    
    _picContainerView.sd_layout
    .leftEqualToView(_titleLabel);
}

- (void)setModel:(FindLoseModel *)model
{
    _model = model;
    //----------------------------------------头像-------------------------------------//
    NSString *breakString =[NSString stringWithFormat:@"/%@",model.thumb];
    NSString *photoUrl = [model.photoImageUrl stringByReplacingOccurrencesOfString:breakString withString:@""];
    [_photoView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"list_head"]];

    CGSize size=[_priceLabel boundingRectWithSize:CGSizeMake(0, 15)];
    _priceLabel.sd_layout.widthIs(size.width);
    //缩略图
    CGFloat picContainerTopMargin = 0;
    _picContainerView.breakString = breakString;
    _picContainerView.picArray = model.thumblicArray;
    if (model.thumblicArray.count!=0) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_titleLabel, picContainerTopMargin);
    
    [self setupAutoHeightWithBottomView:_picContainerView bottomMargin:10];

    NSString *time = [self dateString:model.releaseTime];
    _addressLabel.text =[NSString stringWithFormat:@"%@  %@",model.addressName,time];
    size=[_addressLabel boundingRectWithSize:CGSizeMake(0, 15)];
    _addressLabel.sd_layout.widthIs(size.width);

    
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
    size = [_priceLabel boundingRectWithSize:CGSizeMake(0, 15)];
    _priceLabel.sd_layout.widthIs(size.width);
    
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
     //二手市场标签计算
    NSString *title;
    NSMutableString *string = [[NSMutableString alloc]initWithString:@""];
   
    _tagLabel.text = [NSString stringWithFormat:@"%@",model.tagName];
    size=[_tagLabel boundingRectWithSize:CGSizeMake(0, 15)];
    _tagLabel.textColor = [self getTagColor:model.tagName];
    _tagLabel.layer.borderColor =_tagLabel.textColor.CGColor;
    
    _typeTag.sd_layout.
    leftSpaceToView(_titleLabel,0)
    .topSpaceToView(_titleLabel,15+10)
    .widthIs(0).heightIs(15);
    
    _tagLabel.sd_layout.
    leftSpaceToView(_titleLabel,0)
    .topSpaceToView(_titleLabel,15+10)
    .widthIs(size.width+6).heightIs(15);
    
    if ([model.type isEqualToString:@"2"]) {
        if (model.tagName.length==0) {
            _tagLabel.hidden = YES;
        }else{
            _tagLabel.hidden = NO;
        }
    }else{
        _tagLabel.hidden = YES;
        
    }

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
    
    if (![model.isSearch isEqualToString:@"1"]) {
        _typeTag.hidden = YES;
        return;
    }
    _typeTag.hidden = NO;
    _typeTag.sd_layout.
    leftSpaceToView(_titleLabel,0)
    .topSpaceToView(_titleLabel,25)
    .widthIs(52).heightIs(15);
    
    _tagLabel.sd_layout.
    leftSpaceToView(_typeTag,1)
    .topSpaceToView(_titleLabel,25)
    .widthIs(size.width+6).heightIs(15);
    
    switch ([model.type intValue]) {
            //失物招领
        case 1:
        {
            if ([model.infoType isEqualToString:@"1"]) {
                _typeTag.text = @"寻物启事";
            }else{
                _typeTag.text = @"招领启事";

            }
        }
            break;
            //二手市场
        case 2:
        {
            if ([model.infoType isEqualToString:@"1"]) {
                _typeTag.text = @"闲置市场";

            }else{
                _typeTag.text = @"求购市场";

            }
        }
            break;
            //兼职招聘
            case 3:
        {
            if ([model.infoType isEqualToString:@"1"]) {
                _typeTag.text = @"招聘专区";

            }else{
                _typeTag.text = @"求职市场";
            }
        }
            break;
        default:
            break;
    }
    
    if (_typeTag.text.length!=0) {
        for (int i = 0; i<=_typeTag.text.length+2; i++) {
            [string  appendString: @"  "];
            string = string;
        }
        [string appendString:@" "];
        title = [NSString stringWithFormat:@"%@%@",string,model.title];
        _titleLabel.text  = title;
        _tagLabel.sd_layout.leftSpaceToView(_typeTag,1).topSpaceToView(_titleLabel,0);
        _typeTag.sd_layout.topSpaceToView(_titleLabel,0);
    }else{
        _titleLabel.text = model.title;
    }

    
}
-(NSString *)dateString:(NSString *)date
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:date];
    
    [inputFormatter setLocale:[NSLocale currentLocale]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *str = [inputFormatter stringFromDate:inputDate];
    return str;
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
@end
