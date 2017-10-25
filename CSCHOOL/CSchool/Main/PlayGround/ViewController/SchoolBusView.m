//
//  SchoolBusView.m
//  CSchool
//
//  Created by mac on 16/12/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "SchoolBusView.h"
#import "UIView+SDAutoLayout.h"
#import "UILabel+stringFrame.h"
@implementation SchooBusModel
/*
 @property (nonatomic,copy)NSString *num;//站点序号
 @property (nonatomic,copy)NSString *siteName;//站点名
 @property (nonatomic,copy)NSString *busTagName;//备注
 @property (nonatomic,copy)NSString *busStartTime;//班车发车时间
 @property (nonatomic,copy)NSString *busEndTime;//收车时间
 @property (nonatomic,copy)NSString *isComing;//是否即将来车
 
 
 d    ID
 groupId 线路ID
 name  站点名称
 longitude 经度
 latitude  纬度
 disEndLength 距离终点长度
 sortNum 排序字段
 isStart  是否起点
 isEnd  是否终点
 stationAway  距离上站距离
 
 deviceNum  设备号
 disendlength 距离终点长度
 nextStationName 下站名称
 disnextlength 距离下站长度
 disendtim 距离终点时间（单位：分）
 disnexttim 距离下站时间（单位：分）
 trip 提示
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"busName":@"name",
             @"siteName":@"sitename",
             @"busLodId":@"id",
             @"num":@"sortNum",
             @"isStart":@"isStart",
             @"isEnd":@"isEnd",
             @"stationAway":@"stationAway",
             @"disEndLength":@"disEndLength",
             @"longitude":@"longitude",
             @"latitude":@"latitude",
             @"busTagName":@"busTagName",
             @"busStartTime":@"first",
             @"busEndTime":@"end",
             @"deviceNum":@"deviceNum",
             @"disendlength":@"disendlength",
             @"nextStationName":@"nextStationName",
             @"disnextlength":@"disnextlength",
             @"disendtim":@"disendtim",
             @"disnexttim":@"disnexttim",
             @"trip":@"trip",
             @"isShow":@"showBus",
             @"info":@"info"
             };
}



@end

@implementation SchoolBusView
{
    UILabel  *_busNameL;//去的路
 
    
    UIImageView *_startTV;
    UIImageView *_endTV;
    
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}
-(void)setupView
{
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = Base_Color2.CGColor;
    self.backgroundColor = [UIColor whiteColor];
   
    //点击事件在vc里边设置
    _chooseBusBtn = ({
        LFUIbutton *view = [LFUIbutton buttonWithType:UIButtonTypeCustom];
        view.frame = CGRectMake(10, 5, 200, 30);
        view.titleLabel.font = [UIFont fontWithName:@ "Arial Rounded MT Bold"  size:(18.0)];
        [view setImage:[UIImage imageNamed:@"bus_change"] forState:UIControlStateNormal];
        [view setTitleColor:Color_Black forState:UIControlStateNormal];
        view;
    });
    _busNameL = ({
        UILabel *view = [UILabel new];
        view.text = @"建大→浆水泉路";
        view.textColor = Color_Black;
        view.font = [UIFont fontWithName:@ "Arial Rounded MT Bold"  size:(18.0)];
        view;
    });
    _startTime = ({
        UILabel *view = [UILabel new];
        view.text = @"";
        view.textColor = Color_Black;
        view.font = Title_Font ;
        view;
    });
    _endTime = ({
        UILabel *view = [UILabel new];
        view.text = @"";
        view.textColor = Color_Black;
        view.font = Title_Font;
        view;
    });
    _startTV = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"bus_start"];
        view.clipsToBounds = YES;
        view.layer.cornerRadius = 5;
        view;
    });
    _endTV = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"bus_end"];
        view.clipsToBounds = YES;
        view.layer.cornerRadius = 15/2;
        view;
    });
    
    [self sd_addSubviews:@[_chooseBusBtn,_busNameL,_startTime,_endTime,_endTV,_startTV]];
    _busNameL.sd_layout.leftSpaceToView(self,15).topSpaceToView(self,5).heightIs(20).widthIs(200);
    _startTV.sd_layout.leftEqualToView(_busNameL).topSpaceToView(_busNameL,15).heightIs(15).widthIs(15);
    
    _startTime.sd_layout.leftSpaceToView(_startTV,2).topSpaceToView(_busNameL,15).heightIs(15).widthIs(60);
    _endTV.sd_layout.leftSpaceToView(_startTime,6).topEqualToView(_startTV).heightIs(15).widthIs(15);
    
    _endTime.sd_layout.leftSpaceToView(_endTV,2).topEqualToView(_startTime).heightIs(15).widthIs(60);
    
    _chooseBusBtn.sd_layout.rightSpaceToView(self,20).topSpaceToView(self,45/2).heightIs(25).widthIs(25);
}

-(void)setModel:(SchooBusModel *)model
{
    _model = model;
    _busNameL.text  = model.busName;
    CGSize size=[_busNameL boundingRectWithSize:CGSizeMake(0, 20)];
    _busNameL.sd_layout.widthIs(size.width);
}

@end
