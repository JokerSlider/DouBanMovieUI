//
//  DQTool.m
//  DQMoveCollectionView
//
//  Created by 邓琪 dengqi on 2016/12/16.
//  Copyright © 2016年 邓琪 dengqi. All rights reserved.
//

#import "DQTool.h"
#import "DQModel.h"

static NSString *KDQUserDefauls = @"KDQUserDefauls";

@implementation DQTool

+ (BOOL)isExistUserDefaultsDateFunction{

    BOOL ret = NO;
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [userDefaluts objectForKey:KDQUserDefauls];
    if (arr) {
        ret = YES;
        
    }
    return ret;
}


+ (NSArray *)AccordingToRequirementsLoadData:(NSArray *)RequirementsArr{
    
    NSArray *allArr = [self LoadAllDataFromInitializeFunction];
    if (RequirementsArr.count>allArr.count) {
        NSLog(@"传入的数据有误!");
    }
    
    
    NSMutableArray *dataArr = [NSMutableArray new];
    for (NSInteger i=0; i<RequirementsArr.count; i++) {
        NSInteger index = [RequirementsArr[i] intValue];
        if (index>=allArr.count) {
            NSLog(@"传入的数据有误!");
        }else{
            DQModel *model = allArr[index];
            [dataArr addObject:model];
        
        }
    }
    return dataArr;
}


+ (NSArray *)LoadAllDataFromInitializeFunction{

    NSArray *titleArr = @[@"缴费",@"报修",@"一键上网",@"课程表",@"成绩查询",@"考试查询",@"空教室",@"校车时刻表",@"校历",@"新闻资讯",@"讲座预告",@"一卡通查询", @"办公电话",@"班班通",@"校园地图",@"报销预约",@"工资查询",@"水花墙",@"考拉海购",@"云阅读",@"漫画",@"教工通讯录",@"办事指南",@"信息发布",@"公文发布", @"周会议",@"报告厅",@"重点工作",@"二手市场",@"失物招领",@"兼职招聘",@"网易慕课",@"规章制度", @"照片墙",@"实时公交",@"图书馆",@"读者榜",@"图书榜",@"就业信息",@"天下事",@"校内通",@"菁彩运动",@"摇一摇",@"一卡通统计表",@"偏科统计表",@"个人成绩表",@"班级消费表",@"个人消费表",@"贫困生排名"];
    
    NSArray *imageArr = @[@"index_pay",@"index_repair",@"index_connect",@"index_classtable",@"index_score",@"index_exam",@"index_emptyroom",@"index_bus",@"index_schoolDate",@"index_schoolNews",@"index_lectures", @"index_schoolCard",@"index_officePhone",@"index_contacts",@"index_map",@"index_finance",@"index_salary",@"index_heart",@"index_caola",@"index_yunyuedu",@"index_manhua",@"index_teacherPhoneBook",@"index_banshizhinan_1",@"index_MessageRelease",@"index_OffRelease",@"index_weekMeeting",@"index_baogaoting", @"index_jiankong",@"index_market",@"index_lost_and_found",@"index_parttime",@"index_muke",@"index_rule",@"index_photo_wall", @"index_bus",@"index_library",@"index_rankreader",@"index_rankborrow",@"index_jiuye",@"index_worldNews",@"index_schoolChat",@"index_SchoolSport",@"index_shake",@"index_onecardPort",@"index_personScore",@"index_ScorePort",@"index_classCostPort",@"index_personCost",@"index_neesStudentList"];
    NSMutableArray *muArr = [NSMutableArray new];
    for (int  i=0; i<titleArr.count; i++) {
        DQModel *model = [DQModel new];
        model.title = titleArr[i];
        model.image = imageArr[i];
        model.ai_id = [NSString stringWithFormat:@"%d",i];
        [muArr addObject:model];
    }
    
    return muArr;
}


+ (void)SaveUserDefaultsDataFunction:(NSArray *)ChangeArr{
    
    NSMutableArray *muArr = [NSMutableArray new];
    for (NSInteger i=0; i<ChangeArr.count; i++) {
        DQModel *model = ChangeArr[i];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model] ;
        [muArr addObject:data];
    }
    [[NSUserDefaults standardUserDefaults] setObject:muArr forKey:KDQUserDefauls];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


+ (NSArray *)ReadeUserDefaultsDataFunction{
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [userDefaluts objectForKey:KDQUserDefauls];
    NSMutableArray *muArr = [NSMutableArray new];
    
    for (NSInteger i=0; i<arr.count; i++) {
        NSData *data = arr[i];
        DQModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [muArr addObject:model];
    }
    return muArr;
}

+ (NSArray *)InitializeDateFunction:(NSArray *)RequirementsArr{

    BOOL ret = [self isExistUserDefaultsDateFunction];
    NSArray *Arr = [self AccordingToRequirementsLoadData:RequirementsArr];
    
    if (ret == NO) {//本地没有数据
        
        [self SaveUserDefaultsDataFunction:Arr];
        return Arr;
        
    }else{
//        if (hasAddNewFunction) {
//            //本地有数据
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:KDQUserDefauls];
//            [self SaveUserDefaultsDataFunction:Arr];
//        }
        NSArray *UserArr = [self ReadeUserDefaultsDataFunction];
        // 对比数组
        NSMutableString * defaString = [[NSMutableString alloc]init];
        NSMutableString * localString = [[NSMutableString alloc]init];
        NSMutableArray *AllArr = [NSMutableArray arrayWithArray:Arr];
        NSMutableArray *AllArr1 = [NSMutableArray arrayWithArray:UserArr];
        
        for (NSInteger i=0; i<AllArr.count; i++) {
            for (NSInteger j=i+1; j<AllArr.count; j++) {
                DQModel *model1 = AllArr[i];
                DQModel *model2 = AllArr[j];
                if ([model1.title  compare:model2.title]==NSOrderedAscending) {
                    [AllArr exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
                
            }
        }
        
        for (NSInteger i=0; i<AllArr1 .count; i++) {
            for (NSInteger j=i+1; j<AllArr1.count; j++) {
                DQModel *model1 = AllArr1[i];
                DQModel *model2 = AllArr1[j];
                if ([model1.title  compare:model2.title]==NSOrderedAscending) {
                    [AllArr1 exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
                
            }
        }
        for (DQModel *objc in AllArr) {
            [defaString appendString:objc.title];
        }
        for (DQModel *objc in AllArr1) {
            [localString appendString:objc.title];
        }
        
        
        // 显示的数据和本地数组有改变 用显示数据
        if (![localString isEqualToString:defaString] && localString.length>2) {//重新赋值
            
            [self SaveUserDefaultsDataFunction:Arr];
            return Arr;
        }else{//取本地
        
            return UserArr;
        }
    }

}
@end
