//
//  GropUserInfoCollectionCell.m
//  CSchool
//
//  Created by mac on 17/2/16.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "GropUserInfoCollectionCell.h"
#import "UIView+SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ChatUserInfoViewController.h"
#import "UIView+UIViewController.h"
@implementation GropUserInfoCollectionCell
{
    UILabel *_nickName;
    UIImageView *_imageView;
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
    _nickName = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12.0];
        view.textColor = RGB(98, 98, 98);
        view.textAlignment  = NSTextAlignmentCenter;
        view;
    });
    _imageView = ({
        UIImageView *view = [UIImageView new];
        view.layer.cornerRadius = 5;
        view.clipsToBounds = YES;
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer  *gesTure = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openUserInfo)];
        [view addGestureRecognizer:gesTure];
        view;
    });
    [self sd_addSubviews:@[_nickName,_imageView] ];
    _imageView.sd_layout.leftSpaceToView(self,(self.bounds.size.width-36)/2).widthIs(36).topSpaceToView(self,0).heightIs(36);
    _nickName.sd_layout.leftSpaceToView(self,(self.bounds.size.width-36)/2+5).topSpaceToView(_imageView,5).widthIs(36).heightIs(20);
}
-(void)setModel:(ChatUserModel *)model
{
    _model = model;
    XMPPJID *jid = [XMPPJID jidWithString:model.JID];
    NSString *jidName = [[[jid user] componentsSeparatedByString:@"_"] lastObject];
    _nickName.text = model.XM?model.XM:jidName;
    NSString *breakString =[NSString stringWithFormat:@"/thumb"];
    NSString *photoUrl = [model.TXDZ stringByReplacingOccurrencesOfString:breakString withString:@""];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    CGSize size = [_nickName boundingRectWithSize:CGSizeMake(0, 12)];
    _nickName.sd_layout.widthIs(size.width);
    if (size.width>(kScreenWidth-34-42)/5) {
        _nickName.sd_layout.widthIs((kScreenWidth-34-42)/5);
    }
}
-(void)openUserInfo
{
    ChatUserInfoViewController *vc = [[ChatUserInfoViewController alloc]init];
    vc.jid = [XMPPJID jidWithString:_model.JID];
    vc.groupName = @"我的好友";
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
@end
