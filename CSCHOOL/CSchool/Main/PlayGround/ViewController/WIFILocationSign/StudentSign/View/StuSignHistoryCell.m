//
//  StuSignHistoryCell.m
//  CSchool
//
//  Created by mac on 17/6/29.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "StuSignHistoryCell.h"
#import "UIView+SDAutoLayout.h"
#import "UIView+UIViewController.h"
#import "StuSignInfoController.h"
#import "StuWIFISubsignController.h"
#import "WIFISIgnToolManager.h"
@implementation StuSignHistoryCell
{
    UILabel *_titleL;
    UIButton *_signBtn;
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
        view.textColor = RGB(57, 57, 57);
        view.font = [UIFont systemFontOfSize:13];
        view;
    });
    
    _signBtn = ({
        UIButton *view = [UIButton new];
        [view setTitle:@"签到" forState:UIControlStateNormal];
//        [view setTitle:@"已签到" forState:UIControlStateSelected];]
        view.layer.borderColor = Base_Orange.CGColor;
        view.layer.borderWidth = 0.5;
        view.layer.cornerRadius = 2;
        view.titleLabel.font = [UIFont systemFontOfSize:14];
        [view setTitleColor:Base_Orange forState:UIControlStateNormal];
        [view addTarget:self action:@selector(openVC:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    [self.contentView sd_addSubviews:@[_titleL,_signBtn]];
    _titleL.sd_layout.leftSpaceToView(self.contentView,13).centerYIs(self.contentView.centerY).heightIs(15).widthIs(100);
    _signBtn.sd_layout.rightSpaceToView(self.contentView,14).centerYIs(self.contentView.centerY).heightIs(23).widthIs(60);

}
-(void)setModel:(WIFICellModel *)model
{
    _model = model;
    _titleL.text = model.title;
    NSString *str =  [[WIFISIgnToolManager shareInstance]tranlateDateString:model.aci_creattime withDateFormater:@"yyyy-MM-dd HH:mm:ss.SSSSSSZ" andOutFormatter:@"yyyy-MM-dd HH:mm"];
    switch ([model.aci_state intValue]) {
            case 1:
            //1、未签到
            _titleL.text = [NSString stringWithFormat:@"%@签到,请点击击签到",str];
            [_signBtn setTitle:@"签到" forState:UIControlStateNormal];
            break;
            case 2:
            //2、已签到
            _titleL.text = [NSString stringWithFormat:@"%@签到成功",str];
            [_signBtn setTitle:@"已签到" forState:UIControlStateNormal];
            [_signBtn setTitleColor:RGB(183, 183, 183) forState:UIControlStateNormal];
            _signBtn.layer.borderColor = RGB(183, 183, 183).CGColor;
            _signBtn.enabled = NO;

            break;
            case 3:
            //3、学生补签
            _titleL.text = [NSString stringWithFormat:@"%@请点击补签!",str];
            [_signBtn setTitle:@"补签" forState:UIControlStateNormal];
            break;
            case 4:
            //4、教师代签
            _titleL.text = [NSString stringWithFormat:@"%@教师代签成功",str];
            _titleL.text = [NSString stringWithFormat:@"%@签到成功",str];
            [_signBtn setTitle:@"已签到" forState:UIControlStateNormal];
            [_signBtn setTitleColor:RGB(183, 183, 183) forState:UIControlStateNormal];
            _signBtn.layer.borderColor = RGB(183, 183, 183).CGColor;
            _signBtn.enabled = NO;
            break;
            case 5:
//            5、补签待处理、
            _titleL.text = [NSString stringWithFormat:@"%@补签待处理",str];
            [_signBtn setTitle:@"待处理" forState:UIControlStateNormal];
            [_signBtn setTitleColor:RGB(183, 183, 183) forState:UIControlStateNormal];
            _signBtn.layer.borderColor = RGB(183, 183, 183).CGColor;
            _signBtn.enabled = NO;

            break;
            case 6:
//            6.补签不通过
            _titleL.text = [NSString stringWithFormat:@"%@补签不通过",str];
            [_signBtn setTitle:@"补签失败" forState:UIControlStateNormal];
            [_signBtn setTitleColor:RGB(183, 183, 183) forState:UIControlStateNormal];
            _signBtn.layer.borderColor = RGB(183, 183, 183).CGColor;
            _signBtn.enabled = NO;
            break;
            
        default:
            break;
    }
    /*
     aci_state 签到状态 1、未签到 2、已签到、3、学生补签、4、教师代签 5、补签待处理 6.补签不通过

     */
    CGSize size = [_titleL boundingRectWithSize:CGSizeMake(0, 15)];
    if (size.width>kScreenWidth-13-15-60-14) {
        _titleL.sd_layout.widthIs(kScreenWidth-13-15-60-14);
    }else{
        _titleL.sd_layout.widthIs(size.width);
    }
}
#pragma mark 打开界面
-(void)openVC:(UIButton *)sender
{
    NSInteger ID = [_model.aci_state   intValue];
    NSString *str = [[WIFISIgnToolManager shareInstance]tranlateDateString:_model.aci_creattime withDateFormater:@"yyyy-MM-dd HH:mm:ss.SSSSSSZ" andOutFormatter:@"yyyy-MM-dd HH:mm"];
    switch (ID) {
            case 1:
        {
            //打开签到界面
            StuSignInfoController *vc = [StuSignInfoController new];
            vc.aci_ID = _model.aci_id;
            vc.signSucessBlock = ^(NSString *state){
                //签到成功
                [_signBtn setTitle:@"已签到" forState:UIControlStateNormal];
                [_signBtn setTitleColor:RGB(183, 183, 183) forState:UIControlStateNormal];
                _signBtn.layer.borderColor = RGB(183, 183, 183).CGColor;
                _signBtn.enabled = NO;
                _titleL.text = [NSString stringWithFormat:@"%@签到成功",str];
                [self.contentView layoutSubviews];
            };
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
            break;
            case 3:
            //打开补签界面
        {
            StuWIFISubsignController *vc = [StuWIFISubsignController new];
            vc.model = _model;
            vc.subSignSucessBlock = ^(NSString *state){
                [_signBtn setTitle:@"已签到" forState:UIControlStateNormal];
                [_signBtn setTitleColor:RGB(183, 183, 183) forState:UIControlStateNormal];
                _signBtn.layer.borderColor = RGB(183, 183, 183).CGColor;
                _signBtn.enabled = NO;
                _titleL.text = [NSString stringWithFormat:@"%@签到成功",str];
                [self.contentView layoutSubviews];
            };
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
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
