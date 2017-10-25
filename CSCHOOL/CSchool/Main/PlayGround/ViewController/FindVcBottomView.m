//
//  FindVcBottomView.m
//  CSchool
//
//  Created by mac on 16/10/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "FindVcBottomView.h"
#import "UIView+SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FindLoseModel.h"
#import "UILabel+stringFrame.h"
//#import "i"
@implementation FindVcBottomView
{
    UILabel *_txtInfoLabel;
    UIImageView *_imageV1;
    UIImageView *_imageV2;

    UIImageView *_imageV3;

    
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
    CGFloat margin = 15;
    _txtInfoLabel = [UILabel new];
    _txtInfoLabel.font = [UIFont systemFontOfSize:15];
    _txtInfoLabel.textColor = Color_Gray;

    _imageV1.backgroundColor = [UIColor clearColor];
    _imageV1 = ({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds  = YES;
        view.layer.cornerRadius = 5;
        view.autoresizesSubviews = YES;
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        view;
    });
    _imageV2 = ({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds  = YES;
        view.layer.cornerRadius = 5;
        view.autoresizesSubviews = YES;
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        view;
    });;
    _imageV3 =({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds  = YES;
        view.layer.cornerRadius = 5;
        view.autoresizesSubviews = YES;
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        view;
    });;
    
    [self sd_addSubviews:@[_txtInfoLabel,_imageV1,_imageV2,_imageV3]];
    _txtInfoLabel.sd_layout.leftSpaceToView(self,margin).topSpaceToView(self,margin).widthIs(kScreenWidth-2*margin).autoHeightRatio(0);
    _imageV1.sd_layout.leftSpaceToView(self,margin).topSpaceToView(_txtInfoLabel,margin).rightSpaceToView(self,margin).heightIs(300);
    _imageV2.sd_layout.leftEqualToView(_imageV1).topSpaceToView(_imageV1,margin).rightEqualToView(_imageV1).heightIs(300);
    _imageV3.sd_layout.leftEqualToView(_imageV1).topSpaceToView(_imageV2,margin).rightEqualToView(_imageV1).heightIs(300);

}
-(void)setModel:(FindLoseModel *)model
{
    _model = model;
    _txtInfoLabel.text = model.txtInfo;
    CGSize height = [_txtInfoLabel boundingRectWithHeightSize:CGSizeMake(kScreenWidth-30, 0 )];
    _txtInfoLabel.height = height.height;
 
    NSString *breakString =[NSString stringWithFormat:@"/%@",model.thumb];
    NSMutableArray *imageArr = [NSMutableArray array];
    if (_model.thumblicArray.count!=0) {
        for (NSDictionary *dic in _model.thumblicArray) {
            [imageArr addObject:dic[@"URL"]];
        }
    }
    if (imageArr.count!=0) {
        switch (imageArr.count) {
            case 3:
            {
            [_imageV1 sd_setImageWithURL:[NSURL URLWithString:[imageArr[0] stringByReplacingOccurrencesOfString:breakString withString:@""]] placeholderImage:[UIImage imageNamed:@"placdeImage"]];
            [_imageV2 sd_setImageWithURL:[NSURL URLWithString:[imageArr[1] stringByReplacingOccurrencesOfString:breakString withString:@""]] placeholderImage:[UIImage imageNamed:@"placdeImage"]];
            [_imageV3 sd_setImageWithURL:[NSURL URLWithString:[imageArr[2] stringByReplacingOccurrencesOfString:breakString withString:@""]] placeholderImage:[UIImage imageNamed:@"placdeImage"]];
                _imageV1.sd_layout.heightIs(300);
                _imageV2.sd_layout.heightIs(300);
                _imageV3.sd_layout.heightIs(300);
            }
            break;
            case 2:
            {
            [_imageV1 sd_setImageWithURL:[NSURL URLWithString:[imageArr[0] stringByReplacingOccurrencesOfString:breakString withString:@""]] placeholderImage:[UIImage imageNamed:@"placdeImage"]];
            [_imageV2 sd_setImageWithURL:[NSURL URLWithString:[imageArr[1] stringByReplacingOccurrencesOfString:breakString withString:@""]] placeholderImage:[UIImage imageNamed:@"placdeImage"]];
            _imageV3.sd_layout.heightIs(0);
                _imageV2.sd_layout.heightIs(300);
                _imageV3.sd_layout.heightIs(300);
                _imageV3.sd_layout.heightIs(0);
            }
            break;
            case 1:
            {
            [_imageV1 sd_setImageWithURL:[NSURL URLWithString:[imageArr[0] stringByReplacingOccurrencesOfString:breakString withString:@""]] placeholderImage:[UIImage imageNamed:@"placdeImage"]];
            _imageV2.sd_layout.heightIs(0);
            _imageV3.sd_layout.heightIs(0);
            _imageV1.sd_layout.heightIs(300);
            }
            break;
            default:
            {
                _imageV1.sd_layout.heightIs(0);
                _imageV2.sd_layout.heightIs(0);
                _imageV3.sd_layout.heightIs(0);
            }
            break;
        }
        
    }else{
        _imageV1.sd_layout.heightIs(0);
        _imageV2.sd_layout.heightIs(0);
        _imageV3.sd_layout.heightIs(0);
    }
//    self.height = _txtInfoLabel.height+_imageV1.height+_imageV2.height+_imageV3.height;
    [self setupAutoHeightWithBottomView:_imageV3 bottomMargin:55];

}
@end
