//
//  PhotoCarView.m
//  CSchool
//
//  Created by 左俊鑫 on 16/10/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PhotoCarView.h"
#import "SDAutoLayout.h"
#import "UILabel+stringFrame.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PhotoCarModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"picUrl":@"PWBURL",
        @"headerUrl":@"TXDZ",
        @"name":@"NC",
        @"school":@"SDS_NAME",
        @"flowerNum":@"PWBFLOWERSNUMBER",
        @"picId":@"PWBID",
        @"userSex":@"XBM",
        @"listNum":@"PHH",
        @"commentNum":@"PWBTOTALNUMBER",
        @"photoID":@"PWBID",
        @"publishTime":@"PWBCREATETIME"
    };
}

-(void)setPicUrl:(NSString *)picUrl{
    _picUrl = [picUrl stringByReplacingOccurrencesOfString:@"/thumb" withString:@""];
}

- (void)setHeaderUrl:(NSString *)headerUrl{
    _headerUrl = [headerUrl stringByReplacingOccurrencesOfString:@"/thumb" withString:@""];
}

@end

@implementation PhotoCarView
{
    UIImageView *_picView;
    
    UIView *_bootomView;
    UIImageView *_headerView;
    UILabel *_nameLabel;
    UILabel *_schoolLabel;
    UIImageView *_sexImageView;
    UIImageView *_flowerImageView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    _picView = ({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view;
    });
    
    _bootomView = ({
        UIView *view = [UIView new];
        view;
    });
    
    [self sd_addSubviews:@[_picView, _bootomView]];
    
    _nameLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(51, 51, 51);
        view.font = [UIFont systemFontOfSize:15];
        view.textAlignment = NSTextAlignmentLeft;
        view;
    });
    
    _schoolLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(51, 51, 51);
        view.font = [UIFont systemFontOfSize:12];

        view;
    });
    
    _flowerNumLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = Base_Orange;
        view.font = [UIFont systemFontOfSize:17];
        view.text = @"0";
        view.textAlignment = NSTextAlignmentRight;
        view;
    });
    
    _headerView = ({
        UIImageView *view = [UIImageView new];
        view;
    });
    
    _sexImageView = ({
        UIImageView *view = [UIImageView new];
        view;
    });
    
    _flowerImageView = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"photoWall_flower_s"];
        view;
    });
    
    [_bootomView sd_addSubviews:@[_nameLabel, _schoolLabel, _flowerImageView, _flowerNumLabel, _headerView, _sexImageView]];
    
//    _picView.backgroundColor = [UIColor redColor];
    _bootomView.backgroundColor = [UIColor whiteColor];
}

- (void)cc_layoutSubviews {
    
    CGFloat bootomHeight = self.frame.size.height*(10.0/45.0);
    
    _picView.frame   = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*(35.0/45.0));
    _bootomView.frame = CGRectMake(0, self.frame.size.height - self.frame.size.height*(10.0/45.0), self.frame.size.width, self.frame.size.height*(10.0/45.0));
    _headerView.sd_layout
    .leftSpaceToView(_bootomView,17)
    .centerYEqualToView(_bootomView)
    .widthIs(LayoutHeightCGFloat(40))
    .heightIs(LayoutHeightCGFloat(40));

    _headerView.sd_cornerRadius = @(LayoutHeightCGFloat(20));
    
    _nameLabel.sd_layout
    .leftSpaceToView(_bootomView,10+LayoutHeightCGFloat(40)+17)
    .topSpaceToView(_bootomView, (bootomHeight -LayoutHeightCGFloat(40))/2)
    .heightIs(LayoutHeightCGFloat(14))
    .maxWidthIs(200);
    
    _schoolLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .heightIs(LayoutHeightCGFloat(12))
    .widthIs(180)
    .bottomEqualToView(_headerView);
    
    _sexImageView.sd_layout
    .leftSpaceToView(_nameLabel,2)
    .centerYEqualToView(_nameLabel)
    .widthIs(17)
    .heightIs(17);
    
    _flowerNumLabel.sd_layout
    .centerYEqualToView(_bootomView)
    .rightSpaceToView(_bootomView,5)
    .maxWidthIs(100)
    .heightIs(13);
    
    _flowerImageView.sd_layout
    .rightSpaceToView(_flowerNumLabel,5)
    .centerYEqualToView(_bootomView)
    .widthIs(18)
    .heightIs(21);
}

-(void)setModel:(PhotoCarModel *)model{
    _model = model;
    
    _nameLabel.text = _model.name;
    CGSize size=[_nameLabel boundingRectWithSize:CGSizeMake(0, 21)];
    _nameLabel.sd_layout.widthIs(size.width);
    
    _flowerNumLabel.text = _model.flowerNum;
    CGSize size1=[_flowerNumLabel boundingRectWithSize:CGSizeMake(0, 21)];
    _flowerNumLabel.sd_layout.widthIs(size1.width);
    
    _schoolLabel.text = _model.school;
    
    _sexImageView.image = ([_model.userSex isEqualToString:@"1"])?[UIImage imageNamed:@"photoWall_boy"]:(([_model.userSex isEqualToString:@"2"]?[UIImage imageNamed:@"photoWall_girl"]:[UIImage imageNamed:@""]));

    
    [_picView sd_setImageWithURL:[NSURL URLWithString:_model.picUrl] placeholderImage:PlaceHolder_Image];
    
    [_headerView sd_setImageWithURL:[NSURL URLWithString:_model.headerUrl] placeholderImage:PlaceHolder_Image];

}

@end
