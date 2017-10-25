//
//  ChooseDayorWeek.m
//  CSchool
//
//  Created by mac on 16/4/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ChooseDayorWeek.h"

@implementation ChooseDayorWeek
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initViews];
    }
    return self;
}

- (void)_initViews
{
    self.layer.borderColor = Base_Orange.CGColor;
    self.layer.borderWidth = 0.3f;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    
    _rectTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _rectTitleLabel.textAlignment = NSTextAlignmentCenter;
    _rectTitleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_rectTitleLabel];
    
    _subTitileLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _subTitileLabel.textAlignment = NSTextAlignmentCenter;
    _subTitileLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_subTitileLabel];
    
    _mediaLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _mediaLabel.textAlignment = NSTextAlignmentCenter;
    _mediaLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_mediaLabel];
}
-(void)setTitle:(NSString *)title
{
    _title = title;
    _rectTitleLabel.text = _title;

}
-(void)setSubtitle:(NSString *)subtitle
{

    _subtitle = subtitle;
    _subTitileLabel.text =_subtitle;

}
- (void)layoutSubviews
{
    [super layoutSubviews];
        _rectTitleLabel.frame = CGRectMake(0, 0,(self.bounds.size.width-5)/2,self.bounds.size.height);
        _rectTitleLabel.textColor = _textColor;
        _rectTitleLabel.font =_titleFont;

        _mediaLabel.frame = CGRectMake((self.bounds.size.width-5)/2+3, 0, 5, self.bounds.size.height);
        _mediaLabel.text = @"/";
        _mediaLabel.textColor =_textColor;
        _mediaLabel.font = [UIFont systemFontOfSize:11];
    
        _subTitileLabel.frame = CGRectMake((self.bounds.size.width-5)/2+6, 0, (self.bounds.size.width)/2, self.bounds.size.height);
        _subTitileLabel.textColor = _textColor;
        _subTitileLabel.font = _subtitleFont;

    
    
}

@end
