//
//  MemberListHeaderView.m
//  CSchool
//
//  Created by mac on 17/2/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "MemberListHeaderView.h"
#import "UIView+SDAutoLayout.h"
@implementation MemberListHeaderView
{
//    UILabel *_memberName;//成员名
//    UILabel *_memberNum;//成员线数量
}
-(instancetype )initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createView];
        self.userInteractionEnabled = YES;
    }
    return self;
}
-(void)createView
{
    _memberName = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = Color_Black;
        view;
    });
    _memberNum = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(0, 0, 0);
        view;
    });
    _imageView = ({
        UIImageView *view = [UIImageView new];
        [view setImage:[UIImage imageNamed:@"rightMember"]];
        view;
    });
    _tap_button = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.frame = self.frame;
        view;
    });
    
    [self sd_addSubviews:@[_memberName,_memberNum,_imageView,_tap_button]];
    _memberName.sd_layout.leftSpaceToView(self,10).centerYIs(self.centerY).widthIs(100).heightIs(15);
    _memberNum.sd_layout.leftSpaceToView(_memberName,5).centerYIs(self.centerY).widthIs(50).heightIs(12);
    _imageView.sd_layout.rightSpaceToView(self,10).centerYIs(self.centerY).widthIs(8).heightIs(14);
}
-(void)setModel:(ChatModel *)model
{
    _model = model;
    _memberNum.text = [NSString stringWithFormat:@"%@/%@",model.onlineCount,model.totalCount];
    _memberName.text = model.groupName;
    CGSize size = [_memberName boundingRectWithSize:CGSizeMake(0, 15)];
    _memberName.sd_layout.widthIs(size.width);
}
//调整箭头位置
-(void)tranformImgaelocation:(BOOL)state
{
    if (!state) {
//        self.imageView.transform = CGAffineTransformMakeRotation(-M_PI/4);
    } else {
        _imageView.sd_layout.widthIs(14).heightIs(8);

        _imageView.transform = CGAffineTransformMakeRotation(M_PI/2);
    }

}
@end
