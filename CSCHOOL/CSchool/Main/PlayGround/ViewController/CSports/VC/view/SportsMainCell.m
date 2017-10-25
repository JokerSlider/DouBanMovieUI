//
//  SportsMainCell.m
//  CSchool
//
//  Created by mac on 17/3/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "SportsMainCell.h"
#import "UIView+SDAutoLayout.h"
#import "ZanPersonViewController.h"
#import "UIView+UIViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation SportModel
-(void)setUMIDATE:(NSString *)UMIDATE
{
    _UMIDATE = UMIDATE;
//    NSString* string =UMIDATE ;
//    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
//    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
//    [inputFormatter setDateFormat:@"MMM  dd, yyyy"];
//    NSDate* inputDate = [inputFormatter dateFromString:string];
//    NSString *str = [self dateToString:inputDate withDateFormat:@"yyyy-MM-dd"];
//    _UMIDATE  = str;
}
//日期格式转字符串
//- (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString *)format
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:format];
//    NSString *strDate = [dateFormatter stringFromDate:date];
//    return strDate;
//}

//处理model null的数据


@end

@implementation SportsMainCell
{
    UIView  *_headView;
    UIButton *_rankView;//名次
    UIButton *_stepView;//步数
    UILabel  *_rankL;//显示名次的label
    UILabel  *_rankUnit;//名次的单位
    UILabel  *_stepL;//显示步数的label
    UILabel  *_stepLUnit;//步数的单位

    UIView   *_headLine;//头视图内部的分割线
    UIButton *_coleriaView;//卡路里
    UILabel  *_coleriaL;//卡路里数
    UILabel  *_coleralUnit;//卡路里数

    
    UIView  *_middleView;
    UIImageView *_numberOneImage;//夺得冠军的头像
    UILabel     *_numberOnewName;//姓名 + 夺得今日冠军
    UILabel     *_timeL;//日期
    
    
    
    UIView  *_bottomView;
    UIButton *_locationBtn;//位置
    UIButton     *_zanPNum;//赞我的人 +赞了你  超过6个人就折叠
    
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupHeadView];
        [self setupMiddleView];
        [self setBottomView];
        self.contentView.layer.cornerRadius=10;
    }
    return self;
}
-(void)setupHeadView
{
    _headView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = Base_Color2.CGColor;
        view;
    });
    [self.contentView addSubview:_headView];
    _headView.sd_layout.leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).topSpaceToView(self.contentView,0).heightIs(151);
    _rankView = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.userInteractionEnabled = NO;
        [view setTitle:@"名次" forState:UIControlStateNormal];
        [view setTitleColor:Color_Black forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [view setImage:[UIImage imageNamed:@"sportsNum.png"] forState:UIControlStateNormal];
        view;
    });
    _stepView = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.userInteractionEnabled = NO;
        [view setTitle:@"步数" forState:UIControlStateNormal];
        [view setTitleColor:Color_Black forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [view setImage:[UIImage imageNamed:@"sportsStep"] forState:UIControlStateNormal];
        view;
    });
    _rankL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:16.0];
        view.textColor = Color_Black;
        view.text = @"0";
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });
    _rankUnit = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12.0];
        view.textColor = Color_Black;
        view.text = @"名";
        view;
    });
    _stepL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:16.0];
        view.textColor = Color_Black;
        view.text = @"0";
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });
    _stepLUnit =({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12.0];
        view.textColor = Color_Black;
        view.text = @"步";
        view;
    });
    _headLine =({
        UIView *view = [UIView new];
        view.backgroundColor = Base_Color2;
        view;
    });
    
    _coleriaView = ({
        UIButton *view  = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"消耗卡路里:" forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [view setImage:[UIImage imageNamed:@"calorie"] forState:UIControlStateNormal];
        [view setTitleColor:Color_Black forState:UIControlStateNormal];
        view;
    });
    _coleriaL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:16.0];
