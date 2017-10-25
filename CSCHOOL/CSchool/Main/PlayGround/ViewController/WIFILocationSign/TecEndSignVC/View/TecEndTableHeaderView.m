//
//  TecEndTableHeaderView.m
//  CSchool
//
//  Created by mac on 17/6/29.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "TecEndTableHeaderView.h"
#import "UIView+SDAutoLayout.h"
@implementation TecEndTableHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
-(void)createView
{
    self.frame = CGRectMake(0, 0, kScreenWidth, 45);
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:lineView];
    lineView.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).bottomSpaceToView(self,0).heightIs(0.5);
}
//setModel
-(void)setModel:(WIFICellModel *)model
{
    _model = model;
    [self setFamewithtitleArr:model.titleArr];
}

-(void)setFamewithtitleArr:(NSArray *)titlearr
{
    CGFloat width = (kScreenWidth -70-20-titlearr.count*50)/(titlearr.count-1);//控件 之间的间隙
    self.backgroundColor = [UIColor whiteColor];
    for (int i = 0 ; i<titlearr.count; i++) {
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(40, 40, 40);
        view.text = titlearr[i];;
        
        CGSize size = [view boundingRectWithSize:CGSizeMake(0, 15)];//精准宽度
        [self addSubview:view];
        view.sd_layout.leftSpaceToView(self,50+i*(50+width+5)).heightIs(15).centerYIs(self.centerY).widthIs(size.width);
    }

}
@end
