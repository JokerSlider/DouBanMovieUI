//
//  lbl_fireworksView.m
//  Test
//
//  Created by 张丹 on 16/7/14.
//  Copyright © 2016年 有云. All rights reserved.
//

#import "lbl_FireworksView.h"

@implementation lbl_FireworksView
{
    NSArray         *_emitterCells;
    CAEmitterLayer  *_explosionLayer;
    CAEmitterLayer  *_dismissLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.clipsToBounds = NO;
    self.userInteractionEnabled = NO;
    
    CAEmitterCell *explosionCell  = [CAEmitterCell emitterCell];
    explosionCell.name            = @"explosion";
    explosionCell.alphaRange      = 0.20;
    explosionCell.alphaSpeed      = -1.0;
    explosionCell.lifetime        = 7;
    explosionCell.lifetimeRange   = 0.2;
    explosionCell.birthRate       = 0;
    explosionCell.velocity        = 40.00;
    explosionCell.velocityRange   = 5.00;
    explosionCell.scale           = 0.05;
    explosionCell.scaleRange      = 0.02;
    explosionCell.contents        = (__bridge id _Nullable)([UIImage imageNamed:@"fire_blue"].CGImage);
    explosionCell.yAcceleration = 2;
    
    _explosionLayer               = [CAEmitterLayer layer];
    _explosionLayer.name          = @"emitterLayer";
    _explosionLayer.emitterShape  = kCAEmitterLayerCircle;
    _explosionLayer.emitterMode   = kCAEmitterLayerOutline;
    _explosionLayer.emitterSize   = CGSizeMake(10, 0);
    _explosionLayer.emitterCells  = @[explosionCell];
    _explosionLayer.renderMode    = kCAEmitterLayerOldestFirst;
    _explosionLayer.masksToBounds = NO;
    [self.layer addSublayer:_explosionLayer];

    CAEmitterCell *dismissCell    = [CAEmitterCell emitterCell];
    dismissCell.name              = @"dismiss";
    dismissCell.alphaRange        = 0.20;
    dismissCell.alphaSpeed        = -1.0;
    dismissCell.lifetime          = 0.3;
    dismissCell.lifetimeRange     = 0.1;
    dismissCell.birthRate         = 0;
    dismissCell.velocity          = -40.0;
    dismissCell.velocityRange     = 0.00;
    dismissCell.scale             = 0.05;
    dismissCell.scaleRange        = 0.02;
    dismissCell.contents          = (__bridge id _Nullable)([UIImage imageNamed:@"fire_blue"].CGImage);

    _dismissLayer                 = [CAEmitterLayer layer];
    _dismissLayer.name            = @"emitterLayer";
    _dismissLayer.emitterShape    = kCAEmitterLayerCircle;
    _dismissLayer.emitterMode     = kCAEmitterLayerOutline;
    _dismissLayer.emitterSize     = CGSizeMake(25, 0);
    _dismissLayer.emitterCells    = @[dismissCell];
    _dismissLayer.renderMode      = kCAEmitterLayerOldestFirst;
    _dismissLayer.masksToBounds   = NO;
    [self.layer addSublayer:_dismissLayer];
    
    _emitterCells = @[explosionCell, dismissCell];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self resetViewPositions];
//    CGPoint center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));

}
-(void)resetViewPositions
{
//    _explosionLayer.emitterPosition = CGPointMake(kScreenWidth-45+10, 34+10);
//    _dismissLayer.emitterPosition   = CGPointMake(kScreenWidth-45+10, 34+10);
    _explosionLayer.emitterPosition = _myCenter ;
    _dismissLayer.emitterPosition   = _myCenter;
}
#pragma mark - methods

- (void)animate
{
    _dismissLayer.beginTime = CACurrentMediaTime();
    [_dismissLayer setValue:@0 forKeyPath:@"emitterCells.dismiss.birthRate"];
    [self performSelector:@selector(explode) withObject:nil afterDelay:0.2];
}

- (void)explode
{
    [_dismissLayer setValue:@0 forKeyPath:@"emitterCells.dismiss.birthRate"];
    _explosionLayer.beginTime = CACurrentMediaTime();
    [_explosionLayer setValue:@400 forKeyPath:@"emitterCells.explosion.birthRate"];
    [self performSelector:@selector(stop) withObject:nil afterDelay:0.1];
}

- (void)stop
{
    [_dismissLayer setValue:@0 forKeyPath:@"emitterCells.dismiss.birthRate"];
    [_explosionLayer setValue:@0 forKeyPath:@"emitterCells.explosion.birthRate"];
}

@end