//        view.text = @"152";
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });
    _coleralUnit = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12.0];
        view.textColor = Color_Black;
        view.text = @"千卡";
        view;
    });
    [_headView sd_addSubviews:@[_rankView,_stepView,_rankL,_stepL,_headLine,_coleriaView,_coleriaL,_rankUnit,_stepLUnit,_coleralUnit]];
    _rankView.sd_layout.leftSpaceToView(_headView,66).topSpaceToView(_headView,24).widthIs(50).heightIs(15);
    _stepView.sd_layout.rightSpaceToView(_headView,66).topSpaceToView(_headView,24).widthIs(50).heightIs(15);
    _rankL.sd_layout.leftSpaceToView(_headView,66+25/2).topSpaceToView(_rankView,10).widthIs(30).heightIs(15);
    _rankUnit.sd_layout.leftSpaceToView(_rankL,0).topEqualToView(_rankL).widthIs(15).heightIs(15);
    _stepL.sd_layout.rightSpaceToView(_headView,66+25/2).topSpaceToView(_stepView,10).widthIs(100).heightIs(15);
    _stepLUnit.sd_layout.leftSpaceToView(_stepL,0).topEqualToView(_stepL).widthIs(40).heightIs(15);
    _headLine.sd_layout.leftSpaceToView(_headView,13).rightSpaceToView(_headView,13).heightIs(0.5).topSpaceToView(_rankL,25);
    _coleriaView.sd_layout.leftSpaceToView(_headView,60).topSpaceToView(_headLine,24).widthIs(100).heightIs(15);
    _coleriaL.sd_layout.rightSpaceToView(_headView,66+25/2).topSpaceToView(_headLine,24).widthIs(100).heightIs(15);
    _coleralUnit.sd_layout.leftSpaceToView(_coleriaL,0).topEqualToView(_coleriaL).heightIs(15).widthIs(40);
    
    
}
-(void)setupMiddleView
{
    _middleView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderWidth = 0.25;
        view.layer.borderColor = Base_Color2.CGColor;
        view;
    });
    [self.contentView addSubview:_middleView];
    _middleView.sd_layout.leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).heightIs(46).topSpaceToView(_headView,0);
    _numberOneImage = ({
        UIImageView *view = [UIImageView new];
        view.layer.cornerRadius =30/2;
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        view;
    });
    _numberOnewName = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15.0];
        view.textColor = Color_Black;
        view;
    });
    _timeL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:16.0];
        view.textColor = Color_Black;
        view.textAlignment = NSTextAlignmentRight;
        view;
    });
    [_middleView sd_addSubviews:@[_numberOnewName,_numberOneImage,_timeL]];
    _numberOneImage.sd_layout.leftSpaceToView(_middleView,2).centerYIs(_middleView.centerY).widthIs(30).heightIs(30);
    _numberOnewName.sd_layout.leftSpaceToView(_numberOneImage,5).widthIs(200).heightIs(15).topSpaceToView(_middleView,16);
    _timeL.sd_layout.rightSpaceToView(_middleView,5).centerYIs(_middleView.centerY).heightIs(12).widthIs(100);
}

