//
//  XuebaRankCell.m
//  CSchool
//
//  Created by 左俊鑫 on 2017/9/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "XuebaRankCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation XuebaModel



@end

@implementation XuebaRankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(XuebaModel *)model{
    _model = model;
    _nameLabel.text = model.xm;
    
    if ([model.pm integerValue] < 4) {
        _logoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%@",model.pm]];
    }else{
        _rankLabel.text = model.pm;
    }
    
    
    
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:model.txdz] placeholderImage:PlaceHolder_Image];
    _scoreLabel.text = [NSString stringWithFormat:@"%.2f",[model.cj doubleValue]];
}

@end
