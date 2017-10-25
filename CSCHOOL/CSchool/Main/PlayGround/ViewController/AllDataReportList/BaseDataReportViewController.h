//
//  BaseDataReportViewController.h
//  CSchool
//
//  Created by mac on 17/4/26.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"
typedef enum{
    oneCardDataReport=0,//一卡通
    PersonScorePort=1,//个人偏科情况统计
    PersonNetDataPort=2,//个人成绩，上网，借阅 变化统计
    YearCostDataPort=3,//按年度划分班级消费统计（散点图
    PersonCostDataReport=4,//个人消费统计（饼图）
    NeesStudentListDataReport=5,//贫困生排名（雷达图）(rank - 数据统计  actual - 值统计  score - 个人成绩排行)
    PersonLocationDataReport = 6
}DataReortType;
@interface BaseDataReportViewController : BaseViewController
@property (nonatomic, assign) DataReortType dataType; // 类型


@end
