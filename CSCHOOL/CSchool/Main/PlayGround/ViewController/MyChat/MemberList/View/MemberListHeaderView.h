//
//  MemberListHeaderView.h
//  CSchool
//
//  Created by mac on 17/2/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"
//UILabel *_memberName;//成员名
//UILabel *_memberNum;//成员线数量
@interface MemberListHeaderView : UIView
@property (nonatomic,strong)UIButton *tap_button;
@property (nonatomic,strong)UIImageView  *imageView;//
@property (nonatomic, strong) UILabel *memberName;
@property (nonatomic, strong) UILabel *memberNum;

-(void)tranformImgaelocation:(BOOL )state;
@property(nonatomic,strong) ChatModel *model;


@end
