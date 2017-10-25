//
//  RepairListTableViewCell.h
//  CSchool
//
//  Created by 左俊鑫 on 16/1/7.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#define FAULT_STATE_DIC @{@"1":@"待接单",@"2":@"待预约",@"3":@"待维修",@"4":@"待评价",@"5":@"已完结",@"6":@"已完结",@"7":@"删除",@"8":@"已撤销",@"9":@"待接单"}
/**
 报修单状态
 */
typedef enum : NSUInteger {
    RepairEditAndDelete, //可编辑和撤销
    RepairRemark, //可评分
    RepairDown, //已经完成
} RepairStatus;

@interface RepairListModel : NSObject

@property (nonatomic, assign) RepairStatus repairStatus;

@property (nonatomic, strong) NSString *cancelCause;
//@property (nonatomic, strong) NSString *faultDes;
@property (nonatomic, strong) NSString *repairName;
@property (nonatomic, strong) NSString *serviceName;
@property (nonatomic, strong) NSString *servicePhone;
@property (nonatomic, strong) NSString *solveTime;

//新接口用到的
@property (nonatomic, strong) NSString *faultId; //维修单ID
@property (nonatomic, strong) NSString *createTime; //

@property (nonatomic, strong) NSString *questionType; //报修原因
@property (nonatomic, strong) NSString *questionTypeKey; //报修原因id

@property (nonatomic, strong) NSString *faultState; //报修状态数字
@property (nonatomic, strong) NSString *keyId; //维修单keyId
@property (nonatomic, strong) NSString *faultStateStr; //报修状态转码
@property (nonatomic, strong) NSString *lastRemindTime; //上次催单时间

@property (nonatomic, strong) NSString *deviceTypeKey; //设备类型key -->NRIOFACCESS
@property (nonatomic, strong) NSString *osType;

@property (nonatomic, strong) NSString *netStyleKey; //上网方式key -->NRIINTERNETCASE
@property (nonatomic, strong) NSString *netFunction;

@property (nonatomic, strong) NSString *faultAddress; //地址 -->ADDRESS

@property (nonatomic, strong) NSString *aroundFriendKey; //周围朋友上网key -->NRIFACILITYTYPE
@property (nonatomic, strong) NSString *netspeed;

@property (nonatomic, strong) NSString *faultDes; //故障描述 -->NRIFAULTDESCRIPTION
@property (nonatomic, strong) NSString *username; //报修姓名 -->OIRINAME
@property (nonatomic, strong) NSString *repairPhone; //报修电话 -->OIRIPHONE
@property (nonatomic, strong) NSString *detailAddress; //详细地址
@property (nonatomic, strong) NSString *areaAddress; //区域信息
@property (nonatomic, strong) NSString *areaAddKey; //区域信息Id
@property (nonatomic, strong) NSString *buildAddress; //楼号
@property (nonatomic, strong) NSString *buildAddKey; //楼号id

@end

@interface RepairListTableViewCell : UITableViewCell

@property (nonatomic, strong) RepairListModel *model;

@end
