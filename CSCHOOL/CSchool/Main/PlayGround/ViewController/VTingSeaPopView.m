
//
//  VTingSeaPopView.m
//  WeibooDemo
//
//  Created by WillyZhao on 16/8/31.
//  Copyright © 2016年 WillyZhao. All rights reserved.
//

#import "VTingSeaPopView.h"
#define marginX 60 //左右边距
#define marginY 10 //上下间距
#define Row     40 //水平间距

#define itemW   80
#define itemH   80

#define itemY   kScreenHeight/2-30  //最上面item的y坐标
#define distance  kScreenHeight/2+200

#define BOTTOM_INSTANCE 385


@interface VTingSeaPopView () {
    NSArray *images;
    NSArray *titles;
    CGFloat angle;
    
    UIImageView *bgImageView;

}

@end

@implementation VTingSeaPopView

-(instancetype)initWithButtonBGImageArr:(NSArray *)imgArr andButtonBGT:(NSArray *)title {
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        images = [NSArray arrayWithArray:imgArr];
        titles = [NSArray arrayWithArray:title];
        angle = 0;
        [self loadSubViews];
    }
    return self;
}

#pragma mark getter
-(void)setImageUrl:(NSString *)imageUrl {
    self.imageUrl = imageUrl;
}

#pragma mark 子视图初始化
-(void)loadSubViews {
    _backGroundView = [UIView new];
    _backGroundView.frame = self.bounds;
    _backGroundView.backgroundColor= [UIColor blackColor];
    _backGroundView.alpha = 0;
    [self addSubview:_backGroundView];
    _isLeft = YES;
    //左边的view
    _contentViewLeft = [[UIView alloc] initWithFrame:self.frame];
    [self addSubview:_contentViewLeft];
    
   
    //根据传入的图片数组进行初始化对应的点击item
    for (int i = 0; i<2; i++) {
        for (int j = 0; j<images.count; j++) {
            UIView *item = [[UIView alloc] init];
            item.frame = CGRectMake(marginX +(kScreenWidth-marginX*2-2*itemW+itemW)*(j%2), itemY+(itemH+marginY)*(j/2)+distance, itemW, itemH+41);
            
            //i=0：加载到左边的item。i=1：加载到右边隐藏视图的item
            if (i == 0) {
                item.tag = 100+j;
                [_contentViewLeft addSubview:item];
            }else{
                item.tag = 10+j;
                [_contentViewRight addSubview:item];
            }
            
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:images[j]]];
            img.backgroundColor = [UIColor cyanColor];
            img.frame = CGRectMake(0, 0, itemW, itemW);
            img.layer.masksToBounds = YES;
            img.layer.cornerRadius = itemW/2;
            [item addSubview:img];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, itemW+20, itemW, 21)];
            label.text = titles[j];
            label.font = [UIFont systemFontOfSize:18];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            [item addSubview:label];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = item.bounds;
            if (i == 0) {
                button.tag = 1000+j;
            }else{
                button.tag = 110+j;
            }
            //弹出的对应item的点击事件
            [button addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [item addSubview:button];
        }
    }
    
    
}

#pragma mark 返回左视图
-(void)backToLeftViewBtn:(UIButton *)btn{
    //每次返回时，恢复右边隐藏视图的所有item的frame。方便下次pop
    for (int i = 0; i<images.count; i++) {
        UIView *rItem = [_contentViewRight viewWithTag:i+10];
        rItem.transform = CGAffineTransformIdentity;
        rItem.frame = CGRectMake(rItem.frame.origin.x, rItem.frame.origin.y + BOTTOM_INSTANCE, rItem.frame.size.width, rItem.frame.size.height);
        
    }
    
    _bottomLeftBtn.hidden = YES;
    _bottomRightBtn.hidden = YES;
    _bottomBtn.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        //恢复左右视图的相关CGAffineTransform动画效果
        _contentViewLeft.transform = CGAffineTransformIdentity;
        _contentViewRight.transform = CGAffineTransformIdentity;
        _isLeft = YES;
        _exitImgvi.alpha = 1;
        _centerLine.alpha = 0;
        _leftImgvi.alpha = 0;
        _rightImgvi.alpha = 0;
        
        
    } completion:nil];
}

#pragma mark 关闭当前视图
-(void)dismissSelfBtn {
    //取出当前左边显示的所有item
    for (id vbc in _contentViewLeft.subviews) {
        if ([vbc isKindOfClass:[UIView class]]) {
            UIView *itemView = (UIView *)vbc;
//            NSInteger index = itemView.tag - 100;
            
            [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                itemView.frame = CGRectMake(itemView.frame.origin.x, itemView.frame.origin.y + BOTTOM_INSTANCE, itemView.frame.size.width, itemView.frame.size.height);
                
                self.alpha = 0;
                _backGroundView.alpha = 0;
            } completion:^(BOOL finished) {
            }];
            
        }
    }
    
}
#pragma mark item点击事件
-(void)itemBtnClick:(UIButton *)btn {
    [self dismissSelfBtn];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(itemBtnClick:)]) {
        [self.delegate itemDidSelected:(btn.tag - 1000)];
    }
}
#pragma mark 弹出当前视图
-(void)show {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [UIView animateWithDuration:0 animations:^{
                self.alpha = 1;
                _backGroundView.alpha = 0.618;
                _exitImgvi.transform = CGAffineTransformRotate(_exitImgvi.transform, M_PI_4);
            } completion:^(BOOL finished) {
                
            }];
        });
    });
    //取出当前左边视图显示的所有item
    for (id vbb in _contentViewLeft.subviews) {
        if ([vbb isKindOfClass:[UIView class]]) {
            UIView *itemview = (UIView *)vbb;
            NSInteger index = itemview.tag - 100;
            _contentViewLeft.alpha = 0;

            [UIView animateWithDuration:.7f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                _contentViewLeft.alpha = 1;
                [UIView animateWithDuration:.9f delay:(0.06)*index/3 usingSpringWithDamping:.6725f initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{

                    itemview.frame = CGRectMake(itemview.frame.origin.x, itemview.frame.origin.y - BOTTOM_INSTANCE, itemview.frame.size.width, itemview.frame.size.height);
                    
                } completion:^(BOOL finished) {
                    
                }];
            } completion:nil];
            
        }
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
