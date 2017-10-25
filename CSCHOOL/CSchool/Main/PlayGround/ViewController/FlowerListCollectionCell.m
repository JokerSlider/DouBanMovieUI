//
//  FlowerListCollectionCell.m
//  CSchool
//
//  Created by mac on 16/11/4.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "FlowerListCollectionCell.h"
#import "UIView+SDAutoLayout.h"
//#import "FlowerModel.h"
#import "UILabel+stringFrame.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation FlowerListCollectionCell
{
   UIImageView    *_flowerIcon;//鲜花icon
   UIImageView    *_messageIcon;//信息icon
   
}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        [self createView];
        self.layer.cornerRadius = 8;
    }
    return self;
}
-(void)createView
{
    self.photoImage =({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"placdeImage"];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.layer.cornerRadius= 4;
        view.layer.masksToBounds= YES;
        view.autoresizesSubviews = YES;
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [view setContentScaleFactor:[[UIScreen mainScreen] scale]];
        view.clipsToBounds  = YES;
        view;
    });
    _flowerIcon = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"flowerbtn"];
        view;
    });
    _messageIcon = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"liuyanbtn"];
        view;
    });
    self.flowerNum = ({
        UILabel *view = [UILabel new];
//        view.text = @"0";
        view.textColor = Base_Orange;
        view.font =Small_TitleFont;
        view;
    });
    self.messageNum = ({
        UILabel *view = [UILabel new];
//        view.text = @"0";
        view.textColor = Base_Orange;
        view.font =Small_TitleFont;
        view;
    });
    self.deleBtnPhoto = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"flowerDelete"] forState:UIControlStateNormal];
        view;
    });
    [self sd_addSubviews:@[self.photoImage,_flowerIcon,_messageNum,_messageIcon,_flowerNum,self.deleBtnPhoto]];
    self.photoImage.sd_layout.leftSpaceToView(self,0).topSpaceToView(self,0).rightSpaceToView(self,0).bottomSpaceToView(self,25);
    _flowerIcon.sd_layout.leftSpaceToView(self,10).topSpaceToView (self.photoImage,5).widthIs(15).heightIs(19);
    _flowerNum.sd_layout.leftSpaceToView(_flowerIcon,5).topSpaceToView(self.photoImage,6).widthIs(30).heightIs(15);
    _messageIcon.sd_layout.leftSpaceToView(_flowerNum,10).topSpaceToView(self.photoImage,7).widthIs(15).heightIs(15);
    _messageNum.sd_layout.leftSpaceToView(_messageIcon,5).topEqualToView(_flowerIcon).widthIs(30).heightIs(15);
    _deleBtnPhoto.sd_layout.rightSpaceToView(self,10).topSpaceToView(self.photoImage,5).widthIs(16).heightIs(19);
}
-(void)setModel:(PhotoCarModel *)model
{
    if (model.picUrl.length!=0) {
        NSString *urlStr = [model.picUrl stringByReplacingOccurrencesOfString:@"thumb/"withString:@""];
        model.picUrl = urlStr;
    }

    [_photoImage sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"placdeImage"]];

//    [_photoImage sd_setImageWithURL:[NSURL URLWithString:model.photoImgaurl] placeholderImage:[UIImage imageNamed:@"placdeImage"]];
    self.flowerNum.text = model.flowerNum;
    self.messageNum.text = model.commentNum;
    
    CGSize  size = [self.flowerNum boundingRectWithSize:CGSizeMake(0, 15)];
    self.flowerNum.sd_layout.widthIs(size.width);
    size = [self.messageNum boundingRectWithSize:CGSizeMake(0, 15)];
    self.messageNum.sd_layout.widthIs(size.width);
}
@end
