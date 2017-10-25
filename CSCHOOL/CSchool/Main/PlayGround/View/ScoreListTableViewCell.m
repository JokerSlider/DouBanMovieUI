//
//  ScoreListTableViewCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/5/25.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ScoreListTableViewCell.h"

@implementation ScoreListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataDic:(NSDictionary *)dataDic{
    if (![dataDic[@"SFJG"] boolValue]) {
        _classScoreLabel.textColor = Base_Orange;
        _classXuefenLabel.textColor = Base_Orange;
    }else{
        _classScoreLabel.textColor = Color_Gray;
        _classXuefenLabel.textColor = Color_Gray;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
