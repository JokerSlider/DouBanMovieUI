//
//  MyPriseHeadView.m
//  CSchool
//
//  Created by mac on 17/5/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "MyPriseHeadView.h"
#import "UIView+SDAutoLayout.h"
@implementation MyPriseHeadView
{
    UIImageView *_backImageV;
    UIImageView *_titleImageV;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}
-(void)setUpView
{
    _backImageV = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"myPriseBGV"];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view;
    });
    _titleImageV = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"myPirseTitle"];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view;
    });
    [self sd_addSubviews:@[_backImageV,_titleImageV]];
    _backImageV.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    _titleImageV.sd_layout.centerXIs(self.centerX).widthIs(223).heightIs(41).bottomSpaceToView(self,9);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
