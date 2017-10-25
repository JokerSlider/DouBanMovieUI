//
//  XGButton.m
//  CSchool
//
//  Created by 左俊鑫 on 16/4/14.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "XGButton.h"
#import "UIView+SDAutoLayout.h"

@interface XGButton()<UIGestureRecognizerDelegate>
{
    XGButtonStyle _style;
    XGButtonState _state;
    NSMutableDictionary *_imageDic;
    NSMutableDictionary *_titleDic;
}
@end

@implementation XGButton

- (instancetype)initWithFrame:(CGRect)frame withStyle:(XGButtonStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        _style = style;
        _imageDic = [NSMutableDictionary dictionary];
        _titleDic = [NSMutableDictionary dictionary];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        /**
         *  这里可以根据不同的样式，进行不同的布局
         */
        switch (style) {
            case XGButtonStyleUpDown:
                [self createViewsUpDown];
                break;
                
            default:
                break;
        }
    }
    return self;
}

//XGButtonStyleUpDown 上图下文样式
- (void)createViewsUpDown{
    _imageView = ({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeCenter;
        view;
    });
    
    _titleLabel = ({
        UILabel *view = [UILabel new];
        view.textAlignment = NSTextAlignmentCenter;
        view.font = [UIFont systemFontOfSize:14];
        view.textColor = Color_Black;
        view;
    });
    
    [self addSubview:_imageView];
    [self addSubview:_titleLabel];
    
    _imageView.sd_layout
    .leftSpaceToView(self,5)
    .rightSpaceToView(self,5)
    .topSpaceToView(self,5)
    .bottomSpaceToView(self,20);
    
    _titleLabel.sd_layout
    .topSpaceToView(_imageView,0)
    .leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .heightIs(20);
}

- (void)setTitle:(NSString *)title image:(NSString *)imageName withXGButtonState:(XGButtonState)state{
    [_titleDic setObject:title forKey:@(state)];
    [_imageDic setObject:imageName forKey:@(state)];
    
    if (state == XGButtonStateNomal) {
        _imageView.image = [UIImage imageNamed:imageName];
        _titleLabel.text = title;
    }
}

- (void)setSelected:(BOOL)selected{
    if (selected) {
        if ([_titleDic objectForKey:@(XGButtonStateSelected)]) {
            _titleLabel.text = [_titleDic objectForKey:@(XGButtonStateSelected)];
        }
        if ([_imageDic objectForKey:@(XGButtonStateSelected)]) {
            [_imageView setImage:[UIImage imageNamed:[_imageDic objectForKey:@(XGButtonStateSelected)]]];
        }
    }else{
        _titleLabel.text = [_titleDic objectForKey:@(XGButtonStateNomal)];
        [_imageView setImage:[UIImage imageNamed:[_imageDic objectForKey:@(XGButtonStateNomal)]]];
    }
    
}

- (void)clickAction:(UITapGestureRecognizer *)sender{
    if (self.xgButtonClick) {
        self.xgButtonClick(self.tag);
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    self.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return YES;
}

@end
