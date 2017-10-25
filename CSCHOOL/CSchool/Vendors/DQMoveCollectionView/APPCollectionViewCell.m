//
//  CollectionViewCell.m
//  DQMoveCollectionView
//
//  Created by 邓琪 dengqi on 2016/12/16.
//  Copyright © 2016年 邓琪 dengqi. All rights reserved.
//

#import "APPCollectionViewCell.h"
#import "DQModel.h"
#import "UIView+SDAutoLayout.h"

@interface APPCollectionViewCell ()

@property (strong, nonatomic)  UIImageView *backImg;
@property (strong, nonatomic)  UIImageView *titleImg;

@end

@implementation APPCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
#pragma mark  创建视图
-(void)createView
{
    _backImg = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"app_item_bg"];
        view.contentMode = UIViewContentModeScaleToFill;

        view;
    });
    _titleImg = ({
        UIImageView *view = [UIImageView new];
        view;
    });
    _title = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Black;
        view.numberOfLines = 0;
        view.textAlignment  = NSTextAlignmentCenter;
        view;
    });
    [self.contentView sd_addSubviews:@[_backImg,_titleImg,_title]];
    UIView *contentView = self.contentView;
    _backImg.sd_layout.leftSpaceToView(contentView,0).rightSpaceToView(contentView,0).topSpaceToView(contentView,0).bottomSpaceToView(contentView,0);
    _titleImg.sd_layout.centerXIs(contentView.centerX).topSpaceToView(contentView,15).widthIs(50).heightIs(50);
    _title.sd_layout.centerXIs(contentView.centerX).topSpaceToView(_titleImg,15).widthIs(self.frame.size.width).heightIs(20);
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)SetDataFromModel:(DQModel *)model{

    self.titleImg.image = [UIImage imageNamed:model.image];
    self.title.text = model.title;
    self.ai_id = model.ai_id;
//    CGSize size = [self.title boundingRectWithSize:CGSizeMake(0, 20)];
//    self.title.sd_layout.widthIs(size.width);
}

@end
