//
//  TecStatrSignCell.m
//  CSchool
//
//  Created by mac on 17/6/30.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "TecStatrSignCell.h"
#import "UIView+SDAutoLayout.h"
#import "WIFISIgnToolManager.h"
@implementation TecStatrSignCell
{
    UILabel *_timeL;
    UILabel *_classNameL;
    UILabel *_signLbel;
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
    _timeL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(40, 40, 40);
        view;
    });
    _classNameL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(237,120,14);
        view;
    });
    _signLbel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(40, 40, 40);
        view;
    });
    [self.contentView sd_addSubviews:@[_timeL,_classNameL,_signLbel]];
    _timeL.sd_layout.leftSpaceToView(self.contentView,13).centerYIs(self.contentView.centerY).heightIs(14).widthIs(100);
    _classNameL.sd_layout.leftSpaceToView(_timeL,0).centerYIs(self.contentView.centerY).heightIs(14).widthIs(100);
    _signLbel.sd_layout.leftSpaceToView(_classNameL,0).centerYIs(self.contentView.centerY).heightIs(14).widthIs(100);
    
}
-(void)setModel:(WIFICellModel *)model
{
    _model = model;
    NSString* string = model.tls_creattime;
//    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
//    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
//    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSSZ"];
//    NSDate* inputDate = [inputFormatter dateFromString:string];
//    
//    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//    [outputFormatter setLocale:[NSLocale currentLocale]];
//    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSString *str = [outputFormatter stringFromDate:inputDate];
    _timeL.text =     [[WIFISIgnToolManager shareInstance]tranlateDateString:string withDateFormater:@"yyyy-MM-dd HH:mm:ss.SSSSSSZ" andOutFormatter:@"yyyy-MM-dd HH:mm"];
    _classNameL.text = model.tls_kcmc;
    _signLbel.text  = @"签到";
    CGSize size = [_timeL boundingRectWithSize:CGSizeMake(0, 14)];
    _timeL.sd_layout.widthIs(size.width);
    CGSize newsize = [_classNameL boundingRectWithSize:CGSizeMake(0, 14)];
    _classNameL.sd_layout.widthIs(newsize.width);

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
