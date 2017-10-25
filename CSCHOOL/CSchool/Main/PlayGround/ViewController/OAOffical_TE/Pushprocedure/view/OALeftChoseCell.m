//
//  OALeftChoseCell.m
//  CSchool
//
//  Created by mac on 17/7/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OALeftChoseCell.h"
#import "UIView+SDAutoLayout.h"
@implementation OALeftChoseCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        _lineView = [UIView new];
//        [self.contentView addSubview:_lineView];
//        _lineView.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(self.contentView,0).widthIs(5).heightIs(50);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected) {
        self.lineView.backgroundColor = Base_Orange;
    }else{
        self.lineView.backgroundColor = Base_Color2;
    }
    // 获取 contentView 所有子控件
    NSArray<__kindof UIView *> *subViews = self.contentView.subviews;
    // 创建颜色数组
    NSMutableArray *colors = [NSMutableArray array];
    
    for (UIView *view in subViews) {
        // 获取所有子控件颜色
        [colors addObject:view.backgroundColor ?: [UIColor clearColor]];
    }
    // 调用super
    [super setSelected:selected animated:animated];
    // 修改控件颜色
    for (int i = 0; i < subViews.count; i++) {
        subViews[i].backgroundColor = colors[i];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    // 获取 contentView 所有子控件
    NSArray<__kindof UIView *> *subViews = self.contentView.subviews;
    // 创建颜色数组
    NSMutableArray *colors = [NSMutableArray array];
    
    for (UIView *view in subViews) {
        // 获取所有子控件颜色
        [colors addObject:view.backgroundColor ?: [UIColor clearColor]];
    }
    // 调用super
    [super setHighlighted:highlighted animated:animated];
    // 修改控件颜色
    for (int i = 0; i < subViews.count; i++) {
        subViews[i].backgroundColor = colors[i];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIControl *control in self.subviews) {
        if (![control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            continue;
        }
        
        for (UIView *subView in control.subviews) {
            if (![subView isKindOfClass: [UIImageView class]]) {
                continue;
            }
            
            UIImageView *imageView = (UIImageView *)subView;
            if (self.selected) {
                imageView.image = [UIImage imageNamed:@"CellButtonSelected"]; // 选中时的图片
            } else {
                imageView.image = [UIImage imageNamed:@"CellButtonUnSelected"];   // 未选中时的图片
            }
        }
    }
}
@end
