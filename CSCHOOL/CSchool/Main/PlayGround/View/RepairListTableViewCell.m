//
//  RepairListTableViewCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/7.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "RepairListTableViewCell.h"
#import "UIView+SDAutoLayout.h"
#import "NSDate+Extension.h"
#import "ConfigObject.h"
#import "UIView+UIViewController.h"
#import "RepairListViewController.h"
#import "CallRepairViewController.h"

@implementation RepairListModel


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"faultId" : @"OINUMBER",
             @"createTime" : @"OICREATETIME",
             @"questionType" : @"DXTITLE",
             @"faultState" : @"OISTATUS",
             @"keyId":@"OIID",
             @"lastRemindTime":@"OIRTIME",
             @"deviceTypeKey":@"NRIFACILITYTYPE",
             @"netStyleKey":@"NRIOFACCESS",
             @"faultAddress":@"ADDRESS",
             @"aroundFriendKey":@"NRIINTERNETCASE",
             @"faultDes":@"NRIFAULTDESCRIPTION",
             @"username":@"OIRINAME",
             @"repairPhone":@"OIRIPHONE",
             @"areaAddress":@"CANAME",
             @"buildAddress":@"SHDNAME",
             @"detailAddress":@"NRIADDRESS",
             @"questionTypeKey":@"NRIQUESTIONTYPE",
             @"areaAddKey":@"CAID",
             @"buildAddKey":@"SHDID"
             };
}

- (void)setFaultState:(NSString *)faultState{
    _faultState = faultState;
    _faultStateStr = [FAULT_STATE_DIC objectForKey:_faultState];
}

- (void)setDeviceTypeKey:(NSString *)deviceTypeKey{
    NSArray *arr = [deviceTypeKey componentsSeparatedByString:@";"];
    if (arr.count == 2) {
        _deviceTypeKey = arr[0];
        _osType = arr[1];
    }
}

- (void)setNetStyleKey:(NSString *)netStyleKey{
    NSArray *arr = [netStyleKey componentsSeparatedByString:@";"];
    if (arr.count == 2) {
        _netStyleKey = arr[0];
        _netFunction = arr[1];
    }
}

- (void)setAroundFriendKey:(NSString *)aroundFriendKey{
    NSArray *arr = [aroundFriendKey componentsSeparatedByString:@";"];
    if (arr.count == 2) {
        _aroundFriendKey = arr[0];
        _netspeed = arr[1];
    }
}

@end

@interface RepairListTableViewCell()<XGAlertViewDelegate>

@end

