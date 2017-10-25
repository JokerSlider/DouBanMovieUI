//
//  MyOrderBottomView.m
//  CSchool
//
//  Created by mac on 16/12/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MyOrderBottomView.h"
#import "UIView+SDAutoLayout.h"
#import "UILabel+stringFrame.h"
#define MyFont  [UIFont systemFontOfSize:15]
@implementation MyOrderBottomView
{
    UILabel *_timeoutBook;//即将到期的书本
    UILabel *_noReturnBook;//没归还的书本
    UILabel *_passedBook;//已经过期的书
    UILabel *_passMondey;//欠款
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.5;
    }
    return self;
}
-(void)setupView
{
    self.backgroundColor = [UIColor whiteColor];
  
    _timeoutBook = ({
        UILabel *view = [UILabel new];
        view.text = @"即将到期图书:";
        view.font  = MyFont;
        view.textColor = Color_Black;
        view;
    });
    _noReturnBook = ({
        UILabel *view = [UILabel new];
        view.text = @"当前未归还图书:";
        view.font  = MyFont;
        view.textColor = Color_Black;
        view;
    });
    _passedBook = ({
        UILabel *view = [UILabel new];
        view.text = @"已经超期图书:";
        view.font  = MyFont;
        view.textColor = Color_Black;
        view;
    });
    _passMondey = ({
        UILabel *view = [UILabel new];
        view.text = @"超期已欠款金额:";
        view.font  = MyFont;
        view.textColor = Color_Black;
        view;
    });
    [self sd_addSubviews:@[_timeoutBook,_noReturnBook,_passedBook,_passMondey]];
    
    _timeoutBook.sd_layout.leftSpaceToView(self,15).topSpaceToView(self,15).widthIs((kScreenWidth-20)/2).heightIs(15);
    _noReturnBook.sd_layout.rightSpaceToView(self,15).topSpaceToView(self,15).widthIs((kScreenWidth-20)/2).heightIs(15);
    _passedBook.sd_layout.leftEqualToView(_timeoutBook).topSpaceToView(_timeoutBook,10).widthIs((kScreenWidth-20)/2).heightIs(15);
    _passMondey.sd_layout.rightSpaceToView(self,15).topSpaceToView(_noReturnBook,10).widthIs((kScreenWidth-20)/2).heightIs(15);
    [self reloadLocation];

}
-(void)setModel:(LibiraryModel *)model
{
    _model = model;
    _timeoutBook.text =[NSString stringWithFormat:@"即将到期图书:%@本",model.nearToEnd];
    _noReturnBook.text = [NSString stringWithFormat:@"当前未归还图书:%@本",model.noReturn];
    _passedBook.text = [NSString stringWithFormat:@"已经超期图书:%@本",model.overdue];
    _passMondey.text = [NSString stringWithFormat:@"超期已欠款金额:%@元",model.overdueMoney];
    
    [self reloadLocation];
}
-(void)reloadLocation
{
    CGSize size=[_timeoutBook boundingRectWithSize:CGSizeMake(0, 15)];
    _timeoutBook.sd_layout.widthIs(size.width);
    size = [_noReturnBook boundingRectWithSize:CGSizeMake(0, 15)];
    _noReturnBook.sd_layout.widthIs(size.width);
    size = [_passedBook boundingRectWithSize:CGSizeMake(0, 15)];
    _passedBook.sd_layout.widthIs(size.width);
    size = [_passMondey boundingRectWithSize:CGSizeMake(0, 15)];
    _passMondey.sd_layout.widthIs(size.width);

}
-(void)reloadData
{
    [self setModel:_model];
}
@end
