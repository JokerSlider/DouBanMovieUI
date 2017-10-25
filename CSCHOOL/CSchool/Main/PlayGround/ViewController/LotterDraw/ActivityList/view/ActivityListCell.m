//
//  ActivityListCell.m
//  CSchool
//
//  Created by mac on 17/5/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "ActivityListCell.h"
#import "UIView+SDAutoLayout.h"
@implementation ActivityListCell
{
    UILabel *_titleL;
    UILabel *_subTitleL;
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
        view.font = [UIFont systemFontOfSize:16.0];
        view.textColor = RGB(75, 75, 75);
        view.text = @"";
        view;
    });
    _subTitleL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12.0];
        view.textColor = RGB(133, 133, 133);
        view.text = @"";
        view;
    });
    [self.contentView sd_addSubviews:@[_titleL,_subTitleL]];
    _titleL.sd_layout.leftSpaceToView(self.contentView,11).topSpaceToView(self.contentView,10).widthIs(100).heightIs(16);
    _subTitleL.sd_layout.leftEqualToView(_titleL).topSpaceToView(_titleL,11).widthIs(100).heightIs(12);
    
    [self setupAutoHeightWithBottomView:_subTitleL bottomMargin:11];

}
-(void)setModel:(ActivityModel *)model
{
    _titleL.text = model.name;
    NSString *startTime = [self timeStrFormat:model.startTime];
    NSString *endTime = [self timeStrFormat:model.endTime];
    
    _subTitleL.text = [NSString stringWithFormat:@"活动时间:%@-%@",startTime,endTime];
    
    CGSize size = [_titleL boundingRectWithSize:CGSizeMake(0, 16)];
    _titleL.sd_layout.widthIs(size.width);
    size = [_subTitleL boundingRectWithSize:CGSizeMake(0, 12)];
    if (size.width>kScreenWidth-36) {
        _subTitleL.sd_layout.widthIs(kScreenWidth-40).heightIs(30);
        _subTitleL.numberOfLines = 2;

    }else{
        _subTitleL.sd_layout.widthIs(size.width);
    }
}
-(NSString *)timeStrFormat:(NSString *)dateString
{
    NSString* string = dateString;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy年MM月dd日(HH:mm)"];
    NSString *str = [outputFormatter stringFromDate:inputDate];
    
    return str;
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
