//
//  XGBusView.m
//  CSchool
//
//  Created by 左俊鑫 on 16/12/19.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "XGBusView.h"
#import "SDAutoLayout.h"
#import "UILabel+stringFrame.h"

@implementation XGBusView
{
    NSDictionary *_infoDic;
}


-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _infoDic = dic;
        [self createViews];
    }
    return self;
}


- (void)createViews{
    UIImageView *busView = [[UIImageView alloc] init];


    [self addSubview:busView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    
    if (_infoDic[@"trip"]) {
        titleLabel.text = [NSString stringWithFormat:@"%@",_infoDic[@"trip"]];
    }
    titleLabel.font = [UIFont systemFontOfSize:8];
    titleLabel.textColor = [UIColor whiteColor];
    [busView addSubview:titleLabel];

    CGSize size=[titleLabel boundingRectWithSize:CGSizeMake(0, 21)];
    titleLabel.sd_layout
    .leftSpaceToView(busView,17)
    .topSpaceToView(busView,0)
    .bottomSpaceToView(busView,0)
    .widthIs(size.width+5);
    
    
    CGFloat viewWith = (size.width+20)>70?(viewWith=(size.width+20)):(viewWith=70);
    
    busView.sd_layout
    .leftSpaceToView(self,0)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0)
    .widthIs(viewWith);
    
    UIImage *image2 = [UIImage imageNamed:@"bus_bus"];
    image2 = [image2 stretchableImageWithLeftCapWidth:30 topCapHeight:5];
    busView.image = image2;
    
    self.width = busView.width;
}

@end
