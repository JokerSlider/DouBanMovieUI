//
//  WeekCourse.h
//  ismarter2.0_sz
//
//  Created by MacOS on 16-5-25.
//
//

@interface WeekCourse : NSObject
{
    
    
//    JSJC:2, 结束节次
//    KSJC:1,开始节次
//    XNXQDM:2015-2016-2,学期
//    XQMC:本部,校区名称
//    SKZC:1111111011111000000000000,上课周次
//    JASH:KJ102,教师号
//    XH:20131011160,学号
//    KBID:0005038416,课表ID
//    KCH:CL010016,课程号
//    WID:1463600516206303126.0771733154,主键
//    JXBID:201520162CL01001601,教学班ID
//    KCM:电镀工艺学,课程名
//    SKXQ:1,上课星期
//    SKLS:王玥,蔡元兴,上课老师
//    KXH:01,课序号
//    JSMC:科技馆102[媒128] 教室名称
    


//   "jssj": "09:25", 结束时间
//   "wid": "2",   主键
//   "jcdm": 2,  节次代码
//   "bz": "上午第二节", 备注
//   "kssj": "08:40", 开始时间
//   "jcmc": "第2节", 节次名称
//   "jclb": 1  未知含义
    
    
    NSString        *_studentId;        //学号
    NSString        *_term;             //年度+学期 如2014-20151是2014-2015年底第一学期
    NSString        *_weeks;            //周期，如果为空默认为第一周，否则为参数那一周
    NSString        *_day;              //周几,1/2/3/4/5/6/7,代表周一、周二、周三.........
    NSString        *_lesson;           //课程从第几节开始
    NSString        *_lessonsNum;       //课程有几节课
    NSString        *_courseCode;       //课程号
    NSString        *_courseName;       //课程名
    NSString        *_classRoom;        //教室
    NSString        *_teacherName;      //老师名字
    NSString        *_seWeek;           //周期，比如3-14周，则数据为3-14
    NSString        *_capter;           //只用于cell显示，不存在数据库
    NSString        *_time;             //上课时间
    BOOL            _haveLesson;        //显示cell用
}


@property(nonatomic,  copy) NSString    *KBID;//课表ID
@property(nonatomic,  copy) NSString    *WID;//主键
@property(nonatomic,  copy) NSString    *JXBID;//教学班ID
@property(nonatomic,  copy) NSString    *XQMC;//校区名称
@property (nonatomic, copy) NSString    *XH;//学号
@property (nonatomic, copy) NSString    *XNXQDM;//学期
@property (nonatomic, copy) NSString    *SKXQ;//上课星期
@property (nonatomic, copy) NSString    *KSJC;//开始节次
@property(nonatomic,  copy) NSString    *JSJC;//结束节次
@property (nonatomic, copy) NSString    *lessonsNum;//课程节数
@property (nonatomic, copy) NSString    *KCH;//课程号
@property (nonatomic, copy) NSString    *KXH;//课序号
@property (nonatomic, copy) NSString    *KCM;//课程名
@property (nonatomic, copy) NSString    *JSMC;//上课教室
@property (nonatomic, copy) NSString    *SKLS;//上课老师
@property (nonatomic, copy) NSString    *SKZC;//上课周期
@property (nonatomic, copy) NSString    *capter;//只用于cell显示，不存在数据库
@property(nonatomic,  copy) NSString    *time;//上课时间
@property (nonatomic, assign) BOOL      haveLesson;
@property (nonatomic, retain) NSArray *weeksArray; //存放该课程该学期上课周， 0：无课，1：有课

@property(nonatomic,strong)NSMutableArray *haveLessonWeekArr;

@property(nonatomic,assign)BOOL isDoubleWeek;//是单双周的情况
@property(nonatomic,assign)BOOL noDoubleWeek;//不是单双周的情况
@property(nonatomic,assign)BOOL  doubleWeek;//双周的日期
@property(nonatomic,assign)int  lastDoubleWeekNum;
@property(nonatomic,assign)BOOL isSerialWeek;//是连续的周数
@property(nonatomic,assign)BOOL NoSerialWeek;//不是连续的周数

@property(nonatomic,assign)int   breakSerialWeekNum;//找出不是连续周数的那个点

@property(nonatomic,strong)NSMutableArray *breakNumArr;

- (id)initWithPropertiesDictionary:(NSDictionary *)dic;

@end
