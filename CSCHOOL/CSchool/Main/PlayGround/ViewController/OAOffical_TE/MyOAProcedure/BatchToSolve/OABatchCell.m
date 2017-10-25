//
//  OABatchCell.m
//  CSchool
//
//  Created by mac on 17/6/16.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OABatchCell.h"
#import "UIView+SDAutoLayout.h"
#import "OAOwnCellView.h"
#import "NSDate+Extension.h"
@implementation OABatchCell
{
    OAOwnCellView *_procedureName;//流程名称
    OAOwnCellView *_procedureTime;//流程发起时间
    OAOwnCellView *_procedureUser;//流程发起人
    OAOwnCellView *_procedureStatus;//流程状态
    
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}
//创建视图
-(void)createView
{
    _procedureName = [OAOwnCellView new];
    _procedureTime = [OAOwnCellView new];
    _procedureUser = [OAOwnCellView new];
    _procedureStatus = [OAOwnCellView new];

    
    [self.contentView sd_addSubviews:@[_procedureName,_procedureTime,_procedureStatus,_procedureUser]];
    
    _procedureName.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(self.contentView,16).heightIs(14).rightSpaceToView(self.contentView,0);
    _procedureTime.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(_procedureName,16).heightIs(14).rightSpaceToView(self.contentView,0);
    _procedureUser.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(_procedureTime,16).heightIs(14).rightSpaceToView(self.contentView,0);
    _procedureStatus.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(_procedureUser,16).heightIs(14).rightSpaceToView(self.contentView,0);
    [self setupAutoHeightWithBottomView:_procedureStatus bottomMargin:15];
    
}
-(void)setModel:(OAModel *)model
{
    _model = model;
    model.title = @"流程名称:";
    model.imgName = @"OA_proName";
    model.subTitle = model.fi_name;
    
    _procedureName.model = model;
    model.title = @"发起时间:";
    model.imgName = @"OA_time";
    model.subTitle = [NSDate dateTranlateStringFromTimeString:model.create_time andformatterString:@"yyyy-MM-dd HH:mm"];
    _procedureTime.model = model;
    
    model.title = @"流程发起人:";
    model.imgName = @"OA_proceUser";
    model.subTitle = model.xm;
    
    _procedureUser.model = model;
    
    model.title = @"审批状态:";
    model.imgName = @"OA_shenState";
    model.subTitle = [model.sp_state isEqualToString:@"1"]?@"待审批":@"已审批";
    _procedureStatus.model = model;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
