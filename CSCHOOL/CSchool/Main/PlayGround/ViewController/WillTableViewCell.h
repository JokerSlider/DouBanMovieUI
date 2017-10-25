//
//  WillTableViewCell.h
//  CSchool
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WillTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *wiiExamName;

@property (weak, nonatomic) IBOutlet UILabel *willExamMethod;
@property (weak, nonatomic) IBOutlet UILabel *willExamState;

@property (weak, nonatomic) IBOutlet UILabel *willExamScore;
@end
