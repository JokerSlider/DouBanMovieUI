//
//  InfoTabView.h
//  CSchool
//
//  Created by mac on 16/4/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTabViewCell : UITableViewCell
//考试名称
@property (weak, nonatomic) IBOutlet UILabel *examName;
//学分
@property (weak, nonatomic) IBOutlet UILabel *score;
//考试形式
@property (weak, nonatomic) IBOutlet UILabel *examMethod;
//考试状态
@property (weak, nonatomic) IBOutlet UILabel *examState;
//考试时间
@property (weak, nonatomic) IBOutlet UILabel *examTime;
//考试地点
@property (weak, nonatomic) IBOutlet UILabel *examAdddress;

@property(nonatomic,copy)NSString *examIsEnd;


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
