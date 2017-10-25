//
//  TecEndInfoCell.m
//  CSchool
//
//  Created by mac on 17/6/29.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "TecEndInfoCell.h"
#import "UIView+SDAutoLayout.h"
#import "WIFISIgnToolManager.h"
@implementation TecEndInfoCell
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
    _model = model;
    NSString* string = model.aci_creattime;

    NSString *str = [[WIFISIgnToolManager shareInstance]tranlateDateString:string withDateFormater:@"yyyy-MM-dd HH:mm:ss.SSSSSSZ" andOutFormatter:@"yyyy-MM-dd HH:mm"];

    model.num = @"1";
    
    NSArray *signState = @[@"缺勤",@"出勤",@"出勤",@"出勤",@"缺勤",@"缺勤"];
    int index = [model.aci_state intValue];
    NSArray *titleArr = @[str,model.num,signState[index-1]];
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
        if ([view.text isEqualToString:@"请假"]) {
            view.textColor = RGB(140, 126, 5);
        }else if ([view.text isEqualToString:@"缺勤"]){
            view.textColor = RGB(237, 120, 14);
        }
        if (i==2) {
            size.width = 80;
        }
        view.sd_layout.leftSpaceToView(self.contentView,24+i*(80+width+20)).heightIs(15).centerYIs(self.contentView.centerY).widthIs(size.width);
        
        if (i==1) {
            view.sd_layout.leftSpaceToView(self.contentView,24+i*(80+width+40)).heightIs(15).centerYIs(self.contentView.centerY).widthIs(size.width);
        }
        if (i==3) {
            view.sd_layout.leftSpaceToView(self.contentView,24+i*(80+width+20)).heightIs(15).centerYIs(self.contentView.centerY).widthIs(size.width);
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
