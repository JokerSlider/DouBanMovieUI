
//
//  FlowerListCell.m
//  CSchool
//
//  Created by mac on 16/10/31.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "FlowerListCell.h"
#import "UIView+SDAutoLayout.h"
#import "UILabel+stringFrame.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface FlowerListCell()
{
    UIImageView *_phoToimage;//头像
    UILabel     *_Name;//姓名
    UILabel     *_address;//地址
    UIImageView    *_sexImage;//性别
    UIImageView *_listView;//榜单
    UILabel     *_floweNum;//鲜花数
    NSArray     *_listImagerArr;//
    NSArray     *_sexNameArr;//

    
}
@end

@implementation FlowerListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setView];
    }
    return self;
}


-(void)setView
{
    
    _phoToimage = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"placdeImage"];

        view;
    });
    _Name = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:13.0];
        view.textColor = Color_Black;
        view.text = @"个人昵称";
        view;
    });
    _sexImage = ({
        UIImageView *view = [UIImageView new];
        view;
    });
    _address =({
        UILabel *view = [UILabel new];
        view.textColor = Color_Gray;
        view.font = Small_TitleFont;
//        view.text = @"山东师范大学";
        view;
    });
    _listView = ({
        UIImageView *view = [UIImageView new];
        view;
    });
    _floweNum = ({
        UILabel *view = [UILabel new];
        view.textColor = Base_Orange;
        view.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:13.0];
        view.text = @"鲜花数:0";
        view;
    });
    [self.contentView sd_addSubviews:@[_address,_phoToimage,_sexImage,_Name,_floweNum,_listView,]];
    UIView *contentView = self.contentView;
    CGFloat  margin = 10;
    _phoToimage.sd_layout.leftSpaceToView(contentView,margin).topSpaceToView(contentView,margin).widthIs(80).heightIs(80);
    _Name.sd_layout.leftSpaceToView(_phoToimage,5).topEqualToView(_phoToimage).widthIs(100).heightIs(15);
    _sexImage.sd_layout.leftSpaceToView(_Name,3).topEqualToView(_Name).widthIs(15).heightIs(15);
    _address.sd_layout.leftEqualToView(_Name).bottomSpaceToView(contentView,margin).widthIs(100).heightIs(15);
    _listView.sd_layout.rightSpaceToView(contentView,30).topSpaceToView(contentView,0).widthIs(30).heightIs(30);
    _floweNum.sd_layout.rightSpaceToView(contentView,15).widthIs(100).heightIs(15).bottomEqualToView(_address);
}
-(void)setModel:(PhotoCarModel *)model
{
    _Name.text = model.name;
    _floweNum.text = [NSString stringWithFormat:@"鲜花数:%@",model.flowerNum];
    _address.text = [NSString stringWithFormat:@"%@",model.school];
    
    CGSize size = [_Name boundingRectWithSize:CGSizeMake(0, 15)];
    _Name.sd_layout.widthIs(size.width);
    
    size = [_floweNum boundingRectWithSize:CGSizeMake(0, 15)];
    _floweNum.sd_layout.widthIs(size.width);
    
    size = [_address boundingRectWithSize:CGSizeMake(0, 15)];
    _address.sd_layout.widthIs(size.width);
    
    
    _listImagerArr = @[@"flower1",@"flower2",@"flower3",@"flower4",@"flower5",@"flower6",@"flower7",@"flower8",@"flower9",@"flower10"];
    //排行榜图片
    int i = [model.listNum intValue];
    if (i<=10) {
        _listView.image = [UIImage imageNamed:_listImagerArr[i-1]];
    }

    
    if ([model.userSex isEqualToString:@"2"]) {
        _sexImage.image = [UIImage imageNamed:@"photoWall_girl"];
    }else if([model.userSex isEqualToString:@"1"]){
        _sexImage.image = [UIImage imageNamed:@"photoWall_boy"];
    }else{
        
    }
    if (model.picUrl.length!=0) {
        NSString *urlStr = [model.picUrl stringByReplacingOccurrencesOfString:@"thumb/"withString:@""];
        model.picUrl = urlStr;
    }
    [_phoToimage sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"placdeImage"]];
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
