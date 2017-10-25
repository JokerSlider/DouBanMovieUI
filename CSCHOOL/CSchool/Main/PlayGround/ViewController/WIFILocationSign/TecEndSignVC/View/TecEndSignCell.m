//
//  TecEndSignCell.m
//  CSchool
//
//  Created by mac on 17/6/29.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "TecEndSignCell.h"
#import "UIView+SDAutoLayout.h"
@implementation TecEndSignCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}
-(void)createView
{
    self.backgroundColor = [UIColor whiteColor];
}
-(void)setModel:(WIFICellModel *)model
{
    // 签到状态 1、未签到 2、已签到、3、学生补签、4、教师代签 5、补签待处理 6.补签不通过
    // AP的位置验证状态 1 未验证 2 位置验证成功 3 位置验证失败 4 mac不存在无法验证
    NSArray *signState = @[@"缺勤",@"出勤",@"出勤",@"出勤",@"缺勤",@"缺勤"];
    NSArray *apState = @[@"缺勤",@"出勤",@"缺勤",@"缺勤"];
    _model = model;
    int index = [model.aci_state intValue];
    NSString *signString = signState[index-1];
    index = [model.aci_state_ad intValue];
    NSString *apString = apState[index-1];
    NSArray *titleArr = @[model.yhbh,model.xm,model.kcmc,signString,apString];
    [self setFamewithtitleArr:titleArr];
}


-(void)setFamewithtitleArr:(NSArray *)titlearr
{
    CGFloat width = (kScreenWidth -60-titlearr.count*80)/(titlearr.count-1);//控件 之间的间隙
    for (int i = 0 ; i<titlearr.count; i++) {
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = RGB(90, 90, 90);
        view.text = titlearr[i];;
        view.lineBreakMode = NSLineBreakByTruncatingTail;
        CGSize size = [view boundingRectWithSize:CGSizeMake(0, 15)];//精准宽度
        [self.contentView addSubview:view];
        if ([view.text isEqualToString:@"缺勤"]) {
            view.textColor = Base_Orange;
        }
        if (i==2) {
            size.width = 80;
        }
        view.sd_layout.leftSpaceToView(self.contentView,10+i*(80+width+20)).heightIs(15).centerYIs(self.contentView.centerY).widthIs(size.width);

        if (i==1) {
        view.sd_layout.leftSpaceToView(self.contentView,10+i*(80+width+40)).heightIs(15).centerYIs(self.contentView.centerY).widthIs(size.width);
        }
        if (i==3) {
            view.sd_layout.leftSpaceToView(self.contentView,10+i*(80+width+20)).heightIs(15).centerYIs(self.contentView.centerY).widthIs(size.width);
        }
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
