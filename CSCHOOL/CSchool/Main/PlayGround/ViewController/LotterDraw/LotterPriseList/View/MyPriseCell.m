//
//  MyPriseCell.m
//  CSchool
//
//  Created by mac on 17/5/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "MyPriseCell.h"
#import "UIView+SDAutoLayout.h"
@implementation MyPriseCell
{
    UILabel *_titleL;
    UILabel *_timeTitleL;
    UILabel *_awardName;//
    UILabel *_recodeNumL;//兑奖码
    UILabel *_haveRdeict;//是否领取
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}
-(void)createView
{
    _titleL = ({
        UILabel *view = [UILabel new] ;
        view.font = [UIFont systemFontOfSize:16];
        view.textColor = RGB(75, 75, 75);
        view.text = @"奖项名称:";
        view;
    });
    _awardName = ({
        UILabel *view = [UILabel new] ;
        view.font = [UIFont systemFontOfSize:14];
        view.textColor = RGB(133, 133, 133);
        view.text = @"奖品名称:";
        view;
    });
    _timeTitleL = ({
        UILabel *view = [UILabel new] ;
        view.font = [UIFont systemFontOfSize:14];
        view.textColor = RGB(133, 133, 133);
        view.text = @"领取时间:";
        view;
    });
    
    _recodeNumL = ({
        UILabel *view = [UILabel new] ;
        view.font = [UIFont systemFontOfSize:14];
        view.textColor = RGB(133, 133, 133);
        view.text = @"兑奖码:";
        view;
    });
    _haveRdeict = ({
        UILabel *view = [UILabel new] ;
        view.font = [UIFont systemFontOfSize:14];
        view.textColor = RGB(133, 133, 133);
        view.text = @"领取状态:";
        view;
    });
    UIView *contentView = self.contentView;
    [self.contentView sd_addSubviews:@[_titleL,_awardName,_timeTitleL,_recodeNumL,_haveRdeict]];
    _titleL.sd_layout.leftSpaceToView(contentView,10).topSpaceToView(contentView,10).rightSpaceToView(contentView,10).heightIs(17);
    _awardName.sd_layout.leftEqualToView (_titleL).topSpaceToView(_titleL,10).rightSpaceToView(contentView,10).heightIs(15);
    _timeTitleL.sd_layout.leftEqualToView (_titleL).topSpaceToView(_awardName,10).rightSpaceToView(contentView,10).heightIs(15);
    _recodeNumL.sd_layout.leftEqualToView(_titleL).topSpaceToView (_timeTitleL,10).rightSpaceToView(contentView,10).heightIs(15);
    _haveRdeict.sd_layout.leftEqualToView(_titleL).topSpaceToView (_recodeNumL,10).rightSpaceToView(contentView,10).heightIs(15);
    
    [self setupAutoHeightWithBottomView:_haveRdeict bottomMargin:14];
}
//
-(void)setModel:(PriseModel *)model
{
    _model = model;
    _titleL.text = [NSString stringWithFormat:@"奖项名称:%@",model.awardName];
    _awardName.text = [NSString stringWithFormat:@"奖品名称:%@",model.prizeName];
    NSString *time;
    if (model.receiveTime.length>0) {
        time  =  [self timeStrFormat:model.receiveTime];
    }else{
        time = @"尚未领取";
    }
    _timeTitleL.text = [NSString stringWithFormat:@"兑奖时间:%@",time];
    _recodeNumL.text = [NSString stringWithFormat:@"兑奖码:%@",model.redeemCode];
    _haveRdeict.text = [NSString stringWithFormat:@"领取状态:%@",[model.isReceive intValue]==0?@"未领取":@"已领取"];
//    CGSize size = [_titleL boundingRectWithSize:CGSizeMake(0, 17)];
//    _titleL.sd_layout.widthIs(size.width);
//    size = [_timeTitleL boundingRectWithSize:CGSizeMake(0, 15)];
//    _timeTitleL.sd_layout.widthIs(size.width);
//    size = [_recodeNumL boundingRectWithSize:CGSizeMake(0, 15)];
//    _recodeNumL.sd_layout.widthIs(size.width);
//    size = [_haveRdeict boundingRectWithSize:CGSizeMake(0, 15)];
//    _haveRdeict.sd_layout.widthIs(size.width);
}

-(NSString *)timeStrFormat:(NSString *)dateString
{
    NSString* string = dateString;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy年MM月dd日"];
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
