//
//  XGBusRouteView.h
//  XGBusRouteView
//
//  Created by 左俊鑫 on 16/12/15.
//  Copyright © 2016年 Xin the Great. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGBusRouteView : UIView

@property (nonatomic, assign) CGFloat realTotalDistance; //实际总距离

- (void)addStationView:(NSArray *)stationArray; 

- (void)addBusView:(NSArray *)busArray;

@end
