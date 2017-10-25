//
//  FindInfoHeaderView.m
//  CSchool
//
//  Created by mac on 16/10/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "FindInfoHeaderView.h"
#import "UIView+SDAutoLayout.h"
#import "FindLoseModel.h"
#import "UILabel+stringFrame.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation FindInfoHeaderView
{
    UIImageView *_photoImageV;//头像
    UILabel *_nameLabel;//姓名
    UILabel *_addressLabel;//地址+时间
    UILabel *_moneyLabel;//金钱额度
    UILabel *_tagLabel;//标签
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void)createView
{
    _photoImageV = [UIImageView new];
    _nameLabel = [UILabel new];
    _addressLabel = [UILabel new];
    _moneyLabel = [UILabel new];
    [self sd_addSubviews:@[_photoImageV,_nameLabel,_addressLabel,_moneyLabel]];
    
    _photoImageV.image = [UIImage imageNamed:@"list_head"];
    _photoImageV.clipsToBounds = YES;
    _photoImageV.layer.cornerRadius =35/2;
    
    _nameLabel.textColor = Color_Black;
    _nameLabel.text = @"";
    _nameLabel.font = Title_Font;
    
    _addressLabel.textColor = Color_Gray;
    _addressLabel.text = @"";
    _addressLabel.font = Small_TitleFont;
    
    _moneyLabel.textColor = [UIColor redColor];
    _moneyLabel.text = @"";
    _moneyLabel.font = Title_Font;
    
    CGFloat margin = 15;

    _photoImageV.sd_layout.leftSpaceToView(self,margin).topSpaceToView(self,margin).widthIs(35).heightIs(35);
    _nameLabel.sd_layout.leftSpaceToView(_photoImageV,5).topEqualToView(_photoImageV).heightIs(15).widthIs(44);
    _addressLabel.sd_layout.leftEqualToView(_nameLabel).topSpaceToView(_nameLabel,5).heightIs(15).widthIs(200);
    _moneyLabel.sd_layout.rightSpaceToView(self,margin).topSpaceToView(self,margin).heightIs(margin).widthIs(200);
}
-(void)setModel:(FindLoseModel *)model
{
    _model = model;
    AppUserIndex *user = [AppUserIndex GetInstance];
    //------------------------地址----------------------------//
    NSString *time = [self dateString:model.releaseTime];
    _addressLabel.text =[NSString stringWithFormat:@"%@  %@",model.addressName,time];
    //------------------------价格----------------------------//
    //失物招领
    if ([model.type isEqualToString:@"1"]) {
        _moneyLabel.text = @"";
    }else if([model.type isEqualToString:@"3"]){
        _moneyLabel.text =model.price?[NSString stringWithFormat:@"%@元/%@",model.price,model.priceType]:@"";
        if ([model.priceType isEqualToString:@"面议"]) {
            _moneyLabel.text =model.price?[NSString stringWithFormat:@"面议"]:@"";
        }
    }else{
        _moneyLabel.text =model.price?[NSString stringWithFormat:@"￥%@",model.price]:@"";
    }

    CGSize size=[_moneyLabel boundingRectWithSize:CGSizeMake(0, 15)];
    _moneyLabel.sd_layout.widthIs(size.width);
    size = [_addressLabel boundingRectWithSize:CGSizeMake(0, 15)];
    _addressLabel.sd_layout.widthIs(size.width);
    //------------------------姓名----------------------------//
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
    //------------------------------------头像--------------------------//
    NSString *breakString =[NSString stringWithFormat:@"/%@",model.thumb];
    NSString *photoUrl = [model.photoImageUrl stringByReplacingOccurrencesOfString:breakString withString:@""];
    [_photoImageV sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"list_head"]];


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
@end
