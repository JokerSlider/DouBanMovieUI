//
//  WIFISignInfoNormalCell.m
//  CSchool
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "WIFISignInfoNormalCell.h"
#import "UIView+SDAutoLayout.h"
#import "WIFIChoseClassController.h"
#import "UIView+UIViewController.h"
@implementation WIFISignInfoNormalCell
{
    UILabel *_titleL;
    UILabel *_subtitleL;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}
-(void)createView{
    _titleL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(85, 85, 85);
        view;
    });
    _subtitleL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(85, 85, 85);
        view;
    });
    self.editBtn = ({
        UIButton *view = [UIButton new];
        [view setImage:[UIImage imageNamed:@"wifi_edit"] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(openSchoolChose:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    [self.contentView sd_addSubviews:@[_titleL,self.editBtn,_subtitleL]];
    _titleL.sd_layout.leftSpaceToView(self.contentView,14).centerYIs(self.contentView.centerY).heightIs(14);
    _subtitleL.sd_layout.leftSpaceToView(_titleL,22).centerYIs(self.contentView.centerY).heightIs(14);
    self.editBtn.sd_layout.rightSpaceToView(self.contentView,125).centerYIs(self.contentView.centerY).heightIs(14).widthIs(14);
}
-(void)setModel:(WIFICellModel *)model
{
    _model = model;
    _titleL.text=model.title;
    _subtitleL.text = model.subtitle;
    CGSize size = [_titleL boundingRectWithSize:CGSizeMake(0, 14)];
    _titleL.sd_layout.widthIs(size.width);
    size = [_subtitleL boundingRectWithSize:CGSizeMake(0, 14)];
    _subtitleL.sd_layout.widthIs(size.width);
}

-(void)openSchoolChose:(UIButton *)sender
{
//    WIFIChoseClassController *vc = [WIFIChoseClassController new];
//    vc.selectBlock = ^(NSString *text,NSString * ID){
//        NSLog(@"%@",text);
//        _subtitleL.text = text;
//        CGSize size = [_subtitleL boundingRectWithSize:CGSizeMake(0, 14)];
//        _subtitleL.sd_layout.widthIs(size.width);
//
//    };
//    [self.viewController.navigationController   pushViewController:vc animated:YES];

    if (self.delegate && [self.delegate respondsToSelector:@selector(openChooseCourseVC)]) {
        [self.delegate openChooseCourseVC];
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
