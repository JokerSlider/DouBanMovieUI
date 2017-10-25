//
//  WifiClassEditCell.m
//  CSchool
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "WifiClassEditCell.h"
#import "WifiClassView.h"
#import "UIView+SDAutoLayout.h"
#import "UIView+UIViewController.h"
@implementation WifiClassEditCell
{
    UILabel *_titleL;
    WifiClassView *_addView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}
-(void)createView
{
    _titleL = ({
        UILabel *view = [UILabel new];
        [view setText:@"签到班级:"];
        view.textColor = RGB(85, 85, 85);
        view.font = [UIFont systemFontOfSize:15.0];
        view;
    });
    _addView = ({
        WifiClassView *view = [WifiClassView new];
        WIFICellModel *model = [[WIFICellModel alloc]init];
        model.title = @"点击继续添加";
        [view.deleteBtn addTarget:self action:@selector(addClassAction:) forControlEvents:UIControlEventTouchUpInside];
        view.model = model;
        view;
    });
    [self.contentView addSubview:_titleL];
    [self.contentView addSubview:_addView];
    CGSize size = [_titleL boundingRectWithSize:CGSizeMake(0, 15)];
    _titleL.sd_layout.leftSpaceToView(self.contentView,14).topSpaceToView(self.contentView,15).widthIs(size.width).heightIs(15);
    _addView.sd_layout.leftSpaceToView(_titleL,22).topEqualToView(_titleL).rightSpaceToView(self.contentView,0).heightIs(15);
    [self setupAutoHeightWithBottomView:_addView bottomMargin:15];

}

-(void)setModel:(WIFICellModel *)model
{
    _model = model;
    NSMutableArray *classArr = [NSMutableArray array];
    for (WIFICellModel *newmodel in model.titleArr) {
        [classArr addObject:newmodel.bjm];
    }
    [self setFrmeBySourceArr:classArr];

}
-(void)setFrmeBySourceArr:(NSArray *)arr
{
    for (int i = 0; i<arr.count; i++) {
        WifiClassView *deleteview = [[WifiClassView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        WIFICellModel *model = [WIFICellModel new];
        model.title = arr[i];
        deleteview.model = model;
        deleteview.deleteBtn.tag = i;
        [deleteview.deleteBtn setImage:[UIImage imageNamed:@"wifi_del"] forState:UIControlStateNormal];
        [deleteview.deleteBtn addTarget:self action:@selector(deletAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleteview];
        deleteview.sd_layout.leftSpaceToView(_titleL,22).rightSpaceToView(self.contentView,0).heightIs(15).topSpaceToView(self.contentView,16+i*(15+12));
        _addView.sd_layout.leftSpaceToView(_titleL,22).topSpaceToView(deleteview,12).rightSpaceToView(self.contentView,0).heightIs(15);
        [_addView updateLayout];
        [self layoutSubviews];
        [self setupAutoHeightWithBottomView:_addView bottomMargin:15];

    }
}
#pragma mark 添加
-(void)addClassAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addClassAction:)]) {
        [self.delegate addClassAction:sender];
    }
}
#pragma mark 删除
-(void)deletAction:(UIButton *)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(deletAction:)]) {
      
        [self.delegate deletAction:sender];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
