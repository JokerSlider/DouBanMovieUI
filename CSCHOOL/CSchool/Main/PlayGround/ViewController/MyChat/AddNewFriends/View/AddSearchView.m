//
//  AddSearchView.m
//  CSchool
//
//  Created by mac on 17/3/2.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "AddSearchView.h"
#import "UIView+SDAutoLayout.h"
@implementation AddSearchView
{
    UIImageView *_imageV;
    UIView      *_lineView;//横线
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void)createView
{
    self.userInteractionEnabled = YES;

    _imageV = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"add_noBack"];
        view;
    });
    _inputTxtV = ({
        UITextField *view = [UITextField new];
        view.font = [UIFont systemFontOfSize:12.0];
        view.textColor = [UIColor whiteColor];
        view.borderStyle = UITextBorderStyleNone;
        view.returnKeyType = UIReturnKeySearch;
        view;
    });
    
    _lineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.userInteractionEnabled = YES;
        view;
    });
    [self sd_addSubviews:@[_imageV,_inputTxtV,_lineView]];
    _imageV.sd_layout.leftSpaceToView(self,0).topSpaceToView(self,0).widthIs(16).heightIs(16);
    _lineView.sd_layout.leftSpaceToView(self,0).topSpaceToView(_imageV,0).rightSpaceToView(self,0).heightIs(1);
    _inputTxtV.sd_layout.leftSpaceToView(_imageV,10).topSpaceToView(self,0).rightSpaceToView(self,0).heightIs(16);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    [_imageV addGestureRecognizer:tapGesture];
}
-(void)tapAction:(UITapGestureRecognizer *)gesture
{
    [self.inputTxtV becomeFirstResponder];
}

@end
