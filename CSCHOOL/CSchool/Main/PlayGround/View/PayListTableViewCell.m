//
//  PayListTableViewCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/13.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "PayListTableViewCell.h"
#import "YYText.h"
#import "UIView+SDAutoLayout.h"
#import "ConfigObject.h"

@implementation PayListModel

- (void)setOrderPackageName:(NSString *)orderPackageName{
    _orderPackageName = orderPackageName;
    NSArray *arr = [orderPackageName componentsSeparatedByString:@"|"];
    _payBit = arr[2];
}

- (void)setOrderState:(NSString *)orderState{
    _orderState = orderState;
    NSInteger orderNum = [orderState integerValue];
    ConfigObject *config = [ConfigObject shareConfig];
    NSDictionary *orderDic = config.oderStateDic;
    
    NSArray *arr = [orderDic allKeysForObject:@(orderNum)];
    if (arr.count >0) {
        NSString *str = arr[0];
        if ([str isEqualToString:@"not_pay"] || [str isEqualToString:@"ali_not_pay"]) {
            //支付失败
            _payStatus = PayWaiting;
        }else{
            //支付成功
            _payStatus = PaySucess;
        }
    }
    if ([orderState isEqualToString:@"720000"]) {
        _payStatus = PayCancel;
    }
}

@end

@implementation PayListTableViewCell
{
    UILabel *_payIdLabel;
    YYLabel *_moneyLabel;
    UILabel *_bitLabel;
    UILabel *_timeLabel;
    UIButton *_statusBtn;
    UIButton *_payBtn;
    UIView *_blackLineView;
    UIView *_bottomLineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    [self.contentView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];

    _payIdLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = [UIColor darkGrayColor];
        view;
    });
    
    _statusBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"待支付" forState:UIControlStateNormal];
        [view setTitleColor:Base_Orange forState:UIControlStateNormal];
        [view setTitle:@"交易成功" forState:UIControlStateSelected];
        [view setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
        view.titleLabel.font = Title_Font;
        view;
    });
    
    _blackLineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor darkGrayColor];
        view;
    });
    
    _moneyLabel = ({
        YYLabel *view = [YYLabel new];
        view.font = Title_Font;
        view.textColor = [UIColor darkGrayColor];
        view;
    });
    
    _bitLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = [UIColor darkGrayColor];
        view;
    });
    
    _timeLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = [UIColor darkGrayColor];
        view;
    });
    
    _payBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"支付" forState:UIControlStateNormal];
        [view setTitleColor:Title_Color1 forState:UIControlStateNormal];
        view.titleLabel.font = Title_Font;
        view;
    });
    
    _bottomLineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    
    [self.contentView addSubview:_payIdLabel];
    [self.contentView addSubview:_statusBtn];
    [self.contentView addSubview:_blackLineView];
    [self.contentView addSubview:_moneyLabel];
    [self.contentView addSubview:_bitLabel];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_payBtn];
    [self.contentView addSubview:_bottomLineView];
    
    _payIdLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView,10)
    .widthIs(250)
    .heightIs(30);
    
    _statusBtn.sd_layout
    .rightSpaceToView(self.contentView,0)
    .topEqualToView(_payIdLabel)
    .heightRatioToView(_payIdLabel,1)
    .widthIs(70);
    
    _blackLineView.sd_layout
    .leftEqualToView(_payIdLabel)
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(_payIdLabel,1)
    .heightIs(.5);
    
    _moneyLabel.sd_layout
    .leftEqualToView(_payIdLabel)
    .widthIs(200)
    .topSpaceToView(_blackLineView,1)
    .heightIs(25);
    
    _bitLabel.sd_layout
    .leftEqualToView(_moneyLabel)
    .widthIs(200)
    .topSpaceToView(_moneyLabel,1)
    .heightIs(0);
    
    _timeLabel.sd_layout
    .leftEqualToView(_payIdLabel)
    .widthIs(200)
    .topSpaceToView(_bitLabel,1)
    .heightIs(0);
    
//    _payBtn.sd_layout
//    .rightSpaceToView(self.contentView,10)
//    .topEqualToView(_timeLabel)
//    .heightIs(30)
//    .widthIs(70);
    
    _bottomLineView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .topSpaceToView(_timeLabel,1)
    .heightIs(5);
    
    [self setupAutoHeightWithBottomView:_bottomLineView bottomMargin:0];

}


- (void)setModel:(PayListModel *)model{
    _model = model;
    _payIdLabel.text = [NSString stringWithFormat:@"订单编号：%@",model.orderId];

//    if (model.orderClientPackagePeriod) {
//        _timeLabel.text = [NSString stringWithFormat:@"时长：%@",model.orderClientPackagePeriod];
//    }
//    _bitLabel.text = [NSString stringWithFormat:@"带宽：%@",model.payBit];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"金额：%@元",model.orderFee]];
    NSRange range = [[NSString stringWithFormat:@"金额：%@元",model.orderFee] rangeOfString:model.orderFee];
    [text yy_setTextHighlightRange:range
                             color:Base_Orange
                   backgroundColor:[UIColor groupTableViewBackgroundColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                             NSLog(@"tap text range:...");
                         }];
    _moneyLabel.attributedText = text;
    switch (model.payStatus) {
        case PaySucess:
        {
            _statusBtn.selected = YES;
            _payBtn.hidden = YES;
            [_statusBtn setTitle:@"交易成功" forState:UIControlStateSelected];
        }
            break;
        case PayCancel:
        {
            _statusBtn.selected = YES;
            _payBtn.hidden = YES;
            [_statusBtn setTitle:@"交易关闭" forState:UIControlStateSelected];
        }
            break;
        case PayWaiting:
        {
            _statusBtn.selected = NO;
        }
            break;
        default:
            break;
    }
}

@end
