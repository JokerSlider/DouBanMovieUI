//
//  EmployyessCell.h
//  CSchool
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployyessCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *emName;
@property (weak, nonatomic) IBOutlet UILabel *emPhoneNum;
@property (weak, nonatomic) IBOutlet UIButton *callAction;

@end
