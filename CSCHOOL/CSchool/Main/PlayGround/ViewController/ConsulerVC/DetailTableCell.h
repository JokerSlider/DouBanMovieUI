//
//  DetailTableCell.h
//  DetailTableView
//
//  Created by joker on 12/7/16.
//  Copyright © 2016 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonInfoModel.h"
typedef NS_ENUM(NSInteger, TapActionType)  {
    TapActionTypeGood,
    TapActionTypeBad,
};

typedef void(^tapActionBlock)(TapActionType tapType);

@interface DetailTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
//短信按钮
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
//复制按钮
@property (weak, nonatomic) IBOutlet UIButton *cpyBtn;
//保存按钮
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
//打电话 按钮
@property (weak, nonatomic) IBOutlet UIButton *callBtn;

@property (nonatomic ,strong)NSDictionary *dic;
@property (nonatomic, copy) tapActionBlock tapBlock;
//学生个人信息
@property (weak, nonatomic) IBOutlet UIButton *studentInfoBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic,strong)NSArray *studentInfoArr;
@property (nonatomic,strong)PersonInfoModel *model;




@end
