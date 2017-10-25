//
//  OrdeiTimeTableViewCell.m
//  CSchool
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "OrdeiTimeTableViewCell.h"

@interface OrdeiTimeTableViewCell()<UITextFieldDelegate>
@end
@implementation OrdeiTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.replaceSwitch.onTintColor = Base_Orange;
//    self.replaceName.layer.borderWidth = 1;
//    self.replaceName.layer.borderColor = Base_Color3.CGColor;
//    self.replaceName.textColor = Color_Black;
//    self.repalcePhoneNum.layer.borderWidth = 1;
//    self.repalcePhoneNum.layer.borderColor = Base_Color3.CGColor;
//    self.repalcePhoneNum.textColor = Color_Black;
    self.replaceName.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.repalcePhoneNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.repalcePhoneNum.keyboardType = UIKeyboardTypeNumberPad;
    if (self.repalcePhoneNum.text.length>11) {
        self.repalcePhoneNum.enabled = NO;
    }
    UIImageView *sepView =  [UIImageView new];
    sepView.backgroundColor = Base_Color3;
    sepView.frame = CGRectMake(-10, self.backView.bounds.size.height+3, kScreenWidth+10, 0.6);
    [self.backView addSubview:sepView];
        
}
#pragma mark textField相关事件
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==0) {
        [self.replaceName resignFirstResponder];
        [self.repalcePhoneNum becomeFirstResponder];
    }else if(textField.tag==1)
    {
        [self.repalcePhoneNum resignFirstResponder];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag==1) {
        [textField resignFirstResponder];
    }
    return YES;
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)openCell:(id)sender {
    
}

@end
