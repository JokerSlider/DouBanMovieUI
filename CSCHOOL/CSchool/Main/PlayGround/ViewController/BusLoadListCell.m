//
//  BusLoadListCell.m
//  CSchool
//
//  Created by mac on 16/12/16.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BusLoadListCell.h"

@implementation BusLoadListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

    }
    return self;
}
-(void)setModel:(SchooBusModel *)model
{
    _model = model;
    self.textLabel.text = model.busName ;
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
