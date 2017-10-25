//
//  FindVCMidView.m
//  CSchool
//
//  Created by mac on 16/10/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "FindVCMidView.h"
#import "FindLoseModel.h"
#import "UIView+SDAutoLayout.h"
#import "UILabel+stringFrame.h"
#import "CustomizedPaddingLabel.h"
@implementation FindVCMidView
{
    CustomizedPaddingLabel *_tagLabel;//标签
    UILabel  *_titleLabel;//标题

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
    _titleLabel =({
        UILabel *view = [UILabel new];
        view.textColor = [UIColor darkGrayColor];
        view.font = Title_Font;
        view;
    });    
    _tagLabel = ({
        CustomizedPaddingLabel *view =[CustomizedPaddingLabel new];
        view.layer.borderWidth = 0.5;
        view.layer.cornerRadius = 3;

        view.font = Small_TitleFont;
        view;
    });
    [_titleLabel addSubview:_tagLabel];
    [self addSubview:_titleLabel];
    CGFloat margin = 15;

    _tagLabel.sd_layout.
    leftSpaceToView(_titleLabel,0)
    .topSpaceToView(_titleLabel,margin+15)
    .widthIs(50).heightIs(15);
    
    _titleLabel.sd_layout
    .leftSpaceToView(self, margin)
    .topSpaceToView(self,margin)
    .rightSpaceToView(self, margin).heightIs(30).autoHeightRatio(0);

}
-(void)setModel:(FindLoseModel *)model
{
    _model = model;
    if ([model.type isEqualToString:@"2"]) {
        if (model.tagName.length==0) {
            _tagLabel.hidden = YES;
        }else{
            _tagLabel.hidden = NO;
        }
    }else{
        _tagLabel.hidden = YES;
        
    }
    _tagLabel.text = [NSString stringWithFormat:@"%@",model.tagName];
    CGSize size = [_tagLabel boundingRectWithSize:CGSizeMake(0, 15)];
    _tagLabel.sd_layout.widthIs(size.width+6);
    _tagLabel.textColor = [self getTagColor:model.tagName];
    _tagLabel.layer.borderColor = _tagLabel.textColor.CGColor;
    
    NSString *title;
    NSMutableString *string = [[NSMutableString alloc]initWithString:@""];
    if (_tagLabel.text.length!=0) {
        for (int i = 0; i<=_tagLabel.text.length; i++) {
            [string  appendString: @"   "];
            string = string;
        }
        title = [NSString stringWithFormat:@"%@%@",string,model.title];
        _titleLabel.text  = title;
        _tagLabel.sd_layout.topSpaceToView(_titleLabel,0);
    }else{
        _titleLabel.text = model.title;
    }
    size = [_titleLabel boundingRectWithHeightSize:CGSizeMake(kScreenWidth-30, 0)];
    _titleLabel.height = size.height;

    self.height = 15+_titleLabel.height;
}
-(UIColor *)getTagColor:(NSString *)tagName
{
    if ([tagName isEqualToString:@"生活用品"]) {
        return RGB(255, 119, 83);
    }else if ([tagName isEqualToString:@"电子产品"]){
        return RGB(22, 176, 247);
    }else if ([tagName isEqualToString:@"学习用品"]){
        return RGB(90, 159, 81);
    }else if([tagName isEqualToString:@"其他"]){
        return RGB(35, 98, 192);
    }
    
    return [UIColor purpleColor];
}

@end