-(void)setBottomView
{
    _bottomView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderWidth = 0.25;
        view.layer.borderColor = Base_Color2.CGColor;
        view;
    });
    [self.contentView addSubview:_bottomView];
    _bottomView.sd_layout.leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).heightIs(46).topSpaceToView(_middleView,0);
    _locationBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"sportsLocation"] forState:UIControlStateNormal];
        [view setTitle:@"" forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [view setTitleColor:Color_Black forState:UIControlStateNormal];
        view;
    });
    _zanPNum = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"0人赞你" forState:UIControlStateNormal];
        [view setTitleColor:Base_Orange forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"sport_Zand"] forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [view addTarget:self action:@selector(openZanVC) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    [_bottomView sd_addSubviews:@[_locationBtn,_zanPNum]];
    _locationBtn.sd_layout.leftSpaceToView(_bottomView,5).centerYIs(_middleView.centerY).widthIs(100).heightIs(15);
    _zanPNum.sd_layout.rightSpaceToView(_bottomView,2).centerYIs(_middleView.centerY).heightIs(15).widthIs(200);
    [self setEdgeInsets:@[_zanPNum,_locationBtn,_rankView,_stepView,_coleriaView]];
    
}
-(void)setModel:(SportModel *)model
{
    _model = model;
    _rankL.text = model.PM;//排名
    _stepL.text = model.UMISTEPNUMBER ;//步数
    _coleriaL.text = model.UMICAL ;//kaluli
    _timeL.text = model.UMIDATE ;
    if ([model.UMISTEPNUMBER intValue]>10000) {
        _stepL.textColor = Base_Orange;
        _stepL.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:16];
        _stepL.sd_layout.rightSpaceToView(_headView,66).topSpaceToView(_stepView,10).widthIs(100).heightIs(15);
        [_stepL updateLayout];
        }
    
    [_locationBtn setTitle:[NSString stringWithFormat:@"%@",model.SDSNAME] forState:UIControlStateNormal];
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateStyle:NSDateFormatterMediumStyle];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr1 = [formatter1 stringFromDate:now];
    NSArray *array=[dateStr1 componentsSeparatedByString:@" "];
    NSArray *array1=[[array objectAtIndex:1] componentsSeparatedByString:@":"];
    //晚上八点之后计算出今日冠军
    if ([[array1 objectAtIndex:0] intValue]>=21&[[array1 objectAtIndex:1]intValue]>=30) {
        _numberOnewName.text = [NSString stringWithFormat:@"%@夺得今日冠军",model.XM?model.XM:model.NC];
    }
    //晚上八点之前值显示当前排名
    else{
        _numberOnewName.text = [NSString stringWithFormat:@"%@目前排名第一",model.XM?model.XM:model.NC];
        if (![array[0] isEqualToString:model.UMIDATE]) {
        _numberOnewName.text = [NSString stringWithFormat:@"%@夺得今日冠军",model.XM?model.XM:model.NC];

        }
    }

    
    NSString *breakString =[NSString stringWithFormat:@"/thumb"];
    NSString *photoUrl = [model.TXDZ  stringByReplacingOccurrencesOfString:breakString withString:@""];
    [_numberOneImage sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"rentou"]];

    NSArray *zanArray = model.OUT_NAME;
    NSString *zanPeop;
    if (zanArray.count>5) {
        zanPeop = [NSString stringWithFormat:@"%@、%@等%d等人赞了你",zanArray[0],zanArray[1],(int)zanArray.count];
    }else{
        zanPeop = [zanArray componentsJoinedByString:@","];
        zanPeop = [NSString stringWithFormat:@"%@赞了你",zanPeop];
        if (zanArray.count==0) {
            zanPeop = @"0人赞了你";
        }
    }
    [_zanPNum setTitle:zanPeop forState:UIControlStateNormal];
    CGSize size = [_rankL boundingRectWithSize:CGSizeMake(0, 15)];
    _rankL.sd_layout.widthIs(size.width);
    size = [_stepL boundingRectWithSize:CGSizeMake(0, 15)];
    _stepL.sd_layout.widthIs(size.width);
    size = [_coleriaL boundingRectWithSize:CGSizeMake(0, 15)];
    _coleriaL.sd_layout.widthIs(size.width);
    size = [_numberOnewName boundingRectWithSize:CGSizeMake(0, 15)];
    _numberOnewName.sd_layout.widthIs(size.width);
    size = [_zanPNum.titleLabel boundingRectWithSize:CGSizeMake(0, 15)];
    _zanPNum.sd_layout.widthIs(size.width+_zanPNum.imageView.frame.size.width+2);
    size = [_locationBtn.titleLabel boundingRectWithSize:CGSizeMake(0, 15)];
    _locationBtn.sd_layout.widthIs(size.width+_locationBtn.imageView.frame.size.width+2);
    
    size = [_timeL boundingRectWithSize:CGSizeMake(0, 15)];
    _timeL.sd_layout.widthIs(size.width);
   
}
#pragma mark
-(void)openZanVC
{
    ZanPersonViewController  *vc = [[ZanPersonViewController alloc]init];
    NSArray *zanArray = _model.OUT_NAME;
    vc.currentTime = _model.UMIDATE;
    vc.zanPersonNum = (int)zanArray.count;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
-(void)setEdgeInsets:(NSArray *)buttonArr
{
    for (UIButton *btn in buttonArr) {
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
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
