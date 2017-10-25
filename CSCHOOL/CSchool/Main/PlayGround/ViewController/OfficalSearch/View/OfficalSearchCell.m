//
//  OfficalSearchCell.m
//  CSchool
//
//  Created by mac on 17/8/22.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OfficalSearchCell.h"
#import "HXTagsView.h"
#import "UIView+SDAutoLayout.h"
@implementation OfficalSearchModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ID":@"id"
            };
}

@end
@interface OfficalSearchCell()<HXTagsViewDelegate>

@end

@implementation OfficalSearchCell
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

-(void)createView{
    _titleL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15.0f];
        view.textColor = Color_Black;
        view;
    });
    [self.contentView addSubview:_titleL];
    _titleL.sd_layout.leftSpaceToView(self.contentView,26).topSpaceToView(self.contentView,12).rightSpaceToView(self.contentView,26).heightIs(15);
}
//setter  model
-(void)setModel:(OfficalSearchModel *)model
{
    _model = model;
    _titleL.text = model.tagtitle;
    NSMutableArray *nameArr = [NSMutableArray array];
    for (NSDictionary *dic in model.tagArr) {
        [nameArr addObject:dic[@"name"]];
    }
    
    [self createTagView:nameArr];
}
-(void)createTagView:(NSArray *)tagArr
{
    HXTagsView *tagsView = [[HXTagsView alloc] initWithFrame:CGRectMake(26, 27, kScreenWidth-52, 0)];
    tagsView.type = 0;
    tagsView.tag = 1;
    tagsView.backgroundColor = [UIColor whiteColor];
    tagsView.titleColor = Base_Orange;
    tagsView.borderColor = Base_Orange;
    [tagsView setTagAry:tagArr delegate:self];
    [self.contentView addSubview:tagsView];
    [self setupAutoHeightWithBottomView:tagsView bottomMargin:10];

}
#pragma mark HXTagsViewDelegate

/**
 *  tagsView代理方法
 *
 *  @param tagsView tagsView
 *  @param sender   tag:sender.titleLabel.text index:sender.tag
 */
- (void)tagsViewButtonAction:(HXTagsView *)tagsView button:(UIButton *)sender {
    
    if (self.delegate && [self respondsToSelector:@selector(tagsViewButtonAction:button:)]) {
        [self.delegate tagsAction:tagsView button:sender];
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
