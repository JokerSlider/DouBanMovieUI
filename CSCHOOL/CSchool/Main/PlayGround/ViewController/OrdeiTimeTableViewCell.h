//
//  OrdeiTimeTableViewCell.h
//  CSchool
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+IndexPath.h"
@interface OrdeiTimeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UITextField *replaceName;
@property (weak, nonatomic) IBOutlet UITextField *repalcePhoneNum;

@property (weak, nonatomic) IBOutlet UILabel *relpaceTitle;
@property (weak, nonatomic) IBOutlet UISwitch *replaceSwitch;
@end
