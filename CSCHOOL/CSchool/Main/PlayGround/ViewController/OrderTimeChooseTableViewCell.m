//
//  OrderTimeChooseTableViewCell.m
//  CSchool
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "OrderTimeChooseTableViewCell.h"

@implementation OrderTimeChooseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.firsTime.font = [UIFont fontWithName:@ "Arial Rounded MT Bold"  size:(16.0)];
    self.chooseTimeBtn.layer.borderColor =RGB(230,120,12).CGColor;
    self.chooseTimeBtn.layer.borderWidth = 1;
    [self.chooseTimeBtn setTitleColor:Base_Orange forState:UIControlStateNormal];
    self.chooseTimeBtn.layer.cornerRadius = 3;
}
//- (void)setFrame:(CGRect)frame {
//    
//    frame.size.width = self.window.frame.size.width;
//    [super setFrame:frame];
//    
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)chooseTimeAction:(id)sender {
    

}

@end
