//
//  DrawPriseWord.m
//  CSchool
//
//  Created by mac on 17/5/12.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "DrawPriseWord.h"
@interface  DrawPriseWord()
//数据数组
@property(nonatomic,copy)NSArray *array;
//说明字符数组
@property(nonatomic,copy)NSMutableArray *Marray;

@property (nonatomic,assign)CGPoint centerPoint;
@end
@implementation DrawPriseWord

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addButton];
    }
    return self;
}

- (void)showPieWithAccountArray:(NSArray *)array withcenterPoint:(CGPoint)point{
    self.centerPoint = point;
    self.array = array;
    [self addButton];
    [self setNeedsDisplay];
    
}
//根据数组绘制圆盘
- (void)drawRect:(CGRect)rect
{
    NSArray *data = self.array;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGPoint centerP = CGPointMake(self.centerPoint.x, kScreenHeight/6+(kScreenWidth-50)/2+0.5);
    
    CGFloat radius = (kScreenWidth-75)/2;
    
    CGFloat startAngle =- M_PI * 0.5;
    
    CGFloat endAngle;
    
    for (int i = 0; i < data.count; i++) {

        int charAngle = 360/self.array.count;

        endAngle = ( charAngle / 360.0) * M_PI * 2 + startAngle;
        
        UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:centerP radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        
        [path addLineToPoint:centerP];
        
        CGContextSetLineWidth(ctx, 20);
        
        CGContextAddPath(ctx, path.CGPath);
        
//        [[UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0] set];
        [[self getColorFromAngleNum:i] set];

        CGContextDrawPath(ctx, kCGPathFill);
        
        startAngle = endAngle;
    }
}

-(UIColor *)getColorFromAngleNum:(int)num
{
    if (num%2==0) {//如果是偶数
        return RGB(255,103, 99);
    }else{//如果是奇数
        return RGB(255, 68, 68);
    }
}
//添加文字按钮
- (void)addButton{
    // 起始弧度
    CGFloat startAngle = 0;
    // 结束弧度
    CGFloat endAngle;
    CGFloat buttendAngle;
    CGFloat buttH = [UIScreen mainScreen].bounds.size.width * 0.6;
    CGFloat buttW = buttH * 0.7;
    for (int i = 0; i<self.array.count; i++) {
        int charAngle = 360/self.array.count;

        // 计算每个扇形的结束弧度
        endAngle = ( charAngle / 360.0) * M_PI * 2 + startAngle;
        //计算每个按钮的旋转角度
        buttendAngle = ( charAngle/ 360.0) * M_PI + startAngle;
        UIButton *butt = [[UIButton alloc]init];
        butt.tag = i;
        butt.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:butt];
        butt.bounds = CGRectMake(0, 0, buttW, buttH);
        butt.layer.anchorPoint = CGPointMake(0.5, 1);
        butt.center = CGPointMake(self.centerPoint.x , kScreenHeight/6+(kScreenWidth-50)/2);
        NSString *str = self.array[i];
        [butt setTitle:str forState:UIControlStateNormal];
        butt.transform = CGAffineTransformMakeRotation(buttendAngle);
        // 重新设置起始弧度
        startAngle = endAngle;
    }
    
}
@end
