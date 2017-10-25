//
//  WIFIClassSureCell.m
//  CSchool
//
//  Created by mac on 17/6/29.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "WIFIClassSureCell.h"
#import "WifiClassView.h"
#import "UIView+SDAutoLayout.h"
#import "UIView+UIViewController.h"

@implementation WIFIClassSureCell
{
    UILabel *_titleL;
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

    [self.contentView addSubview:_titleL];
    CGSize size = [_titleL boundingRectWithSize:CGSizeMake(0, 15)];
    _titleL.sd_layout.leftSpaceToView(self.contentView,14).topSpaceToView(self.contentView,15).widthIs(size.width).heightIs(15);
//    _titleL.sd
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
        deleteview.deleteBtn.hidden = YES;
        [self.contentView addSubview:deleteview];
        deleteview.sd_layout.leftSpaceToView(_titleL,22).rightSpaceToView(self.contentView,0).heightIs(15).topSpaceToView(self.contentView,16+i*(15+12));
        [self layoutSubviews];
        [self setupAutoHeightWithBottomView:deleteview bottomMargin:15];
        
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
