//
//  FellowRequestCell.m
//  CSchool
//
//  Created by mac on 17/2/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "FellowRequestCell.h"
#import "LY_CircleButton.h"
#import "ChatModel.h"
#import "UIView+SDAutoLayout.h"

@implementation FellowRequestCell
{
    UIImageView *_picImage;//
    
    UILabel *_noticeLabel;//提示文字
    
    LY_CircleButton *_badgeValue;//角标
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
    _picImage = ({
        UIImageView *view = [UIImageView new];
        view.layer.cornerRadius = 3;
        view.clipsToBounds = YES;
        [view setImage:[UIImage imageNamed:@"add_Fellow"]];
        view;
    });
    _noticeLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black ;
        view.text = @"好友请求";
        view.font = [UIFont systemFontOfSize:15];
        view;
    });
    _badgeValue = ({
        LY_CircleButton *view = [LY_CircleButton buttonWithType:UIButtonTypeCustom];
        view.maxDistance = 30;
        view.frame = CGRectMake(kScreenWidth-45, 15+9+10, 20, 20);
        [view setBackgroundColor:Base_Orange];
        view.imageView.layer.cornerRadius = view.bounds.size.width/2;
        [view setBackgroundImage:[UIImage imageNamed:@"bageValue"] forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:11];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        view.layer.cornerRadius = view.bounds.size.width*0.5;
        view.layer.masksToBounds = YES;
        WEAKSELF;
        [view addButtonAction:^(id sender) {
            NSLog(@"销毁了");
            [weakSelf FellowRequestCell:weakSelf];
        }];
        view;
    });
    [self.contentView sd_addSubviews:@[_picImage,_noticeLabel,_badgeValue]];
    UIView *contentView = self.contentView;
    _picImage.sd_layout.leftSpaceToView(contentView,10 ).topSpaceToView(contentView,16).widthIs(40).heightIs(40);
    _noticeLabel.sd_layout.leftSpaceToView(_picImage,15).topSpaceToView(contentView,27).widthIs(100).heightIs(14);
    _badgeValue.sd_layout.leftSpaceToView(_noticeLabel,5).topSpaceToView(contentView,23).widthIs(20).heightIs(20);
    
}
-(void)setModel:(ChatModel *)model
{
    _model = model;
    [_badgeValue setTitle:model.badgeValue forState:UIControlStateNormal];
    if(model.badgeValue.length>0 && ![model.badgeValue isEqual:[NSNull null]]){
        _badgeValue.frame = CGRectMake(kScreenWidth-35, 34, 17, 17);
        for (UIView *view in self.contentView.subviews) {
            if (![view isKindOfClass:[LY_CircleButton class]]) {
                [self.contentView addSubview:_badgeValue];
            }
        }
        
        if ([model.badgeValue intValue]>99) {
            self.layer.cornerRadius = self.bounds.size.width*0.3;
            _badgeValue.frame = CGRectMake(kScreenWidth-50, 34, 31, 18);
            [_badgeValue setBackgroundImage:[UIImage imageNamed:@"moreBageValue"] forState:UIControlStateNormal];
            [_badgeValue setTitle:@"99+" forState:UIControlStateNormal];
        }
    }else{
        [_badgeValue removeFromSuperview];
    }

    CGSize size =[_noticeLabel boundingRectWithSize:CGSizeMake(0, 14)];
    _noticeLabel.sd_layout.widthIs(size.width);
}
#pragma self.delegate
-(void)FellowRequestCell:(FellowRequestCell *)cell
{
    if (self.delegate&&[self respondsToSelector:@selector(FellowRequestCell:)]) {
        [self.delegate FellowRequestCell:cell];
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
