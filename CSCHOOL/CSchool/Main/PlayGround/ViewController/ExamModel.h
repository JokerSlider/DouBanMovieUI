//
//  ExamModel.h
//  CSchool
//
//  Created by mac on 16/4/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamModel : NSObject
-(instancetype)initWithDic:(NSDictionary *)dic;
@property(nonatomic,retain)NSDictionary *map;
/**
 Infocell.examName.text = @"计算机科学与技术";
Infocell.score.text= @"1.2分";
Infocell.examMethod.text= @"闭卷考试";
Infocell.examState.text=@"未开始";
Infocell.examTime.text = @"2016-01-13 13:10-17:10";
Infocell.examAdddress.text = @"博文馆.博文馆215[99座]";
 **/
@property(nonatomic,copy)NSString *examName;
@property(nonatomic,copy)NSString *score;
@property(nonatomic,copy)NSString *examMethod;
@property(nonatomic,copy)NSString *examState;
@property(nonatomic,copy)NSString *examTime;
@property(nonatomic,copy)NSString *examAddress;
@property(nonatomic,copy)NSString *examIsEnd;

@end