@implementation RepairListTableViewCell
{
    UIView *_lineView;
    UIView *_grayLineView;
    UILabel *_repairIdLabel;
    UILabel *_resonLabel;
    UILabel *_timeLabel;
    UILabel *_statusLabel;
    UIButton *_editeBtn;
    UIButton *_cancelBtn;
    UIButton *_remarkBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    [self.contentView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    _lineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    
    _grayLineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor darkGrayColor];
        view;
    });
    
    _repairIdLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = [UIColor darkGrayColor];
        view;
    });
    
    _resonLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = [UIColor darkGrayColor];
        view;
    });
    
    _timeLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = [UIColor darkGrayColor];
        view;
    });
    
    _statusLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textAlignment = NSTextAlignmentRight;
        view.textColor = [UIColor darkGrayColor];
        view;
    });
    
    _cancelBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitleColor:Title_Color1 forState:UIControlStateNormal];
        view.titleLabel.font = Title_Font;
        [view setTitle:@"撤销" forState:UIControlStateNormal];
        [view addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    _editeBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitleColor:Title_Color1 forState:UIControlStateNormal];
        view.titleLabel.font = Title_Font;
        [view setTitle:@"编辑" forState:UIControlStateNormal];
        [view addTarget:self action:@selector(editeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    _remarkBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitleColor:Title_Color1 forState:UIControlStateNormal];
        view.titleLabel.font = Title_Font;
        [view setTitle:@"评价" forState:UIControlStateNormal];
        [view addTarget:self action:@selector(remarkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    [self.contentView addSubview:_lineView];
    [self.contentView addSubview:_grayLineView];
    [self.contentView addSubview:_repairIdLabel];
    [self.contentView addSubview:_resonLabel];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_statusLabel];
    [self.contentView addSubview:_editeBtn];
    [self.contentView addSubview:_cancelBtn];
    [self.contentView addSubview:_remarkBtn];
    
    _lineView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .topSpaceToView(self.contentView,0)
    .heightIs(4);
    
    _repairIdLabel.sd_layout
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(_lineView,10)
    .widthIs(300)
    .heightIs(25);
    
    _grayLineView.sd_layout
    .leftEqualToView(_repairIdLabel)
    .topSpaceToView(_repairIdLabel,1)
    .rightSpaceToView(self.contentView,10)
    .heightIs(.5);
    
    _resonLabel.sd_layout
    .leftEqualToView(_repairIdLabel)
    .topSpaceToView(_grayLineView,1)
    .rightSpaceToView(self.contentView,10)
    .heightRatioToView(_repairIdLabel,1);
    
    _timeLabel.sd_layout
    .leftEqualToView(_repairIdLabel)
    .topSpaceToView(_resonLabel,1)
    .widthRatioToView(_repairIdLabel,1)
    .heightRatioToView(_repairIdLabel,1);
    
    _statusLabel.sd_layout
    .rightSpaceToView(self.contentView,10)
    .topEqualToView(_repairIdLabel)
    .widthIs(150)
    .heightIs(25);
    
    _cancelBtn.sd_layout
    .rightSpaceToView(self.contentView,10)
    .topEqualToView(_timeLabel)
    .widthIs(60)
    .heightIs(30);
    
    _remarkBtn.sd_layout
    .rightEqualToView(_cancelBtn)
    .topEqualToView(_cancelBtn)
    .widthRatioToView(_cancelBtn,1)
    .heightRatioToView(_cancelBtn,1);
    
    _editeBtn.sd_layout
    .rightSpaceToView(_cancelBtn,5)
    .topEqualToView(_cancelBtn)
    .widthRatioToView(_cancelBtn,1)
    .heightRatioToView(_cancelBtn,1);
    
    [self setupAutoHeightWithBottomView:_timeLabel bottomMargin:10];

}

- (void)setModel:(RepairListModel *)model{
    _model = model;
    _repairIdLabel.text = [NSString stringWithFormat:@"%@",model.faultId];
    _resonLabel.text = [NSString stringWithFormat:@"报修原因：%@",model.questionType];
    _timeLabel.text = [NSString stringWithFormat:@"报修时间：%@",model.createTime];
    _statusLabel.text = model.faultStateStr;

    _editeBtn.hidden = YES;
    _cancelBtn.hidden = YES;
    _remarkBtn.hidden = YES;
    _statusLabel.textColor = [UIColor blackColor];
    
    /**
     *  根据不同的状态显示不同的按钮
     */
    switch (model.repairStatus) {
        case RepairEditAndDelete:
        {
            _editeBtn.hidden = NO;
            _cancelBtn.hidden = NO;
            _statusLabel.textColor  = Base_Orange;
        }
            break;
        case RepairRemark:
        {
            _remarkBtn.hidden = NO;
        }
            break;
        case RepairDown:
        {
        }
            break;
        default:
            break;
    }
    _editeBtn.hidden = YES;
    _cancelBtn.hidden = YES;
    _remarkBtn.hidden = YES;
    
}

- (void)cancelButtonClick:(UIButton *)sender{

    XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self.viewController withDropListTitle:[ConfigObject shareConfig].repairCancelResonArr click:^(NSInteger index) {
        NSDictionary *commitDic = @{
                                    @"rid":@"cancelFaultInfoCause",
                                    @"faultId":_model.faultId,
                                    @"cancelCause":[ConfigObject shareConfig].repairCancelResonArr[index]
                                    };
        [ProgressHUD show:@""];
        [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            [ProgressHUD dismiss];
            [self viewControllerRefresh];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            [ProgressHUD dismiss];
        }];
    }];
    [alert show];
}

- (void)editeButtonClick:(UIButton *)sender{
    CallRepairViewController *vc = [[CallRepairViewController alloc] init];
    vc.repairModel = _model;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

//- (void)remarkButtonClick:(UIButton *)sender{
//    XGAlertView *aler = [[XGAlertView alloc] initWithTarget:self.viewController withRemarkTitle:@[@"服务速度",@"服务态度",@"服务结果"] click:^(NSArray *markArr) {
//        NSDictionary *commitDic = @{
//                                    @"rid":@"saveEvaluateInfo",
//                                    @"faultId":_model.faultId,
//                                    @"speedScore":[NSString stringWithFormat:@"%f",[markArr[0] doubleValue]*5],
//                                    @"attitudeScore":[NSString stringWithFormat:@"%f",[markArr[1] doubleValue]*5],
//                                    @"resultScore":[NSString stringWithFormat:@"%f",[markArr[2] doubleValue]*5]
//                                    };
//        [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
//            [ProgressHUD dismiss];
//            [self viewControllerRefresh];
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
//            [ProgressHUD dismiss];
//        }];
//    }];
//    [aler show];
//}

- (void)viewControllerRefresh{
    [(RepairListViewController *)self.viewController loadData];
}

@end
