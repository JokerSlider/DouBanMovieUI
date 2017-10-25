//
//  SportListCell.m
//  CSchool
//
//  Created by mac on 17/3/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "SportListCell.h"
#import "UIView+SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation SportListCell
{
    UIImageView *_picImageV;//头像
    UILabel     *_nickNameL;//昵称
    UILabel     *_numberL;//排名
    
    UILabel     *_stepNum;//步数
    UIButton    *_zanBtn;//赞我的人
    UILabel     *_zanNumLabel;//赞的次数
    UIImageView *_globelView;//奖牌
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
    self.backgroundColor = [UIColor whiteColor];
    _picImageV = ({
        UIImageView *view = [[UIImageView alloc]init];
        view.clipsToBounds = YES;
        view.layer.cornerRadius = 40/2;
        view;
    });
    _nickNameL = ({
        UILabel *view = [UILabel new];
        view.text = @"";
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:15.0f];
        view;
    });
    _numberL = ({
        UILabel *view = [UILabel new];
        view.text = @"第1名";
        view.textColor = RGB(134, 133, 133);
        view.font = [UIFont systemFontOfSize:12.0f];
        view;
    });
    _stepNum = ({
        UILabel *view = [UILabel new];
        view.text = @"";
        view.textColor = RGB(255, 210, 0);
        view.font = [UIFont systemFontOfSize:24.0f];
        view;
    });
    _zanBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"0" forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"sport_Zan"] forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"sport_ZanOrange"] forState:UIControlStateSelected];
        [view addTarget:self action:@selector(zanAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    _zanNumLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(211, 211, 211);
        view.font = [UIFont systemFontOfSize:15.0];
        view.textAlignment = NSTextAlignmentCenter;
        [view sizeToFit];
        view;
    });
    _globelView = ({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
//        view.image = [UIImage imageNamed:@"sportAmong"];
        view;
    });
    [self.contentView sd_addSubviews:@[_picImageV,_nickNameL,_numberL,_stepNum,_zanBtn,_globelView,_zanNumLabel]];
    _picImageV.sd_layout.leftSpaceToView(self.contentView,14).topSpaceToView(self.contentView,11).widthIs(40).heightIs(40);
    _nickNameL.sd_layout.leftSpaceToView(_picImageV,11).topSpaceToView(self.contentView,11).widthIs(45).heightIs(15);
    _numberL.sd_layout.leftEqualToView(_nickNameL).topSpaceToView(_nickNameL,10).heightIs(12).widthIs(50);
    _globelView.sd_layout.leftSpaceToView(self.contentView,kScreenWidth/2).topSpaceToView(self.contentView,0).heightIs(34).widthIs(31);
    _zanNumLabel.sd_layout.rightSpaceToView(self.contentView,12).topSpaceToView(self.contentView,11).widthIs(18).heightIs(15);
    _zanBtn.sd_layout.rightSpaceToView(self.contentView,14).topSpaceToView(_zanNumLabel,5).widthIs(16).heightIs(16);

    _stepNum.sd_layout.rightSpaceToView(_zanBtn,25).topSpaceToView(self.contentView,24).widthIs(100).heightIs(19);
    [self setupAutoHeightWithBottomView:_picImageV bottomMargin:10];
}
-(void)setModel:(SportModel *)model
{
    _model = model;
    _nickNameL.text = model.xm?model.xm:model.nc;
    _numberL.text = [NSString stringWithFormat:@"第%@名", model.pm];
    _stepNum.text = model.umi_stepnumber;
    _zanNumLabel.text  = model.count;
    //已被自己点赞
    if ([model.state isEqualToString:@"1"]) {
        _zanBtn.selected = YES;
    }else{
        _zanBtn.selected = NO;
    }
    //不能给自己点赞
    if ([model.yhbh isEqualToString:[AppUserIndex GetInstance].role_id]) {
        _zanBtn.selected = YES;
        _zanBtn.userInteractionEnabled = NO;
    }
   
    
    NSString *breakString =[NSString stringWithFormat:@"/thumb"];
    NSString *photoUrl = [model.txdz  stringByReplacingOccurrencesOfString:breakString withString:@""];
    [_picImageV sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"rentou"]];

    CGSize size = [_stepNum boundingRectWithSize:CGSizeMake(0, 15)];
    _stepNum.sd_layout.widthIs(size.width);
    size = [_nickNameL boundingRectWithSize:CGSizeMake(0, 15)];
    _nickNameL.sd_layout.widthIs(size.width);
    size = [_zanNumLabel boundingRectWithSize:CGSizeMake(0, 15)];
    if (size.width>_zanNumLabel.width) {
        _zanNumLabel.sd_layout.widthIs(size.width);
    }
    
    //设置奖牌
    switch ([_model.pm intValue]) {
        case 1:
        {
            [_globelView setImage:[UIImage imageNamed:@"GoldMedal"]];//金牌
        }
            break;
            case 2:
        {
            [_globelView setImage:[UIImage imageNamed:@"sliverMedal"]];//银牌
        }
            break;
        case 3:
        {
            [_globelView setImage:[UIImage imageNamed:@"copperMedal"]];//铜牌

        }
            break;
        default:
            break;
    }
}
#pragma mark 点赞
-(void)zanAction:(UIButton *)sender
{
    /*
     执行操作1点赞2,取消点赞 默认为1
     */
    NSString *state ;
    state = [_model.state isEqualToString:@"1"]?@"2":@"1";
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL  parameters:@{@"rid":@"giveGoodPoint",@"userid":[AppUserIndex GetInstance].role_id,@"infoid":_model.umi_id,@"state":state} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        int state = [responseObject[@"data"] intValue];
        if (state==-1||state==0) {

            [ProgressHUD showError:@"点赞失败"];
        }else {
            sender.selected = !sender.selected;
            //之前赞了就取消赞 -1
            if ([_model.state isEqualToString:@"1"]) {
                _model.state= @"0";
                NSString *num = _model.count;
                num = [NSString stringWithFormat:@"%d",[num intValue]-1];
                _model.count = num;
                _zanNumLabel.text = num;
            }
            //没赞 就+1
            else{
                //点赞成功   在屏幕中央出现一个点赞手指
                _model.state= @"1";
                NSString *num = _model.count;
                num = [NSString stringWithFormat:@"%d",[num intValue]+1];
                _model.count = num;
                _zanNumLabel.text = num;
            }
            CGSize size = [_zanNumLabel boundingRectWithSize:CGSizeMake(0, 15)];
            size = [_zanNumLabel boundingRectWithSize:CGSizeMake(0, 15)];
            if (size.width>_zanNumLabel.width) {
                _zanNumLabel.sd_layout.widthIs(size.width);
                _zanNumLabel.sd_layout.rightSpaceToView(self.contentView, 6);
                [self updateLayoutWithCellContentView:_zanNumLabel];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
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
