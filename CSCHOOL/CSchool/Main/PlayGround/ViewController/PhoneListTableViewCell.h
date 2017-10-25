//
//  PhoneListTableViewCell.h
//  CSchool
//
//  Created by 左俊鑫 on 16/6/29.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

//@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (nonatomic, copy) NSString *phone;
@end
