//
//  XGBusRouteView.m
//  XGBusRouteView
//
//  Created by 左俊鑫 on 16/12/15.
//  Copyright © 2016年 Xin the Great. All rights reserved.
//

#import "XGBusRouteView.h"
#import "XGStationPointView.h"
#import "XGBusView.h"


#define boder 45 //上下左的边距

#define rightBoder 66 //右边距

#define height (self.frame.size.height-boder*2)/4.0  //上下两条线的高度



#define stationWith 16  //站点的宽

@implementation XGBusRouteView
{
    CGFloat _totalLineWith; //画的线的总长度
    NSMutableArray *_distanceArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/


- (void)addStationView:(NSArray *)stationArray{
    for (UIView *view in self.subviews) {
        if ([view isMemberOfClass:[XGStationPointView class]]) {
            [view removeFromSuperview];
        }
    }
    
    _totalLineWith = (self.frame.size.width-boder-rightBoder)*5.0 + height*4.0;

    _distanceArray = [NSMutableArray array];
    _realTotalDistance = 0;
    for (NSDictionary *dic in stationArray) {
        _realTotalDistance += [dic[@"stationAway"] doubleValue];
        
        CGFloat distance = _realTotalDistance ;
        [_distanceArray addObject:@(distance)];
    }
    
    for (int i =0; i<stationArray.count; i++) {
        BOOL isEnd = NO;
        if (i==0 || i == stationArray.count-1) {
            isEnd = YES;
        }
        
        NSDictionary *dic = stationArray[i];
        XGStationPointView *view = [[XGStationPointView alloc] initWithDirection:StationBottom withName:dic[@"sitename"] isEnd:isEnd];
        view.frame = [self caculateFrame:[_distanceArray[i] doubleValue] withView:view];
        [self addSubview:view];
        
        if (i== stationArray.count-1) {
            view.imageView.image = [UIImage imageNamed:@"bus_zhongdian"];
        }
    }
    
}

- (void)addBusView:(NSArray *)busArray{
    
    for (UIView *view in self.subviews) {
        if ([view isMemberOfClass:[XGBusView class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (NSDictionary *dic in busArray) {
        if ([dic[@"showBus"] boolValue]) {
            XGBusView *view = [[XGBusView alloc] initWithDic:dic];
            int count = [dic[@"sortNum"] intValue]-1;
            view.frame = [self caculateBusFrame:[_distanceArray[count] doubleValue]-[dic[@"disnextlength"] doubleValue]  withView:view];
            
            [self addSubview:view];
        }
    }
    
//    for (int i=0; i<6; i++) {
//        XGBusView *view = [[XGBusView alloc] initWithDic:nil];
////        int count = [dic[@"sortNum"] intValue];
//        view.frame = [self caculateBusFrame:[_distanceArray[i] doubleValue]+3  withView:view];
//        
//        [self addSubview:view];
//    }
}

- (CGRect)caculateFrame:(CGFloat)distance withView:(XGStationPointView *)view{
    
    CGFloat lineWith = distance/_realTotalDistance*_totalLineWith*1.0;
    CGFloat hLine = (self.frame.size.width-boder-rightBoder);
    CGFloat unitWith = hLine + height;
    
    int unitCount = lineWith/unitWith;
    
    CGFloat leftCount = lineWith-unitCount*unitWith;
    
    CGFloat fWith = 0;
    CGFloat fHeigth = 0;
    
    if (unitCount%2 == 0) {
        if ((leftCount <= hLine) ) {
            fHeigth = height*unitCount-stationWith/2;
            fWith=leftCount/hLine*hLine;
            view.stationDirection = StationBottom;
        }else{
            fHeigth = (leftCount-hLine) + height*unitCount;
            fWith=hLine-stationWith/2;
            view.stationDirection = StationRight;
        }
    }else{
        if ((leftCount <= hLine) ) {
            fHeigth = height*unitCount-stationWith/2;
            fWith=hLine-leftCount + stationWith/2;
            view.stationDirection = StationBottom;
        }else{
            fHeigth = (leftCount-hLine) + height*unitCount;
            fWith=-stationWith/2;
            view.stationDirection = StationLeft;
        }
    }
    
    return CGRectMake(fWith+boder, fHeigth+boder, stationWith, stationWith);
}

- (CGRect)caculateBusFrame:(CGFloat)distance withView:(XGBusView *)view{
    
    CGFloat lineWith = distance/_realTotalDistance*_totalLineWith*1.0;
    CGFloat hLine = (self.frame.size.width-boder-rightBoder);
    CGFloat unitWith = hLine + height;
    
    int unitCount = lineWith/unitWith;
    
    CGFloat leftCount = lineWith-unitCount*unitWith;
    
    CGFloat fWith = 0;
    CGFloat fHeigth = 0;
    
    if (unitCount%2 == 0) {
        if ((leftCount <= hLine) ) {
            fHeigth = height*unitCount-22;
            fWith=leftCount/hLine*hLine;
        }else{
            fHeigth = (leftCount-hLine) + height*unitCount-22;
            fWith=hLine-7;
        }
    }else{
        if ((leftCount <= hLine) ) {
            fHeigth = height*unitCount-22;
            fWith=hLine-leftCount+7;
        }else{
            fHeigth = (leftCount-hLine) + height*unitCount-22;
            fWith=-7;
        }
    }
    
    return CGRectMake(fWith+boder, fHeigth+boder, view.frame.size.width, 22);
}


- (void)drawRect:(CGRect)rect {
    // 1.取出上下文 （画布）
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawLine:context];
}

// 绘制线条2
- (void)drawLine:(CGContextRef)context
{
    // 1. 获取上下文
    
//    CGFloat height = ;
    
    
    // 2. 添加多条线
    CGPoint p0 = {boder, boder};
    CGPoint p1 = {self.frame.size.width-rightBoder, boder};
    CGPoint p2 = {self.frame.size.width-rightBoder, boder+height};
    CGPoint p3 = {boder, boder+height};
    CGPoint p4 = {boder, boder+height*2};

    CGPoint p5 = {self.frame.size.width-rightBoder, boder+height*2};

    CGPoint p6 = {self.frame.size.width-rightBoder, boder+height*3};

    CGPoint p7 = {boder, boder+height*3};

    CGPoint p8 = {boder, boder+height*4};

    CGPoint p9 = {self.frame.size.width-rightBoder, boder+height*4};

    
    CGPoint points[] = {p0, p1, p2, p3, p4, p5, p6, p7, p8, p9};
    
    // 上下文， 包含点的数组， 数组里元素的个数
    CGContextAddLines(context, points, 10);
    
    // 设置线条的颜色
    [RGB(191, 191, 191) setStroke];
    // 设置填充颜色
    [RGB(245, 245, 245) setFill];
    
    // 设置线条和填充颜色
//        [[UIColor whiteColor] set];
    
    // 3. 绘制路径
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
    
}

@end
