//
//  FairlView.m
//  CSchool
//
//  Created by mac on 16/4/19.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "FairlView.h"
#import "UIView+SDAutoLayout.h"

@implementation FairlView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadFairlView];
    }
    return self;

}

-(void)setTitle:(NSString *)title
{
    _title = title;
    if (_title==nil) {
        _title = @"似乎出了点问题,重新加载试试";
    }
    label.text = _title;
}
-(void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    if (_imageName) {
        imageV.image = [UIImage imageNamed:_imageName];
    }
}

-(void)loadFairlView
{
    UIView *FbackView = [UIView new];
    FbackView.backgroundColor = [UIColor whiteColor];

    label= ({
        UILabel *view = [UILabel new];
        view.font = [UIFont boldSystemFontOfSize:14];
        view.textColor = Color_Gray;
        view.textAlignment = NSTextAlignmentCenter;
        view;
    
    });
    imageV= ({
        UIImageView *view = [UIImageView new];
        
        view.image = [UIImage imageNamed:@"sad.png"];
        
        view.autoresizesSubviews = YES;
        view.contentMode = UIViewContentModeScaleAspectFit;
        view;
    });
    _loadBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"重新加载" forState:UIControlStateNormal];
        [view addTarget:self action:@selector(reloadDataSource) forControlEvents:UIControlEventTouchUpInside];
        view.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        view.titleLabel.textColor = Color_Gray;
        view.layer.cornerRadius = 7;
        view.hidden = YES;
        view.backgroundColor = Base_Orange;
        view;
    });

    [self addSubview:FbackView];
    [FbackView addSubview:imageV];
    [FbackView addSubview:label];
    [FbackView addSubview:_loadBtn];
    
    
    FbackView.frame = self.bounds;
    imageV.sd_layout
    .topSpaceToView(FbackView,(FbackView.bounds.size.height)/4)
    .widthIs(100)
    .heightIs(120)
    .centerXEqualToView(self);
    
    label.sd_layout
    .topSpaceToView(imageV,10)
    .leftSpaceToView(FbackView,20)
    .rightSpaceToView(FbackView,20)
    .autoHeightRatio(0);
    
    _loadBtn.sd_layout.topSpaceToView(label,80).widthIs(100).heightIs(30).leftEqualToView(imageV);
}
- (void)reloadDataSource{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadDataSource)]) {
        [self.delegate performSelector:@selector(reloadDataSource) withObject:nil];
    }
}

@end
