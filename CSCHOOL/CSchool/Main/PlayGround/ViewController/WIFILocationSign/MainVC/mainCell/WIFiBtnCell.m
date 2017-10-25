//
//  WIFiBtnCell.m
//  CSchool
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "WIFiBtnCell.h"
#import "UIView+SDAutoLayout.h"
#import "WifiSignSureController.h"
#import "UIView+UIViewController.h"
#import "StuWIFISubsignController.h"
#import "TecSubSignListViewController.h"
#import "TecEndSignController.h"
#import "WifiSignSureController.h"
#import "TecStartSignController.h"
@implementation WIFiBtnCell
{
    UIButton *_mainBtn;
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
    _mainBtn = ({
        UIButton *view = [UIButton new];
        view.layer.cornerRadius = 1.5;
        [view addTarget:self action:@selector(openVC) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    [self.contentView addSubview:_mainBtn];
    
    _mainBtn.sd_layout.leftSpaceToView(self.contentView,27).rightSpaceToView(self.contentView,27).topSpaceToView(self.contentView, 38/2).heightIs(107);
    [self setupAutoHeightWithBottomView:_mainBtn bottomMargin:38/2];
}
-(void)setModel:(WIFICellModel *)model
{
    _model = model;
    NSArray *titleArr = @[@"发起签到",@"签到统计",@"补签申请"];
    NSArray *imageArr = @[@"faqi",@"tongji",@"buqian"];
    NSInteger index = [model.funcID intValue];
    [_mainBtn setTitle:titleArr[index] forState:UIControlStateNormal];

    [_mainBtn setBackgroundImage:[UIImage imageNamed:imageArr[index]] forState:UIControlStateNormal];
}
#pragma mark 点击方法
-(void)openVC
{
    NSInteger index = [_model.funcID intValue];

    switch (index) {
        case 0:
        {
            WifiSignSureController *vc = [WifiSignSureController new];
//            vc.chooseType = 2;
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
            break;
         case 1:
        {
            TecStartSignController *vc = [TecStartSignController new];
            vc.chooseType = 1;
            [self.viewController.navigationController pushViewController:vc animated:YES];

        }
            break;
            case 2:
        {
            TecStartSignController *vc = [TecStartSignController new];
            vc.chooseType = 2;
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
