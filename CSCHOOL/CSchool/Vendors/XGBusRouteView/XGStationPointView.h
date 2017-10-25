//
//  XGStationPointView.h
//  XGBusRouteView
//
//  Created by 左俊鑫 on 16/12/15.
//  Copyright © 2016年 Xin the Great. All rights reserved.
//

#import <UIKit/UIKit.h>

//文字要显示的位置
typedef NS_ENUM(NSUInteger, StationDirection) {
    StationBottom,
    StationRight,
    StationLeft,
};


@interface XGStationPointView : UIView

@property (nonatomic, copy) NSString *stationName;  //站点名称

@property (nonatomic, assign) StationDirection stationDirection;

@property (nonatomic, retain) UIImageView *imageView;  //设置站点图片（起始点使用）

//
- (instancetype)initWithDirection:(StationDirection)stationDirection withName:(NSString *)name isEnd:(BOOL)isEnd;


@end
