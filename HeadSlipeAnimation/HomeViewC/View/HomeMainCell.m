//
//  HomeMainCell.m
//  HeadSlipeAnimation
//
//  Created by mac on 17/8/22.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "HomeMainCell.h"
#import <YYModel.h>
#import "UIView+SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation HomeMainCell
{
    UILabel *_filmNameL;
    UILabel *_yearL;//年份
    UILabel *_ratingL;//评分
    UILabel *_directorL;//导演
    UILabel *_castsL;//主演
    UIImageView *_filmImage;//电影海报
    UILabel *_filmType;//电影类型
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

#pragma mark  创建视图
-(void)createView
{
    _filmImage = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"BBB"];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view;
    });
    _filmNameL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.text = @"战狼2";
        view.textColor = Color_Black;
        view;
    });
    _yearL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:13];
        view.textColor = Color_Gray;
        view;
    });
    _ratingL = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:11];
        view;
    });
    _directorL = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:11];
        view.text = @"导演  ";
        view;
    });
    _castsL = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:11];
        view.text = @"主演  ";
        view.numberOfLines = 0;
        view;
    });
    
    _filmType = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:11];
        view.text = @"类型  ";
        view;
    });
    [self.contentView sd_addSubviews:@[_filmImage,_filmNameL,_yearL,_ratingL,_directorL,_castsL,_filmType]];
    UIView *contentView = self.contentView;
    _filmImage.sd_layout.leftSpaceToView(contentView,10).topSpaceToView(contentView,10).bottomSpaceToView(contentView,10).widthIs(KscreenWidth*1/3);
    _filmNameL.sd_layout.leftSpaceToView(_filmImage,13).topEqualToView(_filmImage).widthIs(100).heightIs(15);
    _yearL.sd_layout.leftSpaceToView(_filmNameL,15).topEqualToView(_filmImage).widthIs(100).heightIs(14);
    _ratingL.sd_layout.leftEqualToView(_filmNameL).topSpaceToView(_filmNameL,13).widthIs(200).heightIs(15);
    _directorL.sd_layout.leftEqualToView(_filmNameL).topSpaceToView(_ratingL,13).widthIs(200).heightIs(15);
    _filmType.sd_layout.leftEqualToView(_filmNameL).topSpaceToView(_directorL,13).widthIs(200).heightIs(14);
    _castsL.sd_layout.leftEqualToView(_filmNameL).topSpaceToView(_filmType,10).widthIs(KscreenWidth-KscreenWidth*1/3-13-15).heightIs(30);


    [self setupAutoHeightWithBottomView:_filmImage bottomMargin:10];
}
-(void)setModel:(HomeMainModel *)model
{
    _model = model;
    
    _filmNameL.text = model.title;
    
    _yearL.text = model.year;
    
    NSDictionary *imgDic = model.images;
    NSString *imagUrl = imgDic[@"large"];
    [_filmImage sd_setImageWithURL:[NSURL URLWithString:imagUrl]];
    
    float ratValue = [model.rating[@"average"] floatValue];
    NSString *ratingStr = [NSString stringWithFormat:@"评分    %0.1f",ratValue];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:ratingStr];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:11.0]
     
                          range:NSMakeRange(2, 2)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor orangeColor]
     
                          range:NSMakeRange(6, 3)];
    
    _ratingL.attributedText = AttributedStr;
    //遍历查找
    NSMutableArray *directors = [NSMutableArray array];
    NSMutableArray *carsts  =[ NSMutableArray array];
    for (NSDictionary *dic in model.directors) {
        HomeMainModel *model = [HomeMainModel new];
        [model yy_modelSetWithDictionary:dic];
        [directors addObject:model.name];
    }
    for (NSDictionary *dic in model.casts) {
        HomeMainModel *model = [HomeMainModel new];
        [model yy_modelSetWithDictionary:dic];
        [carsts addObject:model.name];
    }
    
    NSString *directorName = [directors componentsJoinedByString:@","];
    _directorL.text = [NSString stringWithFormat:@"导演    %@",directorName];
    
    NSString *carts = [carsts componentsJoinedByString:@" "];
    _castsL.text = [NSString stringWithFormat:@"主演    %@",carts];
    
    NSString *type = [model.genres componentsJoinedByString:@" "];
    _filmType.text = [NSString stringWithFormat:@"类型    %@",type];
    
    
    
    CGSize  size = [_filmNameL boundingRectWithSize:CGSizeMake(0, 15)];
    _filmNameL.sd_layout.widthIs(size.width);
    size = [_yearL boundingRectWithSize:CGSizeMake(0, 14)];
    _yearL.sd_layout.widthIs(size.width);
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
